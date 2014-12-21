#!/bin/bash
#
#
# Author: josecc@gmail.com
source $(dirname $0)/chroot.conf

echo " - - - - - - - - - - - - - - - - - -"
echo -e "$0 Eliminara la jaula $ROOTJAIL/$1\n"
echo -e " - - - - - - - - - - - - - - - - - -\n"
#sleep 3

if [ "$1" == "" ]; then
echo -e "Nombre de Jaula requerido\nEjecute:\n"
echo -e "$0 NombreJaula\n"
echo -e "or\n"
echo -e "$0 NombreJaula umountonly\n"
exit -1
fi

CHROOT=$ROOTJAIL/$1

if [ ! -d $CHROOT ] ; then echo "La jaula no existe. Terminando..."; exit -1; fi

$(dirname $0)/mount_umount-chroot.sh $1 umount
if [ "$?" != "0" ] ; then echo -e "\nError? Terminando. Revise.\n" ; exit -1; fi

#for i in $(mount | grep "$CHROOT" | awk '{print $3}' | sort -r)
#do
#echo "Desmontando $i ..."
#umount $i
#done

if [ "$2" == "umountonly" ] ; then exit 0; fi

echo "Eliminando $CHROOT ..."
rm -rf $CHROOT

echo -e "\nTermino. Revise en los mensajes anteriores si hubo algun error y revise.\n"
