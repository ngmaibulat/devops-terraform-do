#!/bin/bash

mkdir /opt/app

sudo apt -y install nginx

sudo apt -y install vim nala

sudo systemctl enable nginx

sudo systemctl start nginx
