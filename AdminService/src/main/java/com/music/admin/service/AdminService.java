package com.music.admin.service;

import com.music.admin.entity.Admin;
import com.music.admin.repository.AdminRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.Optional;

@Service
public class AdminService {
    
    @Autowired
    private AdminRepository adminRepository;
    
    // Admin Login
    public Admin loginAdmin(String userName, String password) {
        Optional<Admin> admin = adminRepository.findByUserName(userName);
        
        if (admin.isPresent()) {
            if (admin.get().getPassword().equals(password)) {
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
        return adminRepository.save(admin);
    }
}
