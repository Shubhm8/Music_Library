package com.music.admin.service;

import com.music.admin.entity.Admin;
import com.music.admin.repository.AdminRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.security.crypto.password.PasswordEncoder;
import java.util.Optional;

@Service
public class AdminService {
    
    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;
    
    // Admin Login
    public Admin loginAdmin(String userName, String password) {
        Optional<Admin> admin = adminRepository.findByUserName(userName);
        
        if (admin.isPresent()) {
            String storedPassword = admin.get().getPassword();
            if (storedPassword.startsWith("$2")
                    ? passwordEncoder.matches(password, storedPassword)
                    : password.equals(storedPassword)) {
                // One-time compatibility migration for accounts created before BCrypt.
                if (!storedPassword.startsWith("$2")) {
                    admin.get().setPassword(passwordEncoder.encode(password));
                    adminRepository.save(admin.get());
                }
                return admin.get();
            } else {
                throw new RuntimeException("Invalid password!");
            }
        } else {
            throw new RuntimeException("Admin not found!");
        }
    }
    
    // Add Admin  
    public Admin addAdmin(Admin admin) {
        if (adminRepository.existsByUserName(admin.getUserName())) {
            throw new RuntimeException("Admin username already exists!");
        }
        admin.setPassword(passwordEncoder.encode(admin.getPassword()));
        return adminRepository.save(admin);
    }
}
