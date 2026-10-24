package com.music.user.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager; // 👈 NEW IMPORT
import org.springframework.security.authentication.BadCredentialsException; // 👈 NEW IMPORT
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken; // 👈 NEW IMPORT
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.access.prepost.PreAuthorize;

import com.music.user.entity.User;
import com.music.user.service.CustomUserDetailsService;
import com.music.user.service.UserService;
import com.music.user.util.JwtUtil;

@RestController  
@RequestMapping("/api/users")
@CrossOrigin(origins = "*")
public class UserController {
    
    @Autowired
    private UserService userService;

    @Autowired
    private CustomUserDetailsService userDetailsService;

    @Autowired
    private JwtUtil jwtUtil;
    
    @Autowired
    private AuthenticationManager authenticationManager; // 👈 INJECT AUTH MANAGER
    
    // Add User  
    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@RequestBody User user) {
        try {
            User savedUser = userService.addUser(user);
            return new ResponseEntity<>(savedUser, HttpStatus.CREATED);
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }
    
    // Show All Users
    @GetMapping("/all")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<User>> getAllUsers() {
        List<User> users = userService.getAllUsers();
        return new ResponseEntity<>(users, HttpStatus.OK);
    }
    
    // Get User by ID
    @GetMapping("/{id}")
    public ResponseEntity<?> getUserById(@PathVariable Integer id, Authentication authentication) {
        try {
            requireSelfOrAdmin(id, authentication);
            User user = userService.getUserById(id)
                    .orElseThrow(() -> new RuntimeException("User not found!"));
            return new ResponseEntity<>(user, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.NOT_FOUND);
        }
    }
    
    // Login User  
    @PostMapping("/login")
    public ResponseEntity<?> loginUser(@RequestBody Map<String, String> loginData) {
        try {
            String userName = loginData.get("userName");
            String password = loginData.get("password");
            try {
                authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(userName, password)
                );
            } catch (BadCredentialsException e) {
                throw new RuntimeException("Invalid Username or Password");
            }
            User user = userService.loginUser(userName, password); 
            final UserDetails userDetails = userDetailsService.loadUserByUsername(userName);
            // 4. Generate Token
            final String jwt = jwtUtil.generateToken(userDetails);
            // 5. Return Response 
            Map<String, Object> response = new HashMap<>();
            response.put("jwt", jwt);
            response.put("user", user); 
            
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.UNAUTHORIZED);
        }
    }
    
    // Update User Details
    @PutMapping("/{id}")
    public ResponseEntity<?> updateUser(@PathVariable Integer id, @RequestBody User user, Authentication authentication) {
        try {
            requireSelfOrAdmin(id, authentication);
            User updatedUser = userService.updateUser(id, user);
            return new ResponseEntity<>(updatedUser, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.NOT_FOUND);
        }
    }
    
    // Delete User
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> deleteUser(@PathVariable Integer id) {
        try {
            userService.deleteUser(id);
            return new ResponseEntity<>("User deleted successfully!", HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.NOT_FOUND);
        }
    }

    // Update User Status  
    @PutMapping("/status/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> updateUserStatus(@PathVariable Integer id, @RequestParam String status) {
        try {
            userService.updateStatus(id, status);
            return new ResponseEntity<>("User status updated to " + status, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.NOT_FOUND);
        }
    }

    private void requireSelfOrAdmin(Integer id, Authentication authentication) {
        boolean admin = authentication.getAuthorities().stream()
                .anyMatch(a -> "ROLE_ADMIN".equals(a.getAuthority()));
        if (!admin && !userService.getUserByUserName(authentication.getName()).getUserId().equals(id)) {
            throw new org.springframework.security.access.AccessDeniedException("You may only access your own account");
        }
    }
}
