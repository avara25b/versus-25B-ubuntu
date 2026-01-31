# plugins block to specify required Packer plugins
packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

source "amazon-ebs" "versus_frontend" {
  ami_name      = "versus-frontend-ami-{{timestamp}}"
  instance_type = "t3.micro"
  region        = "us-east-1"
  source_ami    = "ami-0b6c6ebed2801a5cb"
  ssh_username  = "ubuntu"
}

build {
    sources = ["source.amazon-ebs.versus_frontend"]

    provisioner "file" {
        source = "../frontend"
        destination = "/tmp/"
    }

    provisioner "shell" {
        inline = [
          "sudo mkdir -p /opt/versus",
          "sudo rm -rf /opt/versus/frontend",
          "sudo mv /tmp/frontend /opt/versus/frontend",
          "sudo chown -R ubuntu:ubuntu /opt/versus",

          "sudo apt-get update -y",
          "sudo apt-get install -y nodejs npm",
          "npm install -g corepack",
          "corepack enable",
          "cd /opt/versus/frontend && yarn install && yarn build",
          "sudo apt-get install -y nginx",
          "sudo rm -rf /usr/share/nginx/html/*",
          "sudo cp -r /opt/versus/frontend/build/* /usr/share/nginx/html/",
          "sudo systemctl enable nginx",
          "sudo systemctl start nginx"
        ]
    }
}
