$rgLocation = 'westus'
$count = 2
$appId = 'c2f03944-b80f-420d-9c90-37f4f5ed9459'
$secretKey = 'k7KsOwAFfwmx1LQfZLdD1EalooFFlw/UFlZlIyMCYyo='
$tenantId = 'dcf9e4d3-f44a-4c28-be12-8245c0d35668'
$charSet = "abcdefghijklmnopqrstuvwxyz0123456789".ToCharArray()
$vmSize = "Standard_A1"
$uniqueString = ""

for ($i = 0; $i -lt 7; $i++ ) {
    $uniqueString += $charSet | Get-Random
}

#Login in to Azure RM account=====================================================================================

Write-Host Login into Azure account

$secretKey = ConvertTo-SecureString $secretKey -AsPlainText -Force
$creds = New-Object -TypeName PSCredential -ArgumentList $appId, $secretKey
Login-AzureRmAccount -ServicePrincipal -Credential $creds -TenantId $tenantId

Write-Host Logged into Azure account successfully.

$rgName = 'myRg-' + $uniqueString
$vnetName = 'sys-' + $uniqueString + '-vnet'
$pipName = 'sys-' + $uniqueString + '-pip'
$nsgName = 'sys-' + $uniqueString + '-nsg'
$nicName = 'sys-' + $uniqueString + '-nic'
$avsetName = 'sys-' + $uniqueString + '-avset'
$vmName = 'sys-' + $uniqueString + '-vm'
#Select a subscription
#Select-AzureRmSubscription -SubscriptionName $subscriptionName

#Create New resource group==========================================================================================

New-AzureRmResourceGroup -Name $rgName -Location $rgLocation

Write-Host Resource Group created successfully with name $rgName

#Create Availability set============================================================================================

Write-Host Provisioning Availability Set....

$avset = New-AzureRmAvailabilitySet -Name $avsetName -Location $rgLocation -PlatformUpdateDomainCount 5 -PlatformFaultDomainCount 2 -ResourceGroupName $rgName -Sku Aligned

Write-Host Availability Set deployed successfully.

#Create a network security group=====================================================================================

Write-Host Provisioning Network security group....

$nsgRule1 = New-AzureRmNetworkSecurityRuleConfig -Name 'default-allow-rdp' -Protocol Tcp -Priority 100 -SourcePortRange * -DestinationPortRange 3389 -SourceAddressPrefix * -DestinationAddressPrefix * -Access Allow -Direction Inbound
$nsgRule2 = New-AzureRmNetworkSecurityRuleConfig -Name 'http' -Protocol Tcp -Priority 102 -SourcePortRange * -DestinationPortRange 80 -SourceAddressPrefix * -DestinationAddressPrefix * -Access Allow -Direction Inbound
$nsg = New-AzureRmNetworkSecurityGroup -Name $nsgName -Location $rgLocation -SecurityRules $nsgRule1, $nsgRule2 -ResourceGroupName $rgName 

Write-Host Network security group deployed successfully.
 
#Create a Virtual Network============================================================================================

Write-Host Provisioning Virtual Network....

$subnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name 'subnet-1' -AddressPrefix '10.2.0.0/24'
$vnet = New-AzureRmVirtualNetwork -Name $vnetName -AddressPrefix '10.2.0.0/16' -ResourceGroupName $rgName -Location $rgLocation -Subnet $subnetConfig

Write-Host Virtual Network deployed successfully. 

for($x = 1; $x -le $count; $x++){

#Create a Public IP Address==========================================================================================

Write-Host Provisioning Public IP Address....

$dnsPrefix = 'sys-' + $uniqueString
$pip = New-AzureRmPublicIpAddress -Name $pipName$x -AllocationMethod Dynamic -DomainNameLabel $dnsPrefix$x -Location $rgLocation -ResourceGroupName $rgName

Write-Host Public IP Address deployed successfully. 

 

#Create network Interface card========================================================================================

Write-Host Provisioning Network Interface....

$nic = New-AzureRmNetworkInterface -Name $nicName$x -Location $rgLocation -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id -IpConfigurationName 'ipconfif1' -ResourceGroupName $rgName

Write-Host Network Interface deployed successfully. 

#Create VM============================================================================================================

Write-Host Provisioning Virtual Machine....

$vmpass = ConvertTo-SecureString "Ashpassword123" -AsPlainText -Force
$vmcreds = New-Object -TypeName pscredential -ArgumentList "ashuser", $vmpass
$osDiskName = 'sys-' + $uniqueString + 'OsDisk' + $x
$vmConfig = New-AzureRmVMConfig -VMName $vmName$x -VMSize $vmSize -AvailabilitySetId $avset.Id
$vmConfig = Set-AzureRmVMBootDiagnostics -VM $vmConfig -Disable
$vmConfig = Set-AzureRmVMOperatingSystem -VM $vmConfig -Windows -ComputerName 'sys-vm' -Credential $vmcreds -ProvisionVMAgent   
$vmConfig = Set-AzureRmVMSourceImage -VM $vmConfig -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2016-Datacenter -Version latest 
$vmConfig = Add-AzureRmVMNetworkInterface -VM $vmConfig -Id $nic.Id
$vm = New-AzureRmVM -VM $vmConfig -Location $rgLocation -ResourceGroupName $rgName 

Write-Host Virtual Machine deployed successfully. 

}