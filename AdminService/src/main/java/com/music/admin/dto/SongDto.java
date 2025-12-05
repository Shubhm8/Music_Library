package com.music.admin.dto;

import java.time.LocalDate;

public class SongDto {
 
    private Long libraryId;
     
    private String imagePath; 

    private String songName;
    private String musicDirector;
    private String singer;
    private LocalDate releaseDate;
    private String albumName;
    private String songType;   
    private String songStatus; 
    private String audioPath;

    public SongDto() {} 

    public Long getLibraryId() { return libraryId; }
    public void setLibraryId(Long libraryId) { this.libraryId = libraryId; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }

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
}