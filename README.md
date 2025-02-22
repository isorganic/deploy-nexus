
# Deploy Nexus Project on VPS

Panduan untuk menginstal dan menjalankan proyek Nexus di VPS menggunakan skrip `auto.sh`.

## Persyaratan

Sebelum memulai, pastikan VPS Anda memenuhi persyaratan berikut:
- Sistem operasi berbasis Linux (Ubuntu/Debian disarankan)
- Akses root atau sudo ke VPS
- Node.js dan npm terinstal

## Langkah 1: Menyiapkan VPS

### 1.1. Perbarui Paket Sistem

Pertama, pastikan VPS Anda diperbarui dengan menjalankan perintah berikut:

```bash
sudo apt update && sudo apt upgrade -y
```

### 1.2. Instal Curl

Jika `curl` belum terinstal, jalankan perintah berikut:

```bash
sudo apt install -y curl
```

### 1.3. Instal Node.js dan npm

Instal Node.js dan npm jika belum terinstal:

```bash
curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -
sudo apt install -y nodejs
```

Verifikasi instalasi dengan memeriksa versi Node.js dan npm:

```bash
node -v
npm -v
```

## Langkah 2: Mengkloning Repositori

### 2.1. Kloning Repositori

Kloning repositori dari GitHub:

```bash
git clone https://github.com/isorganic/deploy-nexus.git
cd deploy-nexus
```

## Langkah 3: Menjalankan Skrip Auto.sh

### 3.1. Memberikan Izin Eksekusi pada Skrip

Sebelum menjalankan skrip, berikan izin eksekusi:

```bash
chmod +x auto.sh
```

### 3.2. Edit Privat Key & Run Skrip

Ganti privat key & jalankan skrip `auto.sh` untuk memulai proses setup:

```bash
./auto.sh
```

Skrip ini akan:
- Menginstal dependensi yang diperlukan (seperti Hardhat, Ethers.js, OpenZeppelin).
- Membuat direktori proyek dan file yang diperlukan.
- Menyusun kontrak dan menyebarkan token Nexus ke jaringan Nexus.
- Mengatur konfigurasi untuk jaringan Nexus.

### 3.3. Skrip Selesai

Setelah skrip selesai dijalankan, Anda akan melihat pesan berikut:

```
ðŸŽ‰ **Selesai!** ðŸŽ‰
```

Artinya, proyek Nexus telah berhasil disiapkan dan 100000 kontrak token telah dideploy!

## Langkah 4: Verifikasi

Untuk memverifikasi kontrak dan token yang telah dideploy:
- Anda dapat mengakses jaringan Nexus menggunakan RPC URL yang telah dikonfigurasi dalam file `hardhat.config.js`.
- Gunakan Hardhat atau alat lainnya untuk berinteraksi dengan kontrak yang telah dideploy.

## Troubleshooting

### 4.1. Masalah dengan Node.js

Jika Anda mengalami masalah dengan instalasi Node.js, coba ulangi proses instalasi atau pastikan repositori NodeSource diikuti dengan benar.

### 4.2. Masalah dengan Skrip

Jika skrip `auto.sh` gagal, pastikan bahwa Anda memiliki izin eksekusi yang benar dan telah mengikuti langkah-langkah sebelumnya dengan benar.

---

**Semoga berhasil!** ðŸš€
