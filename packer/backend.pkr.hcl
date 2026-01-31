# plugins block to specify required Packer plugins
packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

source "amazon-ebs" "versus_backend" {
  ami_name      = "versus-backend-ami-{{timestamp}}"
  instance_type = "t3.micro"
  region        = "us-east-1"
  source_ami    = "ami- "
  ssh_username  = "ubuntu"
}

build {
  sources = ["source.amazon-ebs.versus_backend"]

  # Copy backend code
  provisioner "file" {
  source      = "../backend"
  destination = "/tmp/"
 }

  provisioner "shell" {
    inline = [
      "sudo mkdir -p /opt/versus", # keep all third party aps in /opt
      "sudo rm -rf /opt/versus/backend", # remove old backend if exists
      "sudo mv /tmp/backend /opt/versus/backend",
      "sudo chown -R ubuntu:ubuntu /opt/versus",

      "sudo apt-get update -y",
      # Install Python and dependencies
      "sudo apt-get install -y python3 python3-venv python3-pip python3-dev default-libmysqlclient-dev build-essential",

      
      "python3 -m venv /opt/versus/venv",
      "/opt/versus/venv/bin/pip install --upgrade pip",
      "/opt/versus/venv/bin/pip install -r /opt/versus/backend/requirements.txt",

      "sudo mkdir -p /etc/versus",
      "sudo cp /opt/versus/backend/backend.env /etc/versus/backend.env",
      "sudo cp /opt/versus/backend/versus-backend.service /etc/systemd/system/versus-backend.service",

      "sudo systemctl daemon-reload",
      "sudo systemctl enable versus-backend"
    ]
  }
}
