package com.music.admin.repository;

import com.music.admin.entity.SongsLibrary;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SongsLibraryRepository extends JpaRepository<SongsLibrary, Integer> {

    // Existing filters
    List<SongsLibrary> findBySongStatus(String songStatus);
    List<SongsLibrary> findBySongType(String songType);
    List<SongsLibrary> findBySongStatusAndSongType(String songStatus, String songType);

    // Search by individual fields
    List<SongsLibrary> findBySongNameContainingIgnoreCase(String name);
    List<SongsLibrary> findBySingerContainingIgnoreCase(String singer);
    List<SongsLibrary> findByMusicDirectorContainingIgnoreCase(String director);
    List<SongsLibrary> findByAlbumNameContainingIgnoreCase(String album);

    //  Search across multiple fields
    @Query("SELECT s FROM SongsLibrary s WHERE " +
           "LOWER(s.songName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(s.singer) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(s.musicDirector) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(s.albumName) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    List<SongsLibrary> searchAcrossFields(@Param("keyword") String keyword);
}
