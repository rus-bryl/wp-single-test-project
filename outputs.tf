
#===============Outputs======================
output "wp_server_ip" {
  value = aws_eip.wp_static_ip.public_ip
}

output "wp_server_dns" {
  value = aws_eip.wp_static_ip.public_dns
}

