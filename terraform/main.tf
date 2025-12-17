# 1. Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-enterprise-security"
  location = "East US"
}

# 2. The "Brain" (Log Analytics Workspace for SOC)
resource "azurerm_log_analytics_workspace" "soc" {
  name                = "law-enterprise-sec"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# 3. Azure Container Registry (ACR)
resource "azurerm_container_registry" "acr" {
  name                = "acrsecops${random_id.random.hex}" # Unique name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = true
}

resource "random_id" "random" {
  byte_length = 4
}

# 4. App Service Plan (Linux)
resource "azurerm_service_plan" "plan" {
  name                = "plan-secure-app"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}

# 5. Web App for Containers
resource "azurerm_linux_web_app" "app" {
  name                = "app-secure-platform-${random_id.random.hex}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    always_on = false
    application_stack {
      docker_image     = "${azurerm_container_registry.acr.login_server}/secure-app"
      docker_image_tag = "latest"
    }
  }

  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL"      = "https://${azurerm_container_registry.acr.login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME" = azurerm_container_registry.acr.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD" = azurerm_container_registry.acr.admin_password
  }
}

# 6. CONNECT LOGS TO SIEM (Crucial for SOC)
resource "azurerm_monitor_diagnostic_setting" "app_logs" {
  name                       = "send-logs-to-soc"
  target_resource_id         = azurerm_linux_web_app.app.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.soc.id

  enabled_log {
    category = "AppServiceHTTPLogs"
  }
  
  enabled_log {
    category = "AppServiceConsoleLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
