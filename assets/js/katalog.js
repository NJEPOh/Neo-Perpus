/*
=====================================================
 katalog.js
 Skrip untuk memuat dan memfilter data buku
 di halaman katalog (katalog.html)
=====================================================
*/
document.addEventListener("DOMContentLoaded", () => {
    // 1. Ambil elemen-elemen penting dari DOM
    const searchBar = document.querySelector(".search-bar input");
    const categoryFilter = document.getElementById("kategori");
    const sortFilter = document.getElementById("sort");
    const bookGrid = document.querySelector(".book-grid");

    /**
     * ===================================================
     * Fungsi Utama: Mengambil dan Menampilkan Buku
     * ===================================================
     */
    async function fetchAndRenderBooks() {
        // 1. Dapatkan nilai filter saat ini
        const searchTerm = searchBar.value;
        const category = categoryFilter.value;
        const sort = sortFilter.value;

        // Tampilkan pesan loading di dalam grid
        bookGrid.innerHTML = '<p class="loading-message">Memuat buku...</p>';

        try {
            // 2. Buat URLSearchParams untuk query
            const params = new URLSearchParams({
                search: searchTerm,
                kategori: category,
                sort: sort
            });

            // Path relatif ke skrip backend
            const url = `backend/get_books.php?${params.toString()}`;

            // 3. Panggil API backend menggunakan fetch
            const response = await fetch(url);
            if (!response.ok) {
                throw new Error("Respon server tidak baik (gagal mengambil data).");
            }

            const result = await response.json();

            // 4. Render hasil ke halaman
            if (result.status === "success") {
                renderBooks(result.books);
            } else {
                // Tampilkan error jika status dari backend 'error'
                throw new Error(result.message);
            }
        } catch (error) {
            console.error("Error:", error);
            bookGrid.innerHTML =
                `<p class="error-message">Gagal memuat buku: ${error.message}</p>`;
        }
    }

    /**
     * ===================================================
     * Fungsi Helper: Merender Daftar Buku ke HTML
     * @param {Array} books - Array berisi objek buku
     * ===================================================
     */
    function renderBooks(books) {
        // Kosongkan grid sebelum mengisi data baru
        bookGrid.innerHTML = "";

        // Cek jika tidak ada buku yang ditemukan
        if (books.length === 0) {
            bookGrid.innerHTML =
                '<p class="empty-message">Tidak ada buku yang ditemukan.</p>';
            return;
        }

        // 2. Loop setiap buku dan buat elemen card
        books.forEach((book) => {
            const bookCard = document.createElement("a");
            bookCard.className = "book-card";
            
            // Arahkan card ke halaman detail-buku.html dengan parameter ID
            bookCard.href = `detail-buku.html?id=${book.id_buku}`;

            // Tentukan path gambar
            // (Gunakan gambar default jika 'cover' null atau kosong)
            const coverImage = book.cover ?
                `assets/img/cover/${book.cover}` :
                "assets/img/cover/default.jpg"; // (Pastikan Anda punya file default.jpg)

            bookCard.innerHTML = `
                <img src="${coverImage}" alt="Cover ${book.judul}">
                <h3>${book.judul}</h3>
                <p>${book.pengarang}</p>
            `;

            // Tambahkan card ke grid
            bookGrid.appendChild(bookCard);
        });
    }

    // ===================================
    // Tambahkan Event Listeners
    // ===================================

    // Filter Kategori (saat nilainya berubah)
    categoryFilter.addEventListener("change", fetchAndRenderBooks);

    // Filter Urutkan (saat nilainya berubah)
    sortFilter.addEventListener("change", fetchAndRenderBooks);

    // Search Bar (saat menekan tombol "Enter")
    searchBar.addEventListener("keypress", (e) => {
        if (e.key === "Enter") {
            e.preventDefault(); // Mencegah submit form (jika ada)
            fetchAndRenderBooks();
        }
    });

    // Panggil fungsi saat halaman pertama kali dimuat
    fetchAndRenderBooks();
});