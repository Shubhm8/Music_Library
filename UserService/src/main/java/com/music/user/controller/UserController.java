package com.music.user.controller;

import com.music.user.entity.User;
import com.music.user.service.CustomUserDetailsService;
import com.music.user.service.UserService;
import com.music.user.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = {
        "http://localhost:8080",
        "http://localhost:8081",
        "http://localhost:8082",
        "http://192.168.1.52:8080",
        "http://192.168.1.52:8082"
})
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private CustomUserDetailsService userDetailsService;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private AuthenticationManager authenticationManager;

    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@RequestBody User user) {
        try {
            return ResponseEntity.status(HttpStatus.CREATED).body(userService.addUser(user));
        } catch (IllegalArgumentException exception) {
            return ResponseEntity.badRequest().body(Map.of("error", exception.getMessage()));
        } catch (Exception exception) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(Map.of("error", "Unable to register user"));
        }
    }

    @GetMapping("/all")
    public ResponseEntity<List<User>> getAllUsers() {
        return ResponseEntity.ok(userService.getAllUsers());
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getUserById(@PathVariable Integer id, Authentication authentication) {
        if (!isOwnerOrAdmin(id, authentication)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of("error", "Access denied"));
        }
        return userService.getUserById(id)
                .<ResponseEntity<?>>map(user -> ResponseEntity.ok(user))
                .orElseGet(() -> ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("error", "User not found")));
    }

    @PostMapping("/login")
    public ResponseEntity<?> loginUser(@RequestBody Map<String, String> loginData) {
        try {
            String userName = loginData.get("userName");
            String password = loginData.get("password");
            if (userName == null || password == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Invalid username or password"));
            }
            authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(userName, password));
            User user = userService.loginUser(userName, password);
            UserDetails userDetails = userDetailsService.loadUserByUsername(userName);
            String jwt = jwtUtil.generateToken(userDetails);
            Map<String, Object> response = new HashMap<>();
            response.put("jwt", jwt);
            response.put("user", user);
            return ResponseEntity.ok(response);
        } catch (BadCredentialsException exception) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Invalid username or password"));
        } catch (Exception exception) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Invalid username or password"));
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateUser(@PathVariable Integer id, @RequestBody User user,
                                        Authentication authentication) {
        if (!isOwnerOrAdmin(id, authentication)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of("error", "Access denied"));
        }
        try {
            return ResponseEntity.ok(userService.updateUser(id, user));
        } catch (IllegalArgumentException exception) {
            return ResponseEntity.badRequest().body(Map.of("error", exception.getMessage()));
        } catch (Exception exception) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("error", "Unable to update user"));
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteUser(@PathVariable Integer id, Authentication authentication) {
        if (!isOwnerOrAdmin(id, authentication)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of("error", "Access denied"));
        }
        try {
            userService.deleteUser(id);
            return ResponseEntity.ok(Map.of("message", "User deleted successfully"));
        } catch (Exception exception) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("error", "User not found"));
        }
    }

    @PutMapping("/status/{id}")
    public ResponseEntity<?> updateUserStatus(@PathVariable Integer id, @RequestParam String status) {
        if (!List.of("ACTIVE", "INACTIVE").contains(status == null ? "" : status.toUpperCase())) {
            return ResponseEntity.badRequest().body(Map.of("error", "Status must be ACTIVE or INACTIVE"));
        }
        try {
            userService.updateStatus(id, status.toUpperCase());
            return ResponseEntity.ok(Map.of("message", "User status updated"));
        } catch (Exception exception) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("error", "User not found"));
        }
    }

    private boolean isOwnerOrAdmin(Integer id, Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return false;
        }
        if (authentication.getAuthorities().stream().anyMatch(authority -> "ROLE_ADMIN".equals(authority.getAuthority()))) {
            return true;
        }
        return userService.getUserById(id)
                .map(user -> authentication.getName().equals(user.getUserName()))
                .orElse(false);
    }
}
