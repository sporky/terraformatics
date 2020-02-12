provider "bigip" {
  address = var.bigip_address
  username = var.bigip_username
  password = var.bigip_password
  token_auth = false
  login_ref = "tmos"
}

locals {
  base_name = join("_", [var.env, var.fqdn])
  app = join("_", [local.base_name, "app"])
  analytics = join("_", [local.base_name, "analytics"])
  pool = join("_", [local.base_name, "pool"])
  monitor = join("_", [local.base_name, "monitor"])
  tcp_profile = join("_", [local.base_name, "tcp"])
  http_profile = join("_", [local.base_name, "http"])
  one_connect_profile = join("_", [local.base_name, "oneconnect"])
  persist_profile = join("_", [local.base_name, "persist"])
  compression_profile = join("_", [local.base_name, "compresssion"])
  fq_ip_label = join("", ["/Common/Shared/",var.public_ip_label])
}

resource "bigip_as3" "https_nowaf" {
  config_name = var.tenant
  as3_json = templatefile(
    var.as3_template, 
    { 
      app_id = jsonencode(var.app_id)
      tenant = jsonencode(var.tenant)
      app = jsonencode(local.app)
      analytics = jsonencode(local.analytics)
      public_ip = jsonencode(var.public_ip)
      fq_ip_label = jsonencode(local.fq_ip_label)
      ip_label = jsonencode(var.public_ip_label)
      public_port = jsonencode(var.public_port)
      pool = jsonencode(local.pool)
      pool_members = jsonencode(var.app_servers)
      monitor = jsonencode(local.monitor)
      tcp_profile = jsonencode(local.tcp_profile)
      http_profile = jsonencode(local.http_profile)
      one_connect_profile = jsonencode(local.one_connect_profile)
      persist_profile = jsonencode(local.persist_profile)
      compression_profile = jsonencode(local.compression_profile)
      allowed_vlan = jsonencode(var.allowed_vlan)
      client_ssl_profile = jsonencode(var.client_ssl_profile)
      server_ssl_profile = jsonencode(var.server_ssl_profile)      
    }) 
}