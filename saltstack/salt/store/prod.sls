{{ salt['pillar.get']('store:location', '/store') }}:
  mount.mounted:
    - device: {{ salt['pillar.get']('store:device', '/dev/sdb') }}
    - fstype: ext4
    - mkmnt: True
    - persist: True
    - user: root
    
{{ salt['pillar.get']('store:location', '/store') }}/downloads:
  file.directory:
    - dir_mode: 755