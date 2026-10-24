package com.music.user.controller;

import com.music.user.service.UserService;
import java.util.List;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.*;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

@RestController
@RequestMapping("/api/notifications")
public class NotificationProxyController {
    private final UserService users;
    private final RestTemplate client = new RestTemplate();
    @Value("${notification.service.url}") private String notificationUrl;
    @Value("${internal.api-key}") private String apiKey;
    public NotificationProxyController(UserService users) { this.users = users; }
    @GetMapping("/recent")
    public List<Object> recent(Authentication authentication) {
        return client.exchange(notificationUrl + "/notify/recent/" + users.getUserByUserName(authentication.getName()).getUserId(), HttpMethod.GET, request(), new ParameterizedTypeReference<List<Object>>() {}).getBody();
    }
    @DeleteMapping
    public ResponseEntity<Void> clear(Authentication authentication) {
        client.exchange(notificationUrl + "/notify/user/" + users.getUserByUserName(authentication.getName()).getUserId(), HttpMethod.DELETE, request(), Void.class);
        return ResponseEntity.noContent().build();
    }
    private HttpEntity<Void> request() { HttpHeaders h = new HttpHeaders(); h.set("X-Internal-Api-Key", apiKey); return new HttpEntity<>(h); }
}
