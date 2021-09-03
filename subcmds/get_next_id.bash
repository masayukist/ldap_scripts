#!/bin/bash

. ${SCRIPT_DIR}/config.bash

MAX_ID=`${SCRIPT_DIR}/subcmds/ldapsearch_head.bash uidNumber | grep ^uidNumber | awk '{if(m<$2 && $2<1099) m=$2} END{print m}'`
echo `expr $MAX_ID + 1`
