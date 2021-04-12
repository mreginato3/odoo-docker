#!/bin/sh

FOLDER=/mnt/
#VENV=/home/igomez/workspace_python/odoo11/venv

# Instalar cups
#sudo apt-get install libssl-dev swig python3-dev gcc
#sudo apt-get install libcups2-dev
#sudo apt-get install libxml2-dev libxmlsec1-dev
#sudo apt-get install libsasl2-dev python-dev libldap2-dev libssl-dev

# Activación del Viertual Env
#cd $VENV
#source bin/activate

# Actualizacion de PIP
#cd bin
#python3.8 -m pip install --upgrade pip

# Instalación de dependencias
cd $FOLDER

LIST=$(find $FOLDER -name "requirements.txt")

for FILE in $LIST
do
	python3 -m pip install -r $FILE
done

#deactivate

exit 0
