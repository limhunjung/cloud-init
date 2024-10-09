#!/usr/bin/bash
echo "-------------------------"
echo "| Alpine 30 Script |"
echo "-------------------------"
echo ""

# 파일 다운로드 
git clone https://github.com/limhunjung/cloud-init.git

# ssh 설정
cd /root/cloud-init/ubuntu22/
chmod 644 /root/cloud-init/ubuntu22/sshd_config
chown root sshd_config && chgrp root sshd_config
mv /root/cloud-init/ubuntu22/sshd_config /etc/ssh/sshd_config

# repo 설정 
chmod 644 /root/cloud-init/ubuntu22/sources.list
chown root sources.list && chgrp root sources.list
mv /root/cloud-init/ubuntu22/sources.list /etc/apt/sources.list
"""
#/media/cdrom/apks
http://dl-cdn.alpinelinux.org/alpine/v3.17/main
http://dl-cdn.alpinelinux.org/alpine/v3.17/community
#http://dl-cdn.alpinelinux.org/alpine/edge/main
http://dl-cdn.alpinelinux.org/alpine/edge/community
http://dl-cdn.alpinelinux.org/alpine/edge/testing
"""


# welecome 메시지 
mv /root/cloud-init/ubuntu22/*.msg /root/.ssh/

echo "if [ -f /root/.ssh/first-login.msg ]; then rm -f /root/.ssh/first-login.msg; else cat /home/ubuntu/.ssh/kadap-welecome.msg; fi" | tee -a /etc/profile

chmod -R 755 /home/ubuntu/

# telegraf
tar zxvf /root/cloud-init/ubuntu22/telegraf.tgz -C /etc
apt update; sudo apt install jq -y

vi /etc/telegraf/template/template/telegraf.conf.template  #interval = "60s" 로 조정

apt install /etc/telegraf/telegraf_1.7.2-1_amd64.deb
systemctl enable --now telegraf  

echo "(nohup /etc/telegraf/template/reset_metric_agent_conf.sh > /dev/null 2>&1 &) #telegraf config script" | tee -a /etc/profile
systemctl status telegraf

# cockpit 설치 
msg="Cockpit";
. /etc/os-release
apt install -y cockpit
# banner /etc/issue.d

# 시간 설정 
$ setup-simezone #Asian - Seoul

#마무리 
apt install -y acpid cloud-init cloud-initramfs-growroot

# https://sarc.io/index.php/cloud/2353-gcp-gcp-ubuntu-vm-apt-repo
echo "apt_preserve_sources_list: true" | tee -a /etc/cloud/cloud.cfg

rm /etc/netplan/50-cloud-init.yaml
rm -rf /home/ubuntu/cloud-init
cloud-init clean
apt autoclean

passwd root

cat <<'EOF'

su - 
passwd --expire root 
history -cw  

$ poweroff

EOF
