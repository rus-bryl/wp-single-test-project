resource "aws_eip" "wp_static_ip" {
  instance = aws_instance.wp_server.id
}
