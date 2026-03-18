#!/bin/bash
set -e

echo "🔹 Updating system..."
sudo apt update

echo "🔹 Installing required packages..."
sudo apt install -y ca-certificates curl gnupg lsb-release

echo "🔹 Adding Docker GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "🔹 Adding Docker repository..."
echo \
"deb [arch=$(dpkg --print-architecture) \
signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo $VERSION_CODENAME) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "🔹 Installing Docker..."
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

echo "🔹 Enabling Docker..."
sudo systemctl enable docker
sudo systemctl start docker

echo "🔹 Adding current user to Docker group..."
sudo usermod -aG docker $USER

echo "🔹 Pulling Jenkins image..."
sudo docker pull jenkins/jenkins:lts

echo "🔹 Creating Jenkins volume..."
sudo docker volume create jenkins_home

echo "🔹 Running Jenkins container..."
sudo docker run -d \
  --name jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts

echo "🔹 Jenkins is starting..."
echo "🌐 Access Jenkins at: http://localhost:8080"

echo "🔹 To get admin password, run:"
echo "docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword"

echo "✅ Installation Complete!"
