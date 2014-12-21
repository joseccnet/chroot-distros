#!/bin/bash
#
# Build a chroot with a openSuse base install.
# Author: josecc@gmail.com
source $(dirname $0)/chroot.conf

if [ ! -f /usr/bin/yum ] ; then echo -e "Favor de instalar Yum:\n   apt-get install yum yum-utils\n\nEn debian, es necesario agregar el repositorio 'wheezy-backports'. Revisa el archivo issues_and_notes.txt"; exit -1; fi

echo " - - - - - - - - - - - - - - - - - -"
echo -e "$0 creara una jaula dentro del directorio $ROOTJAIL/$1\n"
echo -e " - - - - - - - - - - - - - - - - - -\n"

if [ "$1" == "" ]; then
echo -e "Nombre de Jaula requerido\nEjecute:\n"
echo -e "$0 NombreJaula [13.2|12.3|11.4 [amd64|i586]]\n"
exit -1
fi

if [ ! -d $ROOTJAIL ] ; then mkdir -vp $ROOTJAIL; chmod 755 $ROOTJAIL; fi
CHROOT=$ROOTJAIL/$1

mkdir -p $CHROOT

version=$2

arch=$3
if [ "$arch" == "" ] ; then arch="x86_64"; fi
excludearch="*.i586"
if [ "$arch" == "i586" ] ; then excludearch="*.x86_64"; fi

if [ "$version" == "13.2" ] ; then
   echo -e "Instalando OpenSuse $version [$arch]..."
   echo -e "ATENCION!!!\nATENCION!!!\nCentos 6.x tiene un kernel que no tiene soporte para OpenSuse $version , por tanto es posible que no funcione esta instalacion.\nUsted observara mensajes como 'FATAL: kernel too old'\n\n"
   sleep 3
elif [ "$version" == "12.3" ] ; then
   echo -e "Instalando OpenSuse $version [$arch]..."
elif [ "$version" == "11.4" ] ; then
   echo -e "Instalando OpenSuse $version [$arch]..."
   echo -e "ATENCION!!! OpenSuse $version ya NO tiene soporte para instalar actualizaciones de Seguridad o Bugs"
else #13.2 - Ultima Version
   version="13.2"
   echo -e "ATENCION!!! Si esta en un sistema con kernel 2.x, NO funcionara esta instalacion. El nuevo sistema OpenSuse $version esta compilado para una version de kernel 3.x."
   echo -e "Instalando OpenSuse $version [$arch]..."
fi

mkdir -p $CHROOT/tmp
cp $(dirname $0)/openSuse/yumsuse.conf $CHROOT/tmp/
sed -i "s/versionopensuse/$version/g" $CHROOT/tmp/yumsuse.conf
sed -i 's/http\:\/\/download.opensuse.org\/update/http\:\/\/mirrors.kernel.org\/opensuse\/update/g' $CHROOT/tmp/yumsuse.conf

mkdir -p $CHROOT/etc; touch $CHROOT/etc/mychroot.conf
./mount_umount-chroot.sh $1 mount > /dev/null 2>&1

if [ "$version" == "11.4" ] ; then
   yum -c $CHROOT/tmp/yumsuse.conf --disablerepo=* --enablerepo=basesuse --installroot=$CHROOT --exclude=$excludearch -y install openSUSE-release zypper iputils openssh cronie rsyslog vim
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
   chroot $CHROOT rm -rf /var/lib/rpm/*
   chroot $CHROOT rpm --rebuilddb
else
   yum -c $CHROOT/tmp/yumsuse.conf --disablerepo=* --enablerepo=basesuse --enablerepo=repo-update --installroot=$CHROOT --exclude=$excludearch --exclude="systemd-mini*" -y install openSUSE-release zypper yast2-firstboot iputils openssh cronie rsyslog vim
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
fi

cp $(dirname $0)/openSuse/*.repo $CHROOT/etc/zypp/repos.d/
sed -i "s/versionopensuse/$version/g" $CHROOT/etc/zypp/repos.d/*.repo
sed -i 's/http\:\/\/download.opensuse.org\/distribution/http\:\/\/mirrors.kernel.org\/opensuse\/distribution/g' $CHROOT/etc/zypp/repos.d/*.repo
echo "nameserver 8.8.8.8" > $CHROOT/etc/resolv.conf

mychrootconf="#Configuracion inicial de Filesystems a montar para la Jaula $CHROOT. El archivo $CHROOT/etc/mychroot.conf segun necesidades.\n\n#Filesystems a montar:
\nFS:/proc\nFS:/dev\nFS:/dev/pts\nFS:/sys\nFS:/home\n
\n\nConfiguracion inicial de Servicios a iniciar:
\nService:/etc/init.d/cron\n"

echo -e $mychrootconf > $CHROOT/etc/mychroot.conf && chmod 640 $CHROOT/etc/mychroot.conf

./mount_umount-chroot.sh $1 umount
./mount_umount-chroot.sh $1 mount
if [ "$version" == "11.4" ] ; then rm -f $CHROOT/etc/zypp/repos.d/*update*.repo; fi

if [ "$arch" == "i586" ] ; then echo "arch = i586" >> $CHROOT/etc/zypp/zypp.conf; fi
chroot $CHROOT zypper --non-interactive --no-gpg-checks update

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
