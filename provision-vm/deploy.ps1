Param(
     [string] [Parameter(Mandatory=$true)] $Location,
     [string] [parameter(Mandatory=$true)] $Number,
     [string] [parameter(Mandatory=$true)] $PublicKey,
     [string] [parameter(Mandatory=$true)] $AdminPassword
)

$num = $Number #"116"
$location = $Location #"eastus"
$adminPassword = $AdminPassword #'AzureP@ssw0rd!'
$AdminUser = 'azureuser'
$environmentHeader = "procoh"
$proctorVMName = $environmentHeader + "vm" + $num
$resourceGroupName = "ProctorResource" + $num

Write-Output ""
Write-Output "**************************************************************************************************"
Write-Output "* Provisioning the Proctor VM..."
Write-Output "**************************************************************************************************"

$RGNameVM = $resourceGroupName + '-proctorvm' 
Get-AzureRmResourceGroup -Name $RGNameVM -ErrorVariable notPresent -ErrorAction SilentlyContinue

if($notPresent)
{
    New-AzureRmResourceGroup -Name $RGNameVM -Location $Location -Force   
}
$random = Get-Random -minimum 1000000 -maximum 9999999;([String]$random).SubString(1,6)
$vmStorageName = $proctorVMName + $random
New-AzureRmStorageAccount -Name $vmStorageName -ResourceGroupName $RGNameVM -Location $Location -SkuName Premium_LRS -Kind Storage

$vmTemplate = $PSScriptRoot + '\azuredeploy.json'

New-AzureRmResourceGroupDeployment -Name "ProctorVMDeployment" -ResourceGroup $RGNameVM -Templatefile $vmTemplate -StorageAccountName $vmStorageName -adminUsername $AdminUser -adminPassword (ConvertTo-SecureString $adminPassword -AsPlainText -Force) -dnsNameForPublicIP $proctorVMName -ubuntuOSVersion "16.04.0-LTS"
