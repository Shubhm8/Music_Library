CREATE DATABASE IF NOT EXISTS Music_Library;
USE Music_Library;

CREATE TABLE IF NOT EXISTS admin (
    admin_id INT PRIMARY KEY AUTO_INCREMENT,
    admin_name VARCHAR(100) NOT NULL,
    user_name VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(254) UNIQUE NOT NULL,
    mobile_no VARCHAR(15),
    admin_status VARCHAR(20) DEFAULT 'YES',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    user_name VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(254) UNIQUE NOT NULL,
    mobile VARCHAR(30),
    address1 VARCHAR(255),
    address2 VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    zip_code VARCHAR(20),
    country VARCHAR(100),
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS songs_library (
    library_id INT PRIMARY KEY AUTO_INCREMENT,
    song_id VARCHAR(100) UNIQUE NOT NULL,
    song_name VARCHAR(200) NOT NULL,
    music_director VARCHAR(100),
    singer VARCHAR(100),
    release_date DATE,
    album_name VARCHAR(200),
    audio_path VARCHAR(500),
    image_path VARCHAR(500),
    song_type VARCHAR(20) DEFAULT 'FREE',
    song_status VARCHAR(20) DEFAULT 'AVAILABLE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_song_type CHECK (song_type IN ('FREE', 'PREMIUM')),
    CONSTRAINT chk_song_status CHECK (song_status IN ('AVAILABLE', 'NOTAVAILABLE'))
);

CREATE TABLE IF NOT EXISTS playlists (
    playlist_id INT PRIMARY KEY AUTO_INCREMENT,
    playlist_name VARCHAR(100) NOT NULL,
    user_id INT NOT NULL,
    CONSTRAINT fk_playlist_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS playlist_songs (
    playlist_id INT NOT NULL,
    song_id VARCHAR(100) NOT NULL,
    CONSTRAINT fk_playlist_songs_playlist FOREIGN KEY (playlist_id) REFERENCES playlists(playlist_id) ON DELETE CASCADE
);
