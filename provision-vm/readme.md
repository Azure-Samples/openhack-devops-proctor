# Infrastructure VM deployment script

## Usage

Login with your PowerShell console.

For a Windows machine it will be:

```shell
Login-AzureRmAccount
```

For Ubuntu it will be:

```shell
sudo pwsh
Connect-AzureRmAccount
```

Change `YOUR_NUMBER`, `YOUR_PUBLIC_KEY`, and `YOUR_LOCATION` below.
Run this from the root of the `provision-vm` folder.

```shell
$YOUR_LOCATION = 'eastus'
$YOUR_NUMBER = '' # 3940
$YOUR_PUBLIC_KEY = '' # ssh-rsa AAAAB3NzaC1yc2EAAAADA... @microsoft.com
.\deploy.ps1 -Location $YOUR_LOCATION -Number $YOUR_NUMBER -PublicKey $YOUR_PUBLIC_KEY
```

After provisioning, login to the VM with the public IP address attached to the VM and the SSH key provided.