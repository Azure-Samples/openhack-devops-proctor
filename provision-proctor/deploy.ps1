Param(
     [string] [Parameter(Mandatory=$true)] $Location,
     [string] [parameter(Mandatory=$true)] $Number,
     [string] [parameter(Mandatory=$true)] $PublicKey
)

$ErrorActionPreference = 'Stop'

# Input your values here if desired to manally specify instead of passing as parameters
$num = $Number
$publicKey = $PublicKey
$location = $Location 

# Leave the rest of the script alone
$resourceGroupName = "ProctorResource" + $num
$environmentHeader = "procoh"
$cosmosdbAccountName = $environmentHeader + "db" + $num
$functionName = $environmentHeader + "fn" + $num
$keyvaultName = $environmentHeader + "kv" + $num
$ADAppName = $environmentHeader + "app" + $num
$ADAppPass = $environmentHeader + "pass" + $num
$AKSDnsNamePrefix = "procohaks" + $num
$acrName = "procohacr" + $num
$PackageUrl =  "https://github.com/Azure-Samples/openhack-devops-proctor/blob/master/leaderboard/api/Binaries/backend-1.0.0.zip?raw=true"

# Register services
Register-AzureRmResourceProvider -ProviderNamespace Microsoft.DocumentDB
Register-AzureRmResourceProvider -ProviderNamespace Microsoft.ContainerRegistry

$RGNameCosmosDB = $ResourceGroupName + '-cosmosdb' 
Get-AzureRmResourceGroup -Name $RGNameCosmosDB -ErrorVariable notPresent -ErrorAction SilentlyContinue

if($notPresent)
{
    Write-Output ""
    Write-Output "**************************************************************************************************"
    Write-Output "* Creating the resource group for CosmosDB..."
    Write-Output "**************************************************************************************************"    
    New-AzureRmResourceGroup -Name $RGNameCosmosDB -Location $Location
}

# Creating CosmosDB
Write-Output ""
Write-Output "**************************************************************************************************"
Write-Output "* Creating a CosmosDB..."
Write-Output "**************************************************************************************************"

Function Get-PrimaryKey
{
    [CmdletBinding()]
  Param
  (
        [Parameter(Mandatory=$true)][String]$DocumentDBApi,
        [Parameter(Mandatory=$true)][String]$ResourceGroupName,
        [Parameter(Mandatory=$true)][String]$CosmosdbAccountName
    )
    try
    {
  
        $keys=Invoke-AzureRmResourceAction -Action listKeys -ResourceType "Microsoft.DocumentDb/databaseAccounts" -ApiVersion $DocumentDBApi -ResourceGroupName $RGNameCosmosDB -Name $CosmosdbAccountName -Force
        $connectionKey=$keys[0].primaryMasterKey
        return $connectionKey
    }
    catch 
    {
        Write-Host "ErrorStatusDescription:" $_
    }
}

$locations = @(@{"locationName"=$Location; "failoverPriority"=0})

$consistencyPolicy = @{"defaultConsistencyLevel"="Session";
                        "maxIntervalInSeconds"="10";
                        "maxStalenessPrefix"="200"}

$DBProperties = @{"databaseAccountOfferType"="Standard";
                    "locations"=$locations;
                    "consistencyPolicy"=$consistencyPolicy
                    }

New-AzureRmResource -ResourceType "Microsoft.DocumentDb/databaseAccounts"`
                    -ApiVersion "2015-04-08"`
                    -ResourceGroupName $RGNameCosmosDB `
                    -Location $Location `
                    -Name $cosmosdbAccountName `
                    -Properties $DBProperties `
                    -Force

## Retrive CosmosDB ConnectionString
$cosmosPrimaryKey = Get-PrimaryKey -DocumentDBApi "2015-04-08" -ResourceGroupName $RGNameCosmosDB -CosmosdbAccountName $cosmosdbAccountName
$cosmosDBConnectionString = "AccountEndpoint=https://" + $cosmosdbAccountName + ".documents.azure.com:443/;AccountKey=" + $cosmosPrimaryKey + ";"
$cosmosDBEndpoint = "https://" + $cosmosdbAccountName + ".documents.azure.com:443/"

# Storage Account for downloading function within the ARM template
Write-Output ""
Write-Output "**************************************************************************************************"
Write-Output "* Provisioning Storage Account for downloading contents ..."
Write-Output "**************************************************************************************************"

$random = Get-Random -minimum 1000000 -maximum 9999999;([String]$random).SubString(1,6)
$storageName = $FunctionAppBaseName + $random

$contentsStorageName = $EnvironmentHeader + $random

New-AzureRmStorageAccount -ResourceGroupName $RGNameCosmosDB -Name $contentsStorageName -Location $Location -SkuName Standard_LRS

# Create a Function App with Function App V2
# This ARM temaplate create Azure Functions with a Service Principal to access the KeyVault.
# Set AppSettings to the Function App
Write-Output ""
Write-Output "**************************************************************************************************"
Write-Output "* Provisioning Azure Functions (v2)..."
Write-Output "**************************************************************************************************"

$currentSubscriptionId = (Get-AzureRmContext).Subscription.Id
$hostingPlanName = $functionName + "Plan"

# Install Newton to handle json
# You need Admin Priviledge

$module = import-module newtonsoft.json -ErrorAction SilentlyContinue -PassThru
if(!$module)
{
    Write-Output "installing newtonsoft.json"
    Install-Module newtonsoft.json -Scope CurrentUser -Force
    import-module newtonsoft.json
}

# compose KeyVault url
$keyVaultUrl = "https://" + $KeyVaultName + ".vault.azure.net"

$functionTemplate = $PSScriptRoot + '\scripts\template.json'
New-AzureRmResourceGroupDeployment -Name LeaderBoardBackendDeployment -ResourceGroup $RGNameCosmosDB -Templatefile $functionTemplate -functionName $functionName -storageName $StorageName -hostingPlanName $hostingPlanName -location $Location -sku Standard -workerSize 0 -serverFarmResourceGroup $RGNameCosmosDB -skuCode "S1" -subscriptionId $currentSubscriptionId -cosmosDBEndpoint $cosmosDBEndpoint -cosmosPrimaryKey $cosmosPrimaryKey -keyVaultUrl $keyVaultUrl -packageUrl $PackageUrl 

# Get the Principal Id and Tenant Id

# If we can't use the Preview Release, this strategy comes.
# Export-AzureRmResourceGroup -ResourceGroupName $ResourceGroupName -Path "$pwd\.current.json"

# It requires Preview Release of WebSites
# https://github.com/Azure/azure-powershell/issues/4808
# With Admin priviledge

$module = import-module AzureRM.Websites -ErrorAction SilentlyContinue -PassThru
if(!$module)
{
    Write-Output "Installing AzureRM.Websites"
    Install-Module AzureRM.Websites -Repository PSGallery -AllowPrerelease -Force
}

# $app = Get-AzureRmWebApp -ResourceGroupName $RGNameCosmosDB -Name $functionName

# Create and Configure KeyVault
Write-Output ""
Write-Output "**************************************************************************************************"
Write-Output "* Provisioning the KeyVault with CosmosDB ConnectionString ..."
Write-Output "**************************************************************************************************"

# Set some Secrets

New-AzureRmKeyVault -Name $KeyVaultName -ResourceGroupName $RGNameCosmosDB -Location $Location

# Add Service Principal To the KeyVault

# # If I doesn't stop in here, sometimes, we can't refer the ObjectId
# Write-Output "Waiting for Service Principal is generated..."
# Start-Sleep -Seconds 30

# Set-AzureRmKeyVaultAccessPolicy -VaultName $KeyVaultName -ObjectId $app.Identity.PrincipalId -PermissionsToSecrets Get

# Upload Secrets

$cosmosDBConnectionStringSecretValue = ConvertTo-SecureString $cosmosDBConnectionString -AsPlainText -Force
Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name 'shared-cosmosDB-ConnectionString' -SecretValue $cosmosDBConnectionStringSecretValue

# Set KeyVault URl 

# These logic for Set KeyVault URL doesn't work. 
# I set the KeyVault URL at the ARM tempate section instead. 
# When I solve this problem, I'll back to this logic.
#
# $webApp = Get-AzureRMWebApp -ResourceGroupName $ResourceGroupName -Name $FunctionAppBaseName 
#$appSettingList = $webApp.SiteConfig.AppSettings
#
#$appSettings = @{}
#
#ForEach ($kvp in $appSettingList) {
#    $appSettings[$kvp.Name] = $kvp.Value
#}
#
#$appSettings["KeyVaultUri"] = $keyvault.VaultUri
#
#$res = Set-AzureRmWebApp -AppSettings $appSettings -ResourceGroupName $ResourceGroupName -Name $FunctionAppBaseName 
#

# Create a Service Principal with Application
# Write-Output ""
# Write-Output "**************************************************************************************************"
# Write-Output "* Provisioning a Service Principal for the AKS Cluster..."
# Write-Output "**************************************************************************************************"

# $secureStringPassword = ConvertTo-SecureString -String $ADAppPass -AsPlainText -Force
#$IdentifierUris = "http://" + $ADAppName
#$ADApplication = New-AzureRmADApplication -DisplayName $ADAppName -HomePage "http://www.microsoft.com" -IdentifierUris $IdentifierUris -Password $secureStringPassword
#Add-Type -AssemblyName System.Web
#$password = [System.Web.Security.Membership]::GeneratePassword(16,3)
#$servicePrincipal = New-AzureRmADServicePrincipal -ApplicationId $ADApplication.ApplicationId -Password $password

# $servicePrincipal = Get-AzureRmADServicePrincipal -DisplayName $ADAppName 

# if (!$servicePrincipal)
# {
#     # If the service principal doesn't exist yet, create it
#     $servicePrincipal = New-AzureRmADServicePrincipal -DisplayName $ADAppName -Password $secureStringPassword
# }

# $ADApplication = Get-AzureRmADApplication -ApplicationId $servicePrincipal.ApplicationId

# Write-Output $servicePrincipal

# Write-Output ""
# Write-Output "**************************************************************************************************"
# Write-Output "* Assinging Contributor role for the Resource Group..."
# Write-Output "**************************************************************************************************"

# Write-Output "Waiting for Service Principal is generated..."
# Start-Sleep -Seconds 30

# $RGNameAKS = $ResourceGroupName + '-aks' 
# Get-AzureRmResourceGroup -Name $RGNameAKS -ErrorVariable notPresent -ErrorAction SilentlyContinue

# if($notPresent)
# {
#     Write-Output ""
#     Write-Output "**************************************************************************************************"
#     Write-Output "* Creating the resource group for AKS Cluster..."
#     Write-Output "**************************************************************************************************"
#     New-AzureRmResourceGroup -Name $RGNameAKS -Location $Location -Force   
# }

# Write-Output ""
# Write-Output "**************************************************************************************************"
# Write-Output "* Provisioning the AKS Cluster..."
# Write-Output "**************************************************************************************************"

# $AKSPublicKey = Get-Content -Path $AKSPublicKeyPath
# $secureStringPublicKey = ConvertTo-SecureString -String $publicKey -AsPlainText -Force
# $secureStringServicePrincipalId = ConvertTo-SecureString -string $ADApplication.ApplicationId -AsPlainText -Force
# $secureStringServicePrincipalPass = ConvertTo-SecureString -string $ADAppPass -AsPlainText -Force

# $aksTemplate = $PSScriptRoot + '\scripts\aks.json'
# New-AzureRmResourceGroupDeployment -Name LeaderBoardAKSDeployment -ResourceGroup $RGNameAKS -Templatefile $aksTemplate -dnsNamePrefix $AKSDnsNamePrefix -sshRSAPublicKey $secureStringPublicKey -servicePrincipalClientId $secureStringServicePrincipalId -servicePrincipalClientSecret $secureStringServicePrincipalPass  -DeploymentDebugLogLevel All

# $RGNameACR = $ResourceGroupName + '-acr' 
# Get-AzureRmResourceGroup -Name $RGNameACR -ErrorVariable notPresent -ErrorAction SilentlyContinue

# if($notPresent)
# {
#     Write-Output ""
#     Write-Output "**************************************************************************************************"
#     Write-Output "* Creating the resource group for ACR..."
#     Write-Output "**************************************************************************************************"
#     New-AzureRmResourceGroup -Name $RGNameACR -Location $Location -Force   
# }

# Write-Output ""
# Write-Output "**************************************************************************************************"
# Write-Output "* Provisioning the ACR..."
# Write-Output "**************************************************************************************************"
# $ACRTemplate = $PSScriptRoot + '\scripts\acr.json'
# New-AzureRmResourceGroupDeployment -Name LeaderBoardACRDeployment -ResourceGroup $RGNameACR -Templatefile $ACRTemplate -acrName $ACRName 

# $message =  "Done! Please refer " + $RGNameACR + " On your subscription"
# Write-Output $message

# $RGNameACR = $ResourceGroupName + '-acr' 
# Get-AzureRmResourceGroup -Name $RGNameACR -ErrorVariable notPresent -ErrorAction SilentlyContinue

# if($notPresent)
# {
#     Write-Output ""
#     Write-Output "**************************************************************************************************"
#     Write-Output "* Creating the resource group for ACR..."
#     Write-Output "**************************************************************************************************"
#     New-AzureRmResourceGroup -Name $RGNameACR -Location $Location -Force   
# }