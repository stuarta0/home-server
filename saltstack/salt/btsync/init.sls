install:
  pkgrepo.managed:
    - humanname: Bittorrent Sync PPA
    - name: deb http://linux-packages.getsync.com/btsync/deb btsync non-free
    - key_url: http://linux-packages.getsync.com/btsync/key.asc
  pkg.installed:
    - name: btsync
    # user/group btsync:btsync automatically created
  file.directory:
    - name: /store/btsync
    - user: btsync
    - group: btsync
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - user
      - group
      - mode

config:
  file.managed:
    - name: /etc/btsync/config.json
    - source: salt://btsync/config.json
    - user: root
    - group: root
    - mode: 644
  
services:
  service.running:
    - name: btsync
    - enable: True
    - reload: True