output "resources_prefix" {
  value = local.resources_prefix
}
output "location" {
  value = azurerm_resource_group.resource_group.location
}
output "resource_group_name" {
  value = azurerm_resource_group.resource_group.name
}
output "tfstate_storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}
output "tfstate_storage_container" {
  value = azurerm_storage_container.storage_container.name
}
output "tfstate_key" {
  value = local.tfstate_key
}