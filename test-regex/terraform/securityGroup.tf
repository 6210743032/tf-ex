data "aws_ip_ranges" "us_west_ip_range" {
  regions = ["us-west-1"]
  services = ["ec2"]
}

resource "aws_security_group" "sg_custom_us_west" {
  name = "sg_custom_us_west"
  ingress {
    # กำหนด ip range
    cidr_blocks = data.aws_ip_ranges.us_west_ip_range.cidr_blocks
    from_port = 443
    protocol = "tcp"
    to_port = 443
  }
}

# SSH
resource "aws_security_group" "allow-customvpc-ssh" {
  vpc_id = aws_vpc.customvpc.id
  name = "allow-customvpc-ssh"
  description = "security group that allows ssh connection."
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # All IPs
  }
  
  egress {
    from_port   = 0 
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow-customvpc-ssh"
  }
}

# HTTP
resource "aws_security_group" "allow-customvpc-http" {
  vpc_id = aws_vpc.customvpc.id
  name = "allow-customvpc-http"
  description = "security group that allows http connection."
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # allow all IP (private&public), ["aws_vcp.customvpc.cidr_block"] - allow private IP
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow-customvpc-http"
  }
}