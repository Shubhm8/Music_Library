package com.music.admin.controller;

import com.music.admin.entity.Admin;
import com.music.admin.service.AdminService;
import com.music.admin.util.JwtUtil;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/admin")
@Tag(
    name = "📂 Admin Management",
    description = "APIs for Admin Authentication and Management"
)
@CrossOrigin(origins = {
        "http://localhost:8080",
        "http://localhost:8082",
        "http://192.168.1.52:8080",
        "http://192.168.1.52:8082"
})
public class AdminController {

    @Autowired
    private AdminService adminService;

    @Autowired
    private JwtUtil jwtUtil;

    @Operation(
            summary = "Admin Login",
            description = "Authenticate an administrator using username and password. Returns a JWT token upon successful authentication."
    )
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Login Successful"),
            @ApiResponse(responseCode = "401", description = "Invalid Username or Password"),
            @ApiResponse(responseCode = "500", description = "Internal Server Error")
    })
    @PostMapping("/login")
    public ResponseEntity<?> loginAdmin(@RequestBody Map<String, String> loginData) {

        try {

            String userName = loginData.get("userName");
            String password = loginData.get("password");

            Admin admin = adminService.loginAdmin(userName, password);

            String token = jwtUtil.generateToken(admin.getUserName());

            Map<String, Object> response = new HashMap<>();
            response.put("token", token);
            response.put("jwt", token);
            response.put("admin", admin);

            return new ResponseEntity<>(response, HttpStatus.OK);

        } catch (Exception e) {

            return new ResponseEntity<>(e.getMessage(), HttpStatus.UNAUTHORIZED);
        }
    }

    @Operation(
            summary = "Register Admin",
            description = "Register a new administrator account."
    )
    @ApiResponses({
            @ApiResponse(responseCode = "201", description = "Admin Registered Successfully"),
            @ApiResponse(responseCode = "400", description = "Invalid Registration Data"),
            @ApiResponse(responseCode = "500", description = "Internal Server Error")
    })
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