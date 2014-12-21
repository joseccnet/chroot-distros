#!/bin/bash
#
# Build a chroot with a CentOS base install.
# Author: josecc@gmail.com
source $(dirname $0)/chroot.conf

if [ ! -f /usr/bin/yum ] ; then echo -e "Favor de instalar Yum:\n   apt-get install yum yum-utils\n\nEn debian, es necesario agregar el repositorio 'wheezy-backports'. Revisa el archivo issues_and_notes.txt"; exit -1; fi

echo " - - - - - - - - - - - - - - - - - -"
echo -e "$0 creara una jaula dentro del directorio $ROOTJAIL/$1\n"
echo -e " - - - - - - - - - - - - - - - - - -\n"


if [ "$1" == "" ]; then
echo -e "Nombre de Jaula requerido\nEjecute:\n"
echo -e "$0 NombreJaula [7|6|5|7-i386|6-i386|5-i386]\n"
exit -1
fi

if [ ! -d $ROOTJAIL ] ; then mkdir -vp $ROOTJAIL; chmod 755 $ROOTJAIL; fi
CHROOT=$ROOTJAIL/$1

mkdir -p $CHROOT

mkdir -p $CHROOT/var/lib/rpm
rpm --rebuilddb --root=$CHROOT

version=$2
rm -f ./centos-release-*.rpm

if [ "$version" == "7" ] ; then
   yumcentosconf=$CHROOT/tmp/yumcentos.conf
   wget -c $c7rpm1
elif [ "$version" == "7-i386" ] ; then
   echo -e "Version NO soportada por el sitio oficial de Centos. Ver http://mirror.centos.org/centos/7/"
   exit 0
elif [ "$version" == "6" ] ; then
   yumcentosconf=$CHROOT/tmp/yumcentos.conf
   wget -c $c6rpm1
elif [ "$version" == "6-i386" ] ; then
   yumcentosconf=$CHROOT/tmp/yumcentosi386.conf
   wget -c $c6rpm1_i386
elif [ "$version" == "5" ] ; then
   yumcentosconf=$CHROOT/tmp/yumcentos.conf
   wget -c $c5rpm1
   wget -c $c5rpm2
elif [ "$version" == "5-i386" ] ; then
   yumcentosconf=$CHROOT/tmp/yumcentosi386.conf
   wget -c $c5rpm1_i386
   wget -c $c5rpm2_i386
else
   yumcentosconf=$CHROOT/tmp/yumcentos.conf
   yum -y install yum-utils
   yumdownloader centos-release
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
fi
rpm -i --root=$CHROOT --nodeps centos-release-*.rpm

mkdir -p $CHROOT/tmp
cp $(dirname $0)/centos/yumcentos.conf $CHROOT/tmp/
cp $(dirname $0)/centos/yumcentosi386.conf $CHROOT/tmp/
yum --nogpgcheck -c $yumcentosconf --disablerepo=* --enablerepo=basecentoschroot --enablerepo=updatescentoschroot --installroot=$CHROOT install -y $paquetesadiocionales

mychrootconf="#Configuracion inicial de Filesystems a montar para la Jaula $CHROOT. El archivo $CHROOT/etc/mychroot.conf segun necesidades.\n\n#Filesystems a montar:
\nFS:/proc\nFS:/dev\nFS:/dev/pts\nFS:/sys\nFS:/home\n
\n\nConfiguracion inicial de Servicios a iniciar:
\nService:/etc/init.d/crond\nService:/etc/init.d/rsyslog\n"

echo -e $mychrootconf > $CHROOT/etc/mychroot.conf && chmod 640 $CHROOT/etc/mychroot.conf

./mount_umount-chroot.sh $1 mount
if [ "$version" == "5-i386" ] || [ "$version" == "6-i386" ] ; then
   sed -i 's/$basearch/i386/g' $CHROOT/etc/yum.repos.d/*.repo
fi

yum --nogpgcheck -c $CHROOT/tmp/yumcentos.conf --disablerepo=* --enablerepo=basecentoschroot --enablerepo=updatescentoschroot --installroot=$CHROOT -y update
yum --nogpgcheck -c $CHROOT/tmp/yumcentos.conf --disablerepo=* --enablerepo=basecentoschroot --enablerepo=updatescentoschroot --installroot=$CHROOT clean all

if [ "$version" == "5" ] || [ "$version" == "5-i386" ] ; then
   #dirty fix to yum works ok
   cp centos-release-* $CHROOT/tmp/
   chroot $CHROOT rm -rf /var/lib/rpm/*
   chroot $CHROOT rpm --rebuilddb
   chroot $CHROOT rpm -i --nodeps /tmp/centos-release-*
   yum update
fi

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

rm -f ./centos-release-*.rpm
exit 0
