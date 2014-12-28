#!/bin/bash
# Author: josecc@gmail.com

source $(dirname $0)/chroot.conf

if [ "$1" != "I_AM_AGREE" ] ; then
   echo -e "\nPara continuar, Ejecute:"
   echo -e "   $0 I_AM_AGREE NombreDistro &\n"
   echo -e "   Donde NombreDistro puede ser: Debian , Ubuntu , Centos, Fedora, OpenSuse o KaliLinux\n\n"

   echo -e "La ejecucion de este script intentara instalar todas las versiones de sistemas operativos en jaulas con 'chroot'.\n\nTenga en cuenta:"
   echo -e " + Se asume que usted entiende sobre administracion de sistemas operativos Linux, en particular de temas con 'chroot'"
   echo -e " + Revise la configuracion del archivo $(dirname $0)/chroot.conf"
   echo -e " + Necesita cerca de 10GB de espacio libre en $ROOTJAIL para instalar todas las versiones de Linux soportadas."
   echo -e " + Despues de ejecutar este script, **NO** elimine los directorios dentro de $ROOTJAIL SIN desmontar los File Systems (ejecutar script mount_umount-chroot.sh)"
   echo -e " + Ignorar esta advertencia puede causar inestabilidad en el sistema o incluso BORRAR archivos del sistema(ejemplo /home)\n\n"
   exit -1
fi

if ! [ "$2" == "Debian" -o "$2" == "Ubuntu" -o "$2" == "Centos" -o "$2" == ""OpenSuse -o "$2" == "KaliLinux" -o "$2" == "Fedora" ] ; then echo "Opcion no valida. Termino"; exit -1; fi

echo "Enviando log de instalacion al archivo /tmp/install-all-versions.$2.log"
echo "Puede ejecutar: tail -f /tmp/install-all-versions.$2.log"
echo "" > /tmp/install-all-versions.$2.log 2>&1

echo -e "\nIniciando en 5 segundos..."
sleep 5

if [ "$2" == "Ubuntu" ] ; then
   ./build-chroot-Ubuntu.sh ubuntu15.04-vivid-x86_84 vivid amd64 >> /tmp/install-all-versions.$2.log 2>&1
   ./build-chroot-Ubuntu.sh ubuntu14.10-utopic-x86_84 utopic amd64 >> /tmp/install-all-versions.$2.log 2>&1
   ./build-chroot-Ubuntu.sh ubuntu14.04LTS-trusty-x86_84 trusty amd64 >> /tmp/install-all-versions.$2.log 2>&1
   ./build-chroot-Ubuntu.sh ubuntu12.04LTS-precise-x86_84 precise amd64 >> /tmp/install-all-versions.$2.log 2>&1
   ./build-chroot-Ubuntu.sh ubuntu10.04LTS-lucid-x86_84 lucid amd64 >> /tmp/install-all-versions.$2.log 2>&1

   ./build-chroot-Ubuntu.sh ubuntu15.04-vivid-i386 vivid i386 >> /tmp/install-all-versions.$2.log 2>&1
   ./build-chroot-Ubuntu.sh ubuntu14.10-utopic-i386 utopic i386 >> /tmp/install-all-versions.$2.log 2>&1
   ./build-chroot-Ubuntu.sh ubuntu14.04LTS-trusty-i386 trusty i386 >> /tmp/install-all-versions.$2.log 2>&1
   ./build-chroot-Ubuntu.sh ubuntu12.04LTS-precise-i386 precise i386 >> /tmp/install-all-versions.$2.log 2>&1
   ./build-chroot-Ubuntu.sh ubuntu10.04LTS-lucid-i386 lucid i386 >> /tmp/install-all-versions.$2.log 2>&1
elif [ "$2" == "Centos" ] ; then
   ./build-chroot-Centos.sh centos7-x86_64 7 >> /tmp/install-all-versions.$2.log 2>&1
   ./build-chroot-Centos.sh centos6-x86_64 6 >> /tmp/install-all-versions.$2.log 2>&1
   ./build-chroot-Centos.sh centos5-x86_64 5 >> /tmp/install-all-versions.$2.log 2>&1

   ./build-chroot-Centos.sh centos7-i386 7-i386 >> /tmp/install-all-versions.$2.log 2>&1
   ./build-chroot-Centos.sh centos6-i386 6-i386 >> /tmp/install-all-versions.$2.log 2>&1
   ./build-chroot-Centos.sh centos5-i386 5-i386 >> /tmp/install-all-versions.$2.log 2>&1
elif [ "$2" == "Debian" ] ; then
   ./build-chroot-Debian.sh debian8-jessie-x86_64 jessie amd64 >> /tmp/install-all-versions.$2.log 2>&1
   ./build-chroot-Debian.sh debian7-wheezy-x86_64 wheezy amd64 >> /tmp/install-all-versions.$2.log 2>&1
   ./build-chroot-Debian.sh debian6-squeeze-x86_64 squeeze amd64 >> /tmp/install-all-versions.$2.log 2>&1

   ./build-chroot-Debian.sh debian8-jessie-i386 jessie i386 >> /tmp/install-all-versions.$2.log 2>&1
   ./build-chroot-Debian.sh debian7-wheezy-i386 wheezy i386 >> /tmp/install-all-versions.$2.log 2>&1
   ./build-chroot-Debian.sh debian6-squeeze-i386 squeeze i386 >> /tmp/install-all-versions.$2.log 2>&1
elif [ "$2" == "OpenSuse" ] ; then
   ./build-chroot-OpenSuse.sh Opensuse13.2-x86_64 13.2 amd64 >> /tmp/install-all-versions.$2.log 2>&1
   ./build-chroot-OpenSuse.sh Opensuse12.3-x86_64 12.3 amd64 >> /tmp/install-all-versions.$2.log 2>&1
   ./build-chroot-OpenSuse.sh Opensuse11.4-x86_64 11.4 amd64 >> /tmp/install-all-versions.$2.log 2>&1

   ./build-chroot-OpenSuse.sh Opensuse13.2-i586 13.2 i586 >> /tmp/install-all-versions.$2.log 2>&1
   ./build-chroot-OpenSuse.sh Opensuse12.3-i586 12.3 i586 >> /tmp/install-all-versions.$2.log 2>&1
   ./build-chroot-OpenSuse.sh Opensuse11.4-i586 11.4 i586 >> /tmp/install-all-versions.$2.log 2>&1
elif [ "$2" == "Fedora" ] ; then
   ./build-chroot-Fedora.sh Fedora21-x86_64 21 >> /tmp/install-all-versions.$2.log 2>&1
   ./build-chroot-Fedora.sh Fedora20-x86_64 20 >> /tmp/install-all-versions.$2.log 2>&1
   ./build-chroot-Fedora.sh Fedora19-x86_64 19 >> /tmp/install-all-versions.$2.log 2>&1

   ./build-chroot-Fedora.sh Fedora21-i386 21-i386 >> /tmp/install-all-versions.$2.log 2>&1
   ./build-chroot-Fedora.sh Fedora20-i386 20-i386 >> /tmp/install-all-versions.$2.log 2>&1
   ./build-chroot-Fedora.sh Fedora19-i386 19-i386 >> /tmp/install-all-versions.$2.log 2>&1
elif [ "$2" == "KaliLinux" ] ; then
   ./build-chroot-Kali.sh kali-x86_64 kali amd64 >> /tmp/install-all-versions.$2.log 2>&1
   ./build-chroot-Kali.sh kali-i386 kali i386 >> /tmp/install-all-versions.$2.log 2>&1
else 
   echo "Nombre de distribucion no valida."
fi

echo "LISTO!!"
