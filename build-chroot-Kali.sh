#!/bin/bash
#
# Build a chroot with a Kali base install.
# Author: josecc@gmail.com
#
# Kali
#arch amd64 , i386 , armhf

source $(dirname $0)/chroot.conf

if [ ! -f /usr/sbin/debootstrap ] ; then echo -e "Instale debootstrap para Centos. Necesario para continuar:\n rpm -ivh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm [Repositorio EPEL]\nyum install debootstrap\n"; fi

echo " - - - - - - - - - - - - - - - - - -"
echo -e "$0 creara una jaula dentro del directorio $ROOTJAIL/$1\n"
echo -e " - - - - - - - - - - - - - - - - - -\n"


if [ "$1" == "" ]; then
echo -e "Nombre de Jaula requerido\nEjecute:\n"
echo -e "$0 NombreJaula [kali [amd64|i386]]\n"
exit -1
fi

if [ ! -d $ROOTJAIL ] ; then mkdir -vp $ROOTJAIL; chmod 755 $ROOTJAIL; fi
CHROOT=$ROOTJAIL/$1

mkdir -p $CHROOT

version=$2
arch=$3
if [ "$arch" == "" ] ; then arch=$(uname -p); fi
if [ "$arch" == "x86_64" ] ; then arch="amd64"; fi
if [ "$version" == "" ] ; then version="kali"; fi
echo "Instalando..."
echo -e "VERSION: $version \t ARCH: $arch"

#Hacer que debootstrap me permita instalar KALI LINUX:
if [ -d /usr/share/debootstrap/scripts ] ; then
   if [ ! -f /usr/share/debootstrap/scripts/kali ] ; then
      ln -s /usr/share/debootstrap/scripts/sid /usr/share/debootstrap/scripts/kali
   fi
else
   echo -e "Version de debootstrap no soporta instalar Kali Linux. Salir.\n"
   exit -1
fi

if [ "$version" == "kali" ] ; then
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesDeb kali $CHROOT http://http.kali.org
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
else
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesDeb kali $CHROOT http://http.kali.org
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
fi

mychrootconf="#Configuracion inicial de Filesystems a montar para la Jaula $CHROOT. El archivo $CHROOT/etc/mychroot.conf segun necesidades.\n\n#Filesystems a montar:
\nFS:/proc\nFS:/dev\nFS:/dev/pts\nFS:/sys\nFS:/home\n
\n\nConfiguracion inicial de Servicios a iniciar:
\nService:/etc/init.d/cron\nService:/etc/init.d/rsyslog\n"

echo -e $mychrootconf > $CHROOT/etc/mychroot.conf && chmod 640 $CHROOT/etc/mychroot.conf

./mount_umount-chroot.sh $1 mount

chroot $CHROOT /usr/bin/apt-get update
chroot $CHROOT /usr/bin/apt-get -y install deborphan
chroot $CHROOT /usr/bin/deborphan -a
for i in $(chroot $CHROOT /usr/bin/deborphan -a | awk '{print $2}' | egrep -v "exclude_pakage_name1|exclude_pakage_name2|deborphan|wget|openssh-|rsyslog"); do chroot $CHROOT /usr/bin/apt-get -y remove $i; done

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
if [ -f /usr/share/debootstrap/scripts/kali ] ; then rm -f /usr/share/debootstrap/scripts/kali; fi
exit 0
