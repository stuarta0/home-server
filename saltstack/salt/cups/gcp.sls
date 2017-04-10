# Google Cloud Print state

cloud print pkgs:
  pkg.installed:
    - pkgs:
      - build-essential
      - libcups2-dev
      - libavahi-client-dev
      - avahi-discover  # https://github.com/google/cloud-print-connector/issues/214
      - git
      - bzr

extract cloud print:
  archive.extracted:
    - name: /usr/local
    - source: salt://cups/files/go1.7.4.linux-amd64.tar.gz
    - if_missing: /usr/local/go
      
# add go bin location system wide
sudo sed -i '$ a export PATH=$PATH:/usr/local/go/bin' /etc/profile:
  cmd.run:
    - unless: cat /etc/profile | grep -q /usr/local/go/bin

# reload shell with updated PATH, export GO working directory and get/compile source
compile gcp:
  cmd.run:
    - name: . /etc/profile && export GOPATH=/usr/build/go && go get github.com/google/cloud-print-connector/...
    - shell: /bin/bash
    - creates: /usr/build/go/bin/gcp-cups-connector

cloud-print-connector:
  group.present: []
  user.present:
    - fullname: Google Cloud Print User
    - shell: /bin/false
    - home: /home/gcp/
    - groups:
      - cloud-print-connector
    
/opt/cloud-print-connector:
  file.directory:
    - user: cloud-print-connector
    - group: cloud-print-connector
    - mode: 755

cp /usr/build/go/bin/gcp-* /opt/cloud-print-connector/:
  cmd.run:
    - onchanges:
      - cmd: compile gcp
  
# enable local printing? y
# enable cloud printing? y
# visit https://www.google.com/device and enter this code XXXX-XXXX (auto-generated)... hmm
# configure cloud print:
  # cmd.run:
    # - name: export GOPATH=/usr/build/go && /usr/build/go/bin/gcp-connector-util init <<< $'y\ny\n...'

# alternative to automated "gcp-connector-util init" (manually run init and copied config)
# NOTE: needs to be manually replaced by running gcp-connector-util init script
/opt/cloud-print-connector/gcp-cups-connector.config.json:
  file.managed:
    - source: salt://cups/files/gcp-cups-connector.config.json
    - user: cloud-print-connector
    - group: cloud-print-connector
    
chown cloud-print-connector:cloud-print-connector /opt/cloud-print-connector/gcp-*:
  cmd.run: []
    
/etc/systemd/system/cloud-print-connector.service:
  file.managed:
    - source: salt://cups/files/cloud-print-connector.service
    - mode: 644

start cloud print:
  service.running:
    - name: cloud-print-connector.service
    - enable: True
    - restart: True