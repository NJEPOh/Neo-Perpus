<?php
/**
 * ===================================================
 * Ambil Data Buku (get_books.php)
 * ===================================================
 * API endpoint untuk mengambil daftar buku dari database.
 * Mendukung pencarian, filter kategori, dan pengurutan.
 */

// 1. Masukkan file koneksi database
require 'db_connect.php';

// 2. Ambil parameter dari request (GET)
// Gunakan null coalescing operator (??) untuk nilai default
$search = $_GET['search'] ?? '';
$kategori = $_GET['kategori'] ?? 'Semua';
$sort = $_GET['sort'] ?? 'Terbaru';

// 3. Bangun query SQL dasar
// Kita select kolom yang dibutuhkan oleh katalog.js
$sql = "SELECT id_buku, judul, pengarang, cover, stok, tanggal_input FROM buku WHERE 1=1";
$params = []; // Array untuk menyimpan parameter prepared statement

// 4. Tambahkan filter pencarian
if (!empty($search)) {
    // Cari berdasarkan judul ATAU pengarang
    $sql .= " AND (judul LIKE ? OR pengarang LIKE ?)";
    $searchTerm = "%{$search}%";
    // Tambahkan parameter dua kali (untuk judul dan pengarang)
    $params[] = $searchTerm;
    $params[] = $searchTerm;
}

// 5. Tambahkan filter kategori
// Hanya tambahkan filter jika kategori BUKAN 'Semua' dan tidak kosong
if ($kategori !== 'Semua' && !empty($kategori)) {
    $sql .= " AND kategori = ?";
    $params[] = $kategori;
}

// 6. Tambahkan logika pengurutan (sorting)
switch ($sort) {
    case 'Abjad A-Z':
        $sql .= " ORDER BY judul ASC";
        break;
    case 'Terpopuler':
        // Catatan: Logika "Terpopuler" idealnya berdasarkan jumlah peminjaman.
        // Untuk simulasi ini, kita urutkan berdasarkan stok tertinggi.
        $sql .= " ORDER BY stok DESC";
        break;
    case 'Terbaru':
    default:
        // Defaultnya adalah buku yang baru di-input
        $sql .= " ORDER BY tanggal_input DESC";
        break;
}

// 7. Eksekusi query dan kirim respon
try {
    $stmt = $conn->prepare($sql);
    $stmt->execute($params);
    $books = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Atur header sebagai JSON (sudah ada di db_connect.php, tapi baik untuk redundant)
    header('Content-Type: application/json');
    echo json_encode(['status' => 'success', 'books' => $books]);

} catch (PDOException $e) {
    // Jika query gagal
    http_response_code(500);
    header('Content-Type: application/json');
    echo json_encode(['status' => 'error', 'message' => 'Gagal mengambil data buku: ' . $e->getMessage()]);
}

?>