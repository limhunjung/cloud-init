#!/usr/bin/bash
echo "-------------------------"
echo "| Alpine 30 Script |"
echo "-------------------------"
echo ""

# 파일 다운로드 
git clone https://github.com/limhunjung/cloud-init.git

# ssh 설정
cd /home/ubuntu/cloud-init/ubuntu22/
chmod 644 /home/ubuntu/cloud-init/ubuntu22/sshd_config
sudo chown root sshd_config && sudo chgrp root sshd_config
sudo mv /home/ubuntu/cloud-init/ubuntu22/sshd_config /etc/ssh/sshd_config

# repo 설정 
chmod 644 /home/ubuntu/cloud-init/ubuntu22/sources.list
sudo chown root sources.list && sudo chgrp root sources.list
sudo mv /home/ubuntu/cloud-init/ubuntu22/sources.list /etc/apt/sources.list
"""
#/media/cdrom/apks
http://dl-cdn.alpinelinux.org/alpine/v3.17/main
http://dl-cdn.alpinelinux.org/alpine/v3.17/community
#http://dl-cdn.alpinelinux.org/alpine/edge/main
http://dl-cdn.alpinelinux.org/alpine/edge/community
http://dl-cdn.alpinelinux.org/alpine/edge/testing
"""


# welecome 메시지 
mv /home/ubuntu/cloud-init/ubuntu22/*.msg /home/ubuntu/.ssh/
sudo rm -f /etc/update-motd.d/10-help-text /etc/update-motd.d/88-esm-announce /etc/update-motd.d/90-updates-available /etc/update-motd.d/91-release-upgrade

sudo echo "if [ -f /home/ubuntu/.ssh/first-login.msg ]; then rm -f /home/ubuntu/.ssh/first-login.msg; else cat /home/ubuntu/.ssh/kadap-welecome.msg; fi" | sudo tee -a /etc/profile

sudo chmod -R 755 /home/ubuntu/

# telegraf
sudo tar zxvf /home/ubuntu/cloud-init/ubuntu22/telegraf.tgz -C /etc
sudo apt update; sudo apt install jq -y

sudo vi /etc/telegraf/template/template/telegraf.conf.template  #interval = "60s" 로 조정

sudo apt install /etc/telegraf/telegraf_1.7.2-1_amd64.deb
sudo systemctl enable --now telegraf  

sudo echo "(nohup /etc/telegraf/template/reset_metric_agent_conf.sh > /dev/null 2>&1 &) #telegraf config script" | sudo tee -a /etc/profile
sudo systemctl status telegraf

# cockpit 설치 
msg="Cockpit";
. /etc/os-release
sudo apt install -y cockpit
# banner /etc/issue.d

# 시간 설정 
$ setup-simezone #Asian - Seoul

#마무리 
sudo apt install -y acpid cloud-init cloud-initramfs-growroot

# https://sarc.io/index.php/cloud/2353-gcp-gcp-ubuntu-vm-apt-repo
sudo echo "apt_preserve_sources_list: true" | sudo tee -a /etc/cloud/cloud.cfg

sudo rm /etc/netplan/50-cloud-init.yaml
rm -rf /home/ubuntu/cloud-init
sudo cloud-init clean
sudo apt autoclean

sudo passwd  root

cat <<'EOF'

su - 
sudo passwd --expire root 
history -cw  

$ poweroff

EOF
