package com.music.notification.controller;

import com.music.notification.entity.Notification;
import com.music.notification.repository.NotificationRepository;
import com.music.notification.service.EmailService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

class NotificationControllerTest {

    private EmailService emailService;
    private NotificationRepository notificationRepository;
    private NotificationController controller;

    @BeforeEach
    void setUp() {
        emailService = mock(EmailService.class);
        notificationRepository = mock(NotificationRepository.class);
        controller = new NotificationController(emailService, notificationRepository, "test-internal-key");
    }

    @Test
    void rejectsMissingOrIncorrectApiKey() {
        ResponseEntity<?> response = controller.sendSongNotification(
                "wrong-key",
                Map.of("to", "test@example.com", "subject", "Test", "message", "Test message"));

        assertEquals(HttpStatus.UNAUTHORIZED, response.getStatusCode());
        verifyNoInteractions(emailService, notificationRepository);
    }

    @Test
    void sendsAndStoresNotificationWithValidApiKey() {
        ResponseEntity<?> response = controller.sendSongNotification(
                "test-internal-key",
                Map.of("to", "test@example.com", "subject", "New song", "message", "A song was added"));

        assertEquals(HttpStatus.OK, response.getStatusCode());
        verify(emailService).sendEmail("test@example.com", "New song", "A song was added");
        verify(notificationRepository).save(any(Notification.class));
    }
}
