<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View All Songs</title>

<style>
:root {
    --bg:#FAFAFA; --surface:#FFFFFF; --surface-muted:#F2F2F7;
    --text-primary:#1C1C1E; --text-secondary:#3A3A3C;
    --accent:#FF2D55; --accent-hover:#e0244a;
    --border:#E5E5EA; --shadow:0 4px 14px rgba(0,0,0,0.08);
    --radius:16px;
}
 
*{margin:0;padding:0;box-sizing:border-box;font-family:-apple-system,Inter,sans-serif;}
body{background:var(--bg);color:var(--text-primary);min-height:100vh;padding-bottom:40px;}

.navbar{
    height:64px;background:var(--surface);padding:0 26px;
    display:flex;align-items:center;justify-content:space-between;
    border-bottom:1px solid var(--border);box-shadow:var(--shadow);
}
.navbar h2{font-size:22px;font-weight:700;}

.back-btn{
    margin-left:14px;background:var(--accent);color:white;
    padding:10px 18px;border-radius:12px;text-decoration:none;
    font-weight:600;transition:.18s;
}
.back-btn:hover{background:var(--accent-hover);}

.container{max-width:1300px;margin:30px auto;padding:0 20px;}

.header-section{
    background:var(--surface);border:1px solid var(--border);
    border-radius:var(--radius);padding:26px;box-shadow:var(--shadow);
    display:flex;justify-content:space-between;flex-wrap:wrap;
    margin-bottom:24px;
}
h1{font-size:32px;font-weight:800;}

.stats{display:flex;gap:16px;}
.stat-box{
    background:var(--surface-muted);border:1px solid var(--border);
    padding:16px 26px;border-radius:var(--radius);text-align:center;
}
.number{font-size:26px;font-weight:700;}
.label{font-size:12px;color:var(--text-secondary);}

.filter-section{
    background:var(--surface);border:1px solid var(--border);
    border-radius:var(--radius);padding:24px;box-shadow:var(--shadow);
    margin-bottom:22px;
}
.filter-buttons{display:flex;gap:10px;flex-wrap:wrap;}
.filter-btn{
    padding:10px 20px;border-radius:25px;border:2px solid var(--accent);
    font-weight:600;color:var(--accent);background:transparent;
    cursor:pointer;transition:.2s;
}
.filter-btn.active,.filter-btn:hover{background:var(--accent);color:white;}

.search-box{margin-top:14px;}
.search-box input{
    width:100%;padding:12px 18px;border-radius:14px;
    border:1.8px solid var(--border);background:var(--surface-muted);
}
.search-box input:focus{border-color:var(--accent);outline:none;}

.songs-grid{
    display:grid; grid-template-columns:repeat(auto-fill,minmax(300px,1fr));
    gap:20px;
    align-items: stretch; 
}

.song-card{
    background:var(--surface);border:1px solid var(--border);
    border-radius:var(--radius);padding:20px;box-shadow:var(--shadow);
    cursor:pointer;transition:.15s;
    display: flex;
    flex-direction: column;
    height: 100%;
}
.song-card:hover{transform:translateY(-3px);}

.song-title{font-size:20px;font-weight:700; margin-bottom: 5px;}
.song-artist{color:var(--text-secondary);font-size:14px; margin-bottom: 10px;}

.song-details{
    padding-top:12px; border-top:1px solid var(--border);
    margin-bottom: 15px;
}
.detail-row{display:flex;justify-content:space-between;padding:4px 0;}
.detail-label{color:var(--text-secondary);font-size:13px;}
.detail-value{font-weight:600; font-size:14px;}

.card-footer {
    margin-top: auto; 
}

.badge{
    padding:6px 14px;border-radius:20px;font-size:11px;
    font-weight:700;margin-top:10px;display:inline-block; margin-right: 5px;
}
.badge-free{background:#10b981;color:white;}
.badge-premium{background:#f59e0b;color:white;}
.badge-available{background:#0ea5e9;color:white;}
.badge-not-available{background:#dc2626;color:white;}

.delete-btn {
    display: block; width: 100%; text-align: center; margin-top: 10px;
    padding: 8px; border-radius: 8px; background: #fee2e2; color: #dc2626;
    text-decoration: none; font-weight: 600; font-size: 13px;
    transition: 0.2s;
}
.delete-btn:hover { background: #dc2626; color: white; }

.edit-btn {
    display: block; width: 100%; text-align: center; margin-top: 15px;
    padding: 8px; border-radius: 8px; background: #E5E5EA; color: #1D1D1F;
    text-decoration: none; font-weight: 600; font-size: 13px;
    transition: 0.2s;
}
.edit-btn:hover { background: #d1d1d6; }

.no-songs{
    text-align: center; grid-column: 1 / -1; padding: 40px; color: var(--text-secondary);
}
</style>
</head>

<body>

<div class="navbar">
    <h2>🎵 Music Library — All Songs</h2>
    <div>
        <a href="/admin/add-song" class="back-btn">+ Add Song</a>
        <a href="/admin/dashboard" class="back-btn">Dashboard</a>
    </div>
</div>   

<div class="container">
    <div class="header-section">
        <h1>Discover Music</h1>
        <div class="stats">
            <div class="stat-box">
                <div class="number" id="totalCount">${fn:length(songs)}</div>
                <div class="label">Total Songs</div>
            </div>
            <div class="stat-box">
                <div class="number" id="freeCount">0</div>
                <div class="label">Free Songs</div>
            </div>
        </div>
    </div>

    <div class="filter-section">
        <div class="filter-buttons">
            <button class="filter-btn active" onclick="filterSongs('all', this)">All</button>
            <button class="filter-btn" onclick="filterSongs('AVAILABLE', this)">Available</button>
            <button class="filter-btn" onclick="filterSongs('FREE', this)">Free</button>
            <button class="filter-btn" onclick="filterSongs('PREMIUM', this)">Premium</button>
        </div>

        <div class="search-box">
            <input id="searchInput" type="text" placeholder="Search by song name, artist, or album..." onkeyup="searchSongs()" />
        </div>
    </div>

    <div class="songs-grid" id="songsGrid">
        
        <c:forEach var="song" items="${songs}">
            <div class="song-card" 
                 data-type="${song.songType}" 
                 data-status="${song.songStatus}"
                 data-search="${song.songName.toLowerCase()} ${song.singer.toLowerCase()} ${song.albumName.toLowerCase()}">
                
                <div class="song-title">${song.songName}</div>
                <div class="song-artist">${song.singer}</div>
                
                <div class="song-details">
                    <div class="detail-row">
                        <span class="detail-label">Album</span>
                        <span class="detail-value">${song.albumName}</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Director</span>
                        <span class="detail-value">${song.musicDirector}</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Released</span>
                        <span class="detail-value">${song.releaseDate}</span>
                    </div>
                </div>

                <div class="card-footer">
                    <span class="badge ${song.songType == 'FREE' ? 'badge-free' : 'badge-premium'}">
                        ${song.songType}
                    </span>
                    <span class="badge ${song.songStatus == 'AVAILABLE' ? 'badge-available' : 'badge-not-available'}">
                        ${song.songStatus}
                    </span>

                    <a href="/admin/songs/edit?id=${song.libraryId}" class="edit-btn">
                        ✏️ Edit Details
                    </a>

                    <a href="/admin/songs/delete?id=${song.libraryId}" class="delete-btn" onclick="return confirm('Are you sure you want to delete this song?')">
                        Delete Song
                    </a>
                </div>
            </div>
        </c:forEach>

        <c:if test="${empty songs}">
            <div class="no-songs">No songs found in the database.</div>
        </c:if>

    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const cards = document.querySelectorAll('.song-card');
        let freeCount = 0;
        cards.forEach(card => {
            if(card.getAttribute('data-type') === 'FREE') freeCount++;
        });
        document.getElementById('freeCount').textContent = freeCount;
    });

    function filterSongs(filterType, btn) {
        document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
        if(btn) btn.classList.add('active');

        const cards = document.querySelectorAll('.song-card');
        cards.forEach(card => {
            const type = card.getAttribute('data-type');
            const status = card.getAttribute('data-status');
            if (filterType === 'all') {
                card.style.display = 'flex'; 
            } else if (filterType === 'FREE' || filterType === 'PREMIUM') {
                card.style.display = (type === filterType) ? 'flex' : 'none';
            } else if (filterType === 'AVAILABLE') {
                card.style.display = (status === 'AVAILABLE') ? 'flex' : 'none';
            }
        });
    }
    function searchSongs() {
        const input = document.getElementById('searchInput').value.toLowerCase();
        const cards = document.querySelectorAll('.song-card');
        cards.forEach(card => {
            const searchData = card.getAttribute('data-search');
            if (searchData.includes(input)) {
                card.style.display = 'flex'; 
            } else {
                card.style.display = 'none';
            }
        });
    }
</script>
</body>
</html>