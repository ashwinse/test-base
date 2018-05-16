Write-Host ********************* Azure CLI 2.0 ********************************************************


$subsId="7eab3893-bd71-4690-84a5-47624df0b0e5"
$appId="8dd7d328-2bdb-4389-9085-5733171b54a0" # Enter app Id
$appSecret="6c2dc7WiIEXbaBHFj8JSIJ3R2V3FJrtxe2KQrZRqZuI=" # Enter app secret key
$tenantId="dcf9e4d3-f44a-4c28-be12-8245c0d35668" # Enter tenant id
$region='westus' #Specify Azure region

$charSet = "abcdefghijklmnopqrstuvwxyz0123456789".ToCharArray()
$uniqueString = ""
for ($i = 0; $i -lt 5; $i++ ) {
    $uniqueString += $charSet | Get-Random
}

$diskName="mngDisk-" + $uniqueString
$rgName="azCliStore-" + $uniqueString
############## Login to Azure #####################################################
Write-Host Login into Azure account.
$login=az login --service-principal -u $appId -p $appSecret --tenant $tenantId
az account set -s $subsId
az account show
Write-Host Successfully Logged into Azure account.

################ Resource group ##########################
Write-Host Creating a resource group with name $rgName in region $region
$rg=az group create -n $rgName -l $region

Write-Host ********************* Your managed disk is starting to deploy *********************************
################ Managed Disk ##########################

az disk create -n $diskName -g $rgName --sku Standard_LRS --size-gb 127
