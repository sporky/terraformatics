#!/bin/bash


help_fn () {
  echo ""
  echo "usage: ./newroot.sh name type"
  echo ""
  echo "     name - name of the new application/bigip to deploy"
  echo "            For instance, green_dot_trading or bip4stl20"
  echo ""
  echo "     type - this should either be DO or AS3.  Don't try and get cute."
  exit 1
}

DO_fn () {
#
# boilerplate stuff for the environment setups and main.tf in the newly created deployment
#
 
  read -r -d '' THEENV <<- EOM
		bigip_address = "10.10.10.245"
		bigip_username = "admin"
		bigip_password = "originalPassword"

		admin_password = "NewHotPassWord!"
		root_password = "NewHotPassWord!"
		f5service_password = "NewHotPassWord!"
		hostname = "$NAME.yourdomain.int"
		dmz1_private = "172.31.1.2/24"
		dmz1_public = "9.99.4.18/29"
		dmz2_private = "10.10.100.3/24"

		default_route = "172.31.1.254"
		mgmt_route = "10.10.10.254"
EOM

  read -r -d '' THEMAIN <<- EOMM
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
EOMM
}

AS3_fn () {
#
# boilerplate stuff for the environment setups and main.tf in the newly created deployment
#
# probably need a couple different versions of this (or handle it some other way completely..)
# effectively, you'll need one of these for each AS3 template you want to support
#
  read -r -d '' THEENV <<- EOM
		bigip_address = "10.10.10.245"
		bigip_username = "ADUserName"
		bigip_password = "theUserPassword"
EOM

	read -r -d '' THEMAIN <<- EOMM
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
EOMM
}

[ -z "$1" ] && help_fn
[ -z "$2" ] && help_fn

if [ "$2" == "DO" ] || [ "$2" == "AS3" ]
then
  NAME=$1
  TYPE=$2
else
  help_fn
fi


if [ "$TYPE" == "DO" ]
then
  DO_fn
else
  AS3_fn
fi

mkdir roots/$NAME
mkdir roots/$NAME/env
echo "$THEENV" > roots/$NAME/env/prod.tfvars
echo "$THEENV" > roots/$NAME/env/stage.tfvars
echo "$THEMAIN" > roots/$NAME/main.tf