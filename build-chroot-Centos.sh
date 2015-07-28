#!/bin/bash
#
# Build a chroot with a CentOS base install.
# Author: josecc@gmail.com
source $(dirname $0)/chroot.conf $0 $@

if [ ! -f /usr/bin/yum ] ; then echo -e "Favor de instalar Yum:\n   apt-get install yum\n"; exit -1; fi
if [ ! -f /usr/sbin/debootstrap ] ; then echo -e "\nInstale debootstrap para Centos, Debian, Ubuntu o Kali. Necesario para continuar\n   yum install debootstrap\nor\n   apt-get install debootstrap"; exit -1; fi
  
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
   rm -rf $CHROOT
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
   $0 $1 7
   exit 0
   version=7 #Centos 7 as default
   yumcentosconf=$CHROOT/tmp/yumcentos.conf
   wget -c $c7rpm1
   #yum -y install yum-utils
   #yumdownloader centos-release
   #if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
fi
mkdir -p $CHROOT/tmp/ ; cp centos-release-*.rpm $CHROOT/tmp/
rpm -ivh --root=$CHROOT --nodeps $CHROOT/tmp/centos-release-*.rpm

cp $(dirname $0)/centos/yumcentos.conf $CHROOT/tmp/
cp $(dirname $0)/centos/yumcentosi386.conf $CHROOT/tmp/
yum --nogpgcheck -c $yumcentosconf --disablerepo=* --enablerepo=basecentoschroot --enablerepo=updatescentoschroot --installroot=$CHROOT install -y yum yum-utils

mychrootconf="#Configuracion inicial de Filesystems a montar para la Jaula $CHROOT. El archivo $CHROOT/etc/mychroot.conf segun necesidades.\n\n#Filesystems a montar:
\nFS:/proc\nFS:/dev\nFS:/dev/pts\nFS:/sys\nFS:/home\n
\n\nConfiguracion inicial de Servicios a iniciar:
\nService:/etc/init.d/crond\n#Service:/etc/init.d/rsyslog\n"

echo -e $mychrootconf > $CHROOT/etc/mychroot.conf && chmod 640 $CHROOT/etc/mychroot.conf

if [ "$version" == "5-i386" ] || [ "$version" == "6-i386" ] ; then
   sed -i 's/$basearch/i386/g' $CHROOT/etc/yum.repos.d/*.repo
fi

./mount_umount-chroot.sh $1 mount
chroot $CHROOT rpm -ivh --nodeps /tmp/centos-release-*.rpm
chroot $CHROOT yum -y install $paquetesadiocionales
chroot $CHROOT yum -y update
chroot $CHROOT yum clean all
yum --nogpgcheck -c $CHROOT/tmp/yumcentos.conf --disablerepo=* --enablerepo=basecentoschroot --enablerepo=updatescentoschroot --installroot=$CHROOT clean all
./mount_umount-chroot.sh $1 umount > /dev/null 2>&1 #Notifica errores "normales"
./mount_umount-chroot.sh $1 mount

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
