<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Registration</title>
<style>
:root {
    --bg:#F8F8F8;
    --surface:#FFFFFF;
    --text:#1C1C1E;
    --accent:#FF2D55;
    --border:#E5E5EA;
    --radius:18px;
}

body {
    background:var(--bg);
    font-family:-apple-system,Inter,sans-serif;
    display:flex;
    justify-content:center;
    padding:40px;
}

.card {
    background:var(--surface);
    padding:40px;
    border-radius:var(--radius);
    box-shadow:0 12px 30px rgba(0,0,0,0.1);
    width:100%;
    max-width:500px;
    border:1px solid var(--border);
}

h2 {
    text-align:center;
    color:var(--accent);
    margin-bottom:25px;
}

.form-group { margin-bottom:15px; }

label {
    display:block;
    font-size:14px;
    font-weight:600;
    margin-bottom:5px;
    color:var(--text);
}

input {
    width:100%;
    padding:12px;
    border:1.5px solid var(--border);
    border-radius:12px;
    font-size:15px;
    box-sizing:border-box;
}
input:focus { outline:none; border-color:var(--accent); }

.btn {
    width:100%;
    padding:14px;
    background:var(--accent);
    color:white;
    border:none;
    border-radius:12px;
    font-weight:700;
    cursor:pointer;
    margin-top:10px;
}

.message {
    padding:10px;
    border-radius:10px;
    margin-bottom:15px;
    display:none;
    text-align:center;
    font-size:14px;
}
.error { background:#ffe5ea; color:#c00026; }
.success { background:#dcfce7; color:#166534; }

.link { text-align:center; margin-top:15px; font-size:14px; }
.link a { color:var(--accent); text-decoration:none; font-weight:600; }
</style>
</head>
<body>

<div class="card">
    <h2>🔐 New Admin Registration</h2>
    
    <div id="message" class="message"></div>

    <form id="adminRegisterForm">
        <div class="form-group">
            <label>Full Name</label>
            <input type="text" name="adminName" required>
        </div>
        <div class="form-group">
            <label>Username</label>
            <input type="text" name="userName" required>
        </div>
        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" required>
        </div>
        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" required>
        </div>
        <div class="form-group">
            <label>Mobile Number</label>
            <input type="text" name="mobileNo" required>
        </div>

        <button type="submit" class="btn">Register Admin</button>
    </form>

    <div class="link">
        Already have an account? <a href="/admin/login">Login here</a>
    </div>
</div>

<script>
document.getElementById('adminRegisterForm').addEventListener('submit', async function(e) {
    e.preventDefault();
    const msg = document.getElementById('message');
    const data = {
        adminName: this.adminName.value,
        userName: this.userName.value,
        email: this.email.value,
        password: this.password.value,
        mobileNo: this.mobileNo.value
    };

    try {
        const res = await fetch('http://localhost:8082/api/admin/register', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(data)
        });

        if (res.ok) {
            msg.className = 'message success';
            msg.textContent = 'Admin Registered Successfully! Redirecting...';
            msg.style.display = 'block';
            setTimeout(() => window.location.href = '/admin/login', 1500);
        } else {
            msg.className = 'message error';
            msg.textContent = await res.text();
            msg.style.display = 'block';
        }
    } catch (err) {
        console.error(err);
        msg.className = 'message error';
        msg.textContent = 'Connection Error: Is the Admin Service running on 8082?';
        msg.style.display = 'block';
    }
});
</script>
</body>
</html>