Write-Host ********************* Azure CLI 2.0 ********************************************************
## Author : Ashwin Sebastian


$subsId="7eab3893-bd71-4690-84a5-47624df0b0e5"
$appId="8dd7d328-2bdb-4389-9085-5733171b54a0"  # Enter service principal app id
$appSecret="6c2dc7WiIEXbaBHFj8JSIJ3R2V3FJrtxe2KQrZRqZuI=" # Enter app secret key
$tenantId="dcf9e4d3-f44a-4c28-be12-8245c0d35668" # Enter tenant id
$vmName='vm'
$vmImage='Win2012R2Datacenter'
$vmusername='adminuser'
$vmpassword='Ashpassword123'
$region='westus' 
$charSet = "abcdefghijklmnopqrstuvwxyz0123456789".ToCharArray()
$uniqueString = ""

for ($i = 0; $i -lt 5; $i++ ) {
    $uniqueString += $charSet | Get-Random
}

$rgName='azCliRG-' + $uniqueString

Write-Host Login into Azure account.
$login=az login --service-principal -u $appId -p $appSecret --tenant $tenantId
Write-Host Successfully Logged into Azure account.

Write-Host Setting default azure subscription to $subsId
az account set -s $subsId

Write-Host Creating a resource group with name $rgName in region $region
az group create -n $rgName -l $region

Write-Host ********************* Your resource are starting to deploy *********************************

Write-Host Creating a Windows VM
$vmconfig=az vm create --resource-group $rgName --name $vmName --image $vmImage --admin-username $vmusername --admin-password $vmpassword
$port=az vm open-port --port 80 --resource-group $rgName --name $vmName
Write-Host Successfully created a Windows VM

Write-Host Creating DSC extension...

$settings='{\"modulesUrl\":\"https://github.com/sysgain/arm-presentation/blob/master/dsc/dscconfig.zip?raw=true\",\"configurationFunction\":\"dscconfig.ps1\dscconfig\",\"properties\":{\"nodeName\":\"' + $vmName + '\",\"sourcePath\":\"https://github.com/sysgain/arm-presentation/blob/master/website.zip?raw=true\"}}"'
$dsc=az vm extension set --name DSC -g $rgName --vm-name $vmName --publisher Microsoft.Powershell --version 2.20 --settings $settings

Write-Host ********************* Your resources have deployed successfully !!! ************************