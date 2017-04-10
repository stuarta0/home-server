syncthing:
  pkgrepo.managed:
    - humanname: Syncthing PPA
    - name: deb http://apt.syncthing.net/ syncthing release
    - key_url: https://syncthing.net/release-key.txt
  pkg.installed: []
  group.present: []
  user.present:
    - fullname: Syncthing User
    - shell: /bin/false
    - home: /home/syncthing
    - groups:
      - syncthing
      
/etc/systemd/system/syncthing.service:
  file.managed:
    - source: salt://syncthing/files/syncthing@.service
    - user: root
    - group: root
    - mode: 644
    
/home/syncthing/.config/syncthing/config.xml:
  file.managed:
    - source: salt://syncthing/files/config.xml
    - user: syncthing
    - group: syncthing
    - mode: 600
    - makedirs: True
    
syncthing service:
  #service.enabled:
    #- name: syncthing
  service.running:
    - name: syncthing@syncthing.service
    - enable: True
    - restart: True
    - watch:
      - pkg: syncthing