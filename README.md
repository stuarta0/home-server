# Home Server

## Vagrant

    vagrant up

1. After complete, run PuTTYgen, Conversions > Import Key and browse to .vagrant/machines/server/virtualbox/private_key
1. Then *Save private key* to the same folder as ```private_key.ppk```
1. In PuTTY settings for vagrant-server, use this file in Connection > SSH > Auth > Private key file for authentication

## Physical Server

1. Install from server image (include OpenSSH server). Create desired logon user for non-privileged use later.
1. To get salt running, follow the instructions here (https://docs.saltstack.com/en/latest/topics/tutorials/quickstart.html): 
    ```
    curl -L https://bootstrap.saltstack.com -o bootstrap_salt.sh
    chmod 755 bootstrap_salt.sh
    sudo sh bootstrap_salt.sh
    ```
1. Change ```file_client: local``` in ```/etc/salt/minion```
1. Now copy over the salt scripts (the following was using a USB drive):
    ```
    sudo fdisk -l #get list of devices to find USB with salt code
    sudo mkdir /media/external
    sudo mount /dev/sdc1 /media/external
    sudo mkdir /srv/salt
    sudo cp -r /media/external/salstack/salt /srv
    shutdown -r now #unplug USB drive to ensure /dev/sdb is the storage drive
    sudo salt-call state.highstate
    ```
## Manual setup after salt provisioning

### Google Cloud Print

1. Change to cloud-print-connector user ```sudo -u cloud-print-connector bash```
1. ```cd /opt/cloud-print-connector```
1. ```export GOPATH=/usr/build/go && /usr/build/go/bin/gcp-connector-util init``` and follow instructions to complete cloud print setup

### CrashPlan

CrashPlan for Home is being phased out. Duplicati+Minio will replace CrashPlan for our needs.

* https://support.code42.com/CrashPlan/4/Getting_Started/Installing_The_Code42_CrashPlan_App#Linux
* https://support.code42.com/CrashPlan/4/Configuring/Using_CrashPlan_On_A_Headless_Computer

1. Use a privileged user to install since I wasn't able to get CrashPlan running under the crashplan user
1. ```cd /home/crashplan/download/crashplan-install/```
1. Run ```./install.sh``` with ```/usr/local``` as installation directory and ```/store/crashplan``` as store
1. When asked, use root user
1. Accept the remaining defaults (works with ubuntu 16.04)
1. Now setup remote admin
