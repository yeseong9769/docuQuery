#################### Key Pair ####################
resource "tls_private_key" "rsa-4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2-key-pair" {
  key_name   = "ec2-key-pair"
  public_key = tls_private_key.rsa-4096.public_key_openssh
}

resource "local_sensitive_file" "ec2-private-key" {
  depends_on      = [aws_key_pair.ec2-key-pair]
  content         = tls_private_key.rsa-4096.private_key_pem
  filename        = "/home/sysoper/.ssh/id_rsa"
  file_permission = "0600"
}

#################### Bastion Host ####################
resource "aws_instance" "bastion_host" {
  ami                         = "ami-0de20b1c8590e09c5"
  instance_type               = "t3a.nano"
  subnet_id                   = aws_subnet.docuQuery_subnet_public2.id
  vpc_security_group_ids      = [aws_security_group.bastion_host_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ec2-key-pair.key_name

  tags = {
    Name = "docuQuery-bastion-host"
  }
}

#################### Web Server ####################
resource "aws_instance" "web_server_1" {
  ami                         = "ami-0a027398380af6970"
  instance_type               = "t3a.micro"
  subnet_id                   = aws_subnet.docuQuery_subnet_private1.id
  vpc_security_group_ids      = [aws_security_group.web_server_sg.id]
  associate_public_ip_address = false
  key_name                    = aws_key_pair.ec2-key-pair.key_name
  user_data                   = <<-EOL
  #!/bin/bash -xe

  apt update
  apt install -y git python3-pip python3-venv
  mkdir /app
  cd /app
  git clone https://github.com/yeseong9769/docuQuery.git
  cd /app/docuQuery
  python3 -m venv /app/venv
  source /app/venv/bin/activate
  pip install -r /app/docuQuery/frontend/requirements.txt
  cd /app/docuQuery/frontend
  echo "BACKEND_URL = \"http://${aws_lb.internal_lb.dns_name}:8000\"" > /app/docuQuery/frontend/secrets.toml
  streamlit run main.py --server.port 8080 --logger.level=warning &> streamlit.log &
  EOL

  tags = {
    Name = "docuQuery-web-server-1"
  }
}

resource "aws_instance" "web_server_2" {
  ami                         = "ami-0a027398380af6970"
  instance_type               = "t3a.micro"
  subnet_id                   = aws_subnet.docuQuery_subnet_private2.id
  vpc_security_group_ids      = [aws_security_group.web_server_sg.id]
  associate_public_ip_address = false
  key_name                    = aws_key_pair.ec2-key-pair.key_name
  user_data                   = <<-EOL
  #!/bin/bash -xe

  apt update
  apt install -y git python3-pip python3-venv
  mkdir /app
  cd /app
  git clone https://github.com/yeseong9769/docuQuery.git
  cd /app/docuQuery
  python3 -m venv /app/venv
  source /app/venv/bin/activate
  pip install -r /app/docuQuery/frontend/requirements.txt
  cd /app/docuQuery/frontend
  echo "BACKEND_URL = \"http://${aws_lb.internal_lb.dns_name}:8000\"" > /app/docuQuery/frontend/secrets.toml
  streamlit run main.py --server.port 8080 --logger.level=warning &> streamlit.log &
  EOL

  tags = {
    Name = "docuQuery-web-server-2"
  }
}

#################### API Server ####################
resource "aws_instance" "api_server_1" {
  ami                         = "ami-0de20b1c8590e09c5"
  instance_type               = "t3a.micro"
  subnet_id                   = aws_subnet.docuQuery_subnet_private3.id
  vpc_security_group_ids      = [aws_security_group.api_server_sg.id]
  associate_public_ip_address = false
  key_name                    = aws_key_pair.ec2-key-pair.key_name
  user_data                   = <<-EOL
  #!/bin/bash -xe

  yum update -y
  yum install -y git python3-pip
  mkdir /app
  cd /app
  git clone https://github.com/yeseong9769/docuQuery.git
  pip3 install -r /app/docuQuery/backend/requirements.txt
  EOL

  tags = {
    Name = "docuQuery-api-server-1"
  }
}

resource "aws_instance" "api_server_2" {
  ami                         = "ami-0de20b1c8590e09c5"
  instance_type               = "t3a.micro"
  subnet_id                   = aws_subnet.docuQuery_subnet_private4.id
  vpc_security_group_ids      = [aws_security_group.api_server_sg.id]
  associate_public_ip_address = false
  key_name                    = aws_key_pair.ec2-key-pair.key_name
  user_data                   = <<-EOL
  #!/bin/bash -xe

  yum update -y
  yum install -y git python3-pip
  mkdir /app
  cd /app
  git clone https://github.com/yeseong9769/docuQuery.git
  pip3 install -r /app/docuQuery/backend/requirements.txt
  EOL

  tags = {
    Name = "docuQuery-api-server-2"
  }
}