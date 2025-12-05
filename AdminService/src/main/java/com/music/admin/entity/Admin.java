package com.music.admin.entity;

import java.time.LocalDateTime;
import jakarta.persistence.*;

@Entity
@Table(name = "admin")
public class Admin {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "admin_id")
    private Integer adminId;
    
    @Column(name = "admin_name", nullable = false)
    private String adminName;
    
    @Column(name = "user_name", nullable = false, unique = true)
    private String userName;
    
    @Column(nullable = false)
    private String password;
    
    @Column(nullable = false, unique = true)
    private String email;
    
    @Column(name = "mobile_no")
    private String mobileNo;
    
    @Column(name = "admin_status", columnDefinition = "VARCHAR(20) DEFAULT 'YES'")
    private String adminStatus = "YES";
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
 
    public Admin() {}
     
    public Integer getAdminId() { return adminId; }
    public void setAdminId(Integer adminId) { this.adminId = adminId; }
    
    public String getAdminName() { return adminName; }
    public void setAdminName(String adminName) { this.adminName = adminName; }
    
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getMobileNo() { return mobileNo; }
    public void setMobileNo(String mobileNo) { this.mobileNo = mobileNo; }
    
    public String getAdminStatus() { return adminStatus; }
    public void setAdminStatus(String adminStatus) { this.adminStatus = adminStatus; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}