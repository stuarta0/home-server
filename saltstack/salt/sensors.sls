install sensors:
  pkg.installed:
    - list:
      - lm-sensors
      - hddtemp
  
init lm sensors:
  cmd.run:
    - name: detect-sensors <<< "\n\n\n\n\n\n\n\n\n\n\n\n\n\nyes\n"
    
kmod:
  service.running
 
# for CPU temp: 
# > sensors

# for HDD temp:
# > hddtemp /dev/sda