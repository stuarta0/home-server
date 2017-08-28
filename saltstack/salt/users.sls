{% for username, args in salt['pillar.get']('users', {}).items() %}

{{ username }}:
  user.present:
    - fullname: {{ args.fullname }}
    - home: {{ args.home }}
    - password: {{ args.password }}
    - groups:
      - root

{% endfor %}