package com.music.user.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class UserPageController {

    @GetMapping("/")
    public String home() {
        return "home"; // Loads home.jsp
    }

    @GetMapping("/login")
    public String showLoginPage() {
        return "login"; // Loads login.jsp
    }

    @GetMapping("/register")
    public String showRegisterPage() {
        return "register"; // Loads register.jsp
    }
    
    @GetMapping("/user/dashboard")
    public String showDashboard() {
        return "dashboard"; // Loads dashboard.jsp
    }

    @GetMapping("/user/library")
    public String showLibrary() {
        return "userLibrary"; // Loads userLibrary.jsp
    }

    @GetMapping("/user/playlists")
    public String showPlaylists() {
        return "myPlaylists"; // Loads myPlaylists.jsp
    }

    @GetMapping("/user/playlist/details")
    public String showPlaylistDetails() {
        return "playlistDetails"; // Loads playlistDetails.jsp
    }

    @GetMapping("/user/profile")
    public String showProfile() {
        return "userProfile"; // Loads userProfile.jsp
    }
}