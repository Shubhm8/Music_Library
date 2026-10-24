package com.music.notification.controller;

import com.music.notification.entity.Notification;
import com.music.notification.repository.NotificationRepository;
import com.music.notification.service.EmailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/notify")
public class NotificationController {

    @Autowired
    private EmailService emailService;

    @Autowired
    private NotificationRepository notificationRepository;

    @Value("${notification.internal-api-key}")
    private String internalApiKey;

    @PostMapping("/songAdded")
    public String sendSongNotification(@RequestHeader("X-Internal-Api-Key") String apiKey,
                                       @RequestBody Map<String, Object> request) {
        if (!internalApiKey.equals(apiKey)) {
            throw new org.springframework.web.server.ResponseStatusException(HttpStatus.FORBIDDEN, "Forbidden");
        }

        String subject = (String) request.get("subject");
        String message = (String) request.get("message");

        String uiMessage = "🎵 " + subject;

        @SuppressWarnings("unchecked") List<Map<String, Object>> recipients = (List<Map<String, Object>>) request.getOrDefault("recipients", List.of());
        for (Map<String, Object> recipient : recipients) {
            Integer userId = ((Number) recipient.get("userId")).intValue();
            String email = (String) recipient.get("email");
            if (email != null && !email.isBlank()) emailService.sendEmail(email, subject, message);
            notificationRepository.save(new Notification(uiMessage, userId));
        }

        return "Notification Sent & Saved";
    }

    @GetMapping("/recent/{userId}")
    public List<Notification> getRecentNotifications(@RequestHeader("X-Internal-Api-Key") String apiKey, @PathVariable Integer userId) {
        requireInternalKey(apiKey);
        return notificationRepository.findTop10ByRecipientUserIdOrderByCreatedAtDesc(userId);
    }

    @DeleteMapping("/user/{userId}")
    public ResponseEntity<String> clearNotifications(@RequestHeader("X-Internal-Api-Key") String apiKey, @PathVariable Integer userId) {
        requireInternalKey(apiKey);
        notificationRepository.deleteByRecipientUserId(userId);
        return ResponseEntity.ok("All notifications cleared successfully.");
    }

    private void requireInternalKey(String apiKey) {
        if (!internalApiKey.equals(apiKey)) throw new org.springframework.web.server.ResponseStatusException(HttpStatus.FORBIDDEN, "Forbidden");
    }
}
