# Requires session from their download site, use managed zip instead
# download driver: 
  # cmd.run:
    # - name: wget http://onlinesupport.fujixerox.com/processDriverForm.do;jsessionid=29660A32DE1BD340969404FF9848EE0E.worker2?ctry_code=AU&lang_code=en&d_lang=en&corp_pid=DPM255Z&rts=null&model=DocuPrint+M255+z&type_id=2&source=fxpc&oslist=GNU+%2F+Linux&lang_list=en
    # - cwd: {{ salt['pillar.get']('store:location', '') }}/downloads
    # - creates: {{ salt['pillar.get']('store:location', '') }}/downloads/DocuPrint_M255_Linux_Driver_1.0.zip
    
# TODO: just manage the .deb file
copy print driver:
  file.managed:
    - name: {{ salt['pillar.get']('store:location', '') }}/downloads/DocuPrint_M255_Linux_Driver_1.0.zip
    - source: salt://cups/files/DocuPrint_M255_Linux_Driver_1.0.zip

extract print driver:
  cmd.run:
    - name: unzip DocuPrint_M255_Linux_Driver_1.0.zip
    - cwd: {{ salt['pillar.get']('store:location', '') }}/downloads
    - onchanges:
      - file: copy print driver

# Not working for me...
# extract driver:
  # archive.cmd_unzip:
    # - dest: {{ salt['pillar.get']('store:location', '') }}/downloads
    # - zip_file: salt://cups/files/DocuPrint_M255_Linux_Driver_1.0.zip
    
install driver:
  pkg.installed:
    - sources:
      - fx-docuprint-m255: {{ salt['pillar.get']('store:location', '') }}/downloads/fx-docuprint-m255_1.0-19_all.deb
      
# this takes quite some time
cups:
  pkg.installed: []
  
/etc/cups/cupsd.conf:
  file.managed:
    - source: salt://cups/files/cupsd.conf

sudo usermod -aG lpadmin stuart:
  cmd.run: []
 
 
# State 'add printer m255' does the following:
#
# navigate to https://<server_ip>:631/
# go to Administration > Add Printer, click Add Printer
# enter username/password of any user who has been added to the lpadmin group (stuart)
# Choose HTTP printer
# socket://192.168.178.110:9100
# name: Fuji_Xerox_DocuPrint_M255_z
# description: Fuji Xerox DocuPrint M255 z
# manufacturer: FX
# model: FX DocuPrint M255 z

add printer m255:
  service.dead:
    - name: cups
  file.managed:
    - name: /etc/cups/printers.conf
    - source: salt://cups/files/printers.conf

start cups:
  service.running:
    - name: cups
    - enable: True
    - restart: True
