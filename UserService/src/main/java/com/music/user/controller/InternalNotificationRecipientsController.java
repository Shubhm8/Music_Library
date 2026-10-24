package com.music.user.controller;

import com.music.user.repository.UserRepository;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/internal/users")
public class InternalNotificationRecipientsController {
    private final UserRepository users;
    @Value("${internal.api-key}") private String apiKey;
    public InternalNotificationRecipientsController(UserRepository users) { this.users = users; }
    @GetMapping("/notification-recipients")
    public List<Map<String, Object>> recipients(@RequestHeader("X-Internal-Api-Key") String key) {
        if (!apiKey.equals(key)) throw new org.springframework.web.server.ResponseStatusException(org.springframework.http.HttpStatus.FORBIDDEN);
        return users.findAll().stream().filter(u -> "ACTIVE".equalsIgnoreCase(u.getStatus()) && u.isNotificationsEnabled())
                .map(u -> Map.<String, Object>of("userId", u.getUserId(), "email", u.getEmail())).toList();
    }
}
