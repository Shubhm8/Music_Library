package com.music.admin.config;

import com.music.admin.entity.Admin;
import com.music.admin.repository.AdminRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
public class AdminBootstrap {
    @Bean
    CommandLineRunner createInitialAdmin(
            AdminRepository repository,
            PasswordEncoder passwordEncoder,
            @Value("${ADMIN_BOOTSTRAP_USERNAME:}") String username,
            @Value("${ADMIN_BOOTSTRAP_PASSWORD:}") String password,
            @Value("${ADMIN_BOOTSTRAP_EMAIL:}") String email) {
        return args -> {
            if (username.isBlank() || password.isBlank() || email.isBlank() || repository.existsByUserName(username)) {
                return;
            }
            Admin admin = new Admin();
            admin.setAdminName("Initial Administrator");
            admin.setUserName(username);
            admin.setEmail(email);
            admin.setPassword(passwordEncoder.encode(password));
            repository.save(admin);
        };
    }
}
