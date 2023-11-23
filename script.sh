sudo apt-get update
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg  

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update





sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose -y


sudo apt install unzip zip -y 

sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip -o awscliv2.zip
sudo ./aws/install --update

sudo aws ecr get-login-password --region us-west-2 | sudo docker login --username AWS --password-stdin 644435390668.dkr.ecr.us-west-2.amazonaws.com


sleep 15


cd ted_search_bstrp

sudo docker compose up  -d 



# sudo docker run hello-world

# sudo groupadd docker



# sudo usermod -aG docker $USER

# newgrp docker