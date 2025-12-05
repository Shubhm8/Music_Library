<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>User Dashboard</title>

<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />

<style>

:root {
    --bg:#FAFAFA; 
    --surface:#FFFFFF; 
    --text-primary:#1C1C1E; 
    --text-secondary:#3A3A3C;
    --accent:#FF2D55; 
    --accent-hover:#e0244a; 
    --border:#E5E5EA; 
    --radius:16px; 
    --shadow:0 4px 14px rgba(0,0,0,0.08);
}

*{margin:0;padding:0;box-sizing:border-box;font-family:-apple-system,Inter,sans-serif;}
body{background:var(--bg);color:var(--text-primary);min-height:100vh;}

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
.navbar h2{font-size:22px;font-weight:700;}

.right-nav { display: flex; align-items: center; gap: 20px; }
.notif-container { position: relative; cursor: pointer; }
.bell-icon { font-size: 24px; }
.badge { 
    position: absolute; top: -5px; right: -5px; 
    background: #FF3B30; color: white; border-radius: 50%; 
    padding: 2px 6px; font-size: 11px; font-weight: bold; 
    border: 2px solid white;
}

.notif-dropdown {
    display: none; position: absolute; top: 40px; right: 0;
    width: 320px; background: white; border: 1px solid #E5E5EA;
    border-radius: 12px; box-shadow: 0 10px 40px rgba(0,0,0,0.15);
    z-index: 1000; max-height: 400px; overflow-y: auto;
}
.notif-header { 
    padding: 12px 16px; font-weight: 700; border-bottom: 1px solid #E5E5EA; 
    background: #FAFAFA; font-size: 14px;
    display: flex; justify-content: space-between; align-items: center;
}
.clear-btn { 
    font-size: 11px; color: #FF3B30; cursor: pointer; text-decoration: none; 
}
.clear-btn:hover { text-decoration: underline; }

.notif-item {
    padding: 14px 16px; border-bottom: 1px solid #f0f0f0; font-size: 14px; text-align: left;
    transition: 0.2s;
}
.notif-item:hover { background: #F2F2F7; }
.notif-time { font-size: 11px; color: #8E8E93; display: block; margin-top: 4px; }

.nav-btn{ 
    background:var(--accent); color:white; padding:10px 18px; 
    border-radius:12px; text-decoration:none; font-weight:600; 
    cursor: pointer; border: none; 
}
.nav-btn:hover{ background:var(--accent-hover); }

.container{ max-width:1000px; margin:60px auto; text-align:center; padding:20px; }
h1{ font-size:42px; font-weight:800; margin-bottom:10px; }
p{ font-size:18px; color:var(--text-secondary); margin-bottom:40px; }

.card-grid{ display:flex; gap:30px; justify-content:center; flex-wrap:wrap; }
.card{ 
    width:300px; background:var(--surface); padding:40px; 
    border-radius:var(--radius); box-shadow:var(--shadow); 
    border:1px solid var(--border); text-decoration:none; 
    color:var(--text-primary); transition:.2s; 
    display:flex; flex-direction:column; align-items:center; 
}
.card:hover{ transform:translateY(-8px); border-color:var(--accent); }
.icon{ font-size:60px; margin-bottom:20px; display:block; }
.title{ font-size:24px; font-weight:700; margin-bottom:10px; }
.desc{ font-size:14px; color:var(--text-secondary); }
</style>
</head>

<body>

<div class="navbar">
    <h2>🎵 User Dashboard</h2>
    
    <div class="right-nav">
        <div class="notif-container">
            <div onclick="toggleNotif()">
                <span class="bell-icon">🔔</span>
                <span id="notifBadge" class="badge" style="display:none">0</span>
            </div>
            
            <div id="notifList" class="notif-dropdown">
                <div class="notif-header">
                    Recent Updates
                    <span class="clear-btn" onclick="clearAllNotifications()">Clear All</span>
                </div>
                <div id="notifContent">
                    <div style="padding:20px; text-align:center; color:#888;">Loading...</div>
                </div>
            </div>
        </div>

        <button type="button" onclick="logout()" class="nav-btn">Logout</button>

    </div>
</div>

<div class="container">
    <h1>Welcome <span id="userName">User</span>!</h1>
    <p>Your personal music sanctuary. Discover new tracks, manage your playlists, and update your profile.</p>

    <div class="card-grid">
        <a href="/user/library" class="card">
            <span class="icon">🎵</span>
            <div class="title">Browse Library</div>
            <div class="desc">Search songs and add music to your playlists.</div>
        </a>
        <a href="/user/playlists" class="card">
            <span class="icon">🎧</span>
            <div class="title">My Collection</div>
            <div class="desc">View and manage your personal playlists.</div>
        </a>
        <a href="/user/profile" class="card">
            <span class="icon">👤</span>
            <div class="title">My Profile</div>
            <div class="desc">Update your personal details and password.</div>
        </a>
    </div>
</div>

<script> 
const storedUser = localStorage.getItem("user");

if (!storedUser) {
    document.cookie = "jwtToken=; path=/; max-age=0";
    window.location.href = "/login";
}

const userObj = JSON.parse(storedUser);
document.getElementById("userName").textContent = userObj.firstName || "User";
 
function logout() {
    localStorage.removeItem("user");
    document.cookie = "jwtToken=; path=/; max-age=0";
    window.location.href = "/login";
}
 
const NOTIF_API = "http://localhost:8085/notify/recent"; 
let latestNotificationId = 0;

async function loadNotifications() {
    try {
        const res = await fetch(NOTIF_API);
        if(res.ok) {
            let list = await res.json();
            const clearedId = localStorage.getItem('clearedNotifId') || 0;
            list = list.filter(n => n.id > clearedId);

            const container = document.getElementById("notifContent");
            const badge = document.getElementById("notifBadge");

            if (list.length > 0) latestNotificationId = list[0].id;
            const lastSeenId = localStorage.getItem('lastSeenNotifId') || 0;

            badge.style.display = (list.length > 0 && latestNotificationId > lastSeenId) ? "block" : "none";

            if(list.length > 0) {
                container.innerHTML = "";
                list.forEach(n => {
                    const d = new Date(n.createdAt);
                    const dateStr = d.toLocaleTimeString([], {hour:'2-digit', minute:'2-digit'});
                    
                    container.innerHTML += 
                        '<div class="notif-item">' + 
                            '<div>' + n.message + '</div>' + 
                            '<span class="notif-time">' + dateStr + '</span>' +
                        '</div>';
                });
            } else {
                container.innerHTML = '<div style="padding:20px; text-align:center; color:#999;">No new notifications</div>';
            }
        }
    } catch(e) { console.error("Notif Error", e); }
}

function toggleNotif() {
    const dd = document.getElementById("notifList");
    const badge = document.getElementById("notifBadge");

    dd.style.display = (dd.style.display === "block") ? "none" : "block";
    badge.style.display = "none";
    if(latestNotificationId > 0) localStorage.setItem('lastSeenNotifId', latestNotificationId);
}

function clearAllNotifications() {
    if(latestNotificationId > 0) {
        localStorage.setItem('clearedNotifId', latestNotificationId);
        document.getElementById("notifContent").innerHTML = '<div style="padding:20px; text-align:center; color:#999;">No new notifications</div>';
        document.getElementById("notifBadge").style.display = "none";
    }
}

window.onclick = function(event) {
    if (!event.target.closest('.notif-container')) {
        document.getElementById("notifList").style.display = "none";
    }
} 
loadNotifications();
</script> 
</body>
</html>
