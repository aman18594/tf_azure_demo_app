variable "location-rg" {
  type        = string
  description = "resource group location"
}

variable "keyvault_name" {
  type        = string
  description = "keyvault name"
}

variable "stg_acc_name" {
  type        = string
  description = "storage account name"
}

variable "db_name" {
  type        = string
  description = "database name"
}

variable "fe_asp_name" {
  type        = string
  description = "front-end app service plan name"
}

variable "be_asp_name" {
  type        = string
  description = "back-end app service plan name"
}

variable "fe_webapp_name" {
  type        = string
  description = "front-end web app name"
}

variable "fn_stg_acc_name" {
  type        = string
  description = "function app storage account name"
}

variable "be_fnapp_name" {
  type        = string
  description = "back-end function app name"
}

variable "loganalytics_name" {
  type        = string
  description = "loganalytics workspace name"
}

variable "appinsights_name" {
  type        = string
  description = "appinsights name"
}

variable "azuresql_name" {
  type        = string
  description = "name of azure sql server"
}

variable "azuresql_vnet_rule" {
  type        = string
  description = "name of azure sql server"
}

variable "sqldbconn_name" {
  type        = string
  description = "name of azure sql server"
}