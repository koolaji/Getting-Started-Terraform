#!/usr/bin/env bash
dnf install git -y 
git clone https://github.com/koolaji/Getting-Started-Terraform.git
wget https://releases.hashicorp.com/terraform/1.12.2/terraform_1.12.2_linux_amd64.zip
unzip terraform_1.12.2_linux_amd64.zip
mv terraform /usr/bin/
wget https://github.com/neovim/neovim/releases/download/v0.11.3/nvim-linux-x86_64.appimage 
mv nvim-linux-x86_64.appimage nvim
chmod +x nvim
mv nvim /usr/bin
