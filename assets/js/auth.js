/**
 * =================================================================
 * auth.js
 * -----------------------------------------------------------------
 * Skrip untuk menangani simulasi Autentikasi Pengguna:
 * 1. Pendaftaran Anggota Baru (`daftar.html`)
 * 2. Login Anggota (`login.html`)
 *
 * Menggunakan localStorage untuk mensimulasikan database pengguna
 * di sisi client.
 * =================================================================
 */

// Menjalankan skrip hanya setelah seluruh halaman HTML selesai dimuat
document.addEventListener('DOMContentLoaded', () => {
  const registerForm = document.querySelector('.register-form');
  const loginForm = document.querySelector('.login-form');

  // ===================================
  // FUNGSI UNTUK HALAMAN PENDAFTARAN
  // ===================================
  if (registerForm) {
    registerForm.addEventListener('submit', (e) => {
      e.preventDefault(); // Mencegah form mengirim data ke server

      // Mengambil nilai dari setiap input field
      const nama = document.getElementById('nama').value.trim();
      const email = document.getElementById('email').value.trim();
      const telepon = document.getElementById('telepon').value.trim();
      const alamat = document.getElementById('alamat').value.trim();
      const kategori = document.getElementById('kategori').value;
      const password = document.getElementById('password').value;
      const konfirmasi = document.getElementById('konfirmasi').value;

      // 1. Validasi Input Sederhana
      if (!nama || !email || !password || !konfirmasi) {
        alert('Nama, Email, dan Password wajib diisi.');
        return;
      }

      if (password.length < 6) {
        alert('Password harus terdiri dari minimal 6 karakter.');
        return;
      }

      if (password !== konfirmasi) {
        alert('Password dan Konfirmasi Password tidak cocok.');
        return;
      }

      // 2. Mengambil data pengguna yang sudah ada dari localStorage
      // Jika tidak ada, inisialisasi sebagai array kosong
      const users = JSON.parse(localStorage.getItem('perpustakaan_users')) || [];

      // 3. Cek apakah email sudah terdaftar
      const emailExists = users.some((user) => user.email === email);
      if (emailExists) {
        alert('Email ini sudah terdaftar. Silakan gunakan email lain atau login.');
        return;
      }

      // 4. Membuat objek pengguna baru
      // PERINGATAN: Di aplikasi production, JANGAN PERNAH menyimpan password
      // sebagai plain text. Gunakan hashing di sisi backend (misal: bcrypt).
      const newUser = {
        nama: nama,
        email: email,
        telepon: telepon,
        alamat: alamat,
        kategori: kategori,
        password: password, // Ini hanya untuk simulasi
      };

      // 5. Menambahkan pengguna baru ke dalam array
      users.push(newUser);

      // 6. Menyimpan kembali data pengguna ke localStorage
      localStorage.setItem('perpustakaan_users', JSON.stringify(users));

      // 7. Memberi notifikasi sukses dan mengarahkan ke halaman login
      alert('Pendaftaran berhasil! Anda akan diarahkan ke halaman login.');
      window.location.href = 'login.html';
    });
  }

  // ===================================
  // FUNGSI UNTUK HALAMAN LOGIN
  // ===================================
  if (loginForm) {
    loginForm.addEventListener('submit', (e) => {
      e.preventDefault();

      // Mengambil nilai input
      const username = document.getElementById('username').value.trim(); // Bisa email atau nama
      const password = document.getElementById('password').value;

      if (!username || !password) {
        alert('Email/Username dan Password tidak boleh kosong.');
        return;
      }

      // 1. Mengambil data pengguna dari localStorage
      const users = JSON.parse(localStorage.getItem('perpustakaan_users')) || [];

      // 2. Mencari pengguna yang cocok berdasarkan email/nama dan password
      const foundUser = users.find(
        (user) => (user.email === username || user.nama === username) && user.password === password
      );

      // 3. Logika autentikasi
      if (foundUser) {
        // Jika pengguna ditemukan (login berhasil)
        alert(`Login berhasil! Selamat datang kembali, ${foundUser.nama}.`);

        // Simpan informasi pengguna yang login ke sessionStorage
        // sessionStorage akan terhapus saat browser ditutup
        sessionStorage.setItem('loggedInUser', JSON.stringify(foundUser));

        // Arahkan ke dashboard anggota (sesuai file `struktur`)
        window.location.href = 'anggota/dashboard.html';
      } else {
        // Jika pengguna tidak ditemukan (login gagal)
        alert('Login gagal. Periksa kembali Email/Username dan Password Anda.');
      }
    });
  }
});