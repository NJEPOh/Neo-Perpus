USE perpustakaan;

-- ==============================
-- 1️⃣  DATA ADMIN
-- ==============================
CREATE TABLE IF NOT EXISTS admin (
    id_admin INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100),
    tanggal_daftar DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO admin (nama, username, password, email)
VALUES 
('Administrator', 'admin', MD5('admin123'), 'admin@perpus.id');


-- ==============================
-- 2️⃣  DATA ANGGOTA
-- ==============================
CREATE TABLE IF NOT EXISTS anggota (
    id_anggota INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    kategori ENUM('Mahasiswa','Dosen','Umum'),
    nomor_anggota VARCHAR(20) UNIQUE,
    tanggal_daftar DATE DEFAULT (CURRENT_DATE),
    status ENUM('Aktif','Nonaktif') DEFAULT 'Aktif'
);

INSERT INTO anggota (nama, email, kategori, nomor_anggota, status) VALUES
-- Mahasiswa
('Rina Saputri', 'rina.saputri@example.com', 'Mahasiswa', 'AGT001', 'Aktif'),
('Ahmad Fauzan', 'ahmad.fz@example.com', 'Mahasiswa', 'AGT002', 'Aktif'),

-- Dosen
('Dr. Budi Santoso', 'budi.santoso@univ.ac.id', 'Dosen', 'AGT003', 'Aktif'),
('Dr. Siti Aminah', 'siti.aminah@univ.ac.id', 'Dosen', 'AGT004', 'Nonaktif'),

-- Umum
('Dewi Kurnia', 'dewi.kurnia@gmail.com', 'Umum', 'AGT005', 'Aktif'),
('Agus Pratama', 'agus.pratama@gmail.com', 'Umum', 'AGT006', 'Nonaktif');


-- ==============================
-- 3️⃣  DATA BUKU (SUDAH ADA DI FILE UTAMA)
-- ==============================
-- (Tambahan contoh saja, jika perlu)
INSERT INTO buku (judul, pengarang, kategori, tahun_terbit, cover, stok) VALUES
('Statistika Terapan untuk Riset', 'Sugiyono', 'Pendidikan', 2021, 'buku7.jpg', 5),
('Ekonomi Mikro Modern', 'Sadono Sukirno', 'Ekonomi', 2019, 'buku8.jpg', 4),
('Dasar-Dasar Jaringan Komputer', 'Andrew Tanenbaum', 'Teknologi', 2020, 'buku9.jpg', 3);


-- ==============================
-- 4️⃣  DATA PEMINJAMAN
-- ==============================
CREATE TABLE IF NOT EXISTS peminjaman (
    id_pinjam INT AUTO_INCREMENT PRIMARY KEY,
    id_anggota INT,
    id_buku INT,
    tanggal_pinjam DATE DEFAULT (CURRENT_DATE),
    tanggal_kembali DATE,
    status ENUM('Dipinjam','Dikembalikan') DEFAULT 'Dipinjam',
    FOREIGN KEY (id_anggota) REFERENCES anggota(id_anggota) ON DELETE CASCADE,
    FOREIGN KEY (id_buku) REFERENCES buku(id_buku) ON DELETE CASCADE
);

INSERT INTO peminjaman (id_anggota, id_buku, tanggal_pinjam, tanggal_kembali, status) VALUES
(1, 2, '2025-10-10', '2025-10-15', 'Dikembalikan'),
(2, 3, '2025-10-15', NULL, 'Dipinjam'),
(3, 1, '2025-09-25', '2025-10-05', 'Dikembalikan'),
(5, 5, '2025-10-12', NULL, 'Dipinjam');


-- ==============================
-- 5️⃣  DATA DENDA
-- ==============================
CREATE TABLE IF NOT EXISTS denda (
    id_denda INT AUTO_INCREMENT PRIMARY KEY,
    id_pinjam INT,
    jumlah DECIMAL(10,2),
    keterangan VARCHAR(255),
    tanggal_bayar DATE,
    FOREIGN KEY (id_pinjam) REFERENCES peminjaman(id_pinjam) ON DELETE CASCADE
);

INSERT INTO denda (id_pinjam, jumlah, keterangan, tanggal_bayar) VALUES
(1, 5000, 'Terlambat 2 hari', '2025-10-16'),
(3, 10000, 'Terlambat 4 hari', '2025-10-06');
