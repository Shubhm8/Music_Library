package com.music.notification.controller;

import com.music.notification.entity.Notification;
import com.music.notification.repository.NotificationRepository;
import com.music.notification.service.EmailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/notify")
@CrossOrigin(origins = "http://localhost:8081") // Allow User Service to fetch
public class NotificationController {

    @Autowired
    private EmailService emailService;
    
    @Autowired
    private NotificationRepository notificationRepository;
    @PostMapping("/songAdded")
    public String sendSongNotification(@RequestBody Map<String, String> request) {
        String subject = request.get("subject");
        String message = request.get("message");
        String to = request.get("to");
        emailService.sendEmail(to, subject, message);
        String uiMessage = "🎵 " + subject; 
        notificationRepository.save(new Notification(uiMessage));

        return "Notification Sent & Saved";
    }
    @GetMapping("/recent")
    public List<Notification> getRecentNotifications() {
        return notificationRepository.findTop10ByOrderByCreatedAtDesc();
    }
}