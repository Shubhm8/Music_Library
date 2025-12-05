package com.music.admin.controller;

import java.util.List;
import com.music.admin.dto.SongDto; // Added/Confirmed Import
import com.music.admin.mapper.SongMapper; // Added/Confirmed Import
import java.util.stream.Collectors; // Added/Confirmed Import
import java.nio.file.*;
import java.io.IOException;

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

import com.music.admin.entity.SongsLibrary;
import com.music.admin.service.SongsService;

@Controller
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
                          Model model) { 
        
        try {
            String audioDir = "src/main/resources/static/audio";
            Path audioPath = Paths.get(audioDir);
            if (!Files.exists(audioPath)) {
                Files.createDirectories(audioPath);
            }
            String audioName = audioFile.getOriginalFilename();
            Files.copy(audioFile.getInputStream(), audioPath.resolve(audioName), StandardCopyOption.REPLACE_EXISTING);
            song.setAudioPath("/audio/" + audioName);
            
            if (imageFile != null && !imageFile.isEmpty()) {
                String imgDir = "src/main/resources/static/images";
                Path imgPath = Paths.get(imgDir);
                
                if (!Files.exists(imgPath)) {
                    Files.createDirectories(imgPath);
                }

                String imgName = imageFile.getOriginalFilename();
                Files.copy(imageFile.getInputStream(), imgPath.resolve(imgName), StandardCopyOption.REPLACE_EXISTING);
                
                song.setImagePath("/images/" + imgName);
            } 
            else {
                song.setImagePath(null);
            }
            
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
    public String viewSongs(Model model) {
        // NOTE: For Thymeleaf/JSP rendering, keeping the entity is usually necessary
        List<SongsLibrary> songs = songsService.getAllSongs();
        model.addAttribute("songs", songs);
        return "viewSongs"; 
    }
    
    @GetMapping("/api/songs/all")
    @ResponseBody
    // CRITICAL FIX: Changed return type and added mapping
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

    @GetMapping("/api/songs/search")
    @ResponseBody
    // CRITICAL FIX: Changed return type and added mapping
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
            // Check if a new Audio file is uploaded
            if (audioFile != null && !audioFile.isEmpty()) {
                String audioDir = "src/main/resources/static/audio";
                Path audioPath = Paths.get(audioDir);
                if (!Files.exists(audioPath)) Files.createDirectories(audioPath);

                String audioName = audioFile.getOriginalFilename();
                Files.copy(audioFile.getInputStream(), audioPath.resolve(audioName), StandardCopyOption.REPLACE_EXISTING);

                song.setAudioPath("/audio/" + audioName);
            }

            // Check if a new Image file is uploaded
            if (imageFile != null && !imageFile.isEmpty()) {
                String imgDir = "src/main/resources/static/images";
                Path imgPath = Paths.get(imgDir);
                if (!Files.exists(imgPath)) Files.createDirectories(imgPath);
                String imgName = imageFile.getOriginalFilename();
                
                Files.copy(imageFile.getInputStream(), imgPath.resolve(imgName), StandardCopyOption.REPLACE_EXISTING);
                song.setImagePath("/images/" + imgName);
            }
            songsService.updateSong(song.getLibraryId(), song);

        } catch (IOException e) {
            e.printStackTrace();
        }

        return "redirect:/admin/songs";
    }

    @GetMapping("/api/songs/available")
    @ResponseBody
    // CRITICAL FIX: Changed return type and added mapping
    public List<SongDto> getAvailableSongsAPI() {
        return songsService.getAvailableSongs().stream()
                           .map(SongMapper::toDto)
                           .collect(Collectors.toList());
    }
}