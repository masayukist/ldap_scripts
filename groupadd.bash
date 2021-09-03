#!/bin/bash

export SCRIPT_DIR=$(cd $(dirname $0); pwd)

. ${SCRIPT_DIR}/config.bash

GROUP_ID=`${SCRIPT_DIR}/subcmds/get_next_gid.bash`

echo new group id is ${GROUP_ID}
read -p "Group name?: " GROUP_NAME

export GROUP_NAME
export GROUP_ID

DATETIME=`date +%Y%m%d-%H%M%S`
LDIF_FILE=${SCRIPT_DIR}/ldifs/${DATETIME}.groupadd.ldif

envsubst < ${SCRIPT_DIR}/templates/groupadd.template.ldif > ${LDIF_FILE}
ldapadd -x -D ${LDAP_ADMIN} -w ${LDAP_ADMIN_PASS} -f ${LDIF_FILE}
