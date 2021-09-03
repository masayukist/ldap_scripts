#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)

. ${SCRIPT_DIR}/config.bash

echo -n "${0}: login name? "
read USERNAME

DATETIME=`date +%Y%m%d-%H%M%S`
LDIF_FILE=${SCRIPT_DIR}/ldifs/${DATETIME}.userdel.ldif

# generate ldif file and register it to the openldap server
envsubst < ${SCRIPT_DIR}/templates/userdel.template.ldif > ${LDIF_FILE}
ldapdelete -x -D ${LDAP_ADMIN} -w ${LDAP_ADMIN_PASS} -f ${LDIF_FILE}

# remove user home directory
mkdir -p /uhome/deleted_users
mv /uhome/${USERNAME} /uhome/deleted_users/${USERNAME}
chown -R root: /uhome/deleted_users/${USERNAME}

# generate mail text
MAIL_FILE=${SCRIPT_DIR}/mails/${DATETIME}.userdel.txt
envsubst < ${SCRIPT_DIR}/templates/userdel_mail.template.txt > ${MAIL_FILE}

# send mail
LC_CTYPE=ja_JP.UTF-9 cat ${MAIL_FILE} | mailx -r ${MAIL_SENDER} \
    -s "Notification of the account (${USERNAME}) for COSMIC cluster" cosmicadm.plum.mech@grp.tohoku.ac.jp
