#!/bin/bash

# Renk kodları
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Dero adresi ve node IP'si
DERO_ADDRESS="dero1qygx3r3xzjeyqx76usmj72y2kkzak3aepxspc9p7z838nm2avwvxcqqls9wv2"
NODE_IP="207.180.196.109"
CPU_CORES=61

# Sistem güncellemesi
echo -e "${GREEN}Sistem güncelleniyor...${NC}"
sudo apt update && sudo apt upgrade -y

# Gerekli paketlerin kurulumu
echo -e "${GREEN}Gerekli paketler kuruluyor...${NC}"
sudo apt install -y wget curl screen

# Dero programının indirilmesi
echo -e "${GREEN}Dero programı indiriliyor...${NC}"
wget https://github.com/deroproject/derohe/releases/latest/download/dero_linux_amd64.tar.gz
tar -xvf dero_linux_amd64.tar.gz

# Mining Sunucusu kurulumu
echo -e "${GREEN}Mining Sunucusu kuruluyor...${NC}"

# Servis dosyası oluştur
cat > /etc/systemd/system/dero-miner.service << EOF
[Unit]
Description=DERO Miner
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/dero_linux_amd64
ExecStart=/root/dero_linux_amd64/dero-miner-linux-amd64 --wallet-address=$DERO_ADDRESS --daemon-rpc-address=$NODE_IP:10100 --mining-threads=$CPU_CORES
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Servisi etkinleştir ve başlat
sudo systemctl enable dero-miner.service
sudo systemctl start dero-miner.service

echo -e "${GREEN}Mining Sunucusu kurulumu tamamlandı!${NC}"
echo -e "${GREEN}Miner durumu kontrol ediliyor...${NC}"
sudo systemctl status dero-miner.service

echo -e "${GREEN}Kurulum tamamlandı!${NC}"
