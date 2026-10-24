package com.music.admin.service;

import com.music.admin.entity.Admin;
import com.music.admin.repository.AdminRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AdminServiceTest {

    @Mock
    private AdminRepository adminRepository;

    private PasswordEncoder passwordEncoder;
    private AdminService adminService;

    @BeforeEach
    void setUp() {
        passwordEncoder = new BCryptPasswordEncoder();
        adminService = new AdminService(adminRepository, passwordEncoder);
    }

    @Test
    void addAdminStoresEncodedPassword() {
        Admin admin = validAdmin();
        when(adminRepository.existsByUserName("admin1")).thenReturn(false);
        when(adminRepository.save(any(Admin.class))).thenAnswer(invocation -> invocation.getArgument(0));

        Admin saved = adminService.addAdmin(admin);

        assertNotEquals("StrongPassword123!", saved.getPassword());
        assertTrue(passwordEncoder.matches("StrongPassword123!", saved.getPassword()));
        verify(adminRepository).save(admin);
    }

    @Test
    void loginAcceptsCorrectEncodedPassword() {
        Admin admin = validAdmin();
        admin.setPassword(passwordEncoder.encode("StrongPassword123!"));
        when(adminRepository.findByUserName("admin1")).thenReturn(Optional.of(admin));

        Admin result = adminService.loginAdmin("admin1", "StrongPassword123!");

        assertEquals("admin1", result.getUserName());
    }

    @Test
    void loginRejectsWrongPassword() {
        Admin admin = validAdmin();
        admin.setPassword(passwordEncoder.encode("StrongPassword123!"));
        when(adminRepository.findByUserName("admin1")).thenReturn(Optional.of(admin));

        assertThrows(IllegalArgumentException.class,
                () -> adminService.loginAdmin("admin1", "wrong-password"));
    }

    private Admin validAdmin() {
        Admin admin = new Admin();
        admin.setAdminName("Test Admin");
        admin.setUserName("admin1");
        admin.setEmail("admin@example.com");
        admin.setPassword("StrongPassword123!");
        admin.setAdminStatus("YES");
        return admin;
    }
}
