
'''python

#!/usr/bin/bash
echo "-------------------------"
echo "| Ubuntu 22.04 Script |"
echo "-------------------------"
echo ""

msg="git clone File download";
git clone https://github.com/limhunjung/cloud-init.git
if [ $? -eq 0 ]; then echo "[OK] ${msg}";else echo "[FAIL] ${msg}" && exit 1; fi

cd /home/ubuntu/cloud-init/ubuntu22/

msg="Replace ssh_config FIle";
chmod 644 /home/ubuntu/cloud-init/ubuntu22/sshd_config
sudo chown root sshd_config && sudo chgrp root sshd_config
sudo mv /home/ubuntu/cloud-init/ubuntu22/sshd_config /etc/ssh/sshd_config
if [ $? -eq 0 ]; then echo "[OK] ${msg}";else echo "[FAIL] ${msg}" && exit 1; fi

msg="Replace repository FIle";
chmod 644 /home/ubuntu/cloud-init/ubuntu22/sources.list
sudo chown root sources.list && sudo chgrp root sources.list
sudo mv /home/ubuntu/cloud-init/ubuntu22/sources.list /etc/apt/sources.list
if [ $? -eq 0 ]; then echo "[OK] ${msg}";else echo "[FAIL] ${msg}" && exit 1; fi


msg="motd msg";
mv /home/ubuntu/cloud-init/ubuntu22/*.msg /home/ubuntu/.ssh/
sudo rm -f /etc/update-motd.d/10-help-text /etc/update-motd.d/88-esm-announce /etc/update-motd.d/90-updates-available /etc/update-motd.d/91-release-upgrade
if [ $? -eq 0 ]; then echo "[OK] ${msg}";else echo "[FAIL] ${msg}" && exit 1; fi

sudo echo "if [ -f /home/ubuntu/.ssh/first-login.msg ]; then rm -f /home/ubuntu/.ssh/first-login.msg; else cat /home/ubuntu/.ssh/kadap-welecome.msg; fi" | sudo tee -a /etc/profile
if [ $? -eq 0 ]; then echo "[OK] ${msg}";else echo "[FAIL] ${msg}" && exit 1; fi

sudo chmod -R 755 /home/ubuntu/
if [ $? -eq 0 ]; then echo "[OK] ${msg}";else echo "[FAIL] ${msg}" && exit 1; fi


msg="telegraf installation";
sudo tar zxvf /home/ubuntu/cloud-init/ubuntu22/telegraf.tgz -C /etc
sudo apt update; sudo apt install jq -y

sudo vi /etc/telegraf/template/template/telegraf.conf.template  #interval = "60s" 로 조정

sudo apt install /etc/telegraf/telegraf_1.7.2-1_amd64.deb
if [ $? -eq 0 ]; then echo "[OK] ${msg}";else echo "[FAIL] ${msg}" && exit 1; fi

sudo systemctl enable --now telegraf  
if [ $? -eq 0 ]; then echo "[OK] ${msg}";else echo "[FAIL] ${msg}" && exit 1; fi
sudo echo "(nohup /etc/telegraf/template/reset_metric_agent_conf.sh > /dev/null 2>&1 &) #telegraf config script" | sudo tee -a /etc/profile
if [ $? -eq 0 ]; then echo "[OK] ${msg}";else echo "[FAIL] ${msg}" && exit 1; fi
sudo systemctl status telegraf

msg="Cockpit";
. /etc/os-release
sudo apt install -y cockpit
# banner /etc/issue.d

msg="Finishing";
sudo apt install -y acpid cloud-init cloud-initramfs-growroot


# https://sarc.io/index.php/cloud/2353-gcp-gcp-ubuntu-vm-apt-repo

sudo echo "apt_preserve_sources_list: true" | sudo tee -a /etc/cloud/cloud.cfg


msg="set-timezone";
sudo timedatectl set-timezone 'Asia/Seoul'
if [ $? -eq 0 ]; then echo "[OK] ${msg}";else echo "[FAIL] ${msg}" && exit 1; fi  

msg="Cleaning";

sudo rm /etc/netplan/50-cloud-init.yaml
rm -rf /home/ubuntu/cloud-init
if [ $? -eq 0 ]; then echo "[OK] ${msg}";else echo "[FAIL] ${msg}" && exit 1; fi  

sudo cloud-init clean
if [ $? -eq 0 ]; then echo "[OK] ${msg}";else echo "[FAIL] ${msg}" && exit 1; fi  

sudo apt autoclean
if [ $? -eq 0 ]; then echo "[OK] ${msg}";else echo "[FAIL] ${msg}" && exit 1; fi  

sudo passwd  root

cat <<'EOF'

su - 
sudo passwd --expire root 
history -cw  

$ poweroff

EOF
```



