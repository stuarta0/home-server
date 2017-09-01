goaccess:
  pkgrepo.managed:
    - hummanname: GoAccess
    - name: deb http://deb.goaccess.io/ xenial main
    - key_url: https://deb.goaccess.io/gnugpg.key
  pkg.installed: []

/etc/goaccess.conf:
  file.managed:
    - source: salt://goaccess/files/goaccess.conf
    - mode: 644

