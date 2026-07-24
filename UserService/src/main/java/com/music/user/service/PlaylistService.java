package com.music.user.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.music.user.entity.Playlist;
import com.music.user.entity.User;
import com.music.user.repository.PlaylistRepository;
import com.music.user.repository.UserRepository;

@Service
public class PlaylistService {

    @Autowired
    private PlaylistRepository playlistRepository;

    @Autowired
    private UserRepository userRepository;

    // 1. Create a new Playlist
    public Playlist createPlaylist(Integer userId, String playlistName) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Playlist playlist = new Playlist(playlistName, user);
        return playlistRepository.save(playlist);
    }

    // 2. Get all Playlists for a User
    public List<Playlist> getUserPlaylists(Integer userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return playlistRepository.findByUser(user);
    }

    // 3. Add a Song to a Playlist
    public Playlist addSongToPlaylist(Integer playlistId, String songId) {
        Playlist playlist = playlistRepository.findById(playlistId)
                .orElseThrow(() -> new RuntimeException("Playlist not found"));
        
        // Prevent duplicates
        if (!playlist.getSongIds().contains(songId)) {
            playlist.getSongIds().add(songId);
            return playlistRepository.save(playlist);
        }
        return playlist;
    }

    // 4. Remove a Song from a Playlist
    public Playlist removeSongFromPlaylist(Integer playlistId, String songId) {
        Playlist playlist = playlistRepository.findById(playlistId)
                .orElseThrow(() -> new RuntimeException("Playlist not found"));
        
        playlist.getSongIds().remove(songId);
        return playlistRepository.save(playlist);
    }

    // 5. Delete a Playlist
    public void deletePlaylist(Integer playlistId) {
        playlistRepository.deleteById(playlistId);
    }
 // 6. Rename Playlist
    public Playlist renamePlaylist(Integer playlistId, String newName) {
        Playlist playlist = playlistRepository.findById(playlistId)
                .orElseThrow(() -> new RuntimeException("Playlist not found"));
        
        playlist.setPlaylistName(newName);
        return playlistRepository.save(playlist);
    }
}