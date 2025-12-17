output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}
output "acr_admin_username" {
  value = azurerm_container_registry.acr.admin_username
}
output "acr_admin_password" {
  value = azurerm_container_registry.acr.admin_password
  sensitive = true
}
output "webapp_url" {
  value = azurerm_linux_web_app.app.default_hostname
}
