<?php
/**
 * ===================================================
 * Login Anggota (login.php)
 * ===================================================
 * API endpoint untuk mengautentikasi login anggota.
 */

// 1. Masukkan file koneksi database
require 'db_connect.php';

// Atur header respon sebagai JSON
header('Content-Type: application/json');

// 2. Ambil data JSON yang dikirim dari auth.js
$data = json_decode(file_get_contents('php://input'), true);

// 3. Validasi Sisi Server
if (empty($data['email']) || empty($data['password'])) {
    http_response_code(400); // Bad Request
    echo json_encode(['status' => 'error', 'message' => 'Email dan Password tidak boleh kosong.']);
    exit();
}

$email = $data['email'];
$password_input = $data['password'];

// 4. Proses Database
try {
    // 4a. Cari pengguna berdasarkan email
    $sql = "SELECT id_anggota, nama, email, nomor_anggota, kategori, password, status 
            FROM anggota 
            WHERE email = ?";
    
    $stmt = $conn->prepare($sql);
    $stmt->execute([$email]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    // 4b. Verifikasi Pengguna dan Password
    
    // Cek apakah pengguna ditemukan DAN password-nya cocok
    if ($user && password_verify($password_input, $user['password'])) {
        
        // 4c. Cek apakah akun aktif
        if ($user['status'] === 'Nonaktif') {
            http_response_code(403); // Forbidden
            echo json_encode(['status' => 'error', 'message' => 'Akun Anda tidak aktif. Silakan hubungi admin.']);
            exit();
        }

        // 4d. Login Berhasil
        
        // PENTING: Hapus hash password dari data sebelum dikirim kembali
        unset($user['password']);

        // Kirim respon sukses beserta data pengguna
        echo json_encode([
            'status' => 'success',
            'message' => 'Login berhasil! Selamat datang, ' . $user['nama'] . '.',
            'user' => $user // Data ini akan disimpan di localStorage oleh auth.js
        ]);

    } else {
        // 4e. Login Gagal (Email tidak ditemukan ATAU password salah)
        http_response_code(401); // Unauthorized
        echo json_encode(['status' => 'error', 'message' => 'Email atau Password salah.']);
    }

} catch (PDOException $e) {
    // 5. Tangani error database
    http_response_code(500); // Internal Server Error
    echo json_encode(['status' => 'error', 'message' => 'Login gagal: ' . $e->getMessage()]);
}

?>