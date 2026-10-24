package com.music.user.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.music.user.entity.User;
import com.music.user.repository.UserRepository;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    // 1. Add User 
    public User addUser(User user) {
        if (user == null || isBlank(user.getFirstName()) || isBlank(user.getLastName())
                || isBlank(user.getUserName()) || isBlank(user.getEmail()) || isBlank(user.getPassword())) {
            throw new IllegalArgumentException("First name, last name, username, email, and password are required");
        }
        if (user.getUserName().length() > 100 || user.getEmail().length() > 254
                || user.getPassword().length() < 8
                || user.getPassword().getBytes(java.nio.charset.StandardCharsets.UTF_8).length > 72) {
            throw new IllegalArgumentException("Username/email is too long or password must be between 8 and 72 UTF-8 bytes");
        }
        if (userRepository.findByUserName(user.getUserName()) != null) {
            throw new IllegalArgumentException("Username already exists");
        }
        user.setUserId(null);
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setStatus("ACTIVE");
        user.setPlaylists(new java.util.ArrayList<>());
        return userRepository.save(user);
    }

    private boolean isBlank(String value) {
        return value == null || value.isBlank();
    }
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }
    
    public Optional<User> getUserById(Integer id) {
        return userRepository.findById(id);
    }
    
    public User loginUser(String userName, String password) {
        User user = userRepository.findByUserName(userName);
        
        if (user == null) {
            throw new RuntimeException("Invalid Username or Password");
        }

        if ("INACTIVE".equalsIgnoreCase(user.getStatus())) {
            throw new RuntimeException("Your account is BLOCKED. Please contact Admin.");
        }
        return user;
    }

    public User updateUser(Integer id, User userDetails) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + id));

        user.setFirstName(userDetails.getFirstName());
        user.setLastName(userDetails.getLastName());
        user.setEmail(userDetails.getEmail());
        user.setMobile(userDetails.getMobile());
        user.setCity(userDetails.getCity());
        user.setCountry(userDetails.getCountry());
        
        if(userDetails.getPassword() != null && !userDetails.getPassword().isEmpty()){
            user.setPassword(passwordEncoder.encode(userDetails.getPassword()));
        }

        return userRepository.save(user);
    }

    public void deleteUser(Integer id) {
        if (userRepository.existsById(id)) {
            userRepository.deleteById(id);
        } else {
            throw new RuntimeException("User not found with id: " + id);
        }
    }
 
    public void updateStatus(Integer id, String status) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + id));
        
        user.setStatus(status);
        userRepository.save(user);
    }
}