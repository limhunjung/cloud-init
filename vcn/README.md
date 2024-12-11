```bash
#https://github.com/kasmtech/KasmVNC
#https://kasmweb.com/kasmvnc/docs/latest/index.html

$ wget https://github.com/kasmtech/KasmVNC/releases/download/v1.3.3/kasmvncserver_jammy_1.3.3_amd64.deb
sudo apt-get install ./kasmvncserver_*.deb
sudo adduser $USER ssl-cert  #로그아웃 후 재 접속 필요 



vncserver

10.10.17.20  kadap/kadap1234

sudo mv ~/cloud-init/vcn/vncserver.service /etc/systemd/system/

sudo systemctl enable vncserver.service
sudo systemctl status vncserver.service

```


---

# Get a list of current sessions with display IDs
vncserver -list

# Kill the VNC session with display ID :2
vncserver -kill :2


설정 파일 
- globla : /etc/kasmvnc/kasmvnc.yaml
- per user : ~/.vnc/kasmvnc.yaml




1. VNC는 기본 local접속만 허용 하여 외부 접속시 0.0.0.0 설정 해야 함 -> 되어 있음 


#     pem_certificate: /etc/ssl/certs/ssl-cert-snakeoil.pem
#     pem_key: /etc/ssl/private/ssl-cert-snakeoil.key


로그 파일 
tail -f ~/.vnc/*.log



http://10.10.17.23:8444/


vncserver -disableBasicAuth
