package com.music.user.service;

import com.music.user.entity.Playlist;
import com.music.user.entity.User;
import com.music.user.repository.PlaylistRepository;
import com.music.user.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PlaylistService {

    private final PlaylistRepository playlistRepository;
    private final UserRepository userRepository;

    public PlaylistService(PlaylistRepository playlistRepository, UserRepository userRepository) {
        this.playlistRepository = playlistRepository;
        this.userRepository = userRepository;
    }

    public Playlist createPlaylist(String username, String playlistName) {
        if (playlistName == null || playlistName.isBlank() || playlistName.length() > 100) {
            throw new IllegalArgumentException("Playlist name must be between 1 and 100 characters");
        }
        User user = userRepository.findByUserName(username);
        if (user == null || !"ACTIVE".equalsIgnoreCase(user.getStatus())) {
            throw new IllegalArgumentException("Active user account not found");
        }
        return playlistRepository.save(new Playlist(playlistName.trim(), user));
    }

    public List<Playlist> getUserPlaylists(String username, Integer requestedUserId) {
        User owner = userRepository.findByUserName(username);
        if (owner == null || !owner.getUserId().equals(requestedUserId)) {
            throw new org.springframework.security.access.AccessDeniedException("You can only view your own playlists");
        }
        return playlistRepository.findByUser(owner);
    }

    public Playlist addSongToPlaylist(String username, Integer playlistId, String songId) {
        Playlist playlist = getOwnedPlaylist(username, playlistId);
        if (songId == null || songId.isBlank() || songId.length() > 100) {
            throw new IllegalArgumentException("Invalid song ID");
        }
        if (!playlist.getSongIds().contains(songId)) {
            playlist.getSongIds().add(songId);
        }
        return playlistRepository.save(playlist);
    }

    public Playlist removeSongFromPlaylist(String username, Integer playlistId, String songId) {
        Playlist playlist = getOwnedPlaylist(username, playlistId);
        playlist.getSongIds().remove(songId);
        return playlistRepository.save(playlist);
    }

    public void deletePlaylist(String username, Integer playlistId) {
        playlistRepository.delete(getOwnedPlaylist(username, playlistId));
    }

    public Playlist renamePlaylist(String username, Integer playlistId, String newName) {
        if (newName == null || newName.isBlank() || newName.length() > 100) {
            throw new IllegalArgumentException("Playlist name must be between 1 and 100 characters");
        }
        Playlist playlist = getOwnedPlaylist(username, playlistId);
        playlist.setPlaylistName(newName.trim());
        return playlistRepository.save(playlist);
    }

    private Playlist getOwnedPlaylist(String username, Integer playlistId) {
        Playlist playlist = playlistRepository.findById(playlistId)
                .orElseThrow(() -> new IllegalArgumentException("Playlist not found"));
        if (playlist.getUser() == null || !username.equals(playlist.getUser().getUserName())) {
            throw new org.springframework.security.access.AccessDeniedException("You do not own this playlist");
        }
        return playlist;
    }
}
