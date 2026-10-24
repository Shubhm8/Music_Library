package com.music.user.service;

import com.music.user.entity.Playlist;
import com.music.user.entity.User;
import com.music.user.repository.PlaylistRepository;
import com.music.user.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.access.AccessDeniedException;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class PlaylistServiceTest {

    @Mock
    private PlaylistRepository playlistRepository;

    @Mock
    private UserRepository userRepository;

    private PlaylistService playlistService;

    @BeforeEach
    void setUp() {
        playlistService = new PlaylistService(playlistRepository, userRepository);
    }

    @Test
    void userCannotReadAnotherUsersPlaylists() {
        User alice = user(1, "alice");
        when(userRepository.findByUserName("alice")).thenReturn(alice);

        assertThrows(AccessDeniedException.class,
                () -> playlistService.getUserPlaylists("alice", 2));
    }

    @Test
    void userCannotAddSongToAnotherUsersPlaylist() {
        User alice = user(1, "alice");
        User bob = user(2, "bob");
        Playlist bobsPlaylist = new Playlist("Private playlist", bob);
        when(playlistRepository.findById(9)).thenReturn(Optional.of(bobsPlaylist));

        assertThrows(AccessDeniedException.class,
                () -> playlistService.addSongToPlaylist("alice", 9, "song-1"));
    }

    private User user(Integer id, String username) {
        User user = new User();
        user.setUserId(id);
        user.setUserName(username);
        user.setStatus("ACTIVE");
        return user;
    }
}
