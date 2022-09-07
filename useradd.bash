#!/bin/bash

export SCRIPT_DIR=$(cd $(dirname $0); pwd)

. ${SCRIPT_DIR}/config.bash

export USER_ID=`${SCRIPT_DIR}/subcmds/get_next_id.bash`
export PASSWORD=`slappasswd -g`
export PASS_ENT=`slappasswd -s ${PASSWORD}`

echo ${0}: next uid is ${USER_ID}

echo -n "${0}: login name? "
read USERNAME
echo -n "${0}: mail address? "
read MAILADDR

export USERNAME
export MAILADDR

echo -------------------------
echo username: ${USERNAME}
echo mail address: ${MAILADDR}
echo -------------------------
source ${SCRIPT_DIR}/subcmds/confirm_dialog.bash

DATETIME=`date +%Y%m%d-%H%M%S`
LDIF_FILE=${SCRIPT_DIR}/ldifs/${DATETIME}.useradd.ldif

# generate ldif file and register it to the openldap server
envsubst < ${SCRIPT_DIR}/templates/useradd.template.ldif > ${LDIF_FILE}
ldapadd -x -D ${LDAP_ADMIN} -w ${LDAP_ADMIN_PASS} -f ${LDIF_FILE}

# generate user home directory
cd /uhome
cp -Rp /etc/skel /uhome/${USERNAME}
chown -R ${USERNAME}: /uhome/${USERNAME}
chmod 700 /uhome/${USERNAME}

# generate mail text
MAIL_FILE=${SCRIPT_DIR}/mails/${DATETIME}.useradd.txt
envsubst < ${SCRIPT_DIR}/templates/useradd_mail.template.txt > ${MAIL_FILE}

# send mail
LC_CTYPE=ja_JP.UTF-9 cat ${MAIL_FILE} | mailx -r ${MAIL_SENDER} -b ${MAIL_BCC} \
    -s "Notification of your account (${USERNAME}) for COSMIC cluster" ${MAILADDR}

echo ${USERNAME},${MAILADDR}, >> ${SCRIPT_DIR}/mailaddrs.csv
