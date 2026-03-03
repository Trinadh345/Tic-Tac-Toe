# 1. మొదట Bastion SG ఉండాలి (ఎందుకంటే దీనిని కింద వాడుతున్నాం)
resource "aws_security_group" "bastion_sg" {
  name        = "Bastion-SG"
  description = "Allow SSH from anywhere"
  vpc_id      = aws_vpc.prod_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. ఇప్పుడు App Server SG రాయాలి
resource "aws_security_group" "app_server_sg" {
  name        = "App-Server-SG"
  vpc_id      = aws_vpc.prod_vpc.id

  # Bastion నుండి SSH అనుమతించడం (లైన్ 20 ఇక్కడే ఎర్రర్ వస్తోంది)
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id] # ఇప్పుడు ఇది వర్క్ అవుతుంది
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "database_sg" {
  name   = "Database-SG"
  vpc_id = aws_vpc.prod_vpc.id

  # App Server నుండి MySQL (3306) అనుమతించడం
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_server_sg.id]
  }

  # Bastion Host నుండి Admin పనుల కోసం అనుమతించడం
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }
}
