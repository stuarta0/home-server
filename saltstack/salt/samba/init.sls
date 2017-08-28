# https://help.ubuntu.com/lts/serverguide/samba-fileserver.html

samba:
  pkg.installed

{{ salt['pillar.get']('store:location', '') }}/samba/storage:
  file.directory:
    - makedirs: True
    - user: nobody
    - group: nogroup
    - dir_mode: 755

samba-conf:
  file.managed:
    - name: /etc/samba/smb.conf
    - source: salt://samba/files/smb.conf
    - mode: 644

smbd.service:  # and nmdb.service
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: samba-conf
