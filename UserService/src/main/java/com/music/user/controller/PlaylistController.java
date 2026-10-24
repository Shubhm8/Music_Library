package com.music.user.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.Authentication;

import com.music.user.entity.Playlist;
import com.music.user.service.PlaylistService;
import com.music.user.service.UserService;

@RestController
@RequestMapping("/api/playlists")
@CrossOrigin(origins = "*") // Allow frontend to access
public class PlaylistController {

    @Autowired
    private PlaylistService playlistService;

    @Autowired
    private UserService userService;

    // CREATE Playlist
    @PostMapping("/create")
    public Playlist createPlaylist(@RequestParam Integer userId, @RequestParam String name, Authentication authentication) {
        requireOwner(userId, authentication);
        return playlistService.createPlaylist(userId, name);
    }

    // GET User's Playlists
    @GetMapping("/user/{userId}")
    public List<Playlist> getUserPlaylists(@PathVariable Integer userId, Authentication authentication) {
        requireOwner(userId, authentication);
        return playlistService.getUserPlaylists(userId);
    }

    // ADD Song to Playlist
    @PostMapping("/{playlistId}/add/{songId}")
    public Playlist addSong(@PathVariable Integer playlistId, @PathVariable String songId, Authentication authentication) {
        requirePlaylistOwner(playlistId, authentication);
        return playlistService.addSongToPlaylist(playlistId, songId);
    }

    // REMOVE Song from Playlist
    @DeleteMapping("/{playlistId}/remove/{songId}")
    public Playlist removeSong(@PathVariable Integer playlistId, @PathVariable String songId, Authentication authentication) {
        requirePlaylistOwner(playlistId, authentication);
        return playlistService.removeSongFromPlaylist(playlistId, songId);
    }

    // DELETE Playlist
    @DeleteMapping("/{id}")
    public String deletePlaylist(@PathVariable Integer id, Authentication authentication) {
        requirePlaylistOwner(id, authentication);
        playlistService.deletePlaylist(id);
        return "Playlist deleted successfully";
    }
 // UPDATE Playlist Name
    @PutMapping("/{id}")
    public Playlist updatePlaylist(@PathVariable Integer id, @RequestParam String name, Authentication authentication) {
        requirePlaylistOwner(id, authentication);
        return playlistService.renamePlaylist(id, name);
    }

    private void requireOwner(Integer userId, Authentication authentication) {
        if (!userService.getUserByUserName(authentication.getName()).getUserId().equals(userId)) {
            throw new org.springframework.security.access.AccessDeniedException("Playlist operations require ownership validation");
        }
    }

    private void requirePlaylistOwner(Integer playlistId, Authentication authentication) {
        boolean owned = playlistService.getUserPlaylists(userService.getUserByUserName(authentication.getName()).getUserId())
                .stream().anyMatch(playlist -> playlist.getPlaylistId().equals(playlistId));
        if (!owned) {
            throw new org.springframework.security.access.AccessDeniedException("Playlist operations require ownership validation");
        }
    }
}
