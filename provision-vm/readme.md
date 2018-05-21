# Infrastructure VM deployment script

## Usage

Login with your PowerShell console.

```shell
Login-AzureRmAccount
```

Change `YOUR_NUMBER`, `YOUR_PUBLIC_KEY`, and `YOUR_LOCATION` below.
Run this from the root of the `provision-vm` folder.

```shell
$YOUR_LOCATION = 'eastus'
$YOUR_NUMBER = '' # 3940
$YOUR_PUBLIC_KEY = '' # ssh-rsa AAAAB3NzaC1yc2EAAAADA... @microsoft.com
$YOUR_PASSWORD = 'ComplexPassw0rdyo!'
.\deploy.ps1 -Location $YOUR_LOCATION -Number $YOUR_NUMBER -PublicKey $YOUR_PUBLIC_KEY -AdminPassword $YOUR_PASSWORD
```