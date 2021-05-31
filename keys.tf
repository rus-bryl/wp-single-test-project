#=====================SSH Keys===============================
variable "ssh_key" {
  default = "~/.ssh/id_rsa.pub"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file(var.ssh_key)
}
