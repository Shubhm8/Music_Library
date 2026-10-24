package com.music.admin.controller;
import org.springframework.data.domain.Page;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;

import java.util.List;
import com.music.admin.dto.SongDto; 
import com.music.admin.mapper.SongMapper; 
import java.util.stream.Collectors; 
import java.nio.file.*;
import java.io.IOException;
import java.io.File;
import java.util.Set;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.Page;

import com.music.admin.entity.SongsLibrary;
import com.music.admin.service.SongsService;

@Controller
@Tag(
    name = "🎵 Song Management",
    description = "APIs for searching and managing songs"
)
public class SongsController {


    @Autowired
    private SongsService songsService;

    @GetMapping("/admin/add-song")
    public String showAddSongPage() {
        return "addSong"; 
    }

    @PostMapping("/admin/songs/add")
    public String addSong(@ModelAttribute SongsLibrary song, 
                          @RequestParam("file") MultipartFile audioFile,
                          @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                          @RequestParam(value = "songType", defaultValue = "Free") String songType, // Added songType param
                          Model model) { 
        
        try { 
            String uploadDir = System.getProperty("user.dir") + "/uploads";
            File directory = new File(uploadDir);
            if (!directory.exists()) {
                directory.mkdirs();
            }

            if (audioFile != null && !audioFile.isEmpty()) {
                song.setAudioPath(storeUpload(audioFile, true));
            }

            // 2. Save Image
            if (imageFile != null && !imageFile.isEmpty()) {
                song.setImagePath(storeUpload(imageFile, false));
            } else {
                song.setImagePath(null);
            } 
            song.setSongType(songType);

            songsService.addSong(song);
            return "redirect:/admin/songs"; 

        } 
        catch (DataIntegrityViolationException e) {
           String specificError = e.getRootCause() != null ? e.getRootCause().getMessage() : e.getMessage();
           model.addAttribute("errorMessage", "Database Error: " + specificError);
           return "addSong"; 
           
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("errorMessage", "System Error: " + e.getMessage());
            return "addSong";
        }
    }
    
    @GetMapping("/admin/songs")
    public String viewSongs(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String type,
            @RequestParam(required = false) String status,
            Model model) {

        Page<SongsLibrary> songPage;

        if (search != null && !search.isBlank()) {

            songPage = songsService.searchSongs(search, page, 12);

        } else if (type != null && !type.isBlank()) {

            songPage = songsService.getSongsByType(type, page, 12);

        } else if (status != null && !status.isBlank()) {

            songPage = songsService.getSongsByStatus(status, page, 12);

        } else {

            songPage = songsService.getSongsByPage(page, 12);

        }

        model.addAttribute("songs", songPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", songPage.getTotalPages());

        model.addAttribute("search", search);
        model.addAttribute("type", type);
        model.addAttribute("status", status);

        return "viewSongs";
    }
    @Operation(
    	    summary = "Get All Songs",
    	    description = "Returns all songs in the music library."
    	)
    @GetMapping("/api/songs/all")
    @ResponseBody 
    public List<SongDto> getAllSongsAPI() { 
        return songsService.getAllSongs().stream()
                           .map(SongMapper::toDto)
                           .collect(Collectors.toList());
    }
    
    @GetMapping("/admin/songs/delete")
    public String deleteSong(@RequestParam Integer id) {
        songsService.deleteSong(id);
        return "redirect:/admin/songs";     
    }
    @Operation(
    	    summary = "Search Songs",
    	    description = "Search songs by title, artist, album, or keyword."
    	)
    @GetMapping("/api/songs/search")
    @ResponseBody
    public List<SongDto> searchSongs(@RequestParam String keyword) {
        return songsService.searchSongs(keyword).stream()
                           .map(SongMapper::toDto)
                           .collect(Collectors.toList());
    }

    @GetMapping("/admin/songs/edit")
    public String showEditSongPage(@RequestParam Integer id, Model model) {
        SongsLibrary song = songsService.getSongById(id);
        model.addAttribute("song", song);
        return "editSong"; 
    }
    
    @PostMapping("/admin/songs/update")
    public String updateSong(@ModelAttribute SongsLibrary song,
                             @RequestParam(value = "file", required = false) MultipartFile audioFile,
                             @RequestParam(value = "imageFile", required = false) MultipartFile imageFile) {
        try { 
            String uploadDir = System.getProperty("user.dir") + "/uploads";
            File directory = new File(uploadDir);
            if (!directory.exists()) {
                directory.mkdirs();
            }
            
            if (audioFile != null && !audioFile.isEmpty()) {
                song.setAudioPath(storeUpload(audioFile, true));
            }

            if (imageFile != null && !imageFile.isEmpty()) {
                song.setImagePath(storeUpload(imageFile, false));
            } 

            songsService.updateSong(song.getLibraryId(), song);

        } catch (IOException e) {
            e.printStackTrace();
        }

        return "redirect:/admin/songs";
    }
    @Operation(
    	    summary = "Available Songs",
    	    description = "Returns all active songs available for users."
    	)
    @GetMapping("/api/songs/available")
    @ResponseBody 
    public List<SongDto> getAvailableSongsAPI() {
        return songsService.getAvailableSongs().stream()
                           .map(SongMapper::toDto)
                           .collect(Collectors.toList());
    }
    private String storeUpload(MultipartFile file, boolean audio) throws IOException {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("Uploaded file is empty");
        }

        long maxSize = audio ? 50L * 1024 * 1024 : 5L * 1024 * 1024;
        if (file.getSize() > maxSize) {
            throw new IllegalArgumentException("Uploaded file exceeds the allowed size");
        }

        String contentType = file.getContentType();
        Set<String> allowedTypes = audio
                ? Set.of("audio/mpeg", "audio/mp3", "audio/mp4", "audio/wav", "audio/x-wav", "audio/ogg")
                : Set.of("image/jpeg", "image/png", "image/webp", "image/gif");
        if (contentType == null || !allowedTypes.contains(contentType.toLowerCase())) {
            throw new IllegalArgumentException("Unsupported " + (audio ? "audio" : "image") + " content type");
        }
        try (var input = file.getInputStream()) {
            if (!hasValidSignature(input.readNBytes(12), contentType.toLowerCase())) {
                throw new IllegalArgumentException("Uploaded file content does not match its declared media type");
            }
        }

        String extension = switch (contentType.toLowerCase()) {
            case "audio/mpeg", "audio/mp3" -> ".mp3";
            case "audio/mp4" -> ".m4a";
            case "audio/wav", "audio/x-wav" -> ".wav";
            case "audio/ogg" -> ".ogg";
            case "image/jpeg" -> ".jpg";
            case "image/png" -> ".png";
            case "image/webp" -> ".webp";
            case "image/gif" -> ".gif";
            default -> throw new IllegalArgumentException("Unsupported file type");
        };

        Path uploadDirectory = Paths.get(System.getProperty("user.dir"), "uploads").toAbsolutePath().normalize();
        Files.createDirectories(uploadDirectory);
        String fileName = UUID.randomUUID() + extension;
        Path destination = uploadDirectory.resolve(fileName).normalize();
        if (!destination.getParent().equals(uploadDirectory)) {
            throw new IllegalArgumentException("Invalid upload path");
        }
        try (var input = file.getInputStream()) {
            Files.copy(input, destination);
        }
        return "/uploads/" + fileName;
    }

}