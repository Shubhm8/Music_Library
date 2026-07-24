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

.error-msg{
    background:#ffe8ec;
    border:1px solid #ffc8d3;
    color:#c50030;
    padding:16px;
    border-radius:14px;
    margin-bottom:20px;
    font-weight:700;
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

.image-preview-box{
    width:260px;
    height:260px;
    margin:0 auto 20px auto;
    border-radius:18px;
    border:2px dashed #E5E5EA;
    background:#FAFAFA;
    display:flex;
    align-items:center;
    justify-content:center;
    overflow:hidden;
    color:#86868B;
    text-align:center;
    font-size:14px;
}

.image-preview-box img{
    width:100%;
    height:100%;
    object-fit:cover;
}
</style>
</head>

<body>

<div class="page-wrapper">

<div class="container">
    <h2>🎵 Add New Song</h2>

    <c:if test="${not empty errorMessage}">
        <div class="error-msg">${errorMessage}</div>
    </c:if>

   <form action="/admin/songs/add"
      method="post"
      enctype="multipart/form-data">

    <div class="edit-layout">

        <!-- LEFT PANEL -->
        <div class="left-panel">

            <div class="form-group">

                <label>Cover Preview</label>

                <div class="image-preview-box" id="imagePreviewBox">
                    <div id="imagePreviewPlaceholder">No Cover Selected</div>
                    <img id="imagePreview" style="display:none;">
                </div>

            </div>

            <div class="form-group">

                <label>Cover Image</label>

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

                <label>Audio File</label>

                <label class="upload-box" id="audioBox">

                    <input
                        class="hidden-input"
                        type="file"
                        id="audioFile"
                        name="file"
                        accept=".mp3,.wav"
                        required>

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
                <input type="text" name="songName" placeholder="Enter Song Name" required>
            </div>

            <div class="form-group">
                <label>Singer</label>
                <input type="text" name="singer" placeholder="Singer Name" required>
            </div>

            <div class="form-group">
                <label>Album Name</label>
                <input type="text" name="albumName" placeholder="Album Name">
            </div>

            <div class="form-group">
                <label>Music Director</label>
                <input type="text" name="musicDirector" placeholder="Music Director">
            </div>

            <div class="form-group">
                <label>Release Date</label>
                <input type="date" name="releaseDate" max="9999-12-31">
            </div>

            <div class="form-group">
                <label>Song ID</label>
                <input type="number" name="songId" placeholder="101" required>
            </div>

            <div class="form-group">
                <label>Song Type</label>
                <select name="songType">
                    <option value="FREE">FREE</option>
                    <option value="PREMIUM">PREMIUM</option>
                </select>
            </div>

            <div class="form-group">
                <label>Status</label>
                <select name="songStatus">
                    <option value="AVAILABLE">AVAILABLE</option>
                    <option value="NOTAVAILABLE">NOT AVAILABLE</option>
                </select>
            </div>

            <button type="submit" class="btn">
                🎵 Upload Song
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

document.getElementById("imagePreviewPlaceholder").style.display="none";

const img=document.getElementById("imagePreview");

img.src=e.target.result;

img.style.display="block";

}

reader.readAsDataURL(this.files[0]);

}

audioInput.onchange=function(){

if(!this.files.length)return;

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
