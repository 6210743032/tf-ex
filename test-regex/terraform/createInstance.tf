data "aws_availability_zones" "available" {}

# define AMI
data "aws_ami" "ubuntu" {
    most_recent = true
    owners = ["099720109477"]
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"] #versionล่าสุุดของregionนั้น
    }
}

resource "aws_key_pair" "mykey" {
    key_name = "mykey"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "first_aws_instance" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    availability_zone = data.aws_availability_zones.available.names[1]
    key_name = aws_key_pair.mykey.key_name
    iam_instance_profile = aws_iam_instance_profile.s3-bucket-role-instance-profile.name
    vpc_security_group_ids = ["aws_security_group.allow-customvpc-ssh.id, aws_security_group.allow-customvpc-http.id"]
    subnet_id = aws_subnet.customvpc-public-2.id
    tags = {
        Name = "custom_instance1"
    }

    provisioner "file" {
        source      = "installNginx.sh"
        destination = "/tmp/installNginx.sh"
    }

    connection {
        type        = "ssh"
        user        = var.INSTANCE_USERNAME
        host        = coalesce(self.public_ip, self.private_ip)
        private_key = file(var.PATH_TO_PRIVATE_KEY)
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/installNginx.sh",
            "sudo /tmp/installNginx.sh",
        ]
    }
}

output "public_ip" {
    value = aws_instance.first_aws_instance.public_ip
}

resource "aws_instance" "second_aws_instance" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    availability_zone = data.aws_availability_zones.available.names[1]
    key_name = aws_key_pair.mykey.key_name
    vpc_security_group_ids = ["aws_security_group.allow-customvpc-ssh.id"]
    subnet_id = aws_subnet.customvpc-private-1.id
    tags = {
        Name = "custom_instance2"
    }
}