variable "bigip_address" {}
variable "bigip_username" {}
variable "bigip_password" {}

variable "hostname" {}
variable "root_password" {}
variable "admin_password" {}
variable "f5service_password" {}

variable "dmz1_private" {}
variable "dmz1_public" {}
variable "dmz2_private" {}

variable "default_route" {}
variable "mgmt_route" {}

module "onboard_bigip" {
    source = "../../modules/onboard_bigip"
    bigip_address = var.bigip_address
    bigip_username = var.bigip_username
    bigip_password = var.bigip_password
    hostname = var.hostname
    root_password = var.root_password
    admin_password = var.admin_password
    f5service_password = var.f5service_password
    dmz1_private = var.dmz1_private
    dmz1_public = var.dmz1_public
    dmz2_private = var.dmz2_private
    default_route = var.default_route
    mgmt_route = var.mgmt_route
}
