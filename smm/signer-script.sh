#script to generate signin key and netwowrk token
#Usage : sh signer-script.sh <ip/dnsname of the signer VM>

#!/bin/bash

# install prerequisites 
apt-get update && apt-get install -y libssl-dev libffi-dev python-dev build-essential && apt-get install -y nodejs-legacy && apt-get install -y npm

echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" | \
     sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-key adv --keyserver packages.microsoft.com --recv-keys 417A0893
sudo apt-get install apt-transport-https
sudo apt-get update && sudo apt-get install azure-cli
sudo apt-get update && sudo apt-get install azure-cli

generatornodeip=$1
serviceprincipal=$2
secretkey=$3
tenatid=$4
subscriptionid=$5
keyvaultname=$6
signerclienttoken=$7
clienttokenname=$8 
az login -u asebastian@sysgaininc.onmicrosoft.com -p Ashwinse2793
az account set -s $subscriptionid

generatornetworktoken=`az keyvault secret show --name networkToken --vault-name $keyvaultname | grep "value" | cut -d "\"" -f4`
blockchainid=`az keyvault secret show --name chaincoreid --vault-name $keyvaultname | grep "value" | cut -d "\"" -f4`


# run chaincore docker image
docker run -d -p 1999:1999 chaincore/developer:latest
sleep 30
containerId=`docker ps | cut -d " " -f1 | sed 1d`

#generator client access token / public key
cclength=`echo $clienttokenname | wc -c`
cclength1=`expr $cclength + 1`
docker exec  $containerId /usr/bin/chain/cored
signerctoken=`docker exec  $containerId /usr/bin/chain/corectl create-token $clienttokenname | cut -c1-71`

signerctoken1=`echo $signerctoken | cut -c$cclength1-`
docker exec  $containerId /usr/bin/chain/corectl config -t $generatornetworktoken -k $signerctoken1 $blockchainid http://$generatornodeip:1999
#generator blockchain_id


sudo docker restart $containerId

az keyvault secret set --name $signerclienttoken --vault-name $keyvaultname --value $signerctoken
