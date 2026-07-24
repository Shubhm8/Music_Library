package com.music.admin.entity;

import java.time.LocalDate;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;

@Entity
@Table(name = "songs_library")
public class SongsLibrary {
    
    @Id 
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer libraryId;
    
    @Column(nullable = false, unique = true)
    private String songId;
    
    @Column(name = "image_path")
    private String imagePath;
    
    @Column(nullable = false)
    private String songName;
    
    private String musicDirector;
    private String singer;
    private LocalDate releaseDate;
    private String albumName;
    @Column(name = "audio_path")
    private String audioPath;
    
    @Column(columnDefinition = "VARCHAR(20) DEFAULT 'FREE'")
    private String songType = "FREE";
    
    @Column(columnDefinition = "VARCHAR(20) DEFAULT 'AVAILABLE'")
    private String songStatus = "AVAILABLE";
    
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
    
    public SongsLibrary() {}
    
    public Integer getLibraryId() { return libraryId; }
    public void setLibraryId(Integer libraryId) { this.libraryId = libraryId; }
    
    public String getSongId() { return songId; }
    public void setSongId(String songId) { this.songId = songId; }
    
    public String getSongName() { return songName; }
    public void setSongName(String songName) { this.songName = songName; }
    
    public String getMusicDirector() { return musicDirector; }
    public void setMusicDirector(String musicDirector) { this.musicDirector = musicDirector; }
    
    public String getSinger() { return singer; }
    public void setSinger(String singer) { this.singer = singer; }
    
    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }
    
    public LocalDate getReleaseDate() { return releaseDate; }
    public void setReleaseDate(LocalDate releaseDate) { this.releaseDate = releaseDate; }
    
    public String getAlbumName() { return albumName; }
    public void setAlbumName(String albumName) { this.albumName = albumName; }
    
    public String getAudioPath() { return audioPath; }
    public void setAudioPath(String audioPath) { this.audioPath = audioPath; }
    
    public String getSongType() { return songType; }
    public void setSongType(String songType) { this.songType = songType; }
    
    public String getSongStatus() { return songStatus; }
    public void setSongStatus(String songStatus) { this.songStatus = songStatus; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
