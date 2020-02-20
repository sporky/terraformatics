variable "bigip_address" {}
variable "bigip_username" {}
variable "bigip_password" {}

module "https_no_waf_module" {
source = "../../modules/https_no_waf"
bigip_address = var.bigip_address
bigip_username = var.bigip_username
bigip_password = var.bigip_password
tenant = "spooky"
fqdn = "www_ps_com"
env = "stage"
app_id = "0x1979"
allowed_vlan = "/Common/dmz1"
client_ssl_profile = "/Common/clientssl"
server_ssl_profile = "/Common/serverssl"
public_ip = "69.44.4.23"
public_ip_label = "ip69_44_4_23"
public_port = 885
app_servers = [{ serverAddresses=["205.170.190.124"], servicePort=53, shareNodes=true},{serverAddresses=["205.170.190.124"], servicePort=99, shareNodes=true}]
}
