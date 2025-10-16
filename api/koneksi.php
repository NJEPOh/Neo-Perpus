<?php
$host = "localhost";
$user = "root";
$pass = "";
$db   = "perpustakaan";

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    die("Koneksi gagal: " . $conn->connect_error);
}

if (!$conn) {
    die("Koneksi gagal: " . mysqli_connect_error());
}
