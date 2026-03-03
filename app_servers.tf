resource "aws_instance" "app_server" {
  count         = 2 # High Availability కోసం 2 సర్వర్లు
  ami           = "ami-0ffef61f6dc37ae89" 
  instance_type = "t3.small"
  key_name      = "ARGO"
  
  # మనం క్రియేట్ చేసిన 6 ప్రైవేట్ సబ్‌నెట్లలో మొదటి రెండింటిని వాడుతున్నాం
  subnet_id              = aws_subnet.private_subnets[count.index].id
  vpc_security_group_ids = [aws_security_group.app_server_sg.id]

  tags = {
    Name = "FinTech-App-Server-${count.index + 1}"
  }
}
