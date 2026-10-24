package com.music.admin.config;

import com.music.admin.entity.Admin;
import com.music.admin.repository.AdminRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class AdminBootstrap implements CommandLineRunner {

    private final AdminRepository adminRepository;
    private final PasswordEncoder passwordEncoder;

    @Value("${ADMIN_BOOTSTRAP_ENABLED:false}")
    private boolean bootstrapEnabled;

    @Value("${ADMIN_BOOTSTRAP_USERNAME:}")
    private String username;

    @Value("${ADMIN_BOOTSTRAP_PASSWORD:}")
    private String password;

    @Value("${ADMIN_BOOTSTRAP_NAME:}")
    private String adminName;

    @Value("${ADMIN_BOOTSTRAP_EMAIL:}")
    private String email;

    public AdminBootstrap(AdminRepository adminRepository, PasswordEncoder passwordEncoder) {
        this.adminRepository = adminRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public void run(String... args) {
        if (!bootstrapEnabled || adminRepository.count() > 0) {
            return;
        }
        if (isBlank(username) || isBlank(password) || isBlank(adminName) || isBlank(email)
                || password.length() < 12
                || password.getBytes(java.nio.charset.StandardCharsets.UTF_8).length > 72) {
            throw new IllegalStateException(
                    "Initial admin bootstrap is enabled but credentials are missing or password is shorter than 12 characters");
        }

        Admin admin = new Admin();
        admin.setAdminName(adminName);
        admin.setUserName(username);
        admin.setPassword(passwordEncoder.encode(password));
        admin.setEmail(email);
        admin.setAdminStatus("YES");
        adminRepository.save(admin);
    }

    private boolean isBlank(String value) {
        return value == null || value.isBlank();
    }
}
