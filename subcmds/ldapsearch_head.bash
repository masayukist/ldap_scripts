#!/bin/bash

. ${SCRIPT_DIR}/config.bash

LDAPTLS_REQCERT=never ldapsearch \
    -H ${LDAP_URI} \
    -x \
    -D ${LDAP_ADMIN} \
    -w ${LDAP_ADMIN_PASS} \
    -b ${LDAP_DN} \
    ${@}
