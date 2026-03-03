# EC2 ఇన్‌స్టాన్స్ క్రియేషన్
resource "aws_instance" "bastion_host" {
  ami                         = "ami-051a31ab2f4d498f5" # మీరు పంపిన చిత్రంలోని Red Hat Enterprise Linux 10 AMI
  instance_type               = "c7i-flex.large"              # మీరు కోరిన ఇన్‌స్టాన్స్ టైప్
  key_name                    = "ARGO"                  # మీ కీపెయిర్ పేరు
  subnet_id                   = aws_subnet.public_subnets[0].id # మనం ముందు క్రియేట్ చేసిన Pub-Sub-1
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id] # మనం క్రియేట్ చేసిన Bastion-SG
  associate_public_ip_address = true                    # బాషన్ హోస్ట్ కాబట్టి పబ్లిక్ IP అవసరం

  tags = {
    Name        = "FinTech-Bastion-Host"
    Project     = "Banking-App"
    Environment = "Production"
  }

  # రూట్ వాల్యూమ్ కాన్ఫిగరేషన్ (SSD)
  root_block_device {
    volume_type = "gp3"
    volume_size = 10 # అవసరాన్ని బట్టి మార్చుకోవచ్చు
  }
}
