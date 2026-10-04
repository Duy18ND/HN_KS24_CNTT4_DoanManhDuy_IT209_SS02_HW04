#!/bin/bash

# 1. Tạo 2 thư mục
sudo mkdir -p /var/www/beta-app/html/
sudo mkdir -p /var/www/internal-app/html/

# 2. Tạo index.html riêng cho từng app
echo "<h1>Beta App</h1>" | sudo tee /var/www/beta-app/html/index.html > /dev/null
echo "<h1>Internal App</h1>" | sudo tee /var/www/internal-app/html/index.html > /dev/null

# 3 & 4. Copy cấu hình Nginx và tạo symbolic link
# (Giả định rằng bạn đã upload file multi-port.conf lên server và chạy script này ở cùng thư mục chứa file đó)
sudo cp multi-port.conf /etc/nginx/sites-available/multi-port.conf
if [ ! -L /etc/nginx/sites-enabled/multi-port.conf ]; then
    sudo ln -s /etc/nginx/sites-available/multi-port.conf /etc/nginx/sites-enabled/multi-port.conf
fi

# 5. Kiểm tra và reload Nginx
echo "Kiểm tra cấu hình Nginx:"
sudo nginx -t
echo "Reloading Nginx..."
sudo systemctl reload nginx

# 6. Mở UFW
sudo ufw allow 8080/tcp
sudo ufw allow 8090/tcp
echo "Trạng thái UFW:"
sudo ufw status

# 8. Kiểm tra Nginx đang lắng nghe
echo "Các port Nginx đang lắng nghe:"
sudo ss -tlnp | grep nginx

# 9. Test nội bộ
echo "Test nội bộ trên cổng 8080:"
curl http://localhost:8080
echo "Test nội bộ trên cổng 8090:"
curl http://localhost:8090

echo "Setup hoàn tất! Vui lòng nhớ mở port 8080 và 8090 trên DigitalOcean Cloud Firewall."
