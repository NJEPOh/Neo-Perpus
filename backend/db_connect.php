<?php
// 1. Pengaturan Kredensial Database
$host = 'localhost';       
$db_name = 'perpustakaan';   // <-- PASTIKAN NAMA INI BENAR
$username = 'root';        
$password = '';            
$charset = 'utf8mb4';      

// 2. Pengaturan DSN (Data Source Name)
$dsn = "mysql:host=$host;dbname=$db_name;charset=$charset";

// 3. Pengaturan Opsi PDO
$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];

// 4. Blok Try-Catch untuk Membuat Koneksi
try {
    $conn = new PDO($dsn, $username, $password, $options);
} catch (PDOException $e) {
    http_response_code(500);
    header('Content-Type: application/json');
    echo json_encode([
        'status' => 'error',
        'message' => 'Koneksi database gagal: ' . $e->getMessage()
    ]);
    exit();
}
?>