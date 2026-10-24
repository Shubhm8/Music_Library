package com.music.user.controller;

import com.music.user.entity.Playlist;
import com.music.user.service.PlaylistService;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/playlists")
public class PlaylistController {

    private final PlaylistService playlistService;

    public PlaylistController(PlaylistService playlistService) {
        this.playlistService = playlistService;
    }

    @PostMapping("/create")
    public Playlist createPlaylist(Authentication authentication, @RequestParam String name) {
        return playlistService.createPlaylist(authentication.getName(), name);
    }

    @GetMapping("/user/{userId}")
    public List<Playlist> getUserPlaylists(Authentication authentication, @PathVariable Integer userId) {
        return playlistService.getUserPlaylists(authentication.getName(), userId);
    }

    @PostMapping("/{playlistId}/add/{songId}")
    public Playlist addSong(Authentication authentication, @PathVariable Integer playlistId,
                            @PathVariable String songId) {
        return playlistService.addSongToPlaylist(authentication.getName(), playlistId, songId);
    }

    @DeleteMapping("/{playlistId}/remove/{songId}")
    public Playlist removeSong(Authentication authentication, @PathVariable Integer playlistId,
                               @PathVariable String songId) {
        return playlistService.removeSongFromPlaylist(authentication.getName(), playlistId, songId);
    }

    @DeleteMapping("/{id}")
    public String deletePlaylist(Authentication authentication, @PathVariable Integer id) {
        playlistService.deletePlaylist(authentication.getName(), id);
        return "Playlist deleted successfully";
    }

    @PutMapping("/{id}")
    public Playlist updatePlaylist(Authentication authentication, @PathVariable Integer id,
                                   @RequestParam String name) {
        return playlistService.renamePlaylist(authentication.getName(), id, name);
    }
}
