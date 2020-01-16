<#

.SYNOPSIS
This script can be used to check the status of a classroom after is has been started in the Cloud Sandbox. 

This script has specficially been authored to check the lab microsoft-open-hack-devops and will not currently validate any other OpenHack labs.

.DESCRIPTION
To use this script, you will need to navigate to a classroom in the Cloud Sandbox and enter the lab view. 

From the lab view, click the List Credentials button, and then export the CSV. 

This script will take the path of that script as in input and use the credentials to enumerate all of the subscriptions within it.

.EXAMPLE
./classroomchecker.ps1 -LabCredentialsFilePath $env:HOMEPATH\Downloads\credentials.csv

.NOTES
This script should only run at least two hours after you have initiated the lab. Running it prior to that will certainly lead to results which lead you to believe the lab has not provisioned successfully, when in fact it is probably just still spinning up.

.LINK
https://github.com/Azure-Samples/openhack-devops-proctor/

#>

Param (
    [Parameter(Mandatory=$false)]
    [String]
    $ResourceGroupNamePrefix = "MC_openhack",

    [Parameter(Mandatory=$false)]
    [String]
    $LabCredentialsFilePath = "$PSScriptRoot\credentials.csv",

    [Parameter(Mandatory=$false)]
    [bool]
    $CheckStageEndpoint = $false
)

if (Test-Path $LabCredentialsFilePath -PathType Leaf) {
    $csv = Import-Csv -Path $LabCredentialsFilePath -Header "PortalUsername","PortalPassword","AzureSubscriptionId","AzureDisplayName","AzureUsername","AzurePassword" | ? AzureUserName -like "hacker*" | Sort-Object AzureSubscriptionId -Unique

    $outputCSVPath = "$env:HOMEPATH\Downloads\classscheckresults.csv"

    if (Test-Path $outputCSVPath -PathType Leaf) {
        $userResponse = Read-Host "Found previous output. Would you like to delete it? (y/n)?"

        if ($userResponse.ToLower() -eq "y") {
            Remove-Item -Path $outputCSVPath
        }
    }

    Write-Host "Storing validation results at $outputCSVPath" -ForegroundColor Green

    if (!(Test-Path $outputCSVPath -PathType Leaf)) {
        Add-Content -Path $outputCSVPath -Value '"SiteFound","POIFound","TripsFound","UserFound","UserJavaFound","AzureUsername","AzurePassword","SubscriptionId","FQDN","TenantURL"'
    }

    for ($i = 0; $i -lt $csv.Count; $i++) {
        $record = $csv[$i]
        $labUsername = $record.AzureUsername
        $labPassword = $record.AzurePassword

        if ($labUsername -ne "Azure UserName" -and $labPassword -ne "Azure Password") {
            $subscriptionId = $record.AzureSubscriptionId

            Write-Host "Processing record for $labUsername"

            $secpasswd = ConvertTo-SecureString $labPassword -AsPlainText -Force
            $labPScred = New-Object System.Management.Automation.PSCredential ($labUsername, $secpasswd)

            Connect-AzAccount -Credential $labPScred -Subscription $subscriptionId

            $resourceGroups = Get-AzResourceGroup

            foreach ($resourceGroup in $resourceGroups) {
                if ($resourceGroup.ResourceGroupName -like "$($ResourceGroupNamePrefix)*") {
                    $pips = Get-AzResource -ResourceGroupName $resourceGroup.ResourceGroupName -ResourceType "Microsoft.Network/publicIPAddresses"

                    foreach ($pip in $pips) {
                        $pipResource = Get-AzPublicIpAddress -ResourceGroupName $resourceGroup.ResourceGroupName -Name $pip.ResourceName

                        $fqdn = $pipResource.DnsSettings.Fqdn

                        $likeClause = "akstraefikopenhack*"

                        if ($CheckStageEndpoint) {
                            $likeClause = "stageakstraefikopenhack*"
                        }

                        if ($fqdn -like $likeClause) {
                            $pingCount = 1
                            $siteFound = $false
                            while (!$siteFound -and $pingCount -le 5) {
                                try {
                                    Write-Host "Checking $fqdn ($pingCount)..." -ForegroundColor Yellow
                                    $pingCount++

                                    $response = Invoke-WebRequest -Uri "http://$fqdn" -TimeoutSec 10 -UseBasicParsing -ErrorAction Stop
                                    if ($response.StatusCode -eq 200) {
                                        Write-Host "`tFound host $fqdn" -ForegroundColor Green
                                        $siteFound = $true;
                                    }
                                } catch {}

                                Start-Sleep 2
                            }

                            $tenantURL = "https://portal.azure.com/" + $labUsername.Split("@")[1]

                            $poiFound = $false
                            $tripsFound = $false
                            $userFound = $false
                            $userJavaFound = $false

                            if (!$siteFound -and !$CheckStageEndpoint) {
                                Write-Host "Unable to verfiy site at $fqdn" -ForegroundColor Yellow
                                Write-Host "`tManually verify the subscription at $tenantURL" -ForegroundColor Yellow
                            } else {
                                $apiPOI = $fqdn + "/api/healthcheck/poi"

                                $pingCount = 1
                                
                                while (!$poiFound -and $pingCount -le 5) {
                                    try {
                                        Write-Host "Checking $apiPOI ($pingCount)..." -ForegroundColor Yellow
                                        $pingCount++

                                        $response = Invoke-WebRequest -Uri "http://$apiPOI" -TimeoutSec 10 -UseBasicParsing -ErrorAction Stop
                                        if ($response.StatusCode -eq 200) {
                                            Write-Host "`tFound host $apiPOI" -ForegroundColor Green
                                            $poiFound = $true;
                                        }
                                    } catch {}

                                    Start-Sleep 2
                                }

                                $apiTrips = $fqdn + "/api/healthcheck/trips"

                                $pingCount = 1
                                
                                while (!$tripsFound -and $pingCount -le 5) {
                                    try {
                                        Write-Host "Checking $apiTrips ($pingCount)..." -ForegroundColor Yellow
                                        $pingCount++

                                        $response = Invoke-WebRequest -Uri "http://$apiTrips" -TimeoutSec 10 -UseBasicParsing -ErrorAction Stop
                                        if ($response.StatusCode -eq 200) {
                                            Write-Host "`tFound host $apiTrips" -ForegroundColor Green
                                            $tripsFound = $true;
                                        }
                                    } catch {}

                                    Start-Sleep 2
                                }

                                $apiUser = $fqdn + "/api/healthcheck/user"

                                $pingCount = 1
                                
                                while (!$userFound -and $pingCount -le 5) {
                                    try {
                                        Write-Host "Checking $apiUser ($pingCount)..." -ForegroundColor Yellow
                                        $pingCount++

                                        $response = Invoke-WebRequest -Uri "http://$apiUser" -TimeoutSec 10 -UseBasicParsing -ErrorAction Stop
                                        if ($response.StatusCode -eq 200) {
                                            Write-Host "`tFound host $apiUser" -ForegroundColor Green
                                            $userFound = $true;
                                        }
                                    } catch {}

                                    Start-Sleep 2
                                }

                                $apiUserJava = $fqdn + "/api/healthcheck/user-java"

                                $pingCount = 1
                                
                                while (!$userJavaFound -and $pingCount -le 5) {
                                    try {
                                        Write-Host "Checking $apiUserJava ($pingCount)..." -ForegroundColor Yellow
                                        $pingCount++

                                        $response = Invoke-WebRequest -Uri "http://$apiUserJava" -TimeoutSec 10 -UseBasicParsing -ErrorAction Stop
                                        if ($response.StatusCode -eq 200) {
                                            Write-Host "`tFound host $apiUserJava" -ForegroundColor Green
                                            $userJavaFound = $true;
                                        }
                                    } catch {}

                                    Start-Sleep 2
                                }
                            }

                            $outputString = '"' + $siteFound + '",'
                            $outputString += '"' + $poiFound + '",'
                            $outputString += '"' + $tripsFound + '",'
                            $outputString += '"' + $userFound + '",'
                            $outputString += '"' + $userJavaFound + '",'
                            $outputString += '"' + $labUsername + '",'
                            $outputString += '"' + $labPassword + '",'
                            $outputString += '"' + $subscriptionId + '",'
                            $outputString += '"' + "http://$fqdn" + '",'
                            $outputString += '"' + $tenantURL + '"'

                            Add-Content -Path $outputCSVPath -Value $outputString
                        }
                    }

                    break;
                }
            }

            Disconnect-AzAccount -Username $labUsername
        }
    }
} else {
    Write-Error -Message "Unable to find CSV at the path provided." -Category InvalidData
}