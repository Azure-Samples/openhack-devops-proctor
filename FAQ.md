# Frequently Asked Questions

Find information for common problems or questions.

## Troubleshooting

## Common Questions / Problems

1. A team deployment times out failures due to quotas or constraints on your Azure subscription.

## Common Resolution

1. Delete & Recreate environment

    Instead of manually hacking the setup script and trying to re-run the steps, sometimes it is easier to simply delete the resource group where the failure occurred and recreate the resources via the setup script using the same team number since it is fully automated.

2. Review the guidance for resource quotas included in provisioning [README](./provision-team/README.md)
