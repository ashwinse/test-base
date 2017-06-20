#!/bin/bash
fileName1=$1
fileName2=$2
fileName3=$3

echo "=====Starting Script execution======"
sudo apt-get -y update || exit 1;
echo "===== Completed packages update =====";

touch $fileName1
touch $fileName2
touch $fileName3