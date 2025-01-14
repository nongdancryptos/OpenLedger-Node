#!/bin/bash

# Node OnTop ASCII Art
echo "
                   ██████╗ ███╗   ██╗    ████████╗ ██████╗ ██████╗ 
                  ██╔═══██╗████╗  ██║    ╚══██╔══╝██╔═══██╗██╔══██╗
                  ██║   ██║██╔██╗ ██║       ██║   ██║   ██║██████╔╝
                  ██║   ██║██║╚██╗██║       ██║   ██║   ██║██╔═══╝ 
                  ╚██████╔╝██║ ╚████║       ██║   ╚██████╔╝██║     
                   ╚═════╝ ╚═╝  ╚═══╝       ╚═╝    ╚═════╝ ╚═╝ 
                                                          
Telegram: https://t.me/OnTopAirdropGroup
GitHub: https://github.com/NongDanCryptos
Chanel: https://t.me/OnTopAirdrop
Twitter: https://x.com/OnTopAirdrop
"

# Kiểm tra phiên bản hệ điều hành
echo "Đang kiểm tra phiên bản hệ điều hành..."
OS_VERSION=$(lsb_release -r | awk '{print $2}')
if [ "$OS_VERSION" != "24.04" ]; then
    echo "Cảnh báo: Script này được thiết kế cho Ubuntu 24.04. Phiên bản hiện tại của bạn là $OS_VERSION."
fi

# Kiểm tra xem Docker đã được cài đặt chưa
echo "Đang kiểm tra Docker..."
if ! command -v docker &> /dev/null; then
    echo "Docker chưa được cài đặt. Bạn có muốn cài đặt Docker không? (y/n)"
    read -r INSTALL_DOCKER
    if [[ "$INSTALL_DOCKER" =~ ^[Yy]$ ]]; then
        echo "Đang cài đặt Docker..."
        sudo apt remove -y docker docker-engine docker.io containerd runc
        sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt update
        sudo apt install -y docker-ce docker-ce-cli containerd.io
        sudo docker --version
    else
        echo "Thoát script. Vui lòng cài đặt Docker và chạy lại."
        exit 1
    fi
fi

# Kiểm tra xem Screen đã được cài đặt chưa
echo "Đang kiểm tra Screen..."
if ! command -v screen &> /dev/null; then
    echo "Screen chưa được cài đặt. Đang cài đặt Screen..."
    sudo apt install -y screen
fi

# Các chức năng quản lý OpenLedger
install_openledger() {
    # Cài đặt các gói phụ thuộc
    echo "Đang cài đặt các gói phụ thuộc..."
    sudo apt-get update
    sudo apt install -y libgtk-3-0 libnotify4 libnss3 libxss1 libxtst6 xdg-utils libatspi2.0-0 libsecret-1-0
    sudo apt-get install -f
    sudo apt-get install -y desktop-file-utils unzip libgbm-dev libasound2

    # Tải và giải nén OpenLedger
    echo "Đang tải OpenLedger..."
    wget https://cdn.openledger.xyz/openledger-node-1.0.0-linux.zip -O openledger-node-1.0.0-linux.zip
    if [ $? -ne 0 ]; then
        echo "Lỗi: Không tải được OpenLedger. Vui lòng kiểm tra URL."
        exit 1
    fi

    echo "Đang giải nén gói OpenLedger..."
    unzip openledger-node-1.0.0-linux.zip -d openledger
    if [ $? -ne 0 ]; then
        echo "Lỗi: Không giải nén được gói OpenLedger. Vui lòng kiểm tra tệp đã tải xuống."
        exit 1
    fi

    # Tìm và cài đặt gói .deb
    echo "Đang tìm gói OpenLedger .deb..."
    DEB_PATH=$(find openledger -name "openledger-node-1.0.0.deb" | head -n 1)

    if [ -z "$DEB_PATH" ]; then
        echo "Lỗi: Không tìm thấy gói .deb trong các tệp đã giải nén."
        exit 1
    fi

    echo "Đang cài đặt OpenLedger từ $DEB_PATH..."
    cd openledger
    sudo apt install -y "$DEB_PATH"  
    sudo dpkg -i openledger-node-1.0.0.deb
    if [ $? -ne 0 ]; then
        echo "Lỗi: Không cài đặt được OpenLedger. Đang cố gắng cấu hình lại các gói..."
        sudo dpkg --configure -a
    fi

    echo "Cài đặt OpenLedger thành công."

    # Khởi chạy OpenLedger trong phiên Screen mới
    echo "Đang khởi chạy OpenLedger trong phiên Screen tên 'ol'..."
    screen -S ol -d -m openledger-node --no-sandbox
    echo "OpenLedger đang chạy trong phiên Screen 'ol'."
}

restart_openledger() {
    echo "Đang dừng OpenLedger..."
    stop_openledger  
    echo "Đang khởi động lại OpenLedger..."
    screen -S ol -d -m openledger-node --no-sandbox  
    echo "OpenLedger đã được khởi động lại trong phiên Screen 'ol'."
}

stop_openledger() {
    echo "Đang dừng OpenLedger..."
    screen -S ol -X quit  # screen
    # Dừng các tiến trình liên quan đến OpenLedger
    pkill -f openledger-node
    echo "Tất cả các tiến trình OpenLedger đã dừng."
}

remove_openledger() {
    echo "Đang gỡ bỏ OpenLedger..."
    sudo dpkg -r openledger-node  
    # Xóa các tệp liên quan
    rm -rf openledger-node-1.0.0-linux.zip openledger
    echo "OpenLedger đã được gỡ bỏ cùng với các tệp liên quan."
}

# Menu chính
echo "Vui lòng chọn một tùy chọn:"
echo "1. Cài đặt OpenLedger"
echo "2. Khởi động lại OpenLedger"
echo "3. Dừng OpenLedger"
echo "4. Gỡ bỏ OpenLedger"
read -r OPTION

case $OPTION in
    1)
        install_openledger
        ;;
    2)
        restart_openledger
        ;;
    3)
        stop_openledger
        ;;
    4)
        remove_openledger
        ;;
    *)
        echo "Tùy chọn không hợp lệ."
        ;;
esac
