package com.music.user.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.music.user.entity.Playlist;
import com.music.user.entity.User;
import java.util.List;

@Repository
public interface PlaylistRepository extends JpaRepository<Playlist, Integer> {
    // Find all playlists created by a specific user
    List<Playlist> findByUser(User user);
}