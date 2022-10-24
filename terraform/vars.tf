locals {
  prefix = terraform.workspace == "default" ? "evertras-home-dashboard" : "evertras-home-dashboard-${terraform.workspace}"
}
