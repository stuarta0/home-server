# https://minio.io/downloads/#minio-server
# wget https://dl.minio.io/server/minio/release/linux-amd64/minio
# chmod +x minio
# ./minio server ~/Photos

# we configure a minio config and service per instance in pillar
# https://github.com/krishnasrinivas/cookbook/blob/68b6dab51f557ed437449104970abcf3bacf4b7b/docs/multi-tenancy-in-minio.md

minio:
  group.present: []
  user.present:
    - fullname: Minio Server User
    - shell: /bin/false
    - home: /home/minio/
    - groups:
      - minio

{{ salt['pillar.get']('store:location', '') }}/minio:
  file.directory:
    - makedirs: True
    - user: minio
    - group: minio
    - dir_mode: 755

/usr/local/bin/minio:
  file.managed:
    - source: salt://minio/files/minio
    - user: minio
    - group: minio
    - mode: 755

/etc/systemd/system/minio@.service:
  file.managed:
    - source: salt://minio/files/minio@.service
    - mode: 644

/etc/nginx/sites-available/minio.conf:
  file.managed:
    - source: salt://minio/files/nginx-reverse-proxy.conf
    - template: jinja
    - user: nginx
    - group: nginx
    - mode: 644
    - makedirs: True

/etc/nginx/sites-enabled/minio.conf:
  file.symlink:
    - target: /etc/nginx/sites-available/minio.conf
    - user: nginx
    - group: nginx
    - makedirs: True

{% for name, args in salt['pillar.get']('minio:accounts', {}).items() %}

/etc/minio/{{ name }}:
  file.directory:
    - makedirs: True
    - user: minio
    - group: minio
    - dir_mode: 755

# https://askubuntu.com/questions/659267/how-do-i-override-or-configure-systemd-services
/etc/minio/{{ name }}/.env:
  file.managed:
    - source: salt://minio/files/minio.env
    - user: minio
    - group: minio
    - mode: 644
    - template: jinja
    - context:
        address: ":{{ args.port }}"
        store: {{ salt['pillar.get']('store:location', '/') }}

/etc/minio/{{ name }}/config.json:
  file.managed:
    - source: salt://minio/files/config-v19.json
    - template: jinja
    - user: minio
    - group: minio
    - mode: 644
    - context:
        key: {{ args.key }}
        secret: {{ args.secret }}

# https://superuser.com/questions/393423/the-symbol-and-systemctl-and-vsftpd
minio@{{ name }}.service:
  service.running:
    - enable: True
    - restart: True

{% endfor %}