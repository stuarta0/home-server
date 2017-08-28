{{ salt['pillar.get']('store:location', '/store') }}:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    
{{ salt['pillar.get']('store:location', '/store') }}/downloads:
  file.directory:
    - dir_mode: 755