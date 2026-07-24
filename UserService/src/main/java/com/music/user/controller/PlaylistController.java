package com.music.user.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.music.user.entity.Playlist;
import com.music.user.service.PlaylistService;

@RestController
@RequestMapping("/api/playlists")
@CrossOrigin(origins = "*") // Allow frontend to access
public class PlaylistController {

    @Autowired
    private PlaylistService playlistService;

    // CREATE Playlist
    @PostMapping("/create")
    public Playlist createPlaylist(@RequestParam Integer userId, @RequestParam String name) {
        return playlistService.createPlaylist(userId, name);
    }

    // GET User's Playlists
    @GetMapping("/user/{userId}")
    public List<Playlist> getUserPlaylists(@PathVariable Integer userId) {
        return playlistService.getUserPlaylists(userId);
    }

    // ADD Song to Playlist
    @PostMapping("/{playlistId}/add/{songId}")
    public Playlist addSong(@PathVariable Integer playlistId, @PathVariable String songId) {
        return playlistService.addSongToPlaylist(playlistId, songId);
    }

    // REMOVE Song from Playlist
    @DeleteMapping("/{playlistId}/remove/{songId}")
    public Playlist removeSong(@PathVariable Integer playlistId, @PathVariable String songId) {
        return playlistService.removeSongFromPlaylist(playlistId, songId);
    }

    // DELETE Playlist
    @DeleteMapping("/{id}")
    public String deletePlaylist(@PathVariable Integer id) {
        playlistService.deletePlaylist(id);
        return "Playlist deleted successfully";
    }
 // UPDATE Playlist Name
    @PutMapping("/{id}")
    public Playlist updatePlaylist(@PathVariable Integer id, @RequestParam String name) {
        return playlistService.renamePlaylist(id, name);
    }
}