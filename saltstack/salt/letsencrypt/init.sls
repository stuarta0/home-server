certbot-repo:
  pkgrepo.managed:
    - ppa: certbot/certbot

python-certbot-nginx:
  pkg.installed

#certbot --nginx:
#  cmd.run

certbot renew:
  cron.present:
    - identifier: letsencrypt_renewal
    - hour: 7
    - minute: 0
