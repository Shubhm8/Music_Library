<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Dashboard</title>
    
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />

<style>
/* Modern Apple-Inspired Theme */
:root{
    --bg:#F5F5F7;
    --surface:#FFFFFF;
    --text-primary:#1D1D1F;
    --text-secondary:#86868b;
    --accent:#FF2D55;
    --accent-hover:#e01c43;
    --radius:20px;
    --border:#E5E5EA;
    --shadow-sm: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
    --shadow-hover: 0 10px 15px -3px rgba(0, 0, 0, 0.08);
}

*{margin:0;padding:0;box-sizing:border-box;font-family:-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;}

body{
    background:var(--bg);
    min-height:100vh;
    padding-bottom: 60px;
    color: var(--text-primary);
}

/* Glassmorphism Navbar */
.navbar{
    background: rgba(255, 255, 255, 0.85);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    padding: 18px 40px;
    display:flex;
    justify-content:space-between;
    align-items:center;
    border-bottom:1px solid rgba(0,0,0,0.05);
    position: sticky;
    top: 0;
    z-index: 100;
}

.navbar h2{
    font-size:22px;
    font-weight:700;
    letter-spacing: -0.5px;
}

.logout-btn{
    padding:10px 24px;
    background:var(--text-primary);
    color:white;
    border:none;
    border-radius:30px;
    font-size: 13px;
    font-weight:600;
    cursor:pointer;
    transition:.2s;
}
.logout-btn:hover{ transform: scale(1.02); opacity: 0.9; }

.container{ max-width:1100px; margin:40px auto; padding:0 30px; }

/* Welcome Section */
.welcome-header {
    margin-bottom: 35px;
    animation: fadeDown 0.6s ease;
}
.welcome-header h3 { font-size: 32px; font-weight: 800; margin-bottom: 8px; }
.welcome-header p { color: var(--text-secondary); font-size: 16px; }

/* --- 1. STATS ROW --- */
.stats-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 20px;
    margin-bottom: 40px;
    animation: fadeUp 0.6s ease 0.1s backwards;
}

.stat-card {
    background: var(--surface);
    padding: 24px;
    border-radius: var(--radius);
    box-shadow: var(--shadow-sm);
    border: 1px solid var(--border);
    transition: 0.2s;
    text-align: center;
}
.stat-card:hover { transform: translateY(-3px); box-shadow: var(--shadow-hover); }

.stat-val { font-size: 42px; font-weight: 800; display: block; line-height: 1.1; margin-bottom: 5px; }
.stat-label { font-size: 13px; font-weight: 600; color: var(--text-secondary); text-transform: uppercase; letter-spacing: 0.5px; }

/* --- 2. ACTIONS SECTION --- */
.section-title { font-size: 20px; font-weight: 700; margin-bottom: 20px; }

.actions-section {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 20px;
    animation: fadeUp 0.6s ease 0.2s backwards;
}

.action-card {
    background: var(--surface);
    padding: 25px;
    border-radius: var(--radius);
    border: 1px solid var(--border);
    box-shadow: var(--shadow-sm);
    display: flex;
    align-items: center;
    justify-content: space-between;
    transition: 0.2s;
    cursor: pointer;
    text-decoration: none;
    color: var(--text-primary);
}
.action-card:hover {
    transform: scale(1.02);
    border-color: var(--accent);
}

.action-info { display: flex; align-items: center; }
.action-icon { font-size: 24px; background: #F2F2F7; width: 50px; height: 50px; border-radius: 12px; display: flex; align-items: center; justify-content: center; margin-right: 15px; }
.action-text h4 { font-size: 17px; font-weight: 700; margin-bottom: 2px; margin-top: 0; }
.action-text p { font-size: 13px; color: var(--text-secondary); margin: 0; }
.action-arrow { color: #D1D1D6; font-weight: 800; font-size: 20px; }

/* Animations */
@keyframes fadeDown { from { opacity:0; transform:translateY(-10px); } to { opacity:1; transform:translateY(0); } }
@keyframes fadeUp { from { opacity:0; transform:translateY(10px); } to { opacity:1; transform:translateY(0); } }
</style>
</head>

<body>

<div class="navbar">
    <h2>🎵 Music Library Admin</h2>
    <button class="logout-btn" onclick="logout()">Logout</button>
</div>

<div class="container">

    <div class="welcome-header">
        <h3>Dashboard</h3>
        <p>Welcome back, <span id="adminName" style="color:var(--text-primary); font-weight:600;">Admin</span>.</p>
    </div>

    <div class="stats-grid">
        <div class="stat-card">
            <span class="stat-val" id="countSongs">-</span>
            <span class="stat-label">Library Songs</span>
        </div>
        <div class="stat-card">
            <span class="stat-val" id="countUsers">-</span>
            <span class="stat-label">Active Users</span>
        </div>
        <div class="stat-card">
            <span class="stat-val" id="countPremium" style="color:#f59e0b;">-</span>
            <span class="stat-label">Premium Tracks</span>
        </div>
        <div class="stat-card">
            <span class="stat-val" id="countBlocked" style="color:#FF3B30;">-</span>
            <span class="stat-label">Blocked Users</span>
        </div>
    </div>

    <div class="section-title">Quick Actions</div>

    <div class="actions-section">
        <a href="/admin/add-song" class="action-card">
            <div class="action-info">
                <div class="action-icon">📝</div>
                <div class="action-text">
                    <h4>Add New Song</h4>
                    <p>Upload MP3 & Cover Art</p>
                </div>
            </div>
            <span class="action-arrow">→</span>
        </a>

        <a href="/admin/songs" class="action-card">
            <div class="action-info">
                <div class="action-icon">🎵</div>
                <div class="action-text">
                    <h4>Manage Library</h4>
                    <p>Edit or Delete Songs</p>
                </div>
            </div>
            <span class="action-arrow">→</span>
        </a>

        <a href="/admin/users" class="action-card">
            <div class="action-info">
                <div class="action-icon">👥</div>
                <div class="action-text">
                    <h4>User Management</h4>
                    <p>Block or Remove Users</p>
                </div>
            </div>
            <span class="action-arrow">→</span>
        </a>
    </div>

</div>

<script>
    // 1. Auth Check
    const storedData = localStorage.getItem('admin');
    if(!storedData){
        window.location.href='/admin/login';
    } else {
        const admin = JSON.parse(storedData);
        document.getElementById('adminName').textContent = admin.adminName || "Super Admin";
    }

    function logout(){
        localStorage.removeItem('admin');
        document.cookie = "jwtToken=; path=/; max-age=0";
        window.location.href='/admin/login';
    }

    // 2. Fetch Data (Just the numbers, no charts)
    const SONGS_API = "http://localhost:8082/api/songs/all";
    const USERS_API = "http://localhost:8081/api/users/all"; 

    async function loadStats() {
        try {
            // Load Songs
            const songsRes = await fetch(SONGS_API);
            const songs = await songsRes.json();
            
            const totalSongs = songs.length;
            const premiumSongs = songs.filter(s => s.songType === 'PREMIUM').length;

            document.getElementById('countSongs').textContent = totalSongs;
            document.getElementById('countPremium').textContent = premiumSongs;

            // Load Users
            const usersRes = await fetch(USERS_API);
            const users = await usersRes.json();

            const totalUsers = users.length;
            const blockedUsers = users.filter(u => u.status === 'INACTIVE').length;
            const activeUsers = totalUsers - blockedUsers;
            
            document.getElementById('countUsers').textContent = activeUsers;
            document.getElementById('countBlocked').textContent = blockedUsers;

        } catch (e) {
            console.error("Dashboard Error:", e);
        }
    }

    loadStats();
</script>




</body>
</html>