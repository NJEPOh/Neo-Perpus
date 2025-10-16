CREATE DATABASE IF NOT EXISTS perpustakaan;
USE perpustakaan;
CREATE TABLE buku (
    id_buku INT AUTO_INCREMENT PRIMARY KEY,
    judul VARCHAR(150),
    pengarang VARCHAR(100),
    kategori VARCHAR(50),
    tahun_terbit YEAR,
    cover VARCHAR(255),
    tanggal_input DATETIME DEFAULT CURRENT_TIMESTAMP,
    stok INT DEFAULT 0
);
INSERT INTO buku (
        judul,
        pengarang,
        kategori,
        tahun_terbit,
        cover,
        stok
    )
VALUES (
        'Filsafat Islam Kontemporer',
        'A. Khudori Soleh',
        'Agama',
        2020,
        'buku1.jpg',
        5
    ),
    (
        'Algoritma dan Pemrograman',
        'Rinaldi Munir',
        'Teknologi',
        2022,
        'buku2.jpg',
        3
    ),
    (
        'Psikologi Pendidikan',
        'Slameto',
        'Pendidikan',
        2018,
        'buku3.jpg',
        4
    ),
    (
        'Manajemen Waktu Efektif',
        'Stephen Covey',
        'Umum',
        2019,
        'buku4.jpg',
        2
    ),
    (
        'Belajar Machine Learning',
        'Andrew Ng',
        'Teknologi',
        2023,
        'buku5.jpg',
        6
    ),
    (
        'Dasar-Dasar Akuntansi',
        'Warren & Reeve',
        'Ekonomi',
        2021,
        'buku6.jpg',
        7
    );