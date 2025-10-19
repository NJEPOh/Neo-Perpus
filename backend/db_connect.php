<?php
/**
 * ===================================================
 * Koneksi Database (db_connect.php)
 * ===================================================
 * File ini bertanggung jawab untuk membuat koneksi
 * ke database MySQL menggunakan PDO (PHP Data Objects).
 *
 * Ini akan di-include oleh file backend lain
 * (login.php, register.php, get_books.php, dll.)
 */

// 1. Pengaturan Kredensial Database
$host = 'localhost';       // Alamat server database Anda
$db_name = 'perpustakaan';   // Nama database dari file .sql
$username = 'root';        // Username database (default XAMPP/Laragon)
$password = '';            // Password database (default kosong)
$charset = 'utf8mb4';      // Pengaturan charset

// 2. Pengaturan DSN (Data Source Name)
$dsn = "mysql:host=$host;dbname=$db_name;charset=$charset";

// 3. Pengaturan Opsi PDO
$options = [
    // Tampilkan error sebagai Pengecualian (Exceptions)
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    
    // Atur mode pengambilan data default ke array asosiatif
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    
    // Nonaktifkan emulasi prepared statements (untuk keamanan)
    PDO::ATTR_EMULATE_PREPARES   => false,
];

// 4. Blok Try-Catch untuk Membuat Koneksi
try {
    
    // Buat objek koneksi PDO
    // Variabel $conn ini akan tersedia di semua skrip yang meng-include file ini
    $conn = new PDO($dsn, $username, $password, $options);

} catch (PDOException $e) {
    
    // Jika koneksi GAGAL, hentikan skrip dan kirim respon error.
    
    // Atur kode status HTTP ke 500 (Internal Server Error)
    http_response_code(500);
    
    // Atur header respon sebagai JSON (karena frontend mengharapkan JSON)
    header('Content-Type: application/json');
    
    // Tampilkan pesan error dalam format JSON
    echo json_encode([
        'status' => 'error',
        'message' => 'Koneksi database gagal: ' . $e->getMessage()
    ]);
    
    // Hentikan eksekusi skrip
    exit();
}
?>