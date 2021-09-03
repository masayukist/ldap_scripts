#!/bin/bash

export SCRIPT_DIR=$(cd $(dirname $0); pwd)

. ${SCRIPT_DIR}/config.bash

read -p "Group name?: " GROUP_NAME

export GROUP_NAME

DATETIME=`date +%Y%m%d-%H%M%S`
LDIF_FILE=${SCRIPT_DIR}/ldifs/${DATETIME}.groupdel.ldif

envsubst < ${SCRIPT_DIR}/templates/groupdel.template.ldif > ${LDIF_FILE}
ldapdelete -x -D ${LDAP_ADMIN} -w ${LDAP_ADMIN_PASS} -f ${LDIF_FILE}
