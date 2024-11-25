# 1. ubunt 키파일로 로그인 

sudo adduser kadap

git clone https://github.com/limhunjung/cloud-init.git

sudo apt update; sudo apt install acpid cloud-init cloud-initramfs-growroot jq -y

sudo mv /home/ubuntu/cloud-init/ubuntu22/issue.net.first /etc/issue.net
sudo chown root /etc/issue.net && sudo chgrp root /etc/issue.net
sudo chmod 644 /etc/issue.net

sudo mv /home/ubuntu/cloud-init/ubuntu22/issue /etc/issue
sudo chown root /etc/issue && sudo chgrp root /etc/issue
sudo chmod 644 /etc/issue

sudo mv /home/ubuntu/cloud-init/ubuntu22/motd.final /etc/motd
sudo chown root /etc/motd && sudo chgrp root /etc/motd
sudo chmod 644 /etc/motd
sudo rm -f /etc/update-motd.d/10* /etc/update-motd.d/8* /etc/update-motd.d/9* /etc/update-motd.d/50-motd-news

echo "Banner /etc/issue.net" | sudo tee -a /etc/ssh/sshd_config 

sudo service ssh restart 




# 2. telegraf 설정 
sudo tar zxvf /home/ubuntu/cloud-init/ubuntu22/telegraf.tgz -C /etc


sudo sed -i 's/20s/60s/' /etc/telegraf/template/template/telegraf.conf.template 
sudo apt install /etc/telegraf/telegraf_1.7.2-1_amd64.deb

sudo systemctl enable --now telegraf  
sudo systemctl status telegraf

# 3. cockput 설치 
. /etc/os-release && sudo apt install -t ${VERSION_CODENAME}-backports cockpit -y


# 4. cloud.cfg
sudo sed -i 's/name: ubuntu/name: kadap/' /etc/cloud/cloud.cfg
sudo sed -i 's/lock_passwd: True/lock_passwd: false/' /etc/cloud/cloud.cfg
sudo sed -i 's/gecos: Ubuntu/gecos: KADaP default user/' /etc/cloud/cloud.cfg



sudo vi /etc/cloud/cloud.cfg
"""
bootcmd:
 - nohup /etc/telegraf/template/reset_metric_agent_conf.sh > /dev/null 2>&1 &
 
apt:
  primary:
    - arches: [default]
      uri: http://mirror.kakao.com/ubuntu/

timezone: Asia/Seoul



sudo rm /etc/netplan/50-cloud-init.yaml
sudo cloud-init clean

sudo reboot
