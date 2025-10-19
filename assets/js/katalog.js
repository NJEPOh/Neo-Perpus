document.addEventListener("DOMContentLoaded", () => {
    const searchBar = document.querySelector(".search-bar input");
    const categoryFilter = document.getElementById("kategori");
    const sortFilter = document.getElementById("sort");
    const bookGrid = document.querySelector(".book-grid");

    async function fetchAndRenderBooks() {
        const searchTerm = searchBar.value;
        const category = categoryFilter.value;
        const sort = sortFilter.value;

        bookGrid.innerHTML = '<p class="loading-message">Memuat buku...</p>';

        try {
            // Buat parameter URL
            const params = new URLSearchParams({
                search: searchTerm,
                kategori: category,
                sort: sort
            });

            // Gunakan path relatif sederhana.
            // Browser akan otomatis memanggil http://localhost/perpustakaan/backend/get_books.php
            const url = `backend/get_books.php?${params.toString()}`;

            const response = await fetch(url);
            if (!response.ok) {
                throw new Error("Respon server tidak baik.");
            }

            const result = await response.json();

            if (result.status === "success") {
                renderBooks(result.books);
            } else {
                throw new Error(result.message);
            }
        } catch (error) {
            console.error("Error:", error);
            bookGrid.innerHTML =
                `<p class="error-message">Gagal memuat buku: ${error.message}</p>`;
        }
    }

    function renderBooks(books) {
        bookGrid.innerHTML = "";

        if (books.length === 0) {
            bookGrid.innerHTML =
                '<p class="empty-message">Tidak ada buku yang ditemukan.</p>';
            return;
        }

        books.forEach((book) => {
            const bookCard = document.createElement("a");
            bookCard.className = "book-card";
            bookCard.href = `detail-buku.html?id=${book.id_buku}`;

            const coverImage = book.cover ?
                `assets/img/cover/${book.cover}` :
                "assets/img/cover/default.jpg"; // (Pastikan ada gambar default)

            bookCard.innerHTML = `
                <img src="${coverImage}" alt="Cover ${book.judul}">
                <h3>${book.judul}</h3>
                <p>${book.pengarang}</p>
            `;

            bookGrid.appendChild(bookCard);
        });
    }

    // Event Listeners
    categoryFilter.addEventListener("change", fetchAndRenderBooks);
    sortFilter.addEventListener("change", fetchAndRenderBooks);
    searchBar.addEventListener("keypress", (e) => {
        if (e.key === "Enter") {
            e.preventDefault();
            fetchAndRenderBooks();
        }
    });

    // Muat data saat halaman dibuka
    fetchAndRenderBooks();
});