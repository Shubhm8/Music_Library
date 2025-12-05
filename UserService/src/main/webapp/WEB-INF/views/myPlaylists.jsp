<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Playlists</title>
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
}

*{margin:0;padding:0;box-sizing:border-box;font-family:-apple-system,Inter,sans-serif;}
body{background:var(--bg);color:var(--text-primary);min-height:100vh;padding-bottom:40px;}

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

.back-btn{
    margin-left:14px;
    background:var(--surface-muted);
    color:var(--text-primary);
    padding:10px 18px;
    border-radius:12px;
    text-decoration:none;
    font-weight:600;
    transition:.18s; 
    border: 1px solid var(--border);
}
.back-btn:hover{background:#e5e5ea;}

.container{max-width:1300px;margin:30px auto;padding:0 20px;}
.header-section{
    background:var(--surface);
    border:1px solid var(--border);
    border-radius:var(--radius);
    padding:26px;
    box-shadow:var(--shadow);
    display:flex;
    justify-content:space-between;
    flex-wrap:wrap;
    margin-bottom:24px;
}
h1{font-size:32px;font-weight:800;}
.stats{display:flex;gap:16px;}
.stat-box{background:var(--surface-muted);border:1px solid var(--border);padding:16px 26px;border-radius:var(--radius);text-align:center;}
.number{font-size:26px;font-weight:700;}
.label{font-size:12px;color:var(--text-secondary);}
.action-row { display: flex; gap: 20px; margin-bottom: 25px; }

.create-section { 
    flex: 2; 
    background:var(--surface);
    border:1px solid var(--border);
    border-radius:var(--radius);
    padding:20px;
    box-shadow:var(--shadow); 
    display: flex; gap: 15px; align-items: center;
}
.search-section { 
    flex: 1; 
    background:var(--surface);
    border:1px solid var(--border);
    border-radius:var(--radius);
    padding:20px;
    box-shadow:var(--shadow); 
}

.input-group { flex: 1; }
.input-group input {
    width:100%;
    padding:14px 18px;
    border-radius:14px;
    border:1.8px solid var(--border);
    background:var(--surface-muted);
    font-size: 16px;
}
.input-group input:focus{border-color:var(--accent);outline:none;background:white;}

.btn-create {
    padding:14px 28px; 
    background:var(--accent); 
    color:white;
    border:none; 
    border-radius:14px; 
    font-size:16px; 
    font-weight:700;
    cursor:pointer; 
    transition:0.2s; 
    white-space: nowrap;
}
.btn-create:hover { background:var(--accent-hover); transform: translateY(-2px); }

/* Grid Layout */
.grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(250px,1fr));gap:20px;}

/* Playlist Card Styling */
.playlist-card{
    background:var(--surface); 
    border:1px solid var(--border); 
    border-radius:var(--radius);
    padding:25px; 
    box-shadow:var(--shadow); 
    cursor:pointer; 
    transition:.2s; 
    text-align: center;
    position: relative; 
}
.playlist-card:hover{transform:translateY(-5px); border-color: var(--accent);}
.playlist-card:active{transform:scale(0.98);}

.icon { font-size: 50px; margin-bottom: 15px; display: block; }
.pl-title { font-size: 20px; font-weight: 700; margin-bottom: 5px; color: var(--text-primary); }
.pl-count { color: var(--text-secondary); font-size: 14px; font-weight: 500; }

.btn-rename {
    margin-top: 15px; display: inline-block; width: 100%;
    padding: 10px; background: #E5E5EA; color: #1D1D1F; border:none;
    border-radius: 10px; text-decoration: none; font-weight: 600; font-size: 13px;
    transition: 0.2s; cursor: pointer;
}
.btn-rename:hover { background: #d1d1d6; }

.btn-delete {
    margin-top: 10px; display: inline-block; width: 100%;
    padding: 10px; background: #fee2e2; color: #dc2626; border:none;
    border-radius: 10px; text-decoration: none; font-weight: 600; font-size: 13px;
    transition: 0.2s; cursor: pointer;
}
.btn-delete:hover { background: #dc2626; color: white; }
.loading { text-align: center; padding: 40px; color: var(--text-secondary); font-size: 18px; }
</style>
</head>
<body>

<div class="navbar">
    <h2>🎵 My Collection</h2>
    <a href="/user/dashboard" class="back-btn">Dashboard</a>
</div>   

<div class="container">
    <div class="header-section">
        <h1>Your Playlists</h1>
        <div class="stats">
            <div class="stat-box">
                <div class="number" id="totalPlaylists">0</div>
                <div class="label">Playlists</div>
            </div>
        </div>
    </div>

    <div class="action-row">
        <div class="create-section">
            <div class="input-group">
                <input type="text" id="playlistName" placeholder="✨ New Name (e.g. '🔥 Mix')..." />
            </div>
            <button class="btn-create" onclick="createPlaylist()">+ Create</button>
        </div>

        <div class="search-section">
            <div class="input-group">
                <input type="text" id="searchInput" placeholder="🔍 Search Playlists..." onkeyup="filterPlaylists()">
            </div>
        </div>
    </div>

    <div id="playlistGrid" class="grid">
        <div class="loading">Loading your collection...</div>
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

    var user = JSON.parse(localStorage.getItem('user'));
    
    if(!user || !user.userId) {
        alert("You are not logged in!");
        window.location.href = "/login";
    }

    var USER_ID = user.userId;
    var JWT_TOKEN = user.jwt; 
    var API_URL = "http://localhost:8081/api/playlists"; 

    var SONGS_AVAIL_API = "http://localhost:8082/api/songs/available"; 

    function parsePlaylistDisplay(fullName, id) {
        const emojiRegex = /^(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])/;
        const match = fullName.match(emojiRegex);

        if (match) {
            return { icon: match[0], name: fullName.replace(emojiRegex, '').trim() };
        } else {
            return { icon: getSmartIconFallback(fullName, id), name: fullName };
        }
    }

    function getSmartIconFallback(name, id) {
        const lower = name.toLowerCase();
        if(lower.includes('gym') || lower.includes('work') || lower.includes('fit')) return '💪';
        if(lower.includes('travel') || lower.includes('trip') || lower.includes('drive')) return '🚗';
        if(lower.includes('love') || lower.includes('heart')) return '❤️';
        if(lower.includes('party') || lower.includes('dance')) return '🎉';
        if(lower.includes('sleep') || lower.includes('calm')) return '🌙';
        
        const musicIcons = ['🎵', '🎧', '💿', '🎹', '🎼', '📻', '🎙️', '🥁'];
        return musicIcons[id % musicIcons.length];
    }
    async function loadPlaylists() {
        try {
            var songsRes = await fetch(SONGS_AVAIL_API);
            if(!songsRes.ok) throw new Error("Could not fetch available songs.");
            var availableSongs = await songsRes.json();
            var res = await fetch(API_URL + "/user/" + USER_ID, {
                method: 'GET',
                headers: { 'Authorization': 'Bearer ' + JWT_TOKEN, 'Content-Type': 'application/json' }
            });
            if(!res.ok) throw new Error("Failed to load user playlists.");
            var playlists = await res.json();
            var grid = document.getElementById("playlistGrid");
            grid.innerHTML = "";
            if(playlists.length === 0) {
                document.getElementById("totalPlaylists").textContent = 0;
                grid.style.display = "block";
                grid.innerHTML = '<div style="text-align:center; padding:50px; color:#86868B;"><h2>No playlists yet.</h2><p>Create one above!</p></div>';
                return;
            }
            grid.style.display = "grid";
            let totalVisiblePlaylists = 0; 
            playlists.forEach(function(pl) {
                var visibleCount = 0;
                var rawSongIds = pl.songIds || [];
                
                rawSongIds.forEach(id => {
                    var found = availableSongs.find(s => String(s.libraryId) === String(id) || String(s.songId) === String(id));
                    if(found) {
                        visibleCount++;
                    }
                });
                var safeName = pl.playlistName.replace(/'/g, "\\'"); 
                var displayData = parsePlaylistDisplay(pl.playlistName, pl.playlistId);

                grid.innerHTML += 
                    '<div class="playlist-card" onclick="openDetails(' + pl.playlistId + ')">' +
                        '<span class="icon">' + displayData.icon + '</span>' + 
                        '<div class="pl-title">' + displayData.name + '</div>' +
                        '<div class="pl-count">' + visibleCount + ' Songs</div>' + 
                        '<button onclick="renamePlaylist(event, ' + pl.playlistId + ', \'' + safeName + '\')" class="btn-rename">✏️ Rename</button>' +
                        '<button onclick="deletePlaylist(event, ' + pl.playlistId + ')" class="btn-delete">Delete Playlist</button>' +
                    '</div>';
                
                totalVisiblePlaylists++; 
            });

            document.getElementById("totalPlaylists").textContent = totalVisiblePlaylists; 

        } catch(err) { 
            console.error(err); 
            document.getElementById("playlistGrid").innerHTML = '<div class="loading" style="color:red;">Error loading collection. Check console.</div>';
        }
    }
    function filterPlaylists() {
        var input = document.getElementById("searchInput").value.toLowerCase();
        var cards = document.getElementsByClassName("playlist-card");

        for (var i = 0; i < cards.length; i++) {
            var title = cards[i].querySelector(".pl-title").innerText.toLowerCase();
            if (title.includes(input)) {
                cards[i].style.display = ""; 
            } else {
                cards[i].style.display = "none"; 
            }
        }
    }

    function openDetails(id) { window.location.href = "/user/playlist/details?id=" + id; }

    async function createPlaylist() {
        var nameInput = document.getElementById("playlistName");
        var name = nameInput.value.trim();
        if(!name) { alert("Enter a name!"); return; }
        
        try {
            var url = API_URL + "/create?userId=" + USER_ID + "&name=" + encodeURIComponent(name);
            var res = await fetch(url, { method: 'POST', headers: { 'Authorization': 'Bearer ' + JWT_TOKEN } });
            if(res.ok) { nameInput.value = ""; loadPlaylists(); }
        } catch(e) { console.error(e); }
    }

    async function renamePlaylist(event, id, currentName) {
        event.stopPropagation();
        var newName = prompt("Rename Playlist:", currentName);
        if(!newName || newName.trim() === "" || newName === currentName) return;

        try {
            var url = API_URL + "/" + id + "?name=" + encodeURIComponent(newName);
            var res = await fetch(url, { method: 'PUT', headers: { 'Authorization': 'Bearer ' + JWT_TOKEN } });
            if(res.ok) { loadPlaylists(); }
        } catch(e) { console.error(e); }
    }

    async function deletePlaylist(event, id) {
        event.stopPropagation();
        if(!confirm("Are you sure?")) return;
        try { 
            await fetch(API_URL + "/" + id, { method: 'DELETE', headers: { 'Authorization': 'Bearer ' + JWT_TOKEN } }); 
            loadPlaylists(); 
        } catch(e) { console.error(e); }
    }

    loadPlaylists();
</script>
</body>
</html>