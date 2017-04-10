use internode repos:
  cmd.run:
    - name: sed -i.bak -r "s|((http://)[^ ]+)|\2mirror.internode.on.net/pub/ubuntu/ubuntu|g" sources.list
    - cwd: /etc/apt/