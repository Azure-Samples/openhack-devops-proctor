Param(
    [string] [Parameter(Mandatory=$true)] $ResourceGroupName,
    [string] [Parameter(Mandatory=$true)] $Location,
    [string] [Parameter(Mandatory=$true)] $EnvironmentHeader,
    [string] [Parameter(Mandatory=$true)] $CosmosdbAccountName,
    [string] [Parameter(Mandatory=$true)] $FunctionAppBaseName,
    [string] [Parameter(Mandatory=$true)] $PackageUrl,
    [string] [parameter(Mandatory=$true)] $KeyVaultName,
    [string] [parameter(Mandatory=$true)] $ADAppName,
    [string] [parameter(Mandatory=$true)] $ADAppPass,
    [string] [parameter(Mandatory=$true)] $AKSPublicKeyPath,
    [string] [parameter(Mandatory=$true)] $AKSDnsNamePrefix,
    [string] [parameter(Mandatory=$true)] $ACRName,
    [string] [parameter(Mandatory=$true)] $ProctorVMHostName,
    [string] [parameter(Mandatory=$true)] $AdminUser,
    [string] [parameter(Mandatory=$true)] $AdminPassword,
    [string] [parameter(Mandatory=$true)] $ExternalKeyVaultName,
    [int] [Parameter(Mandatory=$true)] $teamNum,
    [int] [Parameter(Mandatory=$true)] $servicesPerTeam
)


# Register services

Register-AzureRmResourceProvider -ProviderNamespace Microsoft.DocumentDB
Register-AzureRmResourceProvider -ProviderNamespace Microsoft.ContainerRegistry

# NOTE: Since this script works on the VSTS, I skip the login script.
# Login-AzureRmAccount

# Create or update the resource group using the specified template file and template parameters file
Write-Output ""
Write-Output "**************************************************************************************************"
Write-Output "* Creating the resource group..."
Write-Output "**************************************************************************************************"

Get-AzureRmResourceGroup -Name $ResourceGroupName -ErrorVariable notPresent -ErrorAction SilentlyContinue

if(!$notPresent)
{
    Remove-AzureRmResourceGroup -Name $ResourceGroupName -Force
}

New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location -Force

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
  
        $keys=Invoke-AzureRmResourceAction -Action listKeys -ResourceType "Microsoft.DocumentDb/databaseAccounts" -ApiVersion $DocumentDBApi -ResourceGroupName $ResourceGroupName -Name $CosmosdbAccountName -Force
        $connectionKey=$keys[0].primaryMasterKey
        return $connectionKey
    }
    catch 
    {
        Write-Host "ErrorStatusDescription:" $_
    }
}


$locations = @(@{"locationName"="japaneast"; "failoverPriority"=0})

$consistencyPolicy = @{"defaultConsistencyLevel"="Session";
                        "maxIntervalInSeconds"="10";
                        "maxStalenessPrefix"="200"}

$DBProperties = @{"databaseAccountOfferType"="Standard";
                    "locations"=$Locations;
                    "consistencyPolicy"=$consistencyPolicy
                    }

$ResourceName = $CosmosdbAccountName
$DBProperties
New-AzureRmResource -ResourceType "Microsoft.DocumentDb/databaseAccounts"`
                    -ApiVersion "2015-04-08"`
                    -ResourceGroupName $ResourceGroupName `
                    -Location $Location `
                    -Name $CosmosdbAccountName `
                    -Properties $DBProperties `
                    -Force

## Retrive CosmosDB ConnectionString
$cosmosPrimaryKey = Get-PrimaryKey -DocumentDBApi "2015-04-08" -ResourceGroupName $ResourceGroupName -CosmosdbAccountName $CosmosdbAccountName
$cosmosDBConnectionString = "AccountEndpoint=https://" + $CosmosdbAccountName + ".documents.azure.com:443/;AccountKey=" + $cosmosPrimaryKey + ";"
$cosmosDBEndpoint = "https://" + $CosmosdbAccountName + ".documents.azure.com:443/"

# Storage Account for downloading function within the ARM template
Write-Output ""
Write-Output "**************************************************************************************************"
Write-Output "* Provisioning Storage Account for donwloading contents ..."
Write-Output "**************************************************************************************************"

$random = Get-Random -minimum 1000000 -maximum 9999999;([String]$random).SubString(1,6)
$storageName = $FunctionAppBaseName + $random

$contentsStorageName = $EnvironmentHeader + $random

$contentsStorage = New-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName -Name $contentsStorageName -Location $Location -SkuName Standard_LRS


# Create a Function App with Function App V2
# This ARM temaplate create Azure Functions with a Service Principal to access the KeyVault.
# Set AppSettings to the Function App
Write-Output ""
Write-Output "**************************************************************************************************"
Write-Output "* Provisioning Azure Functions (v2)..."
Write-Output "**************************************************************************************************"

$currentSubscriptionId = (Get-AzureRmContext).Subscription.Id
$hostingPlanName = $FunctionAppBaseName + "Plan"

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


New-AzureRmResourceGroupDeployment -Name LeaderBoardBackendDeployment -ResourceGroup $ResourceGroupName -Templatefile scripts/template.json -functionName $FunctionAppBaseName -storageName $StorageName -hostingPlanName $hostingPlanName -location $Location -sku Standard -workerSize 0 -serverFarmResourceGroup $ResourceGroupName -skuCode "S1" -subscriptionId $currentSubscriptionId -cosmosDBEndpoint $cosmosDBEndpoint -cosmosPrimaryKey $cosmosPrimaryKey -keyVaultUrl $keyVaultUrl -packageUrl $PackageUrl

# Get the Principal Id and Tenant Id

# If we can't use the Preview Release, this staretgy comes.
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

$app = Get-AzureRmWebApp -ResourceGroupName $ResourceGroupName -Name $FunctionAppBaseName


# Create and Configure KeyVault
Write-Output ""
Write-Output "**************************************************************************************************"
Write-Output "* Provisioning the KeyVault with CosmosDB ConnectionString ..."
Write-Output "**************************************************************************************************"

# Set some Secrets

$keyvault = New-AzureRmKeyVault -Name $KeyVaultName -ResourceGroupName $ResourceGroupName -Location $Location

# Add Service Principal To the KeyVault

# If I doesn't stop in here, sometimes, we can't refer the ObjectId
Write-Output "Waiting for Service Principal is generated..."
Start-Sleep -Seconds 30

Set-AzureRmKeyVaultAccessPolicy -VaultName $KeyVaultName -ObjectId $app.Identity.PrincipalId -PermissionsToSecrets Get

# Upload Secrets

$cosmosDBConnectionStringSecretValue = ConvertTo-SecureString $cosmosDBConnectionString -AsPlainText -Force
$cosmosDBConnectionStringSecret = Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name 'shared-cosmosDB-ConnectionString' -SecretValue $cosmosDBConnectionStringSecretValue

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
Write-Output ""
Write-Output "**************************************************************************************************"
Write-Output "* Provisioning a Service Principal for the AKS Cluster..."
Write-Output "**************************************************************************************************"

$IdentifierUris = "http://" + $ADAppName

$secureStringPassword = ConvertTo-SecureString -String $ADAppPass -AsPlainText -Force
#$ADApplication = New-AzureRmADApplication -DisplayName $ADAppName -HomePage "http://www.microsoft.com" -IdentifierUris $IdentifierUris -Password $secureStringPassword
#Add-Type -AssemblyName System.Web
#$password = [System.Web.Security.Membership]::GeneratePassword(16,3)
#$servicePrincipal = New-AzureRmADServicePrincipal -ApplicationId $ADApplication.ApplicationId -Password $password

$servicePrincipal = New-AzureRmADServicePrincipal -DisplayName $ADAppName -Password $secureStringPassword
$ADApplication = Get-AzureRmADApplication -ApplicationId $servicePrincipal.ApplicationId

Write-Output $servicePrincipal

Write-Output ""
Write-Output "**************************************************************************************************"
Write-Output "* Assinging Contributor role for the Resource Group..."
Write-Output "**************************************************************************************************"

Write-Output "Waiting for Service Principal is generated..."
Start-Sleep -Seconds 30

# Create an AKS
Write-Output ""
Write-Output "**************************************************************************************************"
Write-Output "* Provisioning the AKS Cluster..."
Write-Output "**************************************************************************************************"

$AKSPublicKey = Get-Content -Path $AKSPublicKeyPath
$secureStringPublicKey = ConvertTo-SecureString -String $AKSPublicKey -AsPlainText -Force
$secureStringServicePrincipalId = ConvertTo-SecureString -string $ADApplication.ApplicationId -AsPlainText -Force
$secureStringServicePrincipalPass = ConvertTo-SecureString -string $ADAppPass -AsPlainText -Force
$result = New-AzureRmResourceGroupDeployment -Name LeaderBoardAKSDeployment -ResourceGroup $ResourceGroupName -Templatefile .\scripts\aks.json -dnsNamePrefix $AKSDnsNamePrefix -sshRSAPublicKey $secureStringPublicKey -servicePrincipalClientId $secureStringServicePrincipalId -servicePrincipalClientSecret $secureStringServicePrincipalPass  -DeploymentDebugLogLevel All

# Create an ACR
Write-Output ""
Write-Output "**************************************************************************************************"
Write-Output "* Provisioning the ACR..."
Write-Output "**************************************************************************************************"

New-AzureRmResourceGroupDeployment -Name LeaderBoardACRDeployment -ResourceGroup $ResourceGroupName -Templatefile .\scripts\acr.json -acrName $ACRName 

$message =  "Done! Please refer " + $ResourceGroupName + " On your subscription"
Write-Output $message


# Create a Proctor VM

Write-Output ""
Write-Output "**************************************************************************************************"
Write-Output "* Provisioning the Proctor VM..."
Write-Output "**************************************************************************************************"

$vmStorageName = $ProctorVMHostName + $random
New-AzureRmStorageAccount -Name $vmStorageName -ResourceGroupName $ResourceGroupName -Location $Location -SkuName Premium_LRS -Kind Storage

New-AzureRmResourceGroupDeployment -Name "ProctorVMDeployment" -ResourceGroup $ResourceGroupName -Templatefile .\scripts\proctor.json -StorageAccountName $vmStorageName -adminUsername $AdminUser -adminPassword (ConvertTo-SecureString $AdminPassword -AsPlainText -Force) -dnsNameForPublicIP $ProctorVMHostName -ubuntuOSVersion "16.04.0-LTS"



