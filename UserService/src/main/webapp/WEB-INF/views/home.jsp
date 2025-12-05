<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Music Library - Home</title>

<style> 
:root{
    --bg:#F5F5F7;
    --surface:#FFFFFF;
    --surface-alt:#FAFAFC;
    --text-primary:#1D1D1F;
    --text-secondary:#6E6E73;
    --accent:#FF2D55; 
    --accent-hover:#e61a45;
    --danger:#FF3B30;
    --danger-hover:#d72a21;
    --radius:18px;
    --border:#E5E5EA;
    --shadow:0 20px 50px rgba(0,0,0,0.10);
}

*{margin:0;padding:0;box-sizing:border-box;font-family:-apple-system,Inter,sans-serif;}

body{
    background:var(--bg);
    min-height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    padding:25px;
}
 
.card{
    width:100%;
    max-width:480px;
    background:var(--surface);
    padding:46px 38px;
    border-radius:var(--radius);
    box-shadow:var(--shadow);
    border:1px solid var(--border);
    text-align:center; 
    animation:fade .6s ease; 
}
@keyframes fade{from{opacity:0;transform:translateY(18px);}to{opacity:1;transform:translateY(0);} }

h1{
    font-size:34px;
    font-weight:800;
    color:var(--text-primary);
    margin-bottom:12px;
}

p{
    font-size:16px;
    color:var(--text-secondary);
    margin-bottom:28px;
}

.btn{
    width:100%;
    padding:14px 0;
    display:block;
    margin:12px 0;
    border-radius:var(--radius);
    font-size:16px;
    font-weight:700;
    text-decoration:none;
    transition:.25s;
    letter-spacing:.3px;
}

.btn-primary{
    background:var(--accent);
    color:white;
}
.btn-primary:hover{
    background:var(--accent-hover);
    transform:translateY(-2px);
} 
.btn-danger{
    background:var(--danger);
    color:white;
}
.btn-danger:hover{
    background:var(--danger-hover);
    transform:translateY(-2px);
}
</style>
</head> 
<body>
 
<div class="card">
    <h1>🎵 Music Library</h1>
    <p>Your personal music management platform</p>

    <a href="/login" class="btn btn-primary">User Login</a>

    <a href="http://localhost:8082/admin/login" class="btn btn-danger">Admin Login</a>
</div>

</body>
</html>