package com.music.user.controller;

import com.music.user.entity.User;
import com.music.user.service.RazorpayService;
import com.music.user.service.UserService;
import java.time.LocalDateTime;
import java.util.Map;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/subscription")
public class SubscriptionController {
    private final UserService users;
    private final RazorpayService razorpay;
    public SubscriptionController(UserService users, RazorpayService razorpay) { this.users = users; this.razorpay = razorpay; }

    @GetMapping("/status")
    public Map<String, Object> status(Authentication authentication) {
        User user = current(authentication);
        boolean premium = user.getPremiumUntil() != null && user.getPremiumUntil().isAfter(LocalDateTime.now());
        return Map.of("premium", premium, "premiumUntil", user.getPremiumUntil() == null ? "" : user.getPremiumUntil().toString(), "monthlyPricePaise", razorpay.getPricePaise());
    }
    @PostMapping("/order")
    public Map<String, Object> order(Authentication authentication) throws Exception { return razorpay.createOrder(current(authentication)); }
    @PostMapping("/verify")
    public ResponseEntity<Void> verify(Authentication authentication, @RequestBody Map<String, String> body) throws Exception {
        User user = current(authentication);
        razorpay.verifyAndActivate(user, body.get("razorpay_order_id"), body.get("razorpay_payment_id"), body.get("razorpay_signature"));
        users.save(user);
        return ResponseEntity.noContent().build();
    }
    @PostMapping("/webhook")
    public ResponseEntity<Void> webhook(@RequestHeader("X-Razorpay-Signature") String signature, @RequestBody String body) throws Exception {
        razorpay.handleWebhook(body, signature);
        return ResponseEntity.noContent().build();
    }
    @PutMapping("/notifications")
    public Map<String, Boolean> notificationPreference(Authentication authentication, @RequestBody Map<String, Boolean> body) {
        User user = current(authentication); user.setNotificationsEnabled(Boolean.TRUE.equals(body.get("enabled"))); users.save(user); return Map.of("enabled", user.isNotificationsEnabled());
    }
    private User current(Authentication authentication) { return users.getUserByUserName(authentication.getName()); }
}
