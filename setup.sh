#!/bin/bash
# Usage: setup <CONFIG> <HOST> <PASSWORD> [<USER>]

# Read project config
. $1

HOST=$2
PASSWORD=$3
USER=$4

scp bootstrap.sh $USER:$PASSWORD@$HOST:
ssh $USER:$PASSWORD@$HOST bootstrap.sh $GIT_REPO
