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
import java.io.File; // Added for File checks

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
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

    @Value("${app.upload-dir}")
    private String uploadDir;

    @Value("${user.service.url}") private String userServiceUrl;
    @Value("${notification.service.api-key}") private String internalApiKey;
    @Autowired private org.springframework.web.client.RestTemplate restTemplate;

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
            File directory = new File(uploadDir);
            if (!directory.exists()) {
                directory.mkdirs();
            }

            // 1. Save Audio
            if (audioFile != null && !audioFile.isEmpty()) {
                String audioName = System.currentTimeMillis() + "_" + audioFile.getOriginalFilename();
                Path audioPath = Paths.get(uploadDir, audioName);
                Files.copy(audioFile.getInputStream(), audioPath, StandardCopyOption.REPLACE_EXISTING); 
                song.setAudioPath("/uploads/" + audioName);
            }

            // 2. Save Image
            if (imageFile != null && !imageFile.isEmpty()) {
                String imgName = System.currentTimeMillis() + "_" + imageFile.getOriginalFilename();
                Path imgPath = Paths.get(uploadDir, imgName);
                Files.copy(imageFile.getInputStream(), imgPath, StandardCopyOption.REPLACE_EXISTING); 
                song.setImagePath("/uploads/" + imgName);
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
    @PreAuthorize("hasRole('ADMIN')")
    @ResponseBody 
    public List<SongDto> getAllSongsAPI() { 
        return songsService.getAllSongs().stream()
                           .map(SongMapper::toDto)
                           .collect(Collectors.toList());
    }
    
    @PostMapping("/admin/songs/delete")
    public String deleteSong(@RequestParam Integer id) {
        songsService.deleteSong(id);
        return "redirect:/admin/songs";     
    }
    @Operation(
    	    summary = "Search Songs",
    	    description = "Search songs by title, artist, album, or keyword."
    	)
    @GetMapping("/api/songs/search")
    @PreAuthorize("hasRole('ADMIN')")
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
            File directory = new File(uploadDir);
            if (!directory.exists()) {
                directory.mkdirs();
            }
            
            if (audioFile != null && !audioFile.isEmpty()) {
                String audioName = System.currentTimeMillis() + "_" + audioFile.getOriginalFilename();
                Path audioPath = Paths.get(uploadDir, audioName);
                Files.copy(audioFile.getInputStream(), audioPath, StandardCopyOption.REPLACE_EXISTING);

                song.setAudioPath("/uploads/" + audioName);
            }

            if (imageFile != null && !imageFile.isEmpty()) {
                String imgName = System.currentTimeMillis() + "_" + imageFile.getOriginalFilename();
                Path imgPath = Paths.get(uploadDir, imgName);
                Files.copy(imageFile.getInputStream(), imgPath, StandardCopyOption.REPLACE_EXISTING);
                
                song.setImagePath("/uploads/" + imgName);
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

    @GetMapping("/api/songs/{id}/stream")
    public ResponseEntity<byte[]> streamSong(@PathVariable Integer id, Authentication authentication) throws IOException {
        SongsLibrary song = songsService.getSongById(id);
        if ("PREMIUM".equalsIgnoreCase(song.getSongType())) {
            org.springframework.http.HttpHeaders headers = new org.springframework.http.HttpHeaders();
            headers.set("X-Internal-Api-Key", internalApiKey);
            @SuppressWarnings("unchecked") Map<String, Boolean> entitlement = restTemplate.exchange(userServiceUrl + "/api/internal/users/" + authentication.getName() + "/premium", org.springframework.http.HttpMethod.GET, new org.springframework.http.HttpEntity<>(headers), Map.class).getBody();
            if (entitlement == null || !Boolean.TRUE.equals(entitlement.get("premium"))) return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        Path path = Paths.get(uploadDir, Paths.get(song.getAudioPath()).getFileName().toString());
        if (!Files.exists(path)) return ResponseEntity.notFound().build();
        return ResponseEntity.ok().header("Content-Type", "audio/mpeg").body(Files.readAllBytes(path));
    }
}
