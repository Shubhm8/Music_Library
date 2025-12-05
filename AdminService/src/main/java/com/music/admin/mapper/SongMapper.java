package com.music.admin.mapper;

import com.music.admin.dto.SongDto;
import com.music.admin.entity.SongsLibrary;

public class SongMapper {

    public static SongDto toDto(SongsLibrary entity) {
        if (entity == null) {
            return null;
        }
        
        SongDto dto = new SongDto(); 
        if (entity.getLibraryId() != null) {
            dto.setLibraryId(entity.getLibraryId().longValue());
        }

        dto.setImagePath(entity.getImagePath());
        dto.setSongName(entity.getSongName());
        dto.setMusicDirector(entity.getMusicDirector());
        dto.setSinger(entity.getSinger());
        dto.setReleaseDate(entity.getReleaseDate());
        dto.setAlbumName(entity.getAlbumName());
        dto.setSongType(entity.getSongType());
        dto.setSongStatus(entity.getSongStatus());
        dto.setAudioPath(entity.getAudioPath()); 
        
        return dto;
    }
}