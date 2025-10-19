<?php
/**
 * ===================================================
 * Pendaftaran Anggota (register.php)
 * ===================================================
 * API endpoint untuk mendaftarkan anggota baru.
 */

// 1. Masukkan file koneksi database
require 'db_connect.php';

// Atur header respon sebagai JSON
header('Content-Type: application/json');

// 2. Ambil data JSON yang dikirim dari auth.js
$data = json_decode(file_get_contents('php://input'), true);

// 3. Validasi Sisi Server
// Cek kelengkapan data
if (
    empty($data['nama']) || empty($data['email']) || 
    empty($data['password']) || empty($data['konfirmasi']) ||
    empty($data['kategori'])
) {
    http_response_code(400); // Bad Request
    echo json_encode(['status' => 'error', 'message' => 'Semua data wajib diisi.']);
    exit();
}

// Cek kesesuaian password
if ($data['password'] !== $data['konfirmasi']) {
    http_response_code(400);
    echo json_encode(['status' => 'error', 'message' => 'Password dan Konfirmasi Password tidak cocok.']);
    exit();
}

// Cek panjang password
if (strlen($data['password']) < 6) {
    http_response_code(400);
    echo json_encode(['status' => 'error', 'message' => 'Password minimal 6 karakter.']);
    exit();
}

// Cek format email
if (!filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
    http_response_code(400);
    echo json_encode(['status' => 'error', 'message' => 'Format email tidak valid.']);
    exit();
}

// 4. Siapkan data untuk database
$nama = $data['nama'];
$email = $data['email'];
$telepon = $data['telepon'] ?? ''; // Opsional
$alamat = $data['alamat'] ?? ''; // Opsional
$kategori = $data['kategori'];
// PENTING: Hash password untuk keamanan
$hashed_password = password_hash($data['password'], PASSWORD_BCRYPT);


// 5. Proses Database (Menggunakan Transaksi)
try {
    // Mulai transaksi
    $conn->beginTransaction();

    // 5a. Cek apakah email sudah terdaftar
    $stmt_check = $conn->prepare("SELECT id_anggota FROM anggota WHERE email = ?");
    $stmt_check->execute([$email]);

    if ($stmt_check->fetch()) {
        // Jika email ada, batalkan transaksi dan kirim error
        $conn->rollBack();
        http_response_code(409); // Conflict
        echo json_encode(['status' => 'error', 'message' => 'Email ini sudah terdaftar. Silakan login.']);
        exit();
    }

    // 5b. Masukkan data anggota baru (tanpa nomor_anggota dulu)
    $sql_insert = "INSERT INTO anggota (nama, email, password, telepon, alamat, kategori) 
                   VALUES (?, ?, ?, ?, ?, ?)";
    $stmt_insert = $conn->prepare($sql_insert);
    $stmt_insert->execute([$nama, $email, $hashed_password, $telepon, $alamat, $kategori]);

    // 5c. Ambil ID anggota yang baru saja dibuat
    $id_baru = $conn->lastInsertId();

    // 5d. Buat nomor_anggota unik (contoh: AGT00001)
    $nomor_anggota = 'AGT' . str_pad($id_baru, 5, '0', STR_PAD_LEFT);

    // 5e. Update data anggota dengan nomor_anggota yang baru
    $sql_update = "UPDATE anggota SET nomor_anggota = ? WHERE id_anggota = ?";
    $stmt_update = $conn->prepare($sql_update);
    $stmt_update->execute([$nomor_anggota, $id_baru]);

    // 6. Selesaikan transaksi
    $conn->commit();

    // 7. Kirim respon sukses
    http_response_code(201); // Created
    echo json_encode([
        'status' => 'success', 
        'message' => 'Pendaftaran berhasil! Nomor Anggota Anda adalah ' . $nomor_anggota
    ]);

} catch (PDOException $e) {
    // Jika terjadi error, batalkan semua perubahan
    $conn->rollBack();
    
    http_response_code(500); // Internal Server Error
    echo json_encode(['status' => 'error', 'message' => 'Pendaftaran gagal: ' . $e->getMessage()]);
}

?>