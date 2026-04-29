
resource "aws_key_pair" "mykey" {
    key_name = "terraform-ansible-key-new"
    #public_key = file("C:/Users/username/.ssh/id_rsa.pub")
    public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "jenkins_streamlit_sg" {
  name        = "allow-jenkins-streamlit-ssh"
  description = "Allow SSH, Jenkins, and Streamlit ports"

  # SSH
  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Jenkins
  ingress {
    description = "Jenkins UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Streamlit
  ingress {
    description = "Streamlit App"
    from_port   = 8501
    to_port     = 8501
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound (Allow all)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu_22" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "servers" {
    ami = data.aws_ami.ubuntu_22.id
    instance_type = "m7i-flex.large"
    key_name = aws_key_pair.mykey.key_name
    root_block_device {
	  volume_size           = 40
	  volume_type           = "gp3"
	  delete_on_termination = true
	  encrypted             = true
    }
    vpc_security_group_ids = [ aws_security_group.jenkins_streamlit_sg.id]
    connection {
                type     = "ssh"
                user     = "ubuntu"
                private_key = file("~/.ssh/id_rsa")
                host = aws_instance.servers.public_ip
        }
	provisioner "file" {
    		source      = "configure_server.yaml"
		destination = "/home/ubuntu/playbook1.sh"
  	}

	provisioner "file" {
    		source      = "pipeline.groovy"
		destination = "/home/ubuntu/pipeline.groovy"
  	}

	provisioner "remote-exec" {
	  inline = [
	    "sudo apt update -y",
	    "sudo apt install -y ansible",
	    "sed -i 's/REPLACE-IP/${self.public_ip}/g' /home/ubuntu/playbook1.sh",
	    "ansible-playbook /home/ubuntu/playbook1.sh",
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
	value =  "Username: admin / Password: admin123"
}
output "Streamlit-UI" {
	value = "http://${aws_instance.servers.public_ip}:8501 \n"
}

