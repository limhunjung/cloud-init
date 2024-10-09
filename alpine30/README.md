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

service restart sshd

# welecome 메시지 

mv /root/cloud-init/alpine30kadap-welecome.msg /etc/motd


mv /root/cloud-init/alpine30/*.msg /root/.ssh/

echo "if [ -f /root/.ssh/first-login.msg ]; then rm -f /root/.ssh/first-login.msg; fi" | tee -a /etc/profile

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

# poratiner 설치 
docker volume create portainer_data
docker run -d -p 8000:8000 -p 9443:9443 --name DO_NOT_REMOVE_portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:2.21.3
# https://localhost:9443

# 시간 설정 
$ setup-timezone #Asian - Seoul

#마무리 
apk add acpid cloud-init cloud-initramfs-growroot


# ? rm /etc/netplan/50-cloud-init.yaml
rm -rf /root/cloud-init
cloud-init clean
#apt autoclean
apk cache clean


passwd root

cat <<'EOF'

su - 
passwd --expire root 
rm ~/.ash_history #history -cw  

$ poweroff

EOF
