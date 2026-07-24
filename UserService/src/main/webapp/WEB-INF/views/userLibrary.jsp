<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Music Library</title>
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
    --shadow:0 10px 40px rgba(0,0,0,0.08);
} 
* { margin:0; padding:0; box-sizing:border-box; font-family:-apple-system,Inter,sans-serif; }
body { background:var(--bg); color:var(--text-primary); min-height:100vh; padding-bottom:40px; }
 
.navbar{
    height:64px; background:var(--surface); padding:0 26px;
    display:flex; align-items:center; justify-content:space-between;
    border-bottom:1px solid var(--border); box-shadow:0 2px 10px rgba(0,0,0,0.05);
    position:sticky; top:0; z-index:100;
}
.navbar h2{font-size:22px;font-weight:700;}
.nav-links { display:flex; gap:15px; }
.btn-nav { 
    text-decoration:none; color:var(--text-secondary); font-weight:600; 
    font-size:14px; padding:8px 12px; border-radius:8px; transition:0.2s;
}
.btn-nav:hover { background:var(--border); color:var(--text-primary); } 
 
.container{ max-width:1300px; margin:30px auto; padding:0 20px; }
.header-section { text-align:center; margin-bottom:40px; }
.header-section h1 { font-size:36px; font-weight:800; margin-bottom:15px; } 
.search-input { 
    width:100%; max-width:600px; padding:16px 24px;
    border-radius:30px; border:1px solid var(--border);
    font-size:16px; box-shadow:var(--shadow); transition:0.2s; outline:none;
}
.search-input:focus { border-color:var(--accent); transform:scale(1.01); }
 
.grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(230px,1fr)); gap:25px; } 
.card { 
    background:var(--surface); padding:15px; border-radius:var(--radius);
    border:1px solid transparent; box-shadow:var(--shadow);
    display:flex; flex-direction:column; cursor:pointer;
    transition:0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
    min-height:300px;  
}
.card:hover { transform:translateY(-8px); border-color:rgba(0,0,0,0.05); box-shadow: 0 15px 30px rgba(0,0,0,0.12); }

.cover-img { 
    width:100%; aspect-ratio:1/1; border-radius:12px;
    object-fit:cover; margin-bottom:12px;  
    box-shadow:0 5px 15px rgba(0,0,0,0.1);
} 
.title { font-size:16px; font-weight:700; margin-bottom:2px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
.artist { color:var(--accent); font-weight:600; font-size:13px; margin-bottom:2px; }
.album-text { color:#86868b; font-size:12px; margin-bottom:12px; }
 
.player-row {
    display:flex; align-items:center; gap:10px;
    background:#F2F2F7; padding:8px 12px; border-radius:12px;
    margin-bottom:12px; margin-top:auto;
}
.play-btn-mini {
    width:36px; height:36px; border-radius:50%; background:white;
    border:none; display:flex; align-items:center; justify-content:center;
    cursor:pointer; transition:0.2s; box-shadow:0 2px 8px rgba(0,0,0,0.1);
}
.play-btn-mini:hover { transform:scale(1.1); background:var(--accent); color:white; }
.play-btn-mini svg { width:14px; height:14px; fill:currentColor; }
.progress-container { flex-grow:1; }
.progress-slider { width:100%; height:4px; background:#ddd; border-radius:3px; -webkit-appearance:none; }
.progress-slider::-webkit-slider-thumb { width:10px; height:10px; background:var(--accent); border-radius:50%; -webkit-appearance:none; }
 
.btn-add { 
    width:100%; padding:12px; border-radius:12px; border:none;
    color:white; font-size:14px; font-weight:700;
    background:var(--accent); cursor:pointer;
    transition:0.2s; box-shadow: 0 4px 12px rgba(255, 45, 85, 0.3);
    display: flex; align-items: center; justify-content: center; gap: 6px;
}
.btn-add:hover { background:var(--accent-hover); transform:translateY(-2px); }
.btn-add:active { transform:scale(0.98); }
 
.modal {
    display:none; position:fixed; top:0; left:0; width:100%; height:100%;
    background:rgba(0,0,0,0.6); backdrop-filter:blur(10px);
    justify-content:center; align-items:center; z-index:1000;
    animation: fadeIn 0.2s ease-out;
}
@keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }

.modal-content {
    background:white; width:400px; max-width:90%; padding:35px;
    border-radius:28px; text-align:center;
    box-shadow:0 25px 80px rgba(0,0,0,0.3);
    transform: scale(0.95); animation: popIn 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275) forwards;
}
@keyframes popIn { to { transform: scale(1); } }

.modal-content h3 { font-size: 22px; margin-bottom: 10px; }
.modal-content p { color: var(--text-secondary); margin-bottom: 20px; font-size: 15px; }
 
.pl-select {
    width: 100%; padding: 14px; border-radius: 14px;
    border: 1px solid #E5E5EA; background: #F2F2F7;
    font-size: 16px; margin-bottom: 30px; outline: none;
    -webkit-appearance: none; text-align-last:center;
}
.pl-select:focus { border-color: var(--accent); background: white; }
 
.modal-btns { display:flex; gap:15px; }
.btn-cancel, .btn-confirm {
    flex:1; padding:14px; border-radius:14px; border:none;
    font-weight:700; font-size:15px; cursor:pointer; transition:0.2s;
}
.btn-cancel { background:#F2F2F7; color:var(--text-primary); }
.btn-cancel:hover { background:#E5E5EA; }
.btn-confirm { background:var(--accent); color:white; }
.btn-confirm:hover { background:var(--accent-hover); box-shadow: 0 5px 15px rgba(255,45,85,0.3); }

</style>
</head>
<body>

<div class="navbar">
    <h2>🎵 Music Library</h2>
    <div class="nav-links">
        <a href="/user/playlists" class="btn-nav">My Playlists</a>
        <a href="/user/dashboard" class="btn-nav">Dashboard</a>
    </div>
</div>

<div class="container">
    <div class="header-section">
        <h1>Explore Songs</h1>
        <input type="text" id="searchInput" class="search-input" placeholder="🔍 Search by song, artist, or album..." onkeyup="filterSongs()">
    </div>

    <div id="songGrid" class="grid">
        <div class="loading" style="text-align:center; color:#999; padding:40px;">Loading Library...</div>
    </div>
</div>

<div id="playlistModal" class="modal">
    <div class="modal-content">
        <h3>Add to Playlist</h3>
        <p>Select a playlist to save this song</p>
        
        <select id="playlistSelect" class="pl-select">
            <option>Loading playlists...</option>
        </select>

        <div class="modal-btns">
            <button class="btn-cancel" onclick="closeModal()">Cancel</button>
            <button class="btn-confirm" onclick="confirmAddToPlaylist()">Add Song</button>
        </div>
    </div>
</div>

<div id="detailsModal" class="modal">
    <div class="modal-content" style="max-width: 450px;">
        <span class="close" onclick="closeDetailsModal()" style="position: absolute; top: 20px; right: 25px; font-size: 28px; cursor: pointer; color:#999;">&times;</span>
        
        <div style="text-align:center; margin-bottom:20px;">
            <div id="dIconContainer" style="margin-bottom:15px;"></div>
            <h2 id="dName" style="margin-bottom:5px; font-size:24px;">Song Name</h2>
            <p id="dArtist" style="color:var(--accent); font-weight:700; font-size:16px;">Artist</p>
        </div>
        
        <div style="text-align: left; margin-bottom: 30px; background:#F9F9F9; padding:20px; border-radius:16px;">
            <div style="margin: 8px 0; display:flex; justify-content:space-between;"><strong>Album</strong> <span id="dAlbum" style="color:var(--text-secondary)">-</span></div>
            <div style="margin: 8px 0; display:flex; justify-content:space-between;"><strong>Director</strong> <span id="dDirector" style="color:var(--text-secondary)">-</span></div>
            <div style="margin: 8px 0; display:flex; justify-content:space-between;"><strong>Release</strong> <span id="dDate" style="color:var(--text-secondary)">-</span></div>
            <div style="margin: 8px 0; display:flex; justify-content:space-between;"><strong>Genre</strong> <span id="dType" style="color:var(--text-secondary)">-</span></div>
        </div>
        
        <div class="modal-btns">
            <button class="btn-cancel" onclick="closeDetailsModal()">Close</button>
            <button class="btn-confirm" id="dAddBtn">❤️ Add to Playlist</button>
        </div>
    </div>
</div>

<audio id="globalAudio"></audio>

<script> 
    // KEEPING YOUR EXACT LOGIC TO PREVENT BREAKING
    const ADMIN_URL = "http://192.168.1.52:8082";
const PLAYLIST_API = "http://192.168.1.52:8080/api/playlists";
const SONGS_API = ADMIN_URL + "/api/songs/available";
 
    var user = JSON.parse(localStorage.getItem('user'));
    if(!user || !user.userId) window.location.href = "/login";

    var USER_ID = user.userId;
    var JWT_TOKEN = user.jwt; 
    
    var allSongs = [];
    var selectedSongId = null;
 
    var currentAudio = document.getElementById("globalAudio");
    var currentPlayingId = null; 

    const SVG_PLAY = '<svg viewBox="0 0 24 24"><path d="M8 5v14l11-7z"/></svg>';
    const SVG_PAUSE = '<svg viewBox="0 0 24 24"><path d="M6 19h4V5H6v14zm8-14v14h4V5h-4z"/></svg>';

    async function loadLibrary() {
        try {
            var res = await fetch(SONGS_API);
            if(!res.ok) throw new Error("Failed to fetch songs. Status: " + res.status);
            
            allSongs = await res.json();
            renderSongs(allSongs);
        } catch(e) { 
            console.error(e); 
            document.getElementById("songGrid").innerHTML = "<div class='loading'>Failed to load library. Ensure Admin Service is running on Port 8082.</div>";
        }
    }
 
    function getSafeImageUrl(path) { 
        console.log("Checking image path:", path);
 
        if (!path || path.trim() === "") {
            return "https://via.placeholder.com/300x300?text=Music";
        }
 
        var strPath = String(path);
        if (strPath.indexOf("300x300") !== -1 || strPath.indexOf("No+Image") !== -1) {
             return "https://via.placeholder.com/300x300?text=Music";
        } 
        if (strPath.startsWith("http")) {
            return strPath;
        }
 
        var cleanPath = strPath.startsWith("/") ? strPath : "/" + strPath;
        return ADMIN_URL + cleanPath;
    }

    function renderSongs(songs) {
        var grid = document.getElementById("songGrid");
        grid.innerHTML = "";
        
        if(songs.length === 0) {
            grid.innerHTML = "<div class='loading' style='text-align:center; padding:40px; color:#888;'>No available songs found.</div>";
            return;
        }

        for (var i = 0; i < songs.length; i++) {
            var s = songs[i];
            var id = s.libraryId; 
            var album = s.albumName ? s.albumName : "Single";
 
            var imgSrc = getSafeImageUrl(s.imagePath);
 
            var audioUrl = "#";
            if (s.audioPath && s.audioPath.trim() !== "") {
                var cleanAudio = s.audioPath.startsWith("/") ? s.audioPath : "/" + s.audioPath;
                audioUrl = ADMIN_URL + cleanAudio;
            }

            var html = "";
            html += '<div class="card" onclick="openDetails(\'' + s.songName.replace(/'/g, "\\'") + '\')">'; 
            
            html += '<img src="' + imgSrc + '" class="cover-img">'; 
            html += '<div class="title">' + s.songName + '</div>';
            html += '<div class="artist">' + s.singer + '</div>';
            html += '<div class="album-text">' + album + '</div>';
 
            html += '<div class="player-row" onclick="event.stopPropagation()">';
            html +=     '<button id="btn-' + id + '" class="play-btn-mini" onclick="togglePlay(' + id + ', \'' + audioUrl + '\')">' + SVG_PLAY + '</button>';
            html +=     '<div class="progress-container">';
            html +=         '<input type="range" id="progress-' + id + '" class="progress-slider" value="0" min="0" step="0.1" oninput="seekAudio(this.value)">';
            html +=     '</div>';
            html += '</div>';

            // UPDATED BUTTON CLASS FOR PREMIUM LOOK
            html += '<button class="btn-add" onclick="event.stopPropagation(); openAddModal(' + id + ')">❤️ Add to Playlist</button>';
            html += '</div>';

            grid.innerHTML += html;
        }
    }

    function togglePlay(id, url) {
        var btn = document.getElementById("btn-" + id);
        
        if (currentPlayingId === id) {
            if (currentAudio.paused) {
                currentAudio.play();
                btn.innerHTML = SVG_PAUSE;
                btn.classList.add("playing");
            } else {
                currentAudio.pause();
                btn.innerHTML = SVG_PLAY;
                btn.classList.remove("playing");
            }
        } else {
            if (currentPlayingId !== null) {
                var prevBtn = document.getElementById("btn-" + currentPlayingId);
                if(prevBtn) {
                    prevBtn.innerHTML = SVG_PLAY;
                    prevBtn.classList.remove("playing");
                    var prevProg = document.getElementById("progress-" + currentPlayingId);
                    if(prevProg) prevProg.value = 0;
                }
            }
            currentPlayingId = id;
            currentAudio.src = url;
            currentAudio.load();
            currentAudio.play();
            btn.innerHTML = SVG_PAUSE;
            btn.classList.add("playing");
        }
    }

    currentAudio.ontimeupdate = function() {
        if (currentPlayingId !== null) {
            var slider = document.getElementById("progress-" + currentPlayingId);
            if (slider && !isNaN(currentAudio.duration)) {
                slider.max = currentAudio.duration;
                slider.value = currentAudio.currentTime;
            }
        }
    };

    currentAudio.onended = function() {
        if (currentPlayingId !== null) {
            var btn = document.getElementById("btn-" + currentPlayingId);
            if(btn) {
                btn.innerHTML = SVG_PLAY;
                btn.classList.remove("playing");
            }
            var slider = document.getElementById("progress-" + currentPlayingId);
            if(slider) slider.value = 0;
        }
    };

    function seekAudio(val) {
        currentAudio.currentTime = val;
    }

    function filterSongs() {
        var term = document.getElementById("searchInput").value.toLowerCase();
        var filtered = allSongs.filter(function(s) {
            return (s.songName && s.songName.toLowerCase().includes(term)) || 
                   (s.singer && s.singer.toLowerCase().includes(term)) ||
                   (s.albumName && s.albumName.toLowerCase().includes(term));
        });
        renderSongs(filtered);
    }
 
    function openDetails(songName) { 
        var song = allSongs.find(function(s) {
            return s.songName == songName;
        });
        if(!song) return;

        document.getElementById("dName").innerText = song.songName || "Unknown";
        document.getElementById("dArtist").innerText = song.singer || "Unknown";
        document.getElementById("dAlbum").innerText = song.albumName || "-";
        document.getElementById("dDirector").innerText = song.musicDirector || "-";
        document.getElementById("dDate").innerText = song.releaseDate || "-";
        document.getElementById("dType").innerText = song.songType || "Free";
 
        var imgSrc = getSafeImageUrl(song.imagePath);
        
        var iconContainer = document.getElementById("dIconContainer");
        iconContainer.innerHTML = '<img src="' + imgSrc + '" style="width:160px; height:160px; border-radius:16px; object-fit:cover; box-shadow:0 10px 30px rgba(0,0,0,0.2);">';

        document.getElementById("dAddBtn").onclick = function() {
            closeDetailsModal();
            openAddModal(song.libraryId); 
        };

        document.getElementById("detailsModal").style.display = "flex";
    }

    function closeDetailsModal() {
        document.getElementById("detailsModal").style.display = "none";
    }

    async function openAddModal(songId) {
        selectedSongId = songId;
        document.getElementById("playlistModal").style.display = "flex";
        var select = document.getElementById("playlistSelect");
        select.innerHTML = "<option>Loading...</option>";
        
        try {
            var res = await fetch(PLAYLIST_API + "/user/" + USER_ID, {
                method: 'GET',
                headers: { 'Authorization': 'Bearer ' + JWT_TOKEN, 'Content-Type': 'application/json' }
            });

            var playlists = await res.json();
            select.innerHTML = "";
            if(playlists.length === 0) {
                select.innerHTML = "<option value=''>No playlists found.</option>";
                return;
            }
            for(var i=0; i<playlists.length; i++) {
                var p = playlists[i];
                select.innerHTML += '<option value="' + p.playlistId + '">' + p.playlistName + '</option>';
            }
        } catch(e) { console.error(e); }
    }

    function closeModal() {
        document.getElementById("playlistModal").style.display = "none";
    }

    async function confirmAddToPlaylist() {
        var playlistId = document.getElementById("playlistSelect").value;
        if(!playlistId) return;
        var url = PLAYLIST_API + "/" + playlistId + "/add/" + selectedSongId;
        
        var res = await fetch(url, { 
            method: 'POST',
            headers: { 'Authorization': 'Bearer ' + JWT_TOKEN }
        });
        
        if(res.ok) {
            closeModal();
            alert("Song added successfully!");
        } else {
            alert("Failed to add song.");
        }
    }

    window.onclick = function(event) {
        if (event.target == document.getElementById("playlistModal")) closeModal();
        if (event.target == document.getElementById("detailsModal")) closeDetailsModal();
    }

    loadLibrary();
</script>

<footer style="
    text-align:center;
    padding:20px 0;
    font-size:14px;
    color:#86868b;
    margin-top:40px;
">
    © 2025 Music Library Application. All rights reserved.
</footer>

</body>
</html>