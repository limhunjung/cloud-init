#!/usr/bin/bash
echo "-------------------------"
echo "| Alpine 30 Script |"
echo "-------------------------"
echo ""

# apk repossitory 수정 
vi /etc/apk/repositories #copmmunity 주석 제거 

# 필수 패키지 설치 
apk update
apk add git docker docker-compose

# docker 설정
rc-update add docker boot
service docker start
docker version

# 파일 다운로드 
git clone https://github.com/limhunjung/cloud-init.git

# ssh 설정
echo "Banner /root/.ssh/first-loing.msg" | tee -a /etc/ssh/sshd_config

vi /etc/ssh/sshd_config
"""
PermitRootLogin yes #L36
PasswordAuthentication yes #L61
Banner /root/.ssh/first-loing.msg 
"""

# welecome 메시지 
mv /root/cloud-init/ubuntu22/*.msg /root/.ssh/

echo "if [ -f /root/.ssh/first-login.msg ]; then rm -f /root/.ssh/first-login.msg; else cat /home/ubuntu/.ssh/kadap-welecome.msg; fi" | tee -a /etc/profile

#chmod -R 755 /home/ubuntu/

# telegraf
tar zxvf /root/cloud-init/ubuntu22/telegraf.tgz -C /etc
apk jq -y

vi /etc/telegraf/template/template/telegraf.conf.template  #interval = "60s" 로 조정

apt install /etc/telegraf/telegraf_1.7.2-1_amd64.deb
systemctl enable --now telegraf  

echo "(nohup /etc/telegraf/template/reset_metric_agent_conf.sh > /dev/null 2>&1 &) #telegraf config script" | tee -a /etc/profile
systemctl status telegraf

rc-update add telegraf boot
service telegraf start


# cockpit 설치 
sudo docker run -d --name cockpit-ws -p 9090:9090 cockpit/ws


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
