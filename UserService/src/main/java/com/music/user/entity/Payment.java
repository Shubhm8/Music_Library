package com.music.user.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "payments")
public class Payment {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(nullable = false) private Integer userId;
    @Column(nullable = false, unique = true) private String razorpayOrderId;
    @Column(unique = true) private String razorpayPaymentId;
    @Column(nullable = false) private int amountPaise;
    @Column(nullable = false) private String status = "CREATED";
    @Column(nullable = false) private LocalDateTime createdAt = LocalDateTime.now();
    @Version private Long version;

    public Long getId() { return id; }
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    public String getRazorpayOrderId() { return razorpayOrderId; }
    public void setRazorpayOrderId(String value) { razorpayOrderId = value; }
    public String getRazorpayPaymentId() { return razorpayPaymentId; }
    public void setRazorpayPaymentId(String value) { razorpayPaymentId = value; }
    public int getAmountPaise() { return amountPaise; }
    public void setAmountPaise(int value) { amountPaise = value; }
    public String getStatus() { return status; }
    public void setStatus(String value) { status = value; }
}
