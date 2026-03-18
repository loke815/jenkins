#!/bin/bash
set -e

echo "🔹 Updating system..."
sudo apt update

echo "🔹 Installing dependencies..."
sudo apt install -y ca-certificates curl gnupg lsb-release ufw nginx

# -------------------------------
# Docker Installation
# -------------------------------
echo "🔹 Installing Docker..."

sudo install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
"deb [arch=$(dpkg --print-architecture) \
signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo $VERSION_CODENAME) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

sudo systemctl enable docker
sudo systemctl start docker

sudo usermod -aG docker $USER

# -------------------------------
# Firewall Setup
# -------------------------------
echo "🔹 Configuring firewall..."
sudo ufw allow OpenSSH
sudo ufw allow 80
sudo ufw allow 8080
sudo ufw --force enable

# -------------------------------
# Jenkins Setup
# -------------------------------
echo "🔹 Pulling Jenkins image..."
sudo docker pull jenkins/jenkins:lts

echo "🔹 Creating volume..."
sudo docker volume create jenkins_home

echo "🔹 Running Jenkins container..."
sudo docker run -d \
  --name jenkins \
  --restart unless-stopped \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --health-cmd="curl -f http://localhost:8080/login || exit 1" \
  --health-interval=30s \
  --health-retries=3 \
  jenkins/jenkins:lts

# -------------------------------
# Nginx Reverse Proxy
# -------------------------------
echo "🔹 Configuring Nginx..."

sudo tee /etc/nginx/sites-available/jenkins <<EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/jenkins /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

# -------------------------------
# Final Output
# -------------------------------
echo "✅ Jenkins installed successfully!"
echo "🌐 Access Jenkins via: http://<your-server-ip>"
echo ""
echo "🔑 Get admin password using:"
echo "docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword"
