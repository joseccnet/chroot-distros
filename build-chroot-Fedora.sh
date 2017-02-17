#!/bin/bash
#
# Build a chroot with a Fedora base install.
# Author: josecc@gmail.com
source $(dirname $0)/chroot.conf $0 $@

if [ ! -f /usr/bin/yum ] ; then echo -e "Favor de instalar Yum:\n   apt-get install yum\n"; exit -1; fi
if [ ! -f /usr/sbin/debootstrap ] ; then echo -e "\nInstale debootstrap para Centos, Debian, Ubuntu o Kali. Necesario para continuar\n   yum install debootstrap\nor\n   apt-get install debootstrap"; exit -1; fi
  
echo " - - - - - - - - - - - - - - - - - -"
echo -e "$0 creara una jaula dentro del directorio $ROOTJAIL/$1\n"
echo -e " - - - - - - - - - - - - - - - - - -\n"

if ! [ -f /usr/lib*/python2.*/*-packages/liblzma.py -o -f /usr/share/pyshared/liblzma.py ] ; then echo -e "   Instale 'pyliblzma':\n   yum install pyliblzma\n -or-\n   apt-get install python-lzma"; exit -1; fi

if [ "$1" == "" ]; then
echo -e "Nombre de Jaula requerido\nEjecute:\n"
echo -e "$0 NombreJaula [25|24|23|22|21|20|19|25-i386|24-i386|23-i386|22-i386|21-i386|20-i386|19-i386]\n"
exit -1
fi

if [ ! -d $ROOTJAIL ] ; then mkdir -vp $ROOTJAIL; chmod 755 $ROOTJAIL; fi
CHROOT=$ROOTJAIL/$1

mkdir -p $CHROOT

mkdir -p $CHROOT/var/lib/rpm
rpm --rebuilddb --root=$CHROOT

version=$2
rm -f ./fedora-re*.rpm

if [ "$version" == "25" ] ; then
   yumfedoraconf=$CHROOT/tmp/yumfedorax86_64.conf
   wget -c $f25rpm1
   wget -c $f25rpm2
   excludearch="*.i*86"
elif [ "$version" == "25-i386" ] ; then
   yumfedoraconf=$CHROOT/tmp/yumfedorai386.conf
   wget -c $f25rpm1_i386
   wget -c $f25rpm2_i386
   excludearch="*.x86_64"
elif [ "$version" == "24" ] ; then
   yumfedoraconf=$CHROOT/tmp/yumfedorax86_64.conf
   wget -c $f24rpm1
   wget -c $f24rpm2
   excludearch="*.i*86"
elif [ "$version" == "24-i386" ] ; then
   yumfedoraconf=$CHROOT/tmp/yumfedorai386.conf
   wget -c $f24rpm1_i386
   wget -c $f24rpm2_i386
   excludearch="*.x86_64"
elif [ "$version" == "23" ] ; then
   yumfedoraconf=$CHROOT/tmp/yumfedorax86_64.conf
   wget -c $f23rpm1
   wget -c $f23rpm2
   excludearch="*.i*86"
elif [ "$version" == "23-i386" ] ; then
   yumfedoraconf=$CHROOT/tmp/yumfedorai386.conf
   wget -c $f23rpm1_i386
   wget -c $f23rpm2_i386
   excludearch="*.x86_64"
elif [ "$version" == "22" ] ; then
   yumfedoraconf=$CHROOT/tmp/yumfedorax86_64.conf
   wget -c $f22rpm1
   wget -c $f22rpm2
   excludearch="*.i*86"
elif [ "$version" == "22-i386" ] ; then
   yumfedoraconf=$CHROOT/tmp/yumfedorai386.conf
   wget -c $f22rpm1_i386
   wget -c $f22rpm2_i386
   excludearch="*.x86_64"
elif [ "$version" == "21" ] ; then
   yumfedoraconf=$CHROOT/tmp/yumfedorax86_64.conf
   wget -c $f21rpm1
   wget -c $f21rpm2
   excludearch="*.i*86"
elif [ "$version" == "21-i386" ] ; then
   yumfedoraconf=$CHROOT/tmp/yumfedorai386.conf
   wget -c $f21rpm1_i386
   wget -c $f21rpm2_i386
   excludearch="*.x86_64"
elif [ "$version" == "20" ] ; then
   yumfedoraconf=$CHROOT/tmp/yumfedorax86_64.conf
   wget -c $f20rpm1
   excludearch="*.i*86"
elif [ "$version" == "20-i386" ] ; then
   yumfedoraconf=$CHROOT/tmp/yumfedorai386.conf
   wget -c $f20rpm1_i386
   excludearch="*.x86_64"
elif [ "$version" == "19" ] ; then
   yumfedoraconf=$CHROOT/tmp/yumfedorax86_64.conf
   wget -c $f19rpm1
   excludearch="*.i*86"
elif [ "$version" == "19-i386" ] ; then
   yumfedoraconf=$CHROOT/tmp/yumfedorai386.conf
   wget -c $f19rpm1_i386
   excludearch="*.x86_64"
else
   $0 $1 25
   exit 0
   yumfedoraconf=$CHROOT/tmp/yumfedorax86_64.conf
   excludearch="*.i*86"
   yum -y install yum-utils
   yumdownloader fedora-release
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
fi
mkdir -p $CHROOT/tmp/
cp fedora-re*.rpm $CHROOT/tmp/
rpm -ivh --root=$CHROOT --nodeps $CHROOT/tmp/fedora-re*.rpm

mkdir -p $CHROOT/tmp
cp $(dirname $0)/fedora/yumfedorax86_64.conf $CHROOT/tmp/
cp $(dirname $0)/fedora/yumfedorai386.conf $CHROOT/tmp/
yum --nogpgcheck -c $yumfedoraconf --exclude=$excludearch --disablerepo=* --enablerepo=fedorachroot --enablerepo=updatesfedorachroot --installroot=$CHROOT install -y yum

mychrootconf="#Configuracion inicial de Filesystems a montar para la Jaula $CHROOT. El archivo $CHROOT/etc/mychroot.conf segun necesidades.\n\n#Filesystems a montar:
\nFS:/proc\nFS:/dev\nFS:/dev/pts\nFS:/sys\nFS:/home\n
\n\nConfiguracion inicial de Servicios a iniciar:
\nService:/etc/init.d/crond\n#Service:/etc/init.d/rsyslog\n"

echo -e $mychrootconf > $CHROOT/etc/mychroot.conf && chmod 640 $CHROOT/etc/mychroot.conf

./mount_umount-chroot.sh $1 mount
if [ "$version" == "25-i386" ] || [ "$version" == "24-i386" ] || [ "$version" == "23-i386" ] || [ "$version" == "22-i386" ] || [ "$version" == "21-i386" ] || [ "$version" == "20-i386" ] || [ "$version" == "19-i386" ] ; then
   sed -i 's/$basearch/i386/g' $CHROOT/etc/yum.repos.d/*.repo
fi

if [ "$version" == "25" ] || [ "$version" == "25-i386" ] ; then
   chroot $CHROOT /usr/bin/dnf -y --releasever=25 install fedora-repos fedora-release
fi

if [ "$version" == "24" ] || [ "$version" == "24-i386" ] ; then
   chroot $CHROOT /usr/bin/dnf -y --releasever=24 install fedora-repos fedora-release
fi

if [ "$version" == "23" ] || [ "$version" == "23-i386" ] ; then
   chroot $CHROOT /usr/bin/dnf -y --releasever=23 install fedora-repos fedora-release
fi

if [ "$version" == "22" ] || [ "$version" == "22-i386" ] ; then
   chroot $CHROOT /usr/bin/dnf -y --releasever=22 install fedora-repos fedora-release
fi

chroot $CHROOT rpm -ivh /tmp/fedora-re*.rpm
chroot $CHROOT yum -y install $paquetesadiocionales fedora-release fedora-repos
chroot $CHROOT yum -y update
chroot $CHROOT yum clean all
yum --nogpgcheck -c $yumfedoraconf --exclude=$excludearch --disablerepo=* --enablerepo=fedorachroot --enablerepo=updatesfedorachroot --installroot=$CHROOT clean all
./mount_umount-chroot.sh $1 umount
./mount_umount-chroot.sh $1 mount

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

rm -f ./fedora-re*.rpm
exit 0
