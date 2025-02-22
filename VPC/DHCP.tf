resource "aws_vpc_dhcp_options" "dhcp" {
  domain_name          = "<dhcp>"
  domain_name_servers  = ["<Domain Server IP>"]
  ntp_servers          = ["169.254.169.123"]
  netbios_node_type    = 2

  tags = {
    Name = "<env>-DHCP"
  }
}