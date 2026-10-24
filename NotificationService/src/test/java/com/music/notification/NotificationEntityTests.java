package com.music.notification;

import static org.junit.jupiter.api.Assertions.*;
import com.music.notification.entity.Notification;
import org.junit.jupiter.api.Test;

class NotificationEntityTests {
    @Test void notificationBelongsToItsRecipient() {
        Notification notification = new Notification("New song", 42);
        assertEquals(42, notification.getRecipientUserId());
        assertEquals("New song", notification.getMessage());
    }
}
