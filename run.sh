#!/bin/sh
chown -R vmail /var/vmail
chown -R www-data /var/www/html/
chown -R mysql /var/lib/mysql
chown :syslog /var/log/
chmod 775 /var/log/
mkdir -p /var/log/apache2 /var/log/mysql
if [ ! -d "/var/lib/mysql/mysql" ]; then /usr/bin/mysql_install_db;fi
/etc/init.d/mysql start;
if [ ! -d "/var/lib/mysql/mail" ]; 
then 
    PSSW=`doveadm pw -s MD5-CRYPT -p $ADMIN_PASSWD | sed 's/{MD5-CRYPT}//'`
    mysql < /roundcube_postfixadmin.sql;mysql -e "insert into admin values('$ADMIN_USERNAME','$PSSW',1,'2016-03-02 15:23:14','2016-03-03 16:24:44',1);insert into domain_admins values('$ADMIN_USERNAME', 'ALL', NOW(), 1)" mail;
    # TODO make configuration.
    postfixadmin-cli domain add $DOMAIN_NAME --aliases 0 --mailboxes 0
    USERS_LIST=$(echo $USERS | tr , \\n)
    for USER in $USERS_LIST; do
        _user=$(echo $USER | awk -F':' '{print $1}')
        _pwd=$(echo $USER | awk -F':' '{print $2}')
        postfixadmin-cli mailbox add $_user@$DOMAIN_NAME --password $_pwd --password2 $_pwd --quota $USERS_QUOTA --name $_user
    done
fi
/etc/init.d/postfix start;/etc/init.d/rsyslog start;/etc/init.d/spamassassin start;/etc/init.d/apache2 start;/usr/sbin/dovecot -F
