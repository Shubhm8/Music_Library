<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Login</title>

<style>
:root{
    --bg:#F8F8F8; 
    --surface:#FFFFFF; 
    --surface-muted:#F2F2F7;
    --text-primary:#1C1C1E; 
    --text-secondary:#3A3A3C;
    --accent:#FF2D55; 
    --accent-hover:#e01c43;
    --border:#E5E5EA; 
    --shadow:0 12px 30px rgba(0,0,0,0.12);
    --radius:18px;
}
 
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:-apple-system,Inter,sans-serif;
}

body{
    background:var(--bg);
    min-height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    padding:30px;
}

.container{
    width:100%;
    max-width:420px;
    background:var(--surface);
    padding:46px 38px;
    border-radius:var(--radius);
    box-shadow:var(--shadow);
    border:1px solid var(--border);
    animation:fade .5s ease;
}
@keyframes fade{
    from{opacity:0; transform:translateY(12px);}
    to{opacity:1; transform:translateY(0);}
}

h2{
    text-align:center;
    font-size:30px;
    font-weight:800;
    color:var(--text-primary);
    margin-bottom:25px;
}

.form-group{margin-bottom:18px;}

label{
    font-size:14px;
    font-weight:600;
    color:var(--text-primary);
    margin-bottom:6px;
    display:block;
}

input{
    width:100%;
    padding:12px 14px;
    border-radius:14px;
    border:1.6px solid var(--border);
    background:var(--surface-muted);
    font-size:15px;
    color:var(--text-primary);
}
input:focus{
    border-color:var(--accent);
    outline:none;
}

.btn{
    width:100%;
    padding:14px;
    background:var(--accent);
    color:white;
    border-radius:14px;
    border:none;
    cursor:pointer;
    font-size:16px;
    font-weight:700;
    transition:.25s;
}
.btn:hover{
    background:var(--accent-hover);
}

.message{
    padding:12px;
    border-radius:14px;
    margin-bottom:15px;
    display:none;
    text-align:center;
    font-weight:600;
    font-size:14px;
}
.error{
    background:#ffd6dd;
    color:#b40025;
    border:1px solid #ffbdc8;
}

.link{
    text-align:center;
    margin-top:16px;
    font-size:14px;
}
.link a{
    color:var(--accent);
    font-weight:600;
    text-decoration:none;
}
.link a:hover{text-decoration:underline;}
</style>

</head>

<body>
<script>
    // clear any previous sessions
    localStorage.removeItem('user');  
    localStorage.removeItem('admin');  
    document.cookie = "jwtToken=; path=/; max-age=0";
</script>

<div class="container">
    <h2>🔐 Admin Login</h2>

    <div id="message" class="message"></div>

    <form id="adminLoginForm">
        <div class="form-group">
            <label>Username</label>
            <input type="text" name="userName" required>
        </div>

        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" required>
        </div>

        <!-- IMPORTANT: type="submit" so the submit handler runs -->
        <button type="submit" class="btn">Sign In</button>
    </form>

    <div class="link">
        Don't have an account? <a href="/admin/register">Register here</a>
    </div>

    <div class="link">
        <a href="http://localhost:8081/">Back to Home</a>
    </div>
</div>

<script>
document.getElementById('adminLoginForm').addEventListener('submit', async function(e) {
    e.preventDefault(); // stop full-page refresh

    const loginData = {
        userName: this.userName.value,
        password: this.password.value
    };

    const messageDiv = document.getElementById('message');

    try {
        const response = await fetch("http://localhost:8082/api/admin/login", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(loginData)
        });

        if (response.ok) {
            const data = await response.json(); 

            // token can come as "jwt" or "token"
            const jwt = data.jwt || data.token;

            // store admin object + jwt
            const adminObj = data.admin || {};
            adminObj.jwt = jwt;
            localStorage.setItem("admin", JSON.stringify(adminObj));

            // VERY IMPORTANT: set cookie so Spring Security sees you as authenticated
            document.cookie = "jwtToken=" + jwt + "; path=/; max-age=36000;";

            // go to dashboard
            window.location.href = "/admin/dashboard";
        } else {
            const err = await response.text();
            messageDiv.className = "message error";
            messageDiv.textContent = err;
            messageDiv.style.display = "block";
        }
    } catch (error) {
        messageDiv.className = "message error";
        messageDiv.textContent = "Error: " + error.message;
        messageDiv.style.display = "block";
    }
});
</script>
</body>
</html>
