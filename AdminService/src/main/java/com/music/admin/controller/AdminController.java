package com.music.admin.controller;

import com.music.admin.entity.Admin;
import com.music.admin.service.AdminService;
import com.music.admin.util.JwtUtil; 
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/admin")
@CrossOrigin(origins = "*")
public class AdminController {
    
    @Autowired
    private AdminService adminService;
    
    @Autowired
    private JwtUtil jwtUtil; 

    @PostMapping("/login")
    public ResponseEntity<?> loginAdmin(@RequestBody Map<String, String> loginData) {
        try {
            String userName = loginData.get("userName");
            String password = loginData.get("password");

            Admin admin = adminService.loginAdmin(userName, password);

            // generate token
            String token = jwtUtil.generateToken(admin.getUserName());

            Map<String, Object> response = new HashMap<>();
            // keep both keys so frontend can use either
            response.put("token", token);
            response.put("jwt", token);
            response.put("admin", admin);
            
            return new ResponseEntity<>(response, HttpStatus.OK);

        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.UNAUTHORIZED);
        }
    }

    @PostMapping("/register")
    public ResponseEntity<?> registerAdmin(@RequestBody Admin admin) {
        try {
            Admin savedAdmin = adminService.addAdmin(admin);
            return new ResponseEntity<>(savedAdmin, HttpStatus.CREATED);
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }
}
