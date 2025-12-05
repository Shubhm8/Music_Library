<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add New Song</title>

<style>
:root { 
    --bg: #F5F5F7; 
    --surface: #FFFFFF; 
    --text: #1D1D1F; 
    --secondary: #86868b;
    --accent: #FF2D55; 
    --border: #E5E5EA; 
    --radius: 18px; 
}

* { margin: 0; padding: 0; box-sizing: border-box; font-family: -apple-system, Inter, sans-serif; }

body { 
    background: var(--bg); 
    min-height: 100vh; 
    display: flex; 
    justify-content: center; 
    padding: 40px; 
}

.container { 
    width: 100%; 
    max-width: 650px; 
    background: var(--surface); 
    padding: 40px; 
    border-radius: var(--radius); 
    border: 1px solid var(--border); 
    box-shadow: 0 10px 30px rgba(0,0,0,0.08); 
}

h2 { 
    text-align: center; 
    color: var(--accent); 
    margin-bottom: 30px; 
    font-size: 28px; 
    font-weight: 800;
}

.form-group { margin-bottom: 20px; }

label { 
    display: block; 
    font-weight: 600; 
    margin-bottom: 8px; 
    color: var(--text); 
    font-size: 14px;
}

input[type="text"], 
input[type="number"],
input[type="date"], 
select { 
    width: 100%; 
    padding: 14px; 
    border-radius: 12px; 
    border: 1.5px solid var(--border); 
    font-size: 15px; 
    background: #FAFAFC;
    transition: 0.2s;
    font-family: inherit;
}

/* Remove Number Arrows */
input[type=number]::-webkit-inner-spin-button, 
input[type=number]::-webkit-outer-spin-button { 
  -webkit-appearance: none; 
  margin: 0; 
}

input:focus, select:focus { 
    outline: none; 
    border-color: var(--accent); 
    background: #FFF;
}

/* Modern File Upload Styling */
.file-upload-wrapper {
    position: relative;
    height: 120px;
    border: 2px dashed #D1D1D6;
    border-radius: 12px;
    background: #FAFAFC;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    text-align: center;
    transition: all 0.2s ease;
    overflow: hidden;
}

.file-upload-wrapper:hover {
    border-color: var(--accent);
    background: #FFF0F3; 
}

/* Active state when file is selected */
.file-upload-wrapper.has-file {
    border-style: solid;
    border-color: #34C759; /* Green border */
    background: #f0fdf4;
}

.file-upload-wrapper input[type="file"] {
    position: absolute;
    width: 100%;
    height: 100%;
    top: 0;
    left: 0;
    opacity: 0;
    cursor: pointer;
    z-index: 10;
}

.upload-icon { font-size: 28px; margin-bottom: 8px; display: block; }
.upload-text { font-size: 13px; color: var(--secondary); font-weight: 500; padding: 0 10px; }

.btn { 
    width: 100%; 
    padding: 16px; 
    background: var(--accent); 
    color: white; 
    border: none; 
    border-radius: 12px; 
    font-weight: 700; 
    font-size: 16px;
    cursor: pointer; 
    margin-top: 15px; 
    transition: 0.2s;
}
.btn:hover { background: #e0244a; transform: translateY(-2px); }

.btn-cancel { 
    display: block; 
    text-align: center; 
    background: #E5E5EA; 
    color: #1D1D1F; 
    text-decoration: none; 
    margin-top: 12px; 
}
.btn-cancel:hover { background: #d1d1d6; }

.error-msg {
    background: #ffe5ea;
    color: #c00026;
    padding: 15px;
    border-radius: 12px;
    margin-bottom: 25px;
    text-align: center;
    font-weight: 600;
    font-size: 14px;
    border: 1px solid #ffccd4;
}
</style>
</head>
<body>

<div class="container">
    <h2>📝 Add New Song</h2>

    <c:if test="${not empty errorMessage}">
        <div class="error-msg">${errorMessage}</div>
    </c:if>

    <form action="/admin/songs/add" method="post" enctype="multipart/form-data">
        
        <div class="form-group">
            <label>Song ID <span style="color:red">*</span></label>
            <input type="number" name="songId" placeholder="Enter Unique ID (e.g., 101)" required>
        </div>

        <div class="form-group">
            <label>Song Name <span style="color:red">*</span></label>
            <input type="text" name="songName" placeholder="e.g. Blinding Lights" required>
        </div>

        <div class="form-group">
            <label>Singer <span style="color:red">*</span></label>
            <input type="text" name="singer" placeholder="e.g. The Weeknd" required>
        </div>

        <div class="form-group">
            <label>Album Name</label>
            <input type="text" name="albumName" placeholder="e.g. After Hours">
        </div>

        <div class="form-group">
            <label>Music Director</label>
            <input type="text" name="musicDirector" placeholder="e.g. Max Martin">
        </div>

        <div class="form-group">
            <label>Release Date</label>
            <input type="date" name="releaseDate" max="9999-12-31">
        </div>

        <div class="form-group">
            <label>Song Type</label>
            <select name="songType">
                <option value="FREE">FREE (Accessible to all)</option>
                <option value="PREMIUM">PREMIUM (Paid users only)</option>
            </select>
        </div>

        <div class="form-group">
            <label>Song Status</label>
            <select name="songStatus">
                <option value="AVAILABLE">AVAILABLE</option>
                <option value="NOTAVAILABLE">NOT AVAILABLE</option>
            </select>
        </div>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
            <div class="form-group">
                <label>Audio File (MP3/WAV) <span style="color:red">*</span></label>
                <div class="file-upload-wrapper" id="audioBox">
                    <input type="file" name="file" accept=".mp3, .wav" required onchange="updateFileName(this, 'audioText', 'audioBox')">
                    <span class="upload-icon">🎵</span>
                    <span class="upload-text" id="audioText">Click to Upload Audio</span>
                </div>
            </div>

            <div class="form-group">
                <label>Cover Image (JPG/PNG)</label>
                <div class="file-upload-wrapper" id="imgBox">
                    <input type="file" name="imageFile" accept="image/*" onchange="updateFileName(this, 'imgText', 'imgBox')">
                    <span class="upload-icon">🖼️</span>
                    <span class="upload-text" id="imgText">Click to Upload Cover</span>
                </div>
            </div>
        </div>

        <button type="submit" class="btn">Upload Song</button>
        <a href="/admin/songs" class="btn btn-cancel">Cancel</a>
    </form>
</div>

<script>
    function updateFileName(input, textId, boxId) {
        var fileName = input.files[0] ? input.files[0].name : "Click to Upload";
        
        // Update the text inside the box
        document.getElementById(textId).innerText = fileName;
        
        // Add a visual class to show it's done (green border)
        var box = document.getElementById(boxId);
        if (input.files.length > 0) {
            box.classList.add("has-file");
        } else {
            box.classList.remove("has-file");
        }
    }
</script>

</body>
</html>