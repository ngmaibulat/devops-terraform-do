#!/bin/bash

# set vars

export AWS_PAGER=""
export IP=`terraform output -raw ip`
export HOST=`terraform output -raw dns`


# perform tests

echo -e "\033[32m"

echo -e "\n\nTesting access - should succeed:\n"
nc -vz $IP 22

echo -e "\n\nTesting DNS resolvde - should succeed:\n"
nslookup $HOST

echo -e "\n\nRunning ssh-keyscan:\n"
ssh-keyscan $IP
ssh-keyscan $IP >> ~/.ssh/known_hosts

curl -v $IP
curl -v https://$HOST

# show help

echo "use command to connect to the server:"
echo "ssh root@$IP"

# unset vars to allow normal access level

unset IP
echo -e "\033[0m"
