#!/bin/sh

NORMAL="\[\e[0m\]"
RED="\[\e[1;31m\]"
YELLOW="\[\e[1;33m\]"
GREEN="\[\e[1;32m\]"
if [ `id -u` -eq 0 ]; then
	PS1="🐳 $RED\h [$YELLOW\w$RED]# $NORMAL"
else
	PS1="🐳 $GREEN\h [$YELLOW\w$GREEN]\$ $NORMAL"
fi
