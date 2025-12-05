package com.music.notification.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {
    @Autowired
    private JavaMailSender mailSender;
    public void sendEmail(String to, String subject, String body) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom("shubhm8335@gmail.com");
            message.setTo(to);
            message.setSubject(subject);
            message.setText(body);
            mailSender.send(message);
            System.out.println("✅ Email Sent Successfully to " + to);
        } 
        catch (Exception e) {
            System.err.println("❌ Failed to send email: " + e.getMessage());
            System.err.println("👉 (Check application.properties password)");
        }
    }
}