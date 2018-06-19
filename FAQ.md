# Frequently Asked Questions

Find information for common problems or questions.

## Troubleshooting

## Common Questions / Problems

1. The deploy ingress dns script errors out with this message:

    ```bash
    5-Deploy ingress  (bash ./deploy_ingress_dns.sh -s ./test_fetch_build -l westus2 -n teamdcaro04)
    Upgrading tiller (helm server) to match client version.
    $HELM_HOME has been configured at /home/azureuser/.helm.
    Error: tiller was not found. polling deadline exceeded
    ```

    There are a number of steps in this script to try and ensure tiller is available, but sometime it still times out.  Please refer to Common Resolution #1 for the solution.

## Common Resolution

1. Delete & Recreate environment

    Instead of manually hacking the setup script and trying to re-run the steps, sometimes it is easier to simply delete the resource groups where the failure occurred and recreate the resources via the setup script using the same team number since it is fully automated.