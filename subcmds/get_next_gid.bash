#!/bin/bash

. ${SCRIPT_DIR}/config.bash

MAX_ID=`${SCRIPT_DIR}/subcmds/ldapsearch_head.bash gidNumber | grep ^gidNumber | awk '{if(m<$2) m=$2} END{print m}'`
echo `expr $MAX_ID + 1`
