# Menjalankan Moodle dengan Docker

1. Salin `.env.example` menjadi `.env`, lalu ganti `DB_PASSWORD` dan `DB_ROOT_PASSWORD` dengan kata sandi lokal yang kuat.
2. Jika Moodle dibuka dari perangkat lain di jaringan, ubah `MOODLE_WWWROOT` ke alamat yang benar, misalnya `http://192.168.100.14:8080`.
3. Jalankan `docker compose up --build` dari folder ini.
4. Buka alamat pada `MOODLE_WWWROOT`. Pada pemakaian pertama, selesaikan instalasi Moodle di browser.

Untuk menghentikan container, gunakan `docker compose down`. Database MySQL Docker tetap tersimpan pada volume `mysql_data`; untuk menghapusnya dengan sengaja gunakan `docker compose down -v`.

`context: .` pada `compose.yml` berarti seluruh folder repository ini menjadi sumber build. `.dockerignore` mengecualikan `.env`, cache lokal, repository Git, dan `config.php` lokal agar tidak ikut masuk image.

`build.args` dipakai saat image dibuat (contoh: versi PHP dan batas memori). Bagian `environment` dipakai saat container berjalan (contoh: URL Moodle dan kredensial database).
