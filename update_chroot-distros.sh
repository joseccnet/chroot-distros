#!/bin/bash
#Ejecute para revisar si hay actualizaciones o mejoras en los archivos del proyecto
cd $(dirname $0)
git fetch --all
git reset --hard origin/master
git pull --rebase
chmod 750 *.sh