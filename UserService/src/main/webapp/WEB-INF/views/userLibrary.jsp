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
    --radius:14px; 
    --shadow:0 4px 14px rgba(0,0,0,0.08);
} 
* { margin:0; padding:0; box-sizing:border-box; font-family:-apple-system,Inter,sans-serif; }
body { background:var(--bg); color:var(--text-primary); min-height:100vh; padding-bottom:40px; }
 
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
.nav-links { display:flex; gap:15px; }
.btn-nav { 
    text-decoration:none; 
    color:var(--text-secondary); 
    font-weight:600; 
    font-size:14px; 
    padding:8px 12px; 
    border-radius:8px;
    transition:0.2s;
}
.btn-nav:hover { background:var(--border); } 
.container{ max-width:1300px; margin:30px auto; padding:0 20px; }
.header-section { text-align:center; margin-bottom:30px; }
.header-section h1 { font-size:32px; font-weight:800; } 
.search-input { 
    width:100%; max-width:600px; padding:14px 20px;
    border-radius:30px; border:1px solid var(--border);
    font-size:15px; box-shadow:var(--shadow);
}
.search-input:focus { border-color:var(--accent); transform:scale(1.01); }
 
.grid { 
    display:grid; 
    grid-template-columns:repeat(auto-fill,minmax(210px,1fr)); 
    gap:18px; 
} 
.card { 
    background:var(--surface);
    padding:9px;  
    border-radius:12px;
    border:1px solid var(--border);
    box-shadow:var(--shadow);
    display:flex;
    flex-direction:column;
    cursor:pointer;
    transition:0.2s;
    min-height:255px;  
}
.card:hover { transform:translateY(-6px); border-color:var(--accent); }
 
.cover-img { 
    width:100%;
    aspect-ratio:1/1;
    border-radius:10px;
    object-fit:cover;
    margin-bottom:7px;  
    box-shadow:0 2px 6px rgba(0,0,0,0.1);
} 
.title {
    font-size:14px;
    font-weight:700;
    margin-bottom:1px;
    white-space:nowrap;
    overflow:hidden;
    text-overflow:ellipsis;
}
.artist { color:var(--text-secondary); font-size:11px; margin-bottom:1px; }
.album-text { color:#86868b; font-size:10px; margin-bottom:6px; }
 
.player-row {
    display:flex; 
    align-items:center; 
    gap:7px;
    background:#F2F2F7;
    padding:5px;  
    border-radius:8px;
    margin-bottom:7px;  
}
 
.play-btn-mini {
    width:34px;
    height:34px;
    border-radius:50%;
    background:white;
    border:1.6px solid #d0d0d5;
    display:flex;
    align-items:center;
    justify-content:center;
    cursor:pointer;
    transition:0.28s ease;
    box-shadow:0 3px 10px rgba(0,0,0,0.08);
}
.play-btn-mini:hover {
    background:var(--accent);
    color:white;
    border-color:var(--accent);
    box-shadow:0 4px 14px rgba(255,45,85,0.35);
}
.play-btn-mini svg {
    width:14px;
    height:14px;
    fill:currentColor;
}
 
.progress-container { flex-grow:1; }
.progress-slider {
    width:100%; height:4px;
    background:#ddd;
    border-radius:3px;
    -webkit-appearance:none;
}
.progress-slider::-webkit-slider-thumb {
    width:10px; height:10px;
    background:var(--accent);
    border-radius:50%;
    -webkit-appearance:none;
}
 
.btn-add { 
    width:100%;
    margin-top:auto;
    padding:7px; 
    border-radius:10px;
    border:1px solid var(--accent);
    color:var(--accent);
    font-size:12.5px;
    font-weight:700;
    background:var(--surface);
    cursor:pointer;
}
.btn-add:hover { background:var(--accent); color:white; }
 
.modal {
    display:none;
    position:fixed;
    top:0; left:0;
    width:100%; height:100%;
    background:rgba(0,0,0,0.35);
    backdrop-filter:blur(3px);
    justify-content:center;
    align-items:center;
    z-index:1000;
}

.modal-content {
    background:white;
    width:340px;
    max-width:90%;
    padding:28px 30px;
    border-radius:22px;
    text-align:center;
    box-shadow:0 15px 45px rgba(0,0,0,0.18);
    animation:modalPop 0.25s ease;
}

@keyframes modalPop {
    from { transform:scale(0.92); opacity:0; }
    to   { transform:scale(1); opacity:1; }
}

.modal-content h3 {
    font-size:22px;
    font-weight:800;
    margin-bottom:6px;
}

.modal-content p {
    font-size:14px;
    color:var(--text-secondary);
    margin-bottom:15px;
}

.pl-select {
    width:100%;
    padding:10px 12px;
    border-radius:10px;
    border:1px solid var(--border);
    font-size:15px;
    background:#F8F8F8;
    margin-bottom:20px;
}
 
.modal-btns {
    display:flex;
    gap:12px;
}
.btn-cancel {
    flex:1;
    background:#F2F2F7;
    color:#333;
    padding:12px 0;
    border-radius:12px;
    border:1px solid #d1d1d6;
    font-weight:600;
    font-size:15px;
    cursor:pointer;
}
.btn-cancel:hover { background:#e5e5ea; }

.btn-confirm {
    flex:1;
    background:var(--accent);
    color:white;
    padding:12px 0;
    border-radius:12px;
    border:none;
    font-weight:700;
    font-size:15px;
    cursor:pointer;
    box-shadow:0 4px 14px rgba(255,45,85,0.32);
}
.btn-confirm:hover { background:var(--accent-hover); }
 
.loading {
    text-align:center;
    padding:50px;
    font-size:18px;
    color:var(--text-secondary);
} 
.header-section h1 { 
    margin-bottom: 18px; 
}

.search-input {
    margin-top: 10px;
} 
.grid {
    margin-top: 25px;
}

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
        <div class="loading">Loading Library...</div>
    </div>
</div>

<div id="playlistModal" class="modal">
    <div class="modal-content">
        <h3>Add to Playlist</h3>
        <p>Select a playlist to save this song:</p>
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
    <div class="modal-content" style="max-width: 500px;">
        <span class="close" onclick="closeDetailsModal()" style="position: absolute; top: 15px; right: 20px; font-size: 24px; cursor: pointer;">&times;</span>
        
        <div style="text-align:center; margin-bottom:20px;">
            <div id="dIconContainer" style="margin-bottom:10px;"></div>
            <h2 id="dName" style="margin-bottom:5px;">Song Name</h2>
            <p id="dArtist" style="color:var(--accent); font-weight:600;">Artist</p>
        </div>
        
        <div style="text-align: left; margin-bottom: 20px;">
            <div style="margin: 8px 0;"><strong>Album:</strong> <span id="dAlbum">-</span></div>
            <div style="margin: 8px 0;"><strong>Music Director:</strong> <span id="dDirector">-</span></div>
            <div style="margin: 8px 0;"><strong>Release Date:</strong> <span id="dDate">-</span></div>
            <div style="margin: 8px 0;"><strong>Genre/Type:</strong> <span id="dType">-</span></div>
        </div>
        
        <div class="modal-btns">
            <button class="btn-cancel" onclick="closeDetailsModal()">Close</button>
            <button class="btn-confirm" id="dAddBtn">❤️ Add to Playlist</button>
        </div>
    </div>
</div>

<audio id="globalAudio"></audio>

<script> 
    const ADMIN_URL = "http://localhost:8082"; 
    const PLAYLIST_API = "http://localhost:8081/api/playlists"; 
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
            grid.innerHTML = "<div class='loading'>No available songs found.</div>";
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
            html += '<div class="card" onclick="openDetails(\'' + s.songName.replace(/'/g, "\\'") + '\')">'; // Escape quotes in name
            
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
        iconContainer.innerHTML = '<img src="' + imgSrc + '" style="width:150px; height:150px; border-radius:12px; object-fit:cover; box-shadow:0 8px 20px rgba(0,0,0,0.15);">';

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
</body>
</html>