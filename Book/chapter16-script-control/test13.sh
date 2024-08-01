#!/bin/bash
# Test using at command
#
# at -f test13.sh now
#
echo "This script ran at $(date +%B%d,%T)"
echo
sleep 5
echo "This is the script's end..."
#