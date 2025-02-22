#!/bin/bash

# Mengecek apakah Node.js sudah terinstal
if command -v node >/dev/null 2>&1; then
    echo "Node.js sudah terinstal: $(node -v)"
else
    # Memperbarui daftar paket
    echo "Menginstal Node.js..."
    sudo apt update

    # Menginstal curl jika belum terinstal
    sudo apt install -y curl

    # Mengunduh dan menginstal Node.js versi terbaru menggunakan NodeSource
    curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -
    sudo apt install -y nodejs

    # Memverifikasi instalasi
    echo "Node.js dan npm versi terbaru telah diinstal."
    node -v
    npm -v
fi

# Membuat direktori proyek
PROJECT_DIR=~/NexusProject

if [ ! -d "$PROJECT_DIR" ]; then
    mkdir "$PROJECT_DIR"
    echo "Direktori $PROJECT_DIR telah dibuat."
else
    echo "Direktori $PROJECT_DIR sudah ada."
fi

# Masuk ke direktori proyek
cd "$PROJECT_DIR" || exit

# Inisialisasi proyek NPM
npm init -y
echo "Proyek NPM telah diinisialisasi."

# Instal Hardhat, Ethers.js, OpenZeppelin, dan dotenv
npm install --save-dev hardhat @nomiclabs/hardhat-ethers ethers @openzeppelin/contracts dotenv
echo "Hardhat, Ethers.js, OpenZeppelin, dan dotenv telah diinstal."

# Memulai proyek Hardhat
npx hardhat init -y
echo "Proyek Hardhat telah dibuat dengan konfigurasi kosong."

# Membuat folder contracts dan scripts
mkdir -p contracts scripts
echo "Folder 'contracts' dan 'scripts' telah dibuat."

# Membuat file deploy.js di folder scripts
cat <<EOL > scripts/deploy.js
const { ethers } = require("hardhat");

function generateRandomSymbol() {
    const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    let symbol = "";
    for (let i = 0; i < 4; i++) {
        symbol += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return symbol;
}

function generateRandomAddresses(count) {
    const addresses = new Set();
    while (addresses.size < count) {
        const randomAddress = ethers.Wallet.createRandom().address;
        addresses.add(randomAddress);
    }
    return Array.from(addresses);
}

async function main() {
    const [deployer] = await ethers.getSigners();
    const totalTokens = 100000; // Total token yang akan dibuat
    const tokensToSend = ethers.utils.parseUnits("1000", 18); // 1000 token

    for (let i = 0; i < totalTokens; i++) {
        const tokenSymbol = generateRandomSymbol();
        const tokenName = "Token" + tokenSymbol;

        const Token = await ethers.getContractFactory("NexusToken");
        const token = await Token.deploy(tokenName, tokenSymbol);

        // Menampilkan output segera setelah transaksi deploy dimulai
        const currentTime = new Date().toLocaleString();
        console.log(\`Deploying Token: \${i + 1}/\${totalTokens}\`);
        console.log(\`[\${currentTime}] Transaction \${i + 1} - Token deployed to: \${token.address}, Name: \${tokenName}, Symbol: \${tokenSymbol}\`);

        // Mendapatkan 150 alamat unik dan mengirimkan 1000 token ke setiap alamat
        const uniqueAddresses = generateRandomAddresses(150);
        for (const recipient of uniqueAddresses) {
            await token.transfer(recipient, tokensToSend);
            console.log(\`Sent 1000 \${tokenSymbol} to \${recipient}\`);
        }
    }
}

main().catch((error) => {
    console.error("Error encountered:", error);
    console.log("Menunggu 30 detik sebelum mencoba deploy ulang...");
    setTimeout(() => {
        main(); // Mencoba lagi
    }, 30000); // 30 detik delay
});
EOL
echo "File 'deploy.js' telah dibuat di folder 'scripts'."

# Membuat file NexusToken.sol
cat <<EOL > contracts/NexusToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract NexusToken is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(msg.sender, 1000000 * 10 ** 18);
    }
}
EOL
echo "File 'NexusToken.sol' telah dibuat di folder 'contracts'."

# Mengompilasi kontrak
npx hardhat compile
echo "Kontrak telah dikompilasi."

# Membuat file .env
touch .env
echo "PRIVATE_KEY=(INI DIISI PRIVAT KEY)" > .env
echo "Private key telah ditambahkan secara otomatis ke file .env."

# Membuat file .gitignore
cat <<EOL > .gitignore
# Node modules
node_modules/

# Environment variables
.env

# Coverage files
coverage/
coverage.json

# Typechain generated files
typechain/
typechain-types/

# Hardhat files
cache/
artifacts/

# Build files
build/
EOL
echo "File '.gitignore' telah dibuat dengan contoh kode."

# Membuat file hardhat.config.js
cat <<EOL > hardhat.config.js
require("dotenv").config();
require("@nomiclabs/hardhat-ethers");

module.exports = {
  solidity: "0.8.20",
  networks: {
    nexus: {
      url: "https://rpc.nexus.xyz/http",  // Nexus RPC URL
      chainId: 392,  // Nexus Chain ID
      accounts: [process.env.PRIVATE_KEY],
    },
  },
};
EOL
echo "File 'hardhat.config.js' telah diisi dengan konfigurasi Hardhat untuk Nexus dengan Chain ID 392."

# Menjalankan skrip deploy dalam loop tak terbatas
echo "Menjalankan skrip deploy..."
while true; do
    npx hardhat run --network nexus scripts/deploy.js
    echo "Skrip deploy telah selesai, mencoba lagi setelah 30 detik..."
    sleep 30
done

# Menyelesaikan proses
echo -e "\n🎉 **Selesai!** 🎉"
