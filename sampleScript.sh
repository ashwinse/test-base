#!/bin/bash
fileName1=$1
fileName2=$2
fileName3=$3

echo "===== Starting packages update ======"
sudo apt-get -y update || exit 1;
echo "===== Completed packages update =====";
echo "===== Starting packages installation =====";
sudo apt-get -y install npm=3.5.2-0ubuntu4 git=1:2.7.4-0ubuntu1 || unsuccessful_exit "package install 1 failed";
sudo update-alternatives --install /usr/bin/node nodejs /usr/bin/nodejs 100 || unsuccessful_exit "package install 2 failed";
echo "===== Completed packages installation =====";

touch $fileName1
touch $fileName2
touch $fileName3