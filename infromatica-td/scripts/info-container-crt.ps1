workflow container3 {
    param(
     
       

        [Parameter(Mandatory=$true)]
        [string]
        $src1Container,

        [Parameter(Mandatory=$true)]
        [string]
        $src2Container,

        [Parameter(Mandatory=$true)]
        [string]
        $destContainer,

        [Parameter(Mandatory=$true)]
        [string]
        $source1StorageAccountName,

        [Parameter(Mandatory=$true)]
        [string]
        $source1StorageAccountKey,

        [Parameter(Mandatory=$true)]
        [string]
        $source2StorageAccountName,

        [Parameter(Mandatory=$true)]
        [string]
        $source2StorageAccountKey,

        [Parameter(Mandatory=$true)]
        [string]
        $destStorageAccountName,

        [Parameter(Mandatory=$true)]
        [string]
        $destStorageAccountKey

        
    )

    InlineScript{

   
    $src1Container = $Using:src1Container
    $src2Container = $Using:src2Container
    $destContainer = $Using:destContainer
	$source1StorageAccountName = $Using:source1StorageAccountName
    $source1StorageAccountKey = $Using:source1StorageAccountKey
    $source2StorageAccountName = $Using:source2StorageAccountName
    $source2StorageAccountKey = $Using:source2StorageAccountKey
    $destStorageAccountName = $Using:destStorageAccountName
    $destStorageAccountKey = $Using:destStorageAccountKey

    Write-Output $adfStorageAccName,
    Write-Output $adfStorageAccKey

    $storageCtx = New-AzureStorageContext -StorageAccountName $adfStorageAccName -StorageAccountKey $adfStorageAccKey
	
    New-AzureStorageContainer -Name "adfgetstarted" -Context $storageCtx

    }
    
}