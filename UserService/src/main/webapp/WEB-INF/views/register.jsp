<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>User Registration</title>

<style>
:root {
    --bg:#FAFAFA; 
    --surface:#FFFFFF; 
    --surface-alt:#FAFAFC;
    --text-primary:#1C1C1E; 
    --text-secondary:#6E6E73;
    --accent:#FF2D55; 
    --accent-hover:#e61a45;
    --radius:18px;
    --border:#E5E5EA; 
    --shadow:0 4px 14px rgba(0,0,0,0.08);
    --error-bg:#ffe5ea;
    --error-text:#b40028;
    --success-bg:#d6f5e5;
    --success-text:#056839;
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
.center-wrapper {
    display: flex;
    justify-content: center;
    padding: 40px 20px;
}

.card{
    width:100%;
    max-width:780px;
    background:var(--surface);
    padding:38px;
    border-radius:var(--radius);
    box-shadow:var(--shadow);
    border:1px solid var(--border);
    animation:fade .6s ease;
}
@keyframes fade{from{opacity:0;transform:translateY(16px);}to{opacity:1;transform:translateY(0);} }

h2.form-title{
    text-align:center;
    font-size:30px;
    font-weight:800;
    margin-bottom:18px;
    color:var(--accent);
}

.section-title{
    margin:24px 0 10px;
    font-size:17px;
    font-weight:700;
    color:var(--text-primary);
    border-bottom:2px solid var(--border);
    padding-bottom:6px;
}
.form-row{
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:18px;
}
.form-group{margin-bottom:16px;}
.full-width{grid-column:span 2;}

label{
    display:block;
    font-size:14px;
    margin-bottom:6px;
    color:var(--text-secondary);
}
.required{color:#ff3b30;}

input,select{
    width:100%;
    padding:12px 14px;
    border-radius:var(--radius);
    border:1.8px solid var(--border);
    background:var(--surface-alt);
    font-size:15px;
    color:var(--text-primary);
    transition:.25s;
}
input:focus,select:focus{
    border-color:var(--accent);
    box-shadow:0 0 0 3px rgba(255,45,85,0.18);
    outline:none;
}

.btn{
    width:100%;
    padding:15px;
    background:var(--accent);
    border:none;
    border-radius:var(--radius);
    font-size:17px;
    font-weight:700;
    color:white;
    cursor:pointer;
    transition:.25s;
    margin-top:10px;
}
.btn:hover{
    background:var(--accent-hover);
    transform:translateY(-2px);
}

.message{
    padding:14px;
    border-radius:var(--radius);
    text-align:center;
    font-size:15px;
    display:none;
    margin-bottom:15px;
    font-weight:600;
}
.error{background:var(--error-bg);color:var(--error-text);border:1px solid #ffccd4;}
.success{background:var(--success-bg);color:var(--success-text);border:1px solid #bbf7d0;}

.link{text-align:center;margin-top:18px;font-size:14px;}
.link a{color:var(--accent);font-weight:600;text-decoration:none;}
.link a:hover{text-decoration:underline;}

@media(max-width:700px){
    .form-row{grid-template-columns:1fr;}
    .full-width{grid-column:span 1;}
}
</style>
</head>

<body>

<div class="navbar">
    <h2>🎵 Music Library — Register</h2>
    <a href="/" class="back-btn">Home</a>
</div>

<div class="center-wrapper">
    <div class="card">

        <h2 class="form-title">📝 User Registration</h2>

        <div id="message" class="message"></div>

        <form id="registerForm">

            <div class="section-title">Personal Information</div>

            <div class="form-row">
                <div class="form-group">
                    <label>First Name <span class="required">*</span></label>
                    <input type="text" name="firstName" required>
                </div>
                <div class="form-group">
                    <label>Last Name <span class="required">*</span></label>
                    <input type="text" name="lastName" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Username <span class="required">*</span></label>
                    <input type="text" name="userName" required>
                </div>
                <div class="form-group">
                    <label>Email <span class="required">*</span></label>
                    <input type="email" name="email" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Password <span class="required">*</span></label>
                    <input type="password" name="password" required>
                </div>
                <div class="form-group">
                    <label>Mobile</label>
                    <input type="text" name="mobile">
                </div>
            </div>

            <div class="section-title">Address Information</div>

            <div class="form-group full-width">
                <label>Address Line 1</label>
                <input type="text" name="address1">
            </div>

            <div class="form-group full-width">
                <label>Address Line 2</label>
                <input type="text" name="address2">
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>City</label>
                    <input type="text" name="city">
                </div>

                <div class="form-group">
                    <label>State</label>
                    <input type="text" name="state">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>ZIP/Postal Code</label>
                    <input type="text" name="zipCode">
                </div>
                <div class="form-group">
                    <label>Country</label>
                    <input type="text" name="country">
                </div>
            </div>

            <button type="submit" class="btn">Register</button>
        </form>

        <div class="link">
            Already have an account? <a href="/login">Login here</a>
        </div>

    </div>
</div>

<script>
//--- SAFE LOGIN CHECK (Fix redirect loop) ---
const storedUser = localStorage.getItem("user");

if (!storedUser) {
    // clear invalid cookie to prevent infinite redirects
    document.cookie = "jwtToken=; path=/; max-age=0";
    window.location.href = "/login";
}

document.getElementById('registerForm').addEventListener('submit',async function(e){
    e.preventDefault();  
    const data={
        firstName:this.firstName.value.trim(),
        lastName:this.lastName.value.trim(),
        userName:this.userName.value.trim(),
        password:this.password.value,
        email:this.email.value.trim(),
        mobile:this.mobile.value.trim()||null, 
        address1:this.address1.value.trim()||null,
        address2:this.address2.value.trim()||null,
        city:this.city.value.trim()||null,
        state:this.state.value.trim()||null,
        zipCode:this.zipCode.value.trim()||null,
        country:this.country.value.trim()||null
    };

    const msg=document.getElementById('message');

    try{
        const res=await fetch('http://localhost:8081/api/users/register',{
            method:'POST',
            headers:{'Content-Type':'application/json'},
            body:JSON.stringify(data)
        });

        if(res.ok){
            msg.className='message success';
            msg.textContent='Registration successful! Redirecting...';
            msg.style.display='block';
            this.reset();
            setTimeout(()=>window.location.href='/login',1200);
        }else{
            msg.className='message error';
            msg.textContent=await res.text()||'Registration failed';
            msg.style.display='block';
        }
    }catch(err){
        msg.className='message error';
        msg.textContent='Error: '+err.message;
        msg.style.display='block';
    }
});
</script>
</body>
</html>