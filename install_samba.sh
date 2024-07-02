#!/bin/sh

sudo apt install -y samba samba-common-bin

echo "[efindershare]" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "path = /home/efinder" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "writeable=Yes" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "create mask=0777" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "directory mask=0777" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "public=no" | sudo tee -a /etc/samba/smb.conf > /dev/null

pass='secret'
echo -e "$pass\n$pass" | smbpasswd -a -s $(id -un)
sudo systemctl restart smbd
