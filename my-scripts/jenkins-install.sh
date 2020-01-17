sudo apt-get -y install openjdk-8-jdk apt-transport-https wget
sudo wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
echo deb https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list
sudo apt-get update
sudo apt-get install -y jenkins
sudo ufw allow 8080
sudo ufw allow 22
sudo ufw enable
sudo systemctl start jenkins
sudo cat /var/lib/jenkins/secrets/initialAdminPassword | sudo tee ~/jenkinsAdminPassword