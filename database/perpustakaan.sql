-- 1. BUAT DATABASE
CREATE DATABASE IF NOT EXISTS perpustakaan DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE perpustakaan;

-- 2. TABEL BUKU
CREATE TABLE IF NOT EXISTS buku (
    id_buku INT AUTO_INCREMENT PRIMARY KEY,
    judul VARCHAR(150),
    pengarang VARCHAR(100),
    kategori VARCHAR(50),
    tahun_terbit YEAR,
    cover VARCHAR(255),
    tanggal_input DATETIME DEFAULT CURRENT_TIMESTAMP,
    stok INT DEFAULT 0
);

-- 3. TABEL ADMIN
CREATE TABLE IF NOT EXISTS admin (
    id_admin INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100),
    tanggal_daftar DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 4. TABEL ANGGOTA (PENTING: INI SUDAH DIPERBAIKI)
CREATE TABLE IF NOT EXISTS anggota (
    id_anggota INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL, -- Email harus unik
    
    -- Kolom yang dibutuhkan untuk login/register
    password VARCHAR(255) NOT NULL, 
    telepon VARCHAR(20),
    alamat TEXT,
    
    kategori ENUM('Mahasiswa','Dosen','Umum'),
    nomor_anggota VARCHAR(20) UNIQUE,
    tanggal_daftar DATE DEFAULT (CURRENT_DATE),
    status ENUM('Aktif','Nonaktif') DEFAULT 'Aktif'
);

-- 5. TABEL PEMINJAMAN
CREATE TABLE IF NOT EXISTS peminjaman (
    id_pinjam INT AUTO_INCREMENT PRIMARY KEY,
    id_anggota INT,
    id_buku INT,
    tanggal_pinjam DATE DEFAULT (CURRENT_DATE),
    tanggal_kembali DATE,
    status ENUM('Dipinjam','Dikembalikan') DEFAULT 'Dipinjam',
    FOREIGN KEY (id_anggota) REFERENCES anggota(id_anggota) ON DELETE SET NULL,
    FOREIGN KEY (id_buku) REFERENCES buku(id_buku) ON DELETE SET NULL
);

-- 6. TABEL DENDA
CREATE TABLE IF NOT EXISTS denda (
    id_denda INT AUTO_INCREMENT PRIMARY KEY,
    id_pinjam INT,
    jumlah DECIMAL(10,2),
    keterangan VARCHAR(255),
    tanggal_bayar DATE,
    FOREIGN KEY (id_pinjam) REFERENCES peminjaman(id_pinjam) ON DELETE SET NULL
);


-- ==============================
-- ISI DATA (SEEDING)
-- ==============================

-- Isi Data Buku
INSERT INTO buku (judul, pengarang, kategori, tahun_terbit, cover, stok)
VALUES 
    ('Filsafat Islam Kontemporer', 'A. Khudori Soleh', 'Agama', 2020, 'buku1.jpg', 5),
    ('Algoritma dan Pemrograman', 'Rinaldi Munir', 'Teknologi', 2022, 'buku2.jpg', 3),
    ('Psikologi Pendidikan', 'Slameto', 'Pendidikan', 2018, 'buku3.jpg', 4),
    ('Manajemen Waktu Efektif', 'Stephen Covey', 'Umum', 2019, 'buku4.jpg', 2),
    ('Belajar Machine Learning', 'Andrew Ng', 'Teknologi', 2023, 'buku5.jpg', 6),
    ('Dasar-Dasar Akuntansi', 'Warren & Reeve', 'Ekonomi', 2021, 'buku6.jpg', 7),
    ('Statistika Terapan untuk Riset', 'Sugiyono', 'Pendidikan', 2021, 'buku7.jpg', 5),
    ('Ekonomi Mikro Modern', 'Sadono Sukirno', 'Ekonomi', 2019, 'buku8.jpg', 4),
    ('Dasar-Dasar Jaringan Komputer', 'Andrew Tanenbaum', 'Teknologi', 2020, 'buku9.jpg', 3);

-- Isi Data Admin
-- Passwordnya adalah 'admin123' (tapi sudah di-hash)
INSERT INTO admin (nama, username, password, email)
VALUES 
('Administrator', 'admin', '$2y$10$9.yB/l5B2kR.sH.JzG.95OQR.FmC4GfS3eN/w8aE.XG/E.wI/O.Oq', 'admin@perpus.id');

-- Isi Data Anggota
-- Password untuk semua anggota di bawah ini adalah 'rahasia123'
SET @hashed_password = '$2y$10$E.qJm9mX/BGn53.Oq8bQy.rR52A0.FQk/B3N5F3.gW2/qW6/QO8iC';
INSERT INTO anggota (nama, email, password, kategori, nomor_anggota, status) VALUES
('Rina Saputri', 'rina.saputri@example.com', @hashed_password, 'Mahasiswa', 'AGT001', 'Aktif'),
('Ahmad Fauzan', 'ahmad.fz@example.com', @hashed_password, 'Mahasiswa', 'AGT002', 'Aktif'),
('Dr. Budi Santoso', 'budi.santoso@univ.ac.id', @hashed_password, 'Dosen', 'AGT003', 'Aktif'),
('Dr. Siti Aminah', 'siti.aminah@univ.ac.id', @hashed_password, 'Dosen', 'AGT004', 'Nonaktif'),
('Dewi Kurnia', 'dewi.kurnia@gmail.com', @hashed_password, 'Umum', 'AGT005', 'Aktif'),
('Agus Pratama', 'agus.pratama@gmail.com', @hashed_password, 'Umum', 'AGT006', 'Nonaktif');

-- Isi Data Peminjaman
INSERT INTO peminjaman (id_anggota, id_buku, tanggal_pinjam, tanggal_kembali, status) VALUES
(1, 2, '2025-10-10', '2025-10-15', 'Dikembalikan'),
(2, 3, '2025-10-15', NULL, 'Dipinjam'),
(3, 1, '2025-09-25', '2025-10-05', 'Dikembalikan'),
(5, 5, '2025-10-12', NULL, 'Dipinjam');

-- Isi Data Denda
INSERT INTO denda (id_pinjam, jumlah, keterangan, tanggal_bayar) VALUES
(1, 5000, 'Terlambat 2 hari', '2025-10-16'),
(3, 10000, 'Terlambat 4 hari', '2025-10-06');