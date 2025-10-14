locals {
  fe_app_name          = "${lower(var.resource_prefix)}-fe-app-${lower(replace(var.author, " ", "-"))}"
  be_app_name          = "${lower(var.resource_prefix)}-be-app-${lower(replace(var.author, " ", "-"))}"
  service_plan_name_fe = "${lower(var.resource_prefix)}-fe-service-plan-${lower(replace(var.author, " ", "-"))}"
  service_plan_name_be = "${lower(var.resource_prefix)}-be-service-plan-${lower(replace(var.author, " ", "-"))}"
  public_access        = true
  be_sku               = "P1v3" # B1 for basic with manual scaling, P1v3 for autoscaling with rules
  fe_sku               = "P1v3"
}
resource "azurerm_linux_web_app" "fe_app" {
  name                          = local.fe_app_name
  location                      = var.rg_location
  resource_group_name           = var.rg_name
  service_plan_id               = azurerm_service_plan.service_plan_fe.id
  virtual_network_subnet_id     = var.subnet_fe_id
  public_network_access_enabled = local.public_access

  depends_on = [var.subnet_fe_id]

  site_config {
    always_on = true
    application_stack {
      docker_image_name = var.fe_image_name_and_tag
    }
  health_check_path                 = "/"
    health_check_eviction_time_in_min = 5
    ip_restriction {
      name                      = "allow-agw"
      priority                  = 100
      action                    = "Allow"
      virtual_network_subnet_id = var.subnet_agw_id
    }
    ip_restriction {
      name       = "deny-all"
      priority   = 200
      action     = "Deny"
      ip_address = "0.0.0.0/0"
    }
  }

  app_settings = {
    "VITE_API_BASE_URL" = "http://${var.agw_ip}"
    "PORT" = "80"
    "WEBSITE_PORT" = "80"
  }

}
resource "azurerm_linux_web_app" "be_app" {
  name                          = local.be_app_name
  location                      = var.rg_location
  resource_group_name           = var.rg_name
  service_plan_id               = azurerm_service_plan.service_plan_be.id
  virtual_network_subnet_id     = var.subnet_be_id
  depends_on                    = [var.subnet_be_id, var.agw_ip]
  vnet_image_pull_enabled       = true
  public_network_access_enabled = local.public_access

  site_config {
  always_on = true
  application_stack {
    docker_image_name   = var.be_image_name_and_tag
    docker_registry_url = "https://index.docker.io"
  }
  health_check_path                 = "/"
  health_check_eviction_time_in_min = 5
  ip_restriction {
    name                      = "allow-agw"
    priority                  = 100
    action                    = "Allow"
    virtual_network_subnet_id = var.subnet_agw_id
  }
  ip_restriction {
    name       = "deny-all"
    priority   = 200
    action     = "Deny"
    ip_address = "0.0.0.0/0"
  }
}

    app_settings = {
    SERVER_PORT              = 8080
    ASPNETCORE_URLS          = "http://+:8080"
    PORT                     = "8080"
    WEBSITE_PORT             = "8080"

    DB_NAME                  = var.db_name
    DB_USERNAME              = var.db_user
    DB_PASSWORD              = var.db_password
    DB_DRIVER                = "com.microsoft.sqlserver.jdbc.SQLServerDriver"
    DB_HOST                  = var.db_server
    DB_PORT                  = 1433
    SPRING_PROFILES_ACTIVE   = "azure"
    CORS_ALLOWED_ORIGINS     = var.agw_ip
  }


  # ======= هنا تضيف lifecycle =======
  lifecycle {
    ignore_changes = [
      site_config[0].cors
    ]
  }
}

resource "azurerm_service_plan" "service_plan_be" {
  name                = local.service_plan_name_be
  resource_group_name = var.rg_name
  location            = var.rg_location
  os_type             = "Linux"
  sku_name            = local.fe_sku
}
resource "azurerm_service_plan" "service_plan_fe" {
  name                = local.service_plan_name_fe
  resource_group_name = var.rg_name
  location            = var.rg_location
  os_type             = "Linux"
  sku_name            = local.be_sku
}

