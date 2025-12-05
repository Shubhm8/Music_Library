<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Profile</title>
<style>
:root { 
    --bg:#FAFAFA; 
    --surface:#FFFFFF; 
    --text:#1C1C1E; 
    --accent:#FF2D55; 
    --border:#E5E5EA; 
    --radius:16px; 
}

*{margin:0;padding:0;box-sizing:border-box;font-family:-apple-system,Inter,sans-serif;}
body{background:var(--bg);color:var(--text);min-height:100vh;padding:40px;}
.container{
    max-width:600px;
    margin:0 auto;
    background:var(--surface);
    padding:40px;
    border-radius:var(--radius);
    border:1px solid var(--border);
    box-shadow:0 10px 30px rgba(0,0,0,0.05);
}

h2{text-align:center;color:var(--accent);margin-bottom:30px;font-size:28px;}

.form-group{margin-bottom:18px;}
label{display:block;font-weight:600;margin-bottom:8px;font-size:14px;color:#666;}

input{
    width:100%;
    padding:14px;
    border:1.5px solid var(--border);
    border-radius:12px;
    font-size:16px;
    background:#F9F9F9;
}
input:focus{
    outline:none;
    border-color:var(--accent);
    background:#fff;
}

.btn{
    width:100%;
    padding:16px;
    background:var(--accent);
    color:white;
    border:none;
    border-radius:12px;
    font-size:16px;
    font-weight:700;
    cursor:pointer;
    margin-top:10px;
    transition:0.2s;
}
.btn:hover{background:#e0244a;}

.back-link{
    display:block;
    text-align:center;
    margin-top:20px;
    text-decoration:none;
    color:#666;
    font-size:14px;
}
.back-link:hover{color:var(--accent);}
</style>
</head>
<body>

<div class="container">
    <h2>👤 Edit Profile</h2>

    <div class="form-group">
        <label>First Name</label>
        <input type="text" id="firstName">
    </div>
    <div class="form-group">
        <label>Last Name</label>
        <input type="text" id="lastName">
    </div>
    <div class="form-group">
        <label>Email Address</label>
        <input type="email" id="email">
    </div>
    <div class="form-group">
        <label>Mobile Number</label>
        <input type="text" id="mobile">
    </div>
    <div class="form-group">
        <label>City</label>
        <input type="text" id="city">
    </div>
    <div class="form-group">
        <label>Country</label>
        <input type="text" id="country">
    </div>
    
    <div style="margin: 30px 0; border-top: 1px solid #eee; padding-top: 20px;">
        <label style="color:var(--accent);">Change Password (Optional)</label>
        <input type="password" id="password" placeholder="Leave empty to keep current password">
    </div>

    <button class="btn" onclick="updateProfile()">Save Changes</button>
    <a href="/user/dashboard" class="back-link">Cancel & Back to Dashboard</a>
</div>

<script>
//--- SAFE LOGIN CHECK (Fix redirect loop) ---
const storedUser = localStorage.getItem("user");

if (!storedUser) {
    // clear invalid cookie to prevent infinite redirects
    document.cookie = "jwtToken=; path=/; max-age=0";
    window.location.href = "/login";
}

    var user = JSON.parse(localStorage.getItem('user'));
    if(!user || !user.userId) window.location.href = "/login";

    var USER_ID = user.userId;
    var JWT_TOKEN = user.jwt;
    var API_URL = "http://localhost:8081/api/users";
    async function loadProfile() {
        try {
            var res = await fetch(API_URL + "/" + USER_ID, {
                method: 'GET',
                headers: { 
                    'Authorization': 'Bearer ' + JWT_TOKEN,
                    'Content-Type': 'application/json' 
                }
            });
            
            if(!res.ok) { alert("Failed to load profile"); return; }

            var data = await res.json();
            document.getElementById("firstName").value = data.firstName;
            document.getElementById("lastName").value = data.lastName;
            document.getElementById("email").value = data.email;
            document.getElementById("mobile").value = data.mobile || "";
            document.getElementById("city").value = data.city || "";
            document.getElementById("country").value = data.country || "";
        } catch(e) { console.error(e); }
    }

    async function updateProfile() {
        var updatedData = {
            firstName: document.getElementById("firstName").value,
            lastName: document.getElementById("lastName").value,
            email: document.getElementById("email").value,
            mobile: document.getElementById("mobile").value,
            city: document.getElementById("city").value,
            country: document.getElementById("country").value,
            password: document.getElementById("password").value  
        };

        try {
            var res = await fetch(API_URL + "/" + USER_ID, {
                method: 'PUT',
                headers: {
                    'Authorization': 'Bearer ' + JWT_TOKEN,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(updatedData)
            });

            if(res.ok) {
                alert("Profile Updated Successfully!");
                var newUserResponse = await res.json();
                user.firstName = newUserResponse.firstName; 
                user.lastName = newUserResponse.lastName;
                localStorage.setItem('user', JSON.stringify(user));
                
                window.location.href = "/user/dashboard";
            } else {
                alert("Failed to update profile.");
            }
        } catch(e) { console.error(e); }
    }
    loadProfile();
</script>
</body>
</html>