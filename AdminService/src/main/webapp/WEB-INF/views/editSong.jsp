<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Song</title>
<style>

:root { 
    --bg: #F5F5F7; 
    --surface: #FFFFFF; 
    --text: #1D1D1F; 
    --accent: #FF2D55; 
    --border: #E5E5EA; 
    --radius: 18px; 
}

* { margin: 0; padding: 0; box-sizing: border-box; font-family: -apple-system, Inter, sans-serif; }
body { background: var(--bg); min-height: 100vh; display: flex; justify-content: center; padding: 40px; }

.container { 
    width: 100%; max-width: 600px; background: var(--surface); 
    padding: 40px; border-radius: var(--radius); 
    border: 1px solid var(--border); box-shadow: 0 10px 30px rgba(0,0,0,0.1); 
}

h2 { text-align: center; color: var(--accent); margin-bottom: 25px; }
.form-group { margin-bottom: 15px; }
label { display: block; font-weight: 600; margin-bottom: 5px; color: var(--text); }
input, select { width: 100%; padding: 12px; border-radius: 12px; border: 1.5px solid var(--border); font-size: 15px; }

.btn { 
    width: 100%; padding: 14px; background: var(--accent); 
    color: white; border: none; border-radius: 12px; 
    font-weight: 700; cursor: pointer; margin-top: 10px; 
}
.btn-cancel { background: #E5E5EA; color: #1D1D1F; margin-top: 10px; }
</style>
</head>
<body>

<div class="container">
    <h2>✏️ Edit Song Details</h2>

    <form action="/admin/songs/update" method="post" enctype="multipart/form-data" modelAttribute="song" style="max-width:600px; margin:auto;">
        
        <input type="hidden" name="libraryId" value="${song.libraryId}">

        <div class="form-group">
            <label>Song Name</label>
            <input type="text" name="songName" value="${song.songName}" required>
        </div>

        <div class="form-group">
            <label>Singer</label>
            <input type="text" name="singer" value="${song.singer}" required>
        </div>

        <div class="form-group">
            <label>Album Name</label>
            <input type="text" name="albumName" value="${song.albumName}">
        </div>

        <div class="form-group">
            <label>Music Director</label>
            <input type="text" name="musicDirector" value="${song.musicDirector}">
        </div>

        <div class="form-group">
            <label>Release Date</label>
            <input type="date" name="releaseDate" value="${song.releaseDate}">
        </div>

        <div class="form-group">
            <label>Song Type</label>
            <select name="songType">
                <option value="FREE" ${song.songType == 'FREE' ? 'selected' : ''}>FREE</option>
                <option value="PREMIUM" ${song.songType == 'PREMIUM' ? 'selected' : ''}>PREMIUM</option>
            </select>
        </div>

        <div class="form-group">
            <label>Song Status</label>
            <select name="songStatus">
                <option value="AVAILABLE" ${song.songStatus == 'AVAILABLE' ? 'selected' : ''}>AVAILABLE</option>
                <option value="NOTAVAILABLE" ${song.songStatus == 'NOTAVAILABLE' ? 'selected' : ''}>NOT AVAILABLE</option>
            </select>
        </div>

        <div class="form-group">
            <label>Update Cover Image</label>
            <p style="font-size:12px;">Current: ${song.imagePath != null ? 'Image Uploaded' : 'No Image'}</p>
            <input type="file" name="imageFile" accept="image/*" class="form-control" />
        </div>

        <div style="margin-bottom: 15px;">
            <label style="font-weight:600; display:block; margin-bottom:5px;">Update Audio File (Optional)</label>
            <p style="font-size:12px; color:#666; margin-bottom:5px;">Current: ${song.audioPath != null ? song.audioPath : 'No file uploaded'}</p>
            <input type="file" name="file" accept=".mp3, .wav" style="width:100%; padding:10px; border:1px solid #ccc; border-radius:8px;" />
        </div>

        <button type="submit" class="btn">Update Song</button>
        <a href="/admin/songs" class="btn btn-cancel" style="display:block; text-align:center; text-decoration:none;">Cancel</a>
    </form>
</div>
</body>
</html>