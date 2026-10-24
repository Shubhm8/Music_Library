package com.music.admin.service;

import com.music.admin.entity.Admin;
import com.music.admin.repository.AdminRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class AdminService {

    private final AdminRepository adminRepository;
    private final PasswordEncoder passwordEncoder;

    public AdminService(AdminRepository adminRepository, PasswordEncoder passwordEncoder) {
        this.adminRepository = adminRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public Admin loginAdmin(String userName, String password) {
        if (userName == null || userName.isBlank() || password == null || password.isBlank()) {
            throw new IllegalArgumentException("Invalid username or password");
        }

        Optional<Admin> adminRecord = adminRepository.findByUserName(userName);
        Admin admin = adminRecord
                .filter(candidate -> candidate.getPassword() != null
                        && "YES".equalsIgnoreCase(candidate.getAdminStatus())
                        && (candidate.getPassword().equals(password)
                            || passwordEncoder.matches(password, candidate.getPassword())))
                .orElseThrow(() -> new IllegalArgumentException("Invalid username or password"));

        if (!passwordEncoder.matches(password, admin.getPassword())) {
            admin.setPassword(passwordEncoder.encode(password));
            admin = adminRepository.save(admin);
        }

        return admin;
    }

    public Admin addAdmin(Admin admin) {
        if (admin == null
                || admin.getUserName() == null || admin.getUserName().isBlank()
                || admin.getPassword() == null || admin.getPassword().isBlank()
                || admin.getAdminName() == null || admin.getAdminName().isBlank()
                || admin.getEmail() == null || admin.getEmail().isBlank()) {
            throw new IllegalArgumentException("Admin name, username, email, and password are required");
        }

        if (adminRepository.existsByUserName(admin.getUserName())) {
            throw new IllegalArgumentException("Admin username already exists");
        }

        admin.setAdminId(null);
        admin.setPassword(passwordEncoder.encode(admin.getPassword()));
        admin.setAdminStatus("YES");
        return adminRepository.save(admin);
    }
}
