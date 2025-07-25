output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
output "virtual_network_name" {
  value = azurerm_virtual_network.vnet.name
}
output "name_of_subnets" {
  value = [
    for subnet in azurerm_subnet.snet : subnet.name]
}