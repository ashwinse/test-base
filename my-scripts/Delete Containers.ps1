$storageAccountName = "ashbro1"
$storageAccountKey = "u4rmAiB9zsT9kBba5BMBwfSR8+A57p8OCIDdZ57RmQAWdLqyqSNDUDZV+gg+LdvVJ6rLvLbpVXbP4tQiXG3+zQ=="
$regex = "ash-*"

$storageContex = New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey

$containerlist = Get-AzureStorageContainer -Context $storageContex

$listLength = $containerlist.name.Length

for ($i=0; $i -le $listLength; $i++ ) {
    if ($containerlist.name[$i] -match $regex ){
        #Remove-AzureStorageContainer -Name $containerlist.name[$i] -Context $storageContex
        Write-Host "Successfully Removed" $containerlist.name[$i] "Container."
    }
}