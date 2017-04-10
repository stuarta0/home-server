crashplan:
  group.present: []
  user.present:
    - fullname: CrashPlan User
    - shell: /bin/false
    - home: /home/crashplan
    - groups:
      - crashplan
      
/home/crashplan/download/:
  file.directory:
    - user: crashplan
    - group: crashplan
    - dir_mode: 755
        
/store/crashplan:
  file.directory:
    - user: crashplan
    - group: crashplan
    - dir_mode: 755
      
download crashplan:
  cmd.run:
    - name: wget -q https://download1.code42.com/installs/linux/install/CrashPlan/CrashPlan_4.8.0_Linux.tgz
    - cwd: /home/crashplan/download/
    - creates: /home/crashplan/download/CrashPlan_4.8.0_Linux.tgz

extract crashplan archive:
  cmd.run:
    - name: tar -xzvf CrashPlan_4.8.0_Linux.tgz
    - runas: crashplan
    - cwd: /home/crashplan/download/
    - onchanges:
      - cmd: download crashplan

/usr/local/crashplan:
  file.directory:
    - user: crashplan
    - group: crashplan
    - dir_mode: 755

# CANNOT CONFIGURE CRASHPLAN IF INSTALLED AS NON-ROOT
# (there may be a way but I don't know it)
# Instead: 
# cd /home/crashplan/download/crashplan-install/
# ./install.sh and choose y for install as root
# 
#install crashplan:
#  cmd.run:
#    # install.sh interactive input as follows:
#    # enter to continue
#    # install as root? n
#    # install directory: /home/crashplan
#    # data directory: /store/crashplan
#    # is this correct? y
#    # enter to continue
#    - name: /home/crashplan/download/crashplan-install/install.sh <<< $'\nn\n/usr/local\n/store/crashplan\ny\n\n'
#    - runas: crashplan
#    - onchanges:
#      - cmd: extract crashplan archive