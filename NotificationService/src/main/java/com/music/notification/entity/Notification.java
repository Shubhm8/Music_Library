package com.music.notification.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
public class Notification {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String message;
    // Nullable temporarily so existing installations can upgrade without a destructive migration.
    @Column
    private Integer recipientUserId;
    private LocalDateTime createdAt;

    public Notification() {
        this.createdAt = LocalDateTime.now();
    }

    public Notification(String message, Integer recipientUserId) {
        this.message = message;
        this.recipientUserId = recipientUserId;
        this.createdAt = LocalDateTime.now();
    }
    
    public Long getId() { return id; }
    public String getMessage() { return message; }
    public Integer getRecipientUserId() { return recipientUserId; }
    public LocalDateTime getCreatedAt() { return createdAt; }
}
