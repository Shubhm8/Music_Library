package com.music.admin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AdminViewController {
    @GetMapping("/")
    public String rootRedirect() {
        return "redirect:/admin/login";
    }
    
    @GetMapping("/admin/login")
    public String adminLoginPage() {
        return "adminLogin";
    }
    
    @GetMapping("/admin/dashboard")
    public String adminDashboard() {
        return "adminDashboard";
    }
    @GetMapping("/admin/users")
    public String viewUsersPage() {
        return "users";
    }

    @GetMapping("/admin/register")
    public String showAdminRegisterPage() {
        return "adminRegister"; 
    }
}