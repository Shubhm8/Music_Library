package com.music.notification.controller;

import com.music.notification.entity.Notification;
import com.music.notification.repository.NotificationRepository;
import com.music.notification.service.EmailService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

@RestController
@RequestMapping("/notify")
@CrossOrigin(origins = {
        "http://localhost:8080",
        "http://localhost:8082",
        "http://192.168.1.52:8080",
        "http://192.168.1.52:8082"
})
public class NotificationController {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    private final EmailService emailService;
    private final NotificationRepository notificationRepository;
    private final String expectedApiKey;

    public NotificationController(EmailService emailService,
                                  NotificationRepository notificationRepository,
                                  @Value("${notification.api-key}") String expectedApiKey) {
        this.emailService = emailService;
        this.notificationRepository = notificationRepository;
        this.expectedApiKey = expectedApiKey;
    }

    @PostMapping("/songAdded")
    public ResponseEntity<?> sendSongNotification(
            @RequestHeader(value = "X-Notification-Key", required = false) String apiKey,
            @RequestBody Map<String, String> request) {
        if (!isAuthorized(apiKey)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Unauthorized"));
        }
        String subject = request.get("subject");
        String message = request.get("message");
        String to = request.get("to");
        if (isBlank(subject) || isBlank(message) || isBlank(to)
                || subject.length() > 200 || message.length() > 5000
                || !EMAIL_PATTERN.matcher(to).matches()) {
            return ResponseEntity.badRequest().body(Map.of("error", "Invalid notification fields"));
        }

        emailService.sendEmail(to, subject, message);
        notificationRepository.save(new Notification("🎵 " + subject));
        return ResponseEntity.ok(Map.of("message", "Notification processed"));
    }

    @GetMapping("/recent")
    public ResponseEntity<?> getRecentNotifications(
            @RequestHeader(value = "X-Notification-Key", required = false) String apiKey) {
        if (!isAuthorized(apiKey)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Unauthorized"));
        }
        List<Notification> notifications = notificationRepository.findTop10ByOrderByCreatedAtDesc();
        return ResponseEntity.ok(notifications);
    }

    @DeleteMapping("/all")
    public ResponseEntity<String> clearNotifications(
            @RequestHeader(value = "X-Notification-Key", required = false) String apiKey) {
        if (!isAuthorized(apiKey)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Unauthorized");
        }
        notificationRepository.deleteAll();
        return ResponseEntity.ok("All notifications cleared successfully.");
    }

    private boolean isAuthorized(String suppliedKey) {
        if (suppliedKey == null || expectedApiKey == null || expectedApiKey.isBlank()) {
            return false;
        }
        return MessageDigest.isEqual(expectedApiKey.getBytes(StandardCharsets.UTF_8),
                suppliedKey.getBytes(StandardCharsets.UTF_8));
    }

    private boolean isBlank(String value) {
        return value == null || value.isBlank();
    }
}
