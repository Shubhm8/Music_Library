<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Playlist Details</title>
<style>
:root {
    --bg:#FAFAFA; 
    --surface:#FFFFFF; 
    --text-primary:#1C1C1E; 
    --text-secondary:#3A3A3C;
    --accent:#FF2D55; 
    --border:#E5E5EA; 
    --radius:16px; 
    --shadow:0 4px 14px rgba(0,0,0,0.08);
}
*{margin:0;padding:0;box-sizing:border-box;font-family:-apple-system,Inter,sans-serif;}
body{background:var(--bg);color:var(--text-primary);min-height:100vh;padding-bottom:120px;}

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
    background:var(--surface);
    color:var(--text-primary);
    padding:10px 18px;
    border-radius:12px;
    text-decoration:none;
    font-weight:600;
    transition:.18s; 
    border: 1px solid var(--border);
}
.back-btn:hover{background:#F2F2F7;}

.container{max-width:1200px;margin:30px auto;padding:0 20px;}

.header-card{ 
    background:var(--surface); padding:30px; 
    border-radius:var(--radius); box-shadow:var(--shadow); 
    display:flex; justify-content:space-between; align-items:center; 
    margin-bottom:25px; 
}
.header-text p { color:var(--text-secondary); font-size:14px; margin-top:5px;}
.stat-box { background:#F2F2F7; padding:15px 25px; border-radius:12px; text-align:center; min-width:120px; }
.stat-num { font-size: 24px; font-weight: 800; display: block; }
.stat-label { font-size: 12px; color: var(--text-secondary); font-weight: 600; text-transform: uppercase; }

.search-container { margin-bottom: 20px; }
.search-input { 
    width: 100%; padding: 14px 20px; 
    border-radius: 12px; border: 1.5px solid var(--border); 
    font-size: 15px; outline: none; transition: 0.2s; 
}
.search-input:focus { border-color: var(--accent); box-shadow: 0 0 0 3px rgba(255, 45, 85, 0.1); }

.table-card { background: var(--surface); border-radius: var(--radius); box-shadow: var(--shadow); overflow: hidden; }
table { width: 100%; border-collapse: collapse; }
th { text-align: left; padding: 18px 25px; background: #FAFAFA; color: var(--text-secondary); font-size: 13px; text-transform: uppercase; font-weight: 600; border-bottom: 1px solid var(--border); }
td { padding: 18px 25px; border-bottom: 1px solid var(--border); font-size: 15px; vertical-align: middle; }
tr:last-child td { border-bottom: none; }
.song-row { cursor: pointer; transition: 0.2s; }
.song-row:hover { background-color: #F9F9F9; }
 
.list-play-btn { width: 50px; text-align: center; }
.list-play-btn svg {
    width: 28px; height: 28px; 
    fill: var(--accent); 
    vertical-align: middle; 
    cursor: pointer;
    transition: transform 0.1s;
}
.list-play-btn svg:active { transform: scale(0.9); }

.btn-remove { color: #FF3B30; background: #FFF0F0; padding: 6px 12px; border-radius: 6px; text-decoration: none; font-size: 13px; font-weight: 600; border:none; cursor:pointer;}
.btn-remove:hover { background: #FF3B30; color: white; }
.empty-state { text-align: center; padding: 60px; color: var(--text-secondary); }
.edit-btn { background:none; border:none; cursor:pointer; font-size:18px; margin-left: 8px; }

.player-bar {
    position: fixed; bottom: 0; left: 0; width: 100%; height: 95px;
    background: rgba(255, 255, 255, 0.98); backdrop-filter: blur(20px);
    border-top: 1px solid var(--border); box-shadow: 0 -5px 25px rgba(0,0,0,0.06);
    display: flex; align-items: center; justify-content: space-between; padding: 0 40px;
    z-index: 1000;
}

.player-info { width: 200px; }
.player-song-title { font-weight: 700; font-size: 15px; margin-bottom: 2px; color: var(--text-primary); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.player-artist { font-size: 12px; color: var(--text-secondary); }

.center-controls {
    flex-grow: 1; display: flex; flex-direction: column; align-items: center; justify-content: center;
    max-width: 500px; margin: 0 20px;
}
.player-controls { display: flex; align-items: center; gap: 25px; margin-bottom: 5px; }

.progress-area { width: 100%; display: flex; align-items: center; gap: 10px; }
.time-text { font-size: 11px; color: var(--text-secondary); font-variant-numeric: tabular-nums; width: 35px; text-align: center; }

.volume-area { width: 150px; display: flex; align-items: center; justify-content: flex-end; gap: 8px; }
.volume-slider { width: 80px !important; }

input[type=range] {
    -webkit-appearance: none; width: 100%; height: 4px; background: #E5E5EA; border-radius: 2px; cursor: pointer; outline: none;
}
input[type=range]::-webkit-slider-thumb {
    -webkit-appearance: none; width: 12px; height: 12px; background: var(--text-primary); border-radius: 50%; 
    opacity: 0; transition: 0.2s; box-shadow: 0 1px 3px rgba(0,0,0,0.3);
}
.progress-area:hover input[type=range]::-webkit-slider-thumb, 
.volume-area:hover input[type=range]::-webkit-slider-thumb { opacity: 1; }

.btn-icon { background: none; border: none; cursor: pointer; color: #8E8E93; transition: 0.2s; display: flex; align-items: center; justify-content: center; }
.btn-icon svg { width: 18px; height: 18px; fill: currentColor; }
.btn-icon:hover { color: var(--text-primary); transform: scale(1.1); }
.active-ctrl { color: var(--accent) !important; }

.btn-skip { background: none; border: none; cursor: pointer; color: var(--text-primary); transition: 0.2s; }
.btn-skip svg { width: 24px; height: 24px; fill: currentColor; }
.btn-skip:hover { color: var(--accent); transform: scale(1.1); }

.btn-play { 
    width: 48px; height: 48px; border-radius: 50%; border: none; cursor: pointer;
    background: var(--text-primary); color: white; display: flex; align-items: center; justify-content: center;
    box-shadow: 0 4px 12px rgba(0,0,0,0.15); transition: 0.2s;
}
.btn-play svg { width: 20px; height: 20px; fill: white; margin-left: 2px; }
.btn-play:hover { background: var(--accent); transform: scale(1.05); }
.pause-icon { margin-left: 0 !important; }

</style>
</head>
<body>

<div class="navbar">
    <h2>🎵 Playlist View</h2>
    <a href="/user/playlists" class="back-btn">← Back to Collection</a>
</div>

<div class="container">
    <div class="header-card">
        <div class="header-text">
            <div style="display:flex; align-items:center; gap:10px;">
                <h1 id="plName" style="margin:0;">Loading...</h1>
                <button onclick="renamePlaylist()" class="edit-btn" title="Rename Playlist">✏️</button>
                <button onclick="deletePlaylist()" class="edit-btn" style="color:red;" title="Delete Playlist">🗑️</button>
            </div>
            <p>Playlist Details</p>
        </div>
        <div class="stat-box">
            <span class="stat-num" id="plCount">0</span>
            <span class="stat-label">Songs</span>
        </div>
    </div>

    <div class="search-container">
        <input type="text" id="playlistSearch" class="search-input" 
               placeholder="🔍 Search inside this playlist..." onkeyup="filterPlaylistSongs()">
    </div>

    <div class="table-card">
        <table id="songsTable">
            <thead>
                <tr>
                    <th style="width: 60px;">Play</th>
                    <th>Song Name</th>
                    <th>Artist</th>
                    <th>Album</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody id="songList">
                <tr><td colspan="5" class="empty-state">Loading songs...</td></tr>
            </tbody>
        </table>
    </div>
</div>

<audio id="mainAudio" onended="nextSong()"></audio>

<div class="player-bar">
    <div class="player-info">
        <div class="player-song-title" id="pTitle">Select a song</div>
        <div class="player-artist" id="pArtist">to start listening</div>
    </div>

    <div class="center-controls">
        <div class="player-controls">
            <button class="btn-icon" id="btnShuffle" onclick="toggleShuffle()" title="Shuffle">
                <svg viewBox="0 0 24 24"><path d="M10.59 9.17L5.41 4 4 5.41l5.17 5.17 1.42-1.41zM14.5 4l2.04 2.04L4 18.59 5.41 20 17.96 7.46 20 9.5V4h-5.5zm.33 9.41l-1.41 1.41 3.13 3.13L14.5 20H20v-5.5l-2.04 2.04-3.13-3.13z"/></svg>
            </button>
            <button class="btn-skip" onclick="prevSong()" title="Previous">
                <svg viewBox="0 0 24 24"><path d="M6 6h2v12H6zm3.5 6l8.5 6V6z"/></svg>
            </button>
            <button class="btn-play" id="btnPlay" onclick="togglePlay()" title="Play">
                <svg id="iconPlay" viewBox="0 0 24 24"><path d="M8 5v14l11-7z"/></svg>
            </button>
            <button class="btn-skip" onclick="nextSong()" title="Next">
                <svg viewBox="0 0 24 24"><path d="M6 18l8.5-6L6 6v12zM16 6v12h2V6h-2z"/></svg>
            </button>
            <button class="btn-icon" id="btnRepeat" onclick="toggleRepeat()" title="Repeat">
                <svg viewBox="0 0 24 24"><path d="M7 7h10v3l4-4-4-4v3H5v6h2V7zm10 10H7v-3l-4 4 4 4v-3h12v-6h-2v6z"/></svg>
            </button>
        </div>
        <div class="progress-area">
            <span class="time-text" id="currTime">0:00</span>
            <input type="range" id="progressBar" value="0" min="0" step="1" oninput="seekAudio()">
            <span class="time-text" id="totalTime">0:00</span>
        </div>
    </div>

    <div class="volume-area">
        <div class="btn-icon" id="volIcon">
            <svg viewBox="0 0 24 24"><path d="M3 9v6h4l5 5V4L7 9H3zm13.5 3c0-1.77-1.02-3.29-2.5-4.03v8.05c1.48-.73 2.5-2.25 2.5-4.02zM14 3.23v2.06c2.89.86 5 3.54 5 6.71s-2.11 5.85-5 6.71v2.06c4.01-.91 7-4.49 7-8.77s-2.99-7.86-7-8.77z"/></svg>
        </div>
        <input type="range" class="volume-slider" id="volumeBar" min="0" max="1" step="0.05" value="1" oninput="setVolume()">
    </div>
</div>

<script> 
const storedUser = localStorage.getItem("user");

if (!storedUser) { 
    document.cookie = "jwtToken=; path=/; max-age=0";
    window.location.href = "/login";
}

    var user = JSON.parse(localStorage.getItem('user'));
    if(!user || !user.userId) window.location.href = "/login";

    var USER_ID = user.userId;
    var JWT_TOKEN = user.jwt || (document.cookie.match(/jwtToken=([^;]+)/) || [])[1];

    var urlParams = new URLSearchParams(window.location.search);
    var PLAYLIST_ID = urlParams.get('id');
    var PLAYLIST_API = "http://localhost:8081/api/playlists"; 
    var SONGS_API = "http://localhost:8082/api/songs/available";    

    var playlistSongsData = [];
    var originalPlaylistOrder = [];
    var repeatMode = false; 
    var currentIndex = -1;
    var audio = document.getElementById("mainAudio");
    var progressBar = document.getElementById("progressBar");
    var volumeBar = document.getElementById("volumeBar");
    var isPlaying = false;

    const SVG_PLAY = '<svg viewBox="0 0 24 24"><path d="M8 5v14l11-7z"/></svg>';
    const SVG_PAUSE = '<svg viewBox="0 0 24 24"><path d="M6 19h4V5H6v14zm8-14v14h4V5h-4z"/></svg>';
    function playSongAtIndex(index) {
        if (index < 0 || index >= playlistSongsData.length) return;

        if (index === currentIndex) {
            togglePlay(); 
            return;
        }

        currentIndex = index;
        var song = playlistSongsData[currentIndex];

        document.getElementById("pTitle").innerText = song.songName;
        document.getElementById("pArtist").innerText = song.singer;
        if (song.audioPath && song.audioPath.trim() !== "") {
            var streamUrl = song.audioPath;
            if (!streamUrl.startsWith("http")) {
                streamUrl = "http://localhost:8082" + (streamUrl.startsWith("/") ? streamUrl : "/" + streamUrl);
            }
            
            audio.src = streamUrl;
            audio.play().catch(e => console.error("Playback failed:", e));
            isPlaying = true;
        } else {
            audio.pause();
            audio.src = "";
            isPlaying = false;
        }
        updatePlayBtnUI();
    }

    function togglePlay() {
        if(currentIndex === -1) {
            if(playlistSongsData.length > 0) playSongAtIndex(0);
            return;
        }
        if (!audio.paused) {
            audio.pause();
            isPlaying = false;
        } else { 
            if(audio.src && audio.src !== "") { audio.play(); isPlaying = true; }
            else { playSongAtIndex(currentIndex); }
        }
        updatePlayBtnUI();
    }

    function updatePlayBtnUI() {
        var btn = document.getElementById("btnPlay");
        btn.innerHTML = !audio.paused ? SVG_PAUSE : SVG_PLAY;

        var listButtons = document.querySelectorAll(".list-play-btn");
        listButtons.forEach(b => b.innerHTML = SVG_PLAY);

        if(currentIndex !== -1) {
            var activeBtn = document.querySelector('.list-play-btn[data-index="'+currentIndex+'"]');
            if(activeBtn && !audio.paused) {
                activeBtn.innerHTML = SVG_PAUSE;
            }
        }
    }
    audio.onloadedmetadata = function() {
        progressBar.max = audio.duration;
        document.getElementById("totalTime").innerText = formatTime(audio.duration);
    };
    audio.ontimeupdate = function() {
        progressBar.value = audio.currentTime;
        document.getElementById("currTime").innerText = formatTime(audio.currentTime);
        var val = (audio.currentTime / audio.duration) * 100;
        progressBar.style.background = 'linear-gradient(to right, #1C1C1E 0%, #1C1C1E ' + val + '%, #E5E5EA ' + val + '%, #E5E5EA 100%)';
    };
    audio.onplay = function() { updatePlayBtnUI(); };
    audio.onpause = function() { updatePlayBtnUI(); };

    function seekAudio() { audio.currentTime = progressBar.value; }
    function setVolume() {
        audio.volume = volumeBar.value;
        var val = volumeBar.value * 100;
        volumeBar.style.background = 'linear-gradient(to right, #1C1C1E 0%, #1C1C1E ' + val + '%, #E5E5EA ' + val + '%, #E5E5EA 100%)';
    }
    function formatTime(s) {
        if(isNaN(s)) return "0:00";
        var min = Math.floor(s / 60);
        var sec = Math.floor(s % 60);
        return min + ":" + (sec < 10 ? "0" + sec : sec);
    }
    async function loadDetails() {
        try {
            var tbody = document.getElementById("songList");
            tbody.innerHTML = '<tr><td colspan="5" class="empty-state">Loading songs...</td></tr>';

            if(!PLAYLIST_ID) return;

            var plRes = await fetch(PLAYLIST_API + "/user/" + USER_ID, {
                method: 'GET',
                headers: { 'Authorization': 'Bearer ' + JWT_TOKEN, 'Content-Type': 'application/json' }
            });

            if (!plRes.ok) throw new Error("Playlists API returned " + plRes.status);
            var playlists = await plRes.json();

            var currentPl = playlists.find(p => String(p.playlistId) === String(PLAYLIST_ID));
            if (!currentPl) {
                document.getElementById("plName").innerText = "Not Found";
                tbody.innerHTML = '<tr><td colspan="5" class="empty-state">Playlist not found.</td></tr>';
                return;
            }

            document.getElementById("plName").innerText = currentPl.playlistName || "Playlist";
            var mySongIds = currentPl.songIds || [];
            document.getElementById("plCount").innerText = mySongIds.length;

            var songsRes = await fetch(SONGS_API);
            var allSongs = await songsRes.json();

            playlistSongsData = [];
            tbody.innerHTML = "";
            mySongIds.forEach(function(id) {
                var song = allSongs.find(s => String(s.libraryId) === String(id) || String(s.songId) === String(id));
                if (song) playlistSongsData.push(song);
            });

            if (playlistSongsData.length === 0) {
                tbody.innerHTML = '<tr><td colspan="5" class="empty-state">This playlist is empty.</td></tr>';
                originalPlaylistOrder = [];
                return;
            }

            originalPlaylistOrder = playlistSongsData.slice();

            playlistSongsData.forEach(function(song, idx) {
                tbody.innerHTML +=
                    '<tr class="song-row">' +
                        '<td onclick="playSongAtIndex(' + idx + ')" class="list-play-btn" data-index="' + idx + '">' + SVG_PLAY + '</td>' +
                        '<td class="s-name"><strong>' + (song.songName || "Untitled") + '</strong></td>' +
                        '<td class="s-artist">' + (song.singer || "") + '</td>' +
                        '<td class="s-album">' + (song.albumName || "") + '</td>' +
                        '<td><button onclick="removeSong(\'' + (song.libraryId || song.songId) + '\')" class="btn-remove">Remove</button></td>' +
                    '</tr>';
            });

        } catch (err) {
            console.error("loadDetails error:", err);
            document.getElementById("songList").innerHTML = '<tr><td colspan="5" class="empty-state">Failed to load songs.</td></tr>';
        }
    }

    function nextSong() {
        if (repeatMode) {
            if (currentIndex !== -1) { audio.currentTime = 0; audio.play(); }
            return;
        }
        var shuffleActive = document.getElementById("btnShuffle").classList.contains("active-ctrl");
        if (shuffleActive) {
            var nextIndex = Math.floor(Math.random() * playlistSongsData.length);
            playSongAtIndex(nextIndex);
            return;
        }
        if (currentIndex < playlistSongsData.length - 1) {
            playSongAtIndex(currentIndex + 1);
        } else {
            playSongAtIndex(0); 
        }
    }

    function prevSong() {
        if (currentIndex > 0) playSongAtIndex(currentIndex - 1);
        else playSongAtIndex(playlistSongsData.length - 1);
    }

    function toggleShuffle() {
        document.getElementById("btnShuffle").classList.toggle("active-ctrl");
    }

    function toggleRepeat() {
        repeatMode = !repeatMode;
        document.getElementById("btnRepeat").classList.toggle("active-ctrl", repeatMode);
    }

    function filterPlaylistSongs() {
        var input = document.getElementById("playlistSearch").value.toLowerCase();
        var rows = document.getElementsByClassName("song-row");
        for (var i = 0; i < rows.length; i++) {
            var text = rows[i].innerText.toLowerCase();
            rows[i].style.display = text.includes(input) ? "" : "none";
        }
    }

    async function renamePlaylist() {
        var newName = prompt("Rename Playlist:", document.getElementById("plName").innerText);
        if (!newName) return;
        await fetch(PLAYLIST_API + "/" + PLAYLIST_ID + "?name=" + encodeURIComponent(newName), {
            method: 'PUT', headers: { 'Authorization': 'Bearer ' + JWT_TOKEN }
        });
        document.getElementById("plName").innerText = newName;
    }

    async function deletePlaylist() {
        if(!confirm("Delete this playlist?")) return;
        await fetch(PLAYLIST_API + "/" + PLAYLIST_ID, { 
            method: 'DELETE', headers: { 'Authorization': 'Bearer ' + JWT_TOKEN }
        });
        window.location.href = "/user/playlists";
    }

    async function removeSong(songId) {
        if(!confirm("Remove song?")) return;
        await fetch(PLAYLIST_API + "/" + PLAYLIST_ID + "/remove/" + songId, { 
            method: 'DELETE', headers: { 'Authorization': 'Bearer ' + JWT_TOKEN }
        });
        loadDetails();
    }
    loadDetails();
</script>
</body>
</html>