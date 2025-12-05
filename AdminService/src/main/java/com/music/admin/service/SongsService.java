package com.music.admin.service;

import com.music.admin.entity.SongsLibrary;
import com.music.admin.repository.SongsLibraryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class SongsService {

    @Autowired
    private SongsLibraryRepository songsRepository;

    @Autowired
    private RestTemplate restTemplate;

    public SongsLibrary addSong(SongsLibrary song) {

        // Save song in DB
        SongsLibrary savedSong = songsRepository.save(song);
        try {
            Map<String, String> request = new HashMap<>();
            request.put("to", "shubhm8335@gmail.com"); 
            request.put("subject", "New Song Added: " + savedSong.getSongName());
            request.put("message",
                    "A new song was added to the Music Library!\n\n" +
                    "Song Name: " + savedSong.getSongName() + "\n" +
                    "Singer: " + savedSong.getSinger() + "\n" +
                    "Album: " + savedSong.getAlbumName());

            // Call Notification Microservice
            restTemplate.postForObject(
                    "http://localhost:8085/notify/songAdded",
                    request,
                    String.class
            );
        } catch (Exception e) {
            System.err.println("Notification failed: " + e.getMessage());
        }

        return savedSong;
    }

    public List<SongsLibrary> getAllSongs() {
        return songsRepository.findAll();
    }

    public List<SongsLibrary> getAvailableSongs() {
        return songsRepository.findBySongStatus("AVAILABLE");
    }

    public List<SongsLibrary> getFreeSongs() {
        return songsRepository.findBySongType("FREE");
    }

    public SongsLibrary updateSong(Integer id, SongsLibrary songData) {
        return songsRepository.findById(id).map(song -> {
            song.setSongName(songData.getSongName());
            song.setSinger(songData.getSinger());
            song.setAlbumName(songData.getAlbumName());
            song.setMusicDirector(songData.getMusicDirector());
            song.setReleaseDate(songData.getReleaseDate());
            song.setSongStatus(songData.getSongStatus());
            song.setSongType(songData.getSongType());
            
            // 1. Update Audio Path  
            if (songData.getAudioPath() != null && !songData.getAudioPath().isEmpty()) {
                song.setAudioPath(songData.getAudioPath());
            }

            // 2. Update Image Path  
            if (songData.getImagePath() != null && !songData.getImagePath().isEmpty()) {
                song.setImagePath(songData.getImagePath());
            }

            return songsRepository.save(song);
        }).orElseThrow(() -> new RuntimeException("Song not found"));
    }

    public void deleteSong(Integer id) {
        songsRepository.deleteById(id);
    }

    public SongsLibrary getSongById(Integer id) {
        return songsRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Song not found with id: " + id));
    }

    public List<SongsLibrary> searchSongs(String keyword) {
        return songsRepository.searchAcrossFields(keyword);
    }
}