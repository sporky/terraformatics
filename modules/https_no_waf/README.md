# Just plain lazy..

variable "bigip_address" {}
variable "bigip_username" {}
variable "bigip_password" {}
variable "as3_template" {
  default = "./modules/https_no_waf/https_nowaf.json"
}
variable "tenant" {}
variable "fqdn" {}
variable "env" {}
variable "app_id" {}
variable "client_ssl_profile" {}
variable "server_ssl_profile" {}
variable "allowed_vlan" { 
  default = "/Common/dmz1"
} 
variable "public_ip" {}
variable "public_ip_label" {}
variable "public_port" {
  default = 443
}

variable "app_servers" {
  type = list(object({
    serverAddresses = list(string)
    servicePort = number
    shareNodes = bool
  }))
  default = [
    {
      serverAddresses = ["1.2.3.4"]
      servicePort = 8080
      shareNodes = true
    },
    {
      serverAddresses = ["1.2.3.4"]
      servicePort = 8090
      shareNodes = true
    }
  ]
}