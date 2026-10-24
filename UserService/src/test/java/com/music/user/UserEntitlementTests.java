package com.music.user;

import static org.junit.jupiter.api.Assertions.*;
import com.music.user.entity.User;
import java.time.LocalDateTime;
import org.junit.jupiter.api.Test;

class UserEntitlementTests {
    @Test void premiumExpiryAndNotificationPreferenceArePersistable() {
        User user = new User();
        LocalDateTime expiry = LocalDateTime.now().plusDays(30);
        user.setPremiumUntil(expiry);
        user.setNotificationsEnabled(false);
        assertEquals(expiry, user.getPremiumUntil());
        assertFalse(user.isNotificationsEnabled());
    }
}
