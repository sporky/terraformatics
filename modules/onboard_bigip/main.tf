provider "bigip" {
  address = var.bigip_address
  username = var.bigip_username
  password = var.bigip_password
  token_auth = false
  login_ref = "tmos"
}

resource "bigip_do"  "spork_f5do" {
  do_json = templatefile("./modules/onboard_bigip/template.json",
  {
    hostname = jsonencode(var.hostname)
    root_password = jsonencode(var.root_password)
    admin_password = jsonencode(var.admin_password)
    f5service_password = jsonencode(var.f5service_password)
    dmz1_private = jsonencode(var.dmz1_private)
    dmz1_public = jsonencode(var.dmz1_public)
    dmz2_private = jsonencode(var.dmz2_private)
    default_route = jsonencode(var.default_route)
    mgmt_route = jsonencode(var.mgmt_route)
  })
  config_name = "bigip1"
}
