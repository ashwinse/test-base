wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
 
# Register the Microsoft repository GPG keys
sudo dpkg -i packages-microsoft-prod.deb
 
# Update the list of products
sudo apt-get update
 
# Install PowerShell
sudo apt-get install -y powershell
 
# Start PowerShell
pwsh
 
Connect-AzAccount -TenantId 6cddddfe-4063-4a67-81ce-601e09967651 -Subscription 763af79a-75ad-470a-94fc-4a7151d8052d