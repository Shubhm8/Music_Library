package com.music.user.dto; // (Check package name for AdminService)

import java.time.LocalDate;

public class SongDto {

    // --- ADD THIS NEW FIELD ---
    private Long libraryId; 
    // --------------------------

    private String songName;
    private String musicDirector;
    private String singer;
    private LocalDate releaseDate;
    private String albumName;
    private String songType;
    private String songStatus;
    private String audioPath;
    private String imagePath; // Ensure this is here too for images

    public SongDto() {}

    // --- ADD GETTERS AND SETTERS FOR libraryId ---
    public Long getLibraryId() { return libraryId; }
    public void setLibraryId(Long libraryId) { this.libraryId = libraryId; }
    // ---------------------------------------------

    public String getSongName() { return songName; }
    public void setSongName(String songName) { this.songName = songName; }

    public String getMusicDirector() { return musicDirector; }
    public void setMusicDirector(String musicDirector) { this.musicDirector = musicDirector; }

    public String getSinger() { return singer; }
    public void setSinger(String singer) { this.singer = singer; }

    public LocalDate getReleaseDate() { return releaseDate; }
    public void setReleaseDate(LocalDate releaseDate) { this.releaseDate = releaseDate; }

    public String getAlbumName() { return albumName; }
    public void setAlbumName(String albumName) { this.albumName = albumName; }

    public String getSongType() { return songType; }
    public void setSongType(String songType) { this.songType = songType; }

    public String getSongStatus() { return songStatus; }
    public void setSongStatus(String songStatus) { this.songStatus = songStatus; }

    public String getAudioPath() { return audioPath; }
    public void setAudioPath(String audioPath) { this.audioPath = audioPath; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }
}