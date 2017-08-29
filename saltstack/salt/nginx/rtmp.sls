include:
  - nginx.ffmpeg

nginx:
  group.present: []
  user.present:
    - fullname: NGINX User
    - shell: /bin/false
    - home: /home/nginx
    - groups:
      - nginx
  
nginx-pkgs:
  pkg.installed:
    - pkgs:
      - build-essential
      - libpcre3
      - libpcre3-dev
      - libssl-dev
      - unzip
    
/usr/build:
  file.directory: []
  
download nginx source:
  cmd.run:
    - name: wget -q http://nginx.org/download/nginx-1.11.5.tar.gz
    - cwd: /usr/build
    - creates: /usr/build/nginx-1.11.5.tar.gz

download nginx-rtmp source:
  cmd.run:
    - name: wget -q https://github.com/arut/nginx-rtmp-module/archive/master.zip
    - cwd: /usr/build
    - creates: /usr/build/master.zip

extract nginx source:
  cmd.run:
    - name: tar -xzvf nginx-1.11.5.tar.gz
    - cwd: /usr/build
    #- creates: /usr/build/nginx-1.7.8/
    - onchanges:
      - cmd: download nginx source
      
extract nginx-rtmp source:
  cmd.run:
    - name: unzip master.zip
    - cwd: /usr/build
    - onchanges:
      - cmd: download nginx-rtmp source
      
install nginx:
  cmd.run:
    - name: ./configure --with-http_ssl_module --with-http_stub_status_module --with-http_secure_link_module --with-http_flv_module --with-http_mp4_module --add-module=../nginx-rtmp-module-master && make && make install
    - cwd: /usr/build/nginx-1.11.5
    - unless: test -d /usr/local/nginx

cp stat.xsl /usr/local/nginx/html:
  cmd.run: 
    - cwd: /usr/build/nginx-rtmp-module-master
    
/etc/systemd/system/nginx.service:
  file.managed:
    - source: salt://nginx/files/nginx.service
    - user: root
    - group: root
    - mode: 644
    
/usr/local/nginx/conf/nginx.conf:
  file.managed:
    - source: salt://nginx/files/nginx.conf
    
/var/log/nginx/:
  file.directory:
    - makedirs: True
    - user: nginx
    - group: nginx
    - dir_mode: 755

nginx service:
  service.running:
    - name: nginx  # nginx@nginx.service
    - enable: True
    - restart: True
    # - require:
      # - cmd: install nginx
    - onchanges:
      - file: /etc/systemd/system/nginx.service
      - file: /usr/local/nginx/conf/nginx.conf