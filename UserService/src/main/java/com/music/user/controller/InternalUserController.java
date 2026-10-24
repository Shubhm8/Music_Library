package com.music.user.controller;

import com.music.user.entity.User;
import com.music.user.service.UserService;
import java.time.LocalDateTime;
import java.util.Map;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/internal/users")
public class InternalUserController {
    private final UserService users;
    @Value("${internal.api-key}") private String apiKey;
    public InternalUserController(UserService users) { this.users = users; }
    @GetMapping("/{username}/premium")
    public Map<String, Boolean> premium(@RequestHeader("X-Internal-Api-Key") String key, @PathVariable String username) {
        if (!apiKey.equals(key)) throw new org.springframework.web.server.ResponseStatusException(org.springframework.http.HttpStatus.FORBIDDEN);
        User user = users.getUserByUserName(username);
        return Map.of("premium", user.getPremiumUntil() != null && user.getPremiumUntil().isAfter(LocalDateTime.now()));
    }
}
