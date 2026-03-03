 resource "aws_instance" "jenkins_host" {
  ami                         = "ami-019715e0d74f695be" 
  instance_type               = "c7i-flex.large"              
  key_name                    = "ARGO"                  
  subnet_id                   = aws_subnet.public_subnets[1].id 
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id] 
  associate_public_ip_address = true                    
 
  tags = {
    Name        = "jenkins-Host"
    Project     = "Banking-App"
    Environment = "Production"
  }

   root_block_device {
    volume_type = "gp3"
    volume_size = 15
  }
}
