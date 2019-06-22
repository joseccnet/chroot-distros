#!/bin/bash
#
# Build a chroot with a Debian base install.
# Author: josecc@gmail.com
#
#Devuan Debian Without systemd
#https://devuan.org/
#--arch amd64 , i386

source $(dirname $0)/chroot.conf

if [ ! -f /usr/sbin/debootstrap ] ; then echo -e "\nInstale debootstrap para Centos, Debian, Ubuntu o Kali. Necesario para continuar\n   yum install debootstrap\nor\n   apt-get install debootstrap"; exit -1; fi

echo " - - - - - - - - - - - - - - - - - -"
echo -e "$0 creara una jaula dentro del directorio $ROOTJAIL/$1\n"
echo -e " - - - - - - - - - - - - - - - - - -\n"


if [ "$1" == "" ]; then
echo -e "Devuan. (Debian Without systemd) https://devuan.org/
Devuan Jessie - Debian 8 Jessie
Devuan ASCII - Debian 9 Stretch
Devuan Beowulf - Debian 10 Buster
Devuan Ceres - Debian Unstable Sid
"
echo -e "Nombre de Jaula requerido\nEjecute:\n"
echo -e "$0 NombreJaula [sid|buster|stretch|jessie [amd64|i386]]\n"
exit -1
fi

if [ ! -d $ROOTJAIL ] ; then mkdir -vp $ROOTJAIL; chmod 755 $ROOTJAIL; fi
CHROOT=$ROOTJAIL/$1

mkdir -p $CHROOT

version=$2
arch=$3
paquetesadiocionalesDeb=$paquetesadiocionalesDevuan
if [ "$arch" == "" ] ; then arch=$(uname -m); fi
if [ "$arch" == "x86_64" ] ; then arch="amd64"; fi
if [ "$arch" == "amd64" ] ; then paquetesadiocionalesDeb="$paquetesadiocionalesDeb,libc6-i386"; fi
if [ "$version" == "" ] ; then version="stretch"; fi
echo "Instalando..."
echo -e "VERSION: $version \t ARCH: $arch"

if [ "$version" == "jessie" ] ; then
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesDeb jessie $CHROOT http://deb.devuan.org/merged
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
   echo -e "deb http://deb.devuan.org/merged jessie          main\ndeb http://deb.devuan.org/merged jessie-security main\n" > $CHROOT/etc/apt/sources.list
elif [ "$version" == "stretch" ] ; then
   if [ ! -f /usr/share/debootstrap/scripts/ascii ] ; then ln -s /usr/share/debootstrap/scripts/sid /usr/share/debootstrap/scripts/ascii; fi
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesDeb ascii $CHROOT http://deb.devuan.org/merged
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
   echo -e "deb http://deb.devuan.org/merged ascii          main\ndeb http://deb.devuan.org/merged ascii-updates  main\ndeb http://deb.devuan.org/merged ascii-security main\n" > $CHROOT/etc/apt/sources.list
elif [ "$version" == "buster" ] ; then
   paquetesadiocionalesDeb=${paquetesadiocionalesDeb/mysql-client/mariadb-client}
   if [ ! -f /usr/share/debootstrap/scripts/beowulf ] ; then ln -s /usr/share/debootstrap/scripts/sid /usr/share/debootstrap/scripts/beowulf; fi
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesDeb beowulf $CHROOT http://deb.devuan.org/merged
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
   echo -e "deb http://deb.devuan.org/merged beowulf          main\ndeb http://deb.devuan.org/merged beowulf-updates  main\ndeb http://deb.devuan.org/merged beowulf-security main\n" > $CHROOT/etc/apt/sources.list
elif [ "$version" == "sid" ] ; then
   paquetesadiocionalesDeb=${paquetesadiocionalesDeb/mysql-client/mariadb-client}
   if [ ! -f /usr/share/debootstrap/scripts/ceres ] ; then ln -s /usr/share/debootstrap/scripts/sid /usr/share/debootstrap/scripts/ceres; fi
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesDeb ceres $CHROOT http://deb.devuan.org/merged
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
   echo -e "#deb http://deb.devuan.org/merged ceres          main\n#deb http://deb.devuan.org/merged ceres-updates  main\n#deb http://deb.devuan.org/merged ceres-security main\n" > $CHROOT/etc/apt/sources.list
else
   version="stretch"
   if [ ! -f /usr/share/debootstrap/scripts/ascii ] ; then ln -s /usr/share/debootstrap/scripts/sid /usr/share/debootstrap/scripts/ascii; fi
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesDeb ascii $CHROOT http://deb.devuan.org/merged
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
   echo -e "deb http://deb.devuan.org/merged ascii          main\ndeb http://deb.devuan.org/merged ascii-updates  main\ndeb http://deb.devuan.org/merged ascii-security main\n" > $CHROOT/etc/apt/sources.list
fi

mychrootconf="#Configuracion inicial de Filesystems a montar para la Jaula $CHROOT. El archivo $CHROOT/etc/mychroot.conf segun necesidades.\n\n#Filesystems a montar:
\nFS:/proc\nFS:/dev\nFS:/dev/pts\nFS:/sys\nFS:/home\n
\n\nConfiguracion inicial de Servicios a iniciar:
\nService:/etc/init.d/cron\n#Service:/etc/init.d/rsyslog\n"

echo -e $mychrootconf > $CHROOT/etc/mychroot.conf && chmod 640 $CHROOT/etc/mychroot.conf

./mount_umount-chroot.sh $1 mount

chroot $CHROOT /bin/bash -c "apt-get update && apt-get -y install deborphan && deborphan -a"
#chroot $CHROOT /usr/bin/apt-get update
#chroot $CHROOT /usr/bin/apt-get -y install deborphan
#chroot $CHROOT /usr/bin/deborphan -a
for i in $(chroot $CHROOT /usr/bin/deborphan -a | awk '{print $2}' | egrep -v "exclude_pakage_name1|exclude_pakage_name2|deborphan|wget|openssh-|rsyslog|devuan-keyring"); do chroot $CHROOT /usr/bin/apt-get -y remove $i; done
chroot $CHROOT /bin/bash -c "apt-get -y upgrade && apt-get clean all"

echo -e "\n- - - - RESUMEN- - - -\n"
echo -e "Dispositivos montados:"
mount | grep "$CHROOT" | awk '{print $3}' | sort -r
echo -e "\nIMPORTANTE!!! Revisa el archivo $CHROOT/etc/mychroot.conf y configuralo segun tus necesidades.\n"
echo -e "\nLa jaula $CHROOT fue creada. Revise la salida de las lineas anteriores por errores y corrija si es necesario."
echo -e "Para que un usuario <userbob> pueda hacer uso de esta jaula, egregar en el archivo de configuracion /etc/ssh/sshd_config lo siguiente:"

conf="
Match User userbob
        ChrootDirectory $CHROOT
        X11Forwarding no
        AllowTcpForwarding no
"
echo -e "\n$conf\n"
echo -e "Y reinicie el servicio ssh: service sshd restart"
echo -e "- - - - - - - - - - - - -"

opt="
#Opcional:
#
# + Como usuario root:
#   chroot $CHROOT
#
# + Usuarios NO root:
#   cp /usr/sbin/chroot /usr/sbin/chrootuser (como root una sola vez)
#   setcap cap_sys_chroot+ep /usr/sbin/chrootUser (como root una sola vez)
#   /usr/sbin/chrootUser $CHROOT (como NO root, ya puede hacer uso de la jaula)
"
echo -e "\n$opt\n"

exit 0
