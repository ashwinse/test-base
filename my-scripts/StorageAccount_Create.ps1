# Script to create Storage account and then create a container.


$charSet = "abcdefghijklmnopqrstuvwxyz0123456789".ToCharArray()
$uniqueString = ""
for ($i = 0; $i -lt 7; $i++ ) {
    $uniqueString += $charSet | Get-Random
}


$rgLocation = 'westus'
$rgName = 'myRg-' + $uniqueString
$storageAccountName = 'stor' + $uniqueString
$containerName = 'backup'
$appId = 'c2f03944-b80f-420d-9c90-37f4f5ed9459'
$secretKey = 'k7KsOwAFfwmx1LQfZLdD1EalooFFlw/UFlZlIyMCYyo='
$tenantId = 'dcf9e4d3-f44a-4c28-be12-8245c0d35668'
$secretKey = ConvertTo-SecureString $secretKey -AsPlainText -Force
$creds = New-Object -TypeName PSCredential -ArgumentList $appId, $secretKey
Login-AzureRmAccount -ServicePrincipal -Credential $creds -TenantId $tenantId

#Create New resource group==========================================================================================

New-AzureRmResourceGroup -Name $rgName -Location $rgLocation
Write-Host Resource Group created successfully with name $rgName

#Create New storage account==========================================================================================
$StorageAccount = @{
    ResourceGroupName = $rgname;
    Name = $storageAccountName
    SkuName = 'Standard_LRS';
    Location = $rgLocation;
}
New-AzureRmStorageAccount @StorageAccount;
Write-Host Created storage account successfully with name $storageAccountName

#Get New storage accounts primary key ==========================================================================================
$Keys = Get-AzureRmStorageAccountKey -ResourceGroupName $rgName -Name $storageAccountName;
$StorageContext = New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $Keys[0].Value;

#Create a container in that storage account ==========================================================================================
New-AzureStorageContainer -Context $StorageContext -Name $containerName;

Write-Host Created container successfully with name $containerName