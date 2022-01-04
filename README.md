**THIS IS A FORK OF https://github.com/marooou/postfix-roundcube**


# postfix-roundcube

This is a docker image for Postfix, Dovecot, PostfixAdmin and Roundcube running all
in one container for mail server testing purposes.

## How-to guide

1. Create directory for persistent data: accounts, emails, databases and logs.
```
mkdir -p /data/ 
```

2. Start docker container

```
docker run -e "ADMIN_USERNAME=root"
           -e "ADMIN_PASSWD=password" 
           -e "DOMAIN_NAME=example.com"
           -e "USERS=user1:pass1,user2:pass2"
           -d -v /data/mysql:/var/lib/mysql -v /data/vmail/:/var/vmail -v /data/log:/var/log 
           -p 25:25 -p 80:80 -p 110:110 -p 143:143 -p 465:465 -p 993:993 -p 995:995 
           marooou/postfix-roundcube
```

## Possible environment variables

- `ADMIN_USERNAME` - The name of SUPERUSER for PostfixAdmin
- `ADMIN_PASSWD` - The password of SUPERUSER for PostfixAdmin
- `DOMAIN_NAME` - a mail domain
- `USERS` - a comma separated list of username:passwords which will be created (e.g. user1:pass1,user2:pass2).
- `USERS_QUOTA` - a space quota for each mailbox in MBs (defauls to 50).

## Services

After running container, you can access the mail server via:

- Protocols: pop3, smtp, imap, pop3s imaps, smtps
- PostfixAdmin - http://yourhost/postfixadmin - use login and password defined within docker start, with variables ADMIN_USERNAME and ADMIN_PASSWD.
- Roundcube - http://yourhost/roundcubemail - use accounts created with either with the admin panel or with USERS env variable - - 

