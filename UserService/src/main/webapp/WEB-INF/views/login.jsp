<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>User Login</title>

<style>
:root {
    --bg:#FAFAFA; 
    --surface:#FFFFFF; 
    --surface-muted:#F2F2F7;
    --text-primary:#1C1C1E; 
    --text-secondary:#3A3A3C;
    --accent:#FF2D55; 
    --accent-hover:#e0244a;
    --border:#E5E5EA; 
    --shadow:0 4px 14px rgba(0,0,0,0.08);
    --radius:16px;
    --error-bg:#ffe5ea;
    --error-text:#c00026;
}

*{margin:0;padding:0;box-sizing:border-box;font-family:-apple-system,Inter,sans-serif;}
body{
    background:var(--bg);
    color:var(--text-primary);
    min-height:100vh;
}
.navbar{
    height:64px;
    background:var(--surface);
    padding:0 26px;
    display:flex;
    align-items:center;
    justify-content:space-between;
    border-bottom:1px solid var(--border);
    box-shadow:var(--shadow);
}

.navbar h2{
    font-size:22px;
    font-weight:700;
    margin: 0;
    color: var(--text-primary);
}

.back-btn{
    margin-left:14px;
    background:var(--accent);
    color:white;
    padding:10px 18px;
    border-radius:12px;
    text-decoration:none;
    font-weight:600;
    transition:.18s;
}
.back-btn:hover{background:var(--accent-hover);}

.center-wrapper{
    display:flex;
    justify-content:center;
    align-items:center;
    margin-top:60px;
    padding:20px;
}

.card{
    width:100%;
    max-width:450px;
    background:var(--surface);
    border:1px solid var(--border);
    border-radius:var(--radius);
    box-shadow:var(--shadow);
    padding:38px;
    animation:fade .6s ease;
}
@keyframes fade { from{opacity:0; transform:translateY(18px);} to{opacity:1; transform:translateY(0);} }

h2.form-title{
    font-size:30px;
    font-weight:800;
    color:var(--accent);
    text-align:center;
    margin-bottom:25px;
}

.form-group{margin-bottom:18px;}

label{
    font-size:14px;
    font-weight:600;
    color:var(--text-secondary);
    margin-bottom:6px;
    display:block;
}

input{
    width:100%;
    padding:12px 14px;
    border-radius:var(--radius);
    border:1.6px solid var(--border);
    background:var(--surface-muted);
    font-size:15px;
    transition:.25s;
}
input:focus{
    border-color:var(--accent);
    box-shadow:0 0 0 3px rgba(255,45,85,0.18);
    outline:none;
}

.btn{
    width:100%;
    padding:14px;
    background:var(--accent);
    border:none;
    border-radius:var(--radius);
    color:white;
    font-size:17px;
    font-weight:700;
    cursor:pointer;
    transition:.25s;
    margin-top:10px;
}
.btn:hover{background:var(--accent-hover); transform:translateY(-2px);}

.message{
    padding:12px;
    border-radius:var(--radius);
    margin-bottom:15px;
    display:none;
    font-size:14px;
    font-weight:600;
}
.error{ background:var(--error-bg); color:var(--error-text); border:1px solid #ffb3c1; }

.link{ margin-top:18px; text-align:center; font-size:14px; }
.link a{ color:var(--accent); font-weight:600; text-decoration:none; }
.link a:hover{text-decoration:underline;}

</style>
</head>

<body>

<script>
//--- SAFE LOGIN CHECK (Fix redirect loop) ---
const storedUser = localStorage.getItem("user");

if (!storedUser) {
    // clear invalid cookie to prevent infinite redirects
    document.cookie = "jwtToken=; path=/; max-age=0";
    window.location.href = "/login";
}

</script>

<div class="navbar">
    <h2>🎵 Music Library — Login</h2>
    <a href="/" class="back-btn">Home</a>
</div>

<div class="center-wrapper">
    <div class="card">

        <h2 class="form-title">🔐 User Login</h2>

        <div id="message" class="message"></div>

        <form id="loginForm">

            <div class="form-group">
                <label>Username</label>
                <input type="text" name="userName" required>
            </div>

            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" required>
            </div>

            <button type="submit" class="btn">Login</button>
        </form>

        <div class="link">
            Don't have an account?
            <a href="/register">Register here</a>
        </div>
    </div>
</div>

<script>
document.getElementById('loginForm').addEventListener('submit', async function(e){
    e.preventDefault();

    const data = {
        userName: this.userName.value,
        password: this.password.value
    };

    const msg = document.getElementById('message');

    try {
        const res = await fetch('http://localhost:8081/api/users/login', {
            method:'POST',
            headers:{'Content-Type':'application/json'},
            body:JSON.stringify(data)
        });

        if(res.ok){
            const responseData = await res.json();
            const userObj = responseData.user;
            userObj.jwt = responseData.jwt; 
            document.cookie = "jwtToken=" + responseData.jwt + "; path=/; max-age=36000;";
            localStorage.setItem('user', JSON.stringify(userObj));
            
            window.location.href = '/user/dashboard';
        } else {
            msg.className = 'message error';
            msg.textContent = await res.text();
            msg.style.display = 'block';
        }
    } catch(err){
        msg.className = 'message error';
        msg.textContent = 'Error: ' + err.message;
        msg.style.display = 'block';
    }
});
</script>
</body>
</html>