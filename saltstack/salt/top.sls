base:
  'vagrant-server':
    - store.vm
  'home-server':
    - store.prod
  '*':
    - users
    - common
    - isp
    - syncthing
    - minio
    - cups
    - cups.gcp
    - nginx.rtmp
    - samba
