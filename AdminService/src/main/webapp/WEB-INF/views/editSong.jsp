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

body{
    background:var(--bg);
    color:var(--text-primary);
    min-height:100vh;
    display:flex;
    flex-direction:column;
}

.page-wrapper {
    flex: 1;
    display: flex;
    justify-content: center;
    padding: 40px 20px;
}

footer {
    text-align:center;
    padding:20px 0;
    font-size:14px;
    color:#86868b;
    margin-top:auto;
    background: transparent;
}

.container{
    width:100%;
    max-width:1000px;
    background:var(--surface);
    padding:45px;
    border-radius:22px;
    border:1px solid var(--border);
    box-shadow:0 15px 35px rgba(0,0,0,.08);
}

.edit-layout{
    display:grid;
    grid-template-columns:340px 1fr;
    gap:40px;
    align-items:start;
}
.left-panel{
    background:white;
    border-radius:20px;
    padding:25px;
    border:1px solid #E5E5EA;
    box-shadow:0 8px 20px rgba(0,0,0,.05);
    position:sticky;
    top:30px;
}

.right-panel{
    background:white;
    border-radius:20px;
    padding:25px;
    border:1px solid #E5E5EA;
    box-shadow:0 8px 20px rgba(0,0,0,.05);
}

h2 { 
    text-align: center; 
    color: var(--accent); 
    margin-bottom: 25px; 
}

.form-group { margin-bottom: 15px; }

label { 
    display: block; 
    font-weight: 600; 
    margin-bottom: 5px; 
    color: var(--text); 
}

input,
select{

width:100%;
padding:14px;
border-radius:14px;
border:1.5px solid #E5E5EA;
transition:.25s;
font-size:15px;

}

input:focus,
select:focus{

outline:none;
border-color:#FF2D55;
box-shadow:0 0 0 4px rgba(255,45,85,.1);

}

.btn { 
    width: 100%; 
    padding: 14px; 
    background: var(--accent); 
    color: white; 
    border: none; 
    border-radius: 12px; 
    font-weight: 700; 
    cursor: pointer; 
    margin-top: 10px; 
}


.btn:hover{
    transform:translateY(-2px);
    box-shadow:0 8px 20px rgba(255,45,85,.25);
}

.btn-cancel{
    background:#E5E5EA;
    color:#1D1D1F;
}
.upload-box{
    width:100%;
    border:2px dashed #D1D1D6;
    border-radius:18px;
    padding:28px;
    text-align:center;
    cursor:pointer;
    transition:.3s;
    background:#FAFAFA;
    position:relative;
}

.upload-box:hover{
    border-color:#FF2D55;
    background:#FFF5F8;
}

.upload-box.dragover{
    border-color:#FF2D55;
    background:#FFEAF0;
}

.upload-box i{
    font-size:42px;
    display:block;
    margin-bottom:12px;
}

.upload-title{
    font-size:17px;
    font-weight:700;
}

.upload-subtitle{
    color:#777;
    font-size:13px;
    margin-top:8px;
}

.upload-name{
    margin-top:12px;
    color:#FF2D55;
    font-weight:700;
}

.hidden-input{
    display:none;
}

.btn-cancel:hover{
    background:#D1D1D6;
}
</style>
</head>

<body>

<div class="page-wrapper">

<div class="container">
    <h2>✏️ Edit Song Details</h2>

   <form action="/admin/songs/update"
      method="post"
      enctype="multipart/form-data"
      modelAttribute="song">

    <input type="hidden" name="libraryId" value="${song.libraryId}">

    <div class="edit-layout">

        <!-- LEFT PANEL -->
        <div class="left-panel">

            <div class="form-group">

                <label>Current Cover</label>

                <div style="text-align:center;margin-bottom:20px;">

                    <img id="imagePreview"
                         src="http://192.168.1.52:8082${song.imagePath}"
                         style="width:260px;height:260px;object-fit:cover;
                                border-radius:18px;
                                border:2px solid #E5E5EA;
                                box-shadow:0 10px 25px rgba(0,0,0,.08);">

                </div>

            </div>

            <div class="form-group">

                <label>Replace Cover Image</label>

                <label class="upload-box" id="imageBox">

                    <input
                        class="hidden-input"
                        type="file"
                        id="imageFile"
                        name="imageFile"
                        accept="image/*">

                    <div style="font-size:45px;">🖼️</div>

                    <div class="upload-title">
                        Drag Image Here
                    </div>

                    <div class="upload-subtitle">
                        or Click to Browse
                    </div>

                    <div id="imageFileName" class="upload-name"></div>

                </label>

            </div>

            <div class="form-group">

                <label>Current Audio</label>

                <div id="audioName"
                     style="
                     display:flex;
                     gap:12px;
                     align-items:center;
                     background:#F8F9FC;
                     border:1px solid #E5E5EA;
                     border-radius:16px;
                     padding:15px;
                     ">

                    <div style="
                        width:48px;
                        height:48px;
                        border-radius:12px;
                        background:#FF2D55;
                        color:white;
                        display:flex;
                        justify-content:center;
                        align-items:center;
                        font-size:24px;">
                        🎵
                    </div>

                    <div>

                        <div style="font-weight:700;">
                            ${song.songName}
                        </div>

                        <div id="audioFileText"
                             style="font-size:13px;color:#86868B;">

                            ${song.audioPath.substring(song.audioPath.lastIndexOf('/')+1)}

                        </div>

                    </div>

                </div>

            </div>

            <div class="form-group">

                <label>Replace Audio</label>

                <label class="upload-box" id="audioBox">

                    <input
                        class="hidden-input"
                        type="file"
                        id="audioFile"
                        name="file"
                        accept=".mp3,.wav">

                    <div style="font-size:45px;">🎵</div>

                    <div class="upload-title">
                        Drag Audio Here
                    </div>

                    <div class="upload-subtitle">
                        or Click to Browse
                    </div>

                    <div id="audioFileName" class="upload-name"></div>

                </label>

            </div>

        </div>

        <!-- RIGHT PANEL -->
        <div class="right-panel">

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

            <button type="submit" class="btn">
                ✔ Update Song
            </button>

            <a href="/admin/songs"
               class="btn btn-cancel"
               style="display:block;text-align:center;text-decoration:none;">
                ← Cancel
            </a>

        </div>

    </div>

</form>
</div>

</div>

<footer>
    © 2025 Music Library Application. All rights reserved.
</footer>
<script>

const imageInput=document.getElementById("imageFile");
const audioInput=document.getElementById("audioFile");

imageInput.onchange=function(){

if(!this.files.length)return;

document.getElementById("imageFileName").innerHTML="✔ "+this.files[0].name;

const reader=new FileReader();

reader.onload=function(e){

document.getElementById("imagePreview").src=e.target.result;

}

reader.readAsDataURL(this.files[0]);

}

audioInput.onchange=function(){

if(!this.files.length)return;

document.getElementById("audioFileText").innerHTML =
	this.files[0].name;

document.getElementById("audioFileName").innerHTML="✔ "+this.files[0].name;

}

function enableDrag(boxId,inputId){

const box=document.getElementById(boxId);

const input=document.getElementById(inputId);

box.addEventListener("dragover",function(e){

e.preventDefault();

box.classList.add("dragover");

});

box.addEventListener("dragleave",function(){

box.classList.remove("dragover");

});

box.addEventListener("drop",function(e){

e.preventDefault();

box.classList.remove("dragover");

input.files=e.dataTransfer.files;

input.dispatchEvent(new Event("change"));

});

}

enableDrag("imageBox","imageFile");

enableDrag("audioBox","audioFile");

</script>
</body>
</html>
