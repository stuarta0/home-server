/store:
  mount.mounted:
    - device: /dev/sdb
    - fstype: ext4
    - mkmnt: True
    - persist: True
    - user: root
    
/store/downloads:
  file.directory:
    - dir_mode: 755