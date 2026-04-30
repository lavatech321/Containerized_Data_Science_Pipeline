resource "aws_key_pair" "mykey" {
    key_name = "terraform-key"
    #public_key = file("C:/Users/username/.ssh/id_rsa.pub")
    public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "ports-allow" {
    name        = "allow-jenkins-ssh-streamlit"
    description = "Allow SSH and Jenkins access"

    # SSH (Port 22)
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Jenkins (Port 8080)
    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Streamlit App (Port 8501)
    ingress {
        from_port   = 8501
        to_port     = 8501
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow all outbound traffic
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

data "aws_ami" "ubuntu_26" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-resolute-26.04-amd64-server-20260421"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "servers" {
        ami = data.aws_ami.ubuntu_26.id
        instance_type = "m7i-flex.large"
        key_name = aws_key_pair.mykey.key_name
        root_block_device {
		  volume_size           = 40
		  volume_type           = "gp3"
		  delete_on_termination = true
		  encrypted             = true
    	}
	vpc_security_group_ids = [aws_security_group.ports-allow.id]

        connection {
                type     = "ssh"
                user     = "ubuntu"
                private_key = file("~/.ssh/id_rsa")
                host = aws_instance.servers.public_ip
        }
	provisioner "file" {
    		source      = "main.yaml"
		destination = "/home/ubuntu/main.yaml"
  	}
	provisioner "remote-exec" {
	 	inline = [
		"sudo hostnamectl set-hostname server.example.com",
    		"sudo apt update -y",
    		"sudo apt install -y ansible",
		"ansible-galaxy collection install git+https://github.com/lavatech321/DevOps_Projects_Ansible_Collections.git",
		"ansible-playbook /home/ubuntu/main.yaml",
  		]
	}
}

output "EC2-Instance-access-details" {
	value = "ssh -i ~/.ssh/id_rsa ubuntu@${aws_instance.servers.public_ip} \n"
}

output "Jenkins-UI" {
	value = "http://${aws_instance.servers.public_ip}:8080 \n"
}
output "Jenkins-Credentials" {
	value =  "Username: admin / Password: admin123 \n"
}

output "Streamlit-Access" {
	value =  "http://${aws_instance.servers.public_ip}:8501 \n"
}

