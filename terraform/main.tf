
module "appgw" {
  source          = "./modules/appgw"
  rg_location     = module.resourcegroups.rg_location
  rg_name         = module.resourcegroups.rg_name
  fe_app_id       = module.appservice.fe_app_id
  be_app_id       = module.appservice.be_app_id
  subnet_agw_id   = module.subnets.subnet_agw_id
  vnet_name       = module.vnets.vnet_name
  be_app_fqdn     = module.appservice.be_app_fqdn
  fe_app_fqdn     = module.appservice.fe_app_fqdn
  author          = var.author
  resource_prefix = var.resource_prefix
  be_port         = var.be_port
  fe_port         = var.fe_port
}

module "appservice" {
  source                     = "./modules/appservice"
  author                     = var.author
  rg_location                = module.resourcegroups.rg_location
  rg_name                    = module.resourcegroups.rg_name
  fe_app_id                  = module.appservice.fe_app_id
  be_app_id                  = module.appservice.be_app_id
  be_port                    = var.be_port
  fe_port                    = var.fe_port
  resource_prefix            = var.resource_prefix
  db_password                = var.db_password
  db_name                    = module.db.db_name
  db_server                  = module.db.db_server
  db_user                    = module.db.db_user
  private_endpoint_subnet_id = module.subnets.private_endpoint_subnet_id
  subnet_agw_cidr            = module.subnets.subnet_agw_cidr[0]
  subnet_fe_id               = module.subnets.subnet_fe_id
  subnet_be_id               = module.subnets.subnet_be_id
  vnet_id                    = module.vnets.vnet_id
  vnet_name                  = module.vnets.vnet_name
  subnet_agw_id              = module.subnets.subnet_agw_id
  mssql_server_name          = module.db.mssql_server_name
  agw_ip                     = module.appgw.agw_ip
  fe_image_name_and_tag      = var.fe_image_name_and_tag
  be_image_name_and_tag      = var.be_image_name_and_tag
}
module "db" {
  source                     = "./modules/db"
  rg_location                = module.resourcegroups.rg_location
  rg_name                    = module.resourcegroups.rg_name
  vnet_id                    = module.vnets.vnet_id
  private_endpoint_subnet_id = module.subnets.private_endpoint_subnet_id
  db_password                = var.db_password
  author                     = var.author
  resource_prefix            = var.resource_prefix
  subnet_db_id               = module.subnets.subnet_db_id
  subnet_be_id               = module.subnets.subnet_be_id
  rg_id                      = module.resourcegroups.rg_id
  db_admin                   = var.db_admin
}

module "nsg" {
  source          = "./modules/nsg"
  be_app_id       = module.appservice.be_app_id
  db_id           = module.db.db_id
  fe_app_id       = module.appservice.fe_app_id
  rg_location     = module.resourcegroups.rg_location
  rg_name         = module.resourcegroups.rg_name
  subnet_pe_cidr  = module.subnets.subnet_pe_cidr
  subnet_agw_cidr = module.subnets.subnet_agw_cidr
  subnet_db_cidr  = module.subnets.subnet_db_cidr
  subnet_be_cidr  = module.subnets.subnet_be_cidr
  subnet_fe_cidr  = module.subnets.subnet_fe_cidr
  vnet_name       = module.vnets.vnet_name
  subnet_agw_id   = module.subnets.subnet_agw_id
  subnet_db_id    = module.subnets.subnet_db_id
  subnet_be_id    = module.subnets.subnet_be_id
  subnet_fe_id    = module.subnets.subnet_fe_id
  be_port         = var.be_port
  fe_port         = var.fe_port
  author          = var.author
  resource_prefix = var.resource_prefix
}
module "resourcegroups" {
  source                  = "./modules/resourcegroups"
  author                  = var.author
  resource_prefix         = var.resource_prefix
  resource_group_location = var.resource_group_location
  resource_group_name     = var.resource_group_name
}
module "subnets" {
  source          = "./modules/subnets"
  rg_location     = module.resourcegroups.rg_location
  rg_name         = module.resourcegroups.rg_name
  vnet_name       = module.vnets.vnet_name
  author          = var.author
  resource_prefix = var.resource_prefix
  rg_id           = module.resourcegroups.rg_id
  vnet_id         = module.vnets.vnet_id
}
module "vnets" {
  source          = "./modules/vnets"
  rg_location     = module.resourcegroups.rg_location
  rg_name         = module.resourcegroups.rg_name
  author          = var.author
  resource_prefix = var.resource_prefix
}
