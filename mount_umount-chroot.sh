#!/bin/bash
#
#
# Author: josecc@gmail.com
source $(dirname $0)/chroot.conf

if ! [ -f /sbin/fuser -o -f /bin/fuser ] ; then echo -e "\nInstale el paquete psmisc: yum install psmisc\nor\n apt-get install psmisc"; exit -1; fi

if [ "$1" == "status" ] ; then
   echo -e "+ Se muestran procesos(si existen) en cada una de las jaulas dentro de $ROOTJAIL :\n"
   fuser -v $ROOTJAIL/*
   echo -e "\n+ Jaulas con File System montados:\n"
   montados=$(mount | grep "on $ROOTJAIL" | awk '{print $3}')
   for x in $(ls $ROOTJAIL)
   do
      if [[ $montados =~ $x ]] ; then echo -e " $ROOTJAIL/$x"; fi
   done
   exit 0
fi

if [ "$1" == "mountall" ] ; then
for i in $(ls $ROOTJAIL | grep -v X)
do
   echo "Montando $i ..."
   $0 $i mount
   sleep 0.2
done
echo "Termino mountall"
exit 0
fi

if [ "$1" == "umountall" ] ; then
for i in $(ls $ROOTJAIL | grep -v X)
do
   echo "Desmontando $i ..."
   $0 $i umount
done
exit 0
fi

echo " - - - - - - - - - - - - - - - - - -"
echo -e "$0 Monta/Desmontata los dispositivos como /proc /dev /dev/pts /home /sys de la jaula $ROOTJAIL/$1\n"
echo -e "Lee la configuracion /etc/mychroot.conf en cada jaula."
echo -e " - - - - - - - - - - - - - - - - - -\n"

if [ "$1" == "" ] || [ "$2" == "" ] ; then
echo -e "Atencion!!! Nombre de Jaula y accion requerido\nEjecute:\n"
echo -e "$0 NombreJaula [mount|umount]"
echo -e "or"
echo -e "$0 mountall"
echo -e "or"
echo -e "$0 umountall\n"
echo -e "or"
echo -e "$0 status\n"
exit -1
fi

CHROOT=$ROOTJAIL/$1
if [ ! -d $CHROOT ] ; then echo "La jaula no existe. Terminando..."; exit -1; fi

if [ "$2" == "umount" ] ; then

   echo -e "Deteniendo servicio ..."
   for i in $(grep ^"Service:" $CHROOT/etc/mychroot.conf | awk -F\: '{print $2}')
   do
      echo " + $CHROOT$i ..."
      if [ -d $CHROOT/etc/systemd ] ; then
         fuser -vk $CHROOT
      else
         chroot $CHROOT $i stop
      fi
   done

   echo -e "\nDesmontando FS ..."
   for i in $(mount | grep "$CHROOT" | awk '{print $3}' | sort -r)
   do
      echo " + Desmontando $i ..."
      umount $i
      if [ "$?" != "0" ] ; then
         echo -e "ATENCION!!!! no se pudo desmontar $i . Existen procesos ejecutandose dentro de la jaula:"
         fuser -v $CHROOT
         echo -e "\n Indique si quiere terminar con kill los procesos..."
         fuser -ik $CHROOT
         echo -e "*** Por favor ejecute NUEVAMENTE el comando para asegurar que se desmontaron todos los File Systems ***"
         exit -1
      fi
   done
   fuser -k $CHROOT #Fuerza matar procesos dentro de la jaula.

elif [ "$2" == "mount" ] ; then
   if [ ! -f $CHROOT/etc/mychroot.conf ] ; then echo "No existe archivo de configuracion $CHROOT/etc/mychroot.conf. Saliendo"; exit -1; fi

   echo "Montando [`date`] ..."

   for i in $(grep ^"FS:" $CHROOT/etc/mychroot.conf | awk -F\: '{print $2}')
   do
      echo " + $CHROOT$i"
      mkdir -p $CHROOT$i
      mount | grep " on $CHROOT$i" > /dev/null
      if [ "$?" == "1" ] ; then mount --bind $i $CHROOT$i; fi
   done

   migraarchivo() #procesa y migra /etc/passwd, /etc/group, /etc/shadow, /etc/gshadow
   {
      export UGIDLIMIT=500 # UID y GID >= 500 para Centos/RedHat
      if [ "$1" == "/etc/passwd" ] || [ "$1" == "/etc/group" ] ; then awk -v LIMIT=$UGIDLIMIT -F: '($3>=LIMIT) && ($3!=65534)' $1 > /tmp/fileto.mig; fi
      if [ "$1" == "/etc/shadow" ] || [ "$1" == "/etc/gshadow" ] ; then awk -v LIMIT=$UGIDLIMIT -F: '($3>=LIMIT) && ($3!=65534) {print $1}' $CHROOT/etc/passwd | tee - |egrep -f - $1 > /tmp/fileto.mig; fi
      IFS=$'\n'
      for i in $(cat /tmp/fileto.mig)
      do
         campo1=$(echo $i|awk -F: '{print $1}')
         grep $campo1 $CHROOT$1 > /dev/null
         if [ "$?" != "0" ] ; then echo $i >> $CHROOT$1; fi
      done
      rm -f /tmp/fileto.mig
   }

   migraarchivo /etc/passwd
   migraarchivo /etc/group
   migraarchivo /etc/shadow
   migraarchivo /etc/gshadow

   #Actualiza archivos importantes del sistema.
   cp -f /etc/resolv.conf /etc/hosts /etc/fstab $CHROOT/etc/
   chroot $CHROOT mv /etc/localtime /etc/localtime.ori
   chroot $CHROOT ln -s $mylocaltime /etc/localtime
   #grep -v encfs /etc/mtab | grep -v "$1" | grep -v "$ROOTJAIL" > $CHROOT/etc/mtab

   mkdir -p $CHROOT/root
   cp $CHROOT/etc/skel/.??* $CHROOT/root

   echo -e "\nIniciando servicios ..."
   for i in $(grep ^"Service:" $CHROOT/etc/mychroot.conf | awk -F\: '{print $2}')
   do
      echo " + $CHROOT$i"
      if [ -d $CHROOT/etc/systemd ] ; then
         s=$(echo $i | awk -F\/ '{print $NF}')
         #Sistemas Linux con 'systemd' es necesario levantar 'manualmente' los servicios. Implementarlos aqui:
         if [[ $s =~ .*cron.* ]] ; then echo 'c=$(which crond) || c=$(which cron); eval $c' > $CHROOT/opt/cron.sh; chmod 700 $CHROOT/opt/cron.sh; chroot $CHROOT /opt/cron.sh; rm -f $CHROOT/opt/cron.sh; echo " $s [done]"; fi
         if [[ $s =~ .*syslog.* ]] ; then echo 'c=$(which rsyslogd); eval "$c -f /etc/rsyslog.conf"' > $CHROOT/opt/cron.sh; chmod 700 $CHROOT/opt/cron.sh; chroot $CHROOT /opt/cron.sh; rm -f $CHROOT/opt/cron.sh; echo " $s [done]"; fi
      else
         chroot $CHROOT $i start
      fi
   done

   echo "Done."
else
   echo "Opcion no valida. Saliendo ..."
   exit -1
fi

echo -e "\nTermino. Revise en los mensajes anteriores si hubo algun error y revise.\n"
