#!/bin/bash
#
# Build a chroot with a Ubuntu base install.
# Author: josecc@gmail.com
#
#Artful Aardvark - 17.10
#Zesty - 17.04
#Yakkety - 16.10
#Xenial - 16.04 LTS
#Wily - 15.10
#Vivid - 15.04
#Utopic - 14.10
#Trusty - 14.04 LTS
#Precise - 12.04 LTS
#Lucid - 10.04 LTS
#--arch amd64 , i386

source $(dirname $0)/chroot.conf

if [ ! -f /usr/sbin/debootstrap ] ; then echo -e "\nInstale debootstrap para Centos, Debian, Ubuntu o Kali. Necesario para continuar\n   yum install debootstrap\nor\n   apt-get install debootstrap"; exit -1; fi

echo " - - - - - - - - - - - - - - - - - -"
echo -e "$0 creara una jaula dentro del directorio $ROOTJAIL/$1\n"
echo -e " - - - - - - - - - - - - - - - - - -\n"


if [ "$1" == "" ]; then
echo -e "#Eoan Ermine - 19.10
#Disco Dingo - 19.04
#Cosmic Cuttlefish - 18.10
#Bionic Beaver - 18.04 LTS
#Artful Aardvark - 17.10 [old release]
#Zesty - 17.04 [old release]
#Yakkety - 16.10 [old release]
#Xenial - 16.04 LTS
#Wily - 15.10 [old release]
#Vivid - 15.04 [old release]
#Utopic - 14.10 [old release]
#Trusty - 14.04 LTS
#Precise - 12.04 LTS 
#Lucid - 10.04 LTS [old release]
"
oldRelease=false

echo -e "Nombre de Jaula requerido\nEjecute:\n"
echo -e "$0 NombreJaula [eoan|disco|cosmic|bionic|artful|zesty|yakkety|xenial|wily|vivid|utopic|trusty|precise|lucid [amd64|i386]]\n"
exit -1
fi

if [ ! -d $ROOTJAIL ] ; then mkdir -vp $ROOTJAIL; chmod 755 $ROOTJAIL; fi
CHROOT=$ROOTJAIL/$1

mkdir -p $CHROOT

version=$2
arch=$3
if [ "$arch" == "" ] ; then arch=$(uname -m); fi
if [ "$arch" == "x86_64" ] ; then arch="amd64"; fi
if [ "$arch" == "amd64" ] ; then paquetesadiocionalesUbuntu="$paquetesadiocionalesUbuntu,libc6-i386"; fi
if [ "$version" == "" ] ; then version="xenial"; fi #Ultima version LTS
echo "Instalando..."
echo -e "VERSION: $version \t ARCH: $arch"

#Hacer que debootstrap me permita instalar Ubuntu LINUX:
if [ -d /usr/share/debootstrap/scripts ] ; then
   if [ ! -f /usr/share/debootstrap/scripts/$version ] ; then
      ln -s /usr/share/debootstrap/scripts/sid /usr/share/debootstrap/scripts/$version
   fi
else
   echo -e "Version de debootstrap no soporta instalar Ubuntu Linux. Salir.\n"
   exit -1
fi

if [ "$version" == "eoan" ] ; then
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesUbuntu eoan $CHROOT http://archive.ubuntu.com/ubuntu
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
elif [ "$version" == "disco" ] ; then
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesUbuntu disco $CHROOT http://archive.ubuntu.com/ubuntu
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
elif [ "$version" == "cosmic" ] ; then
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesUbuntu cosmic $CHROOT http://archive.ubuntu.com/ubuntu
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
elif [ "$version" == "bionic" ] ; then
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesUbuntu bionic $CHROOT http://archive.ubuntu.com/ubuntu
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
elif [ "$version" == "artful" ] ; then
   oldRelease=true
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesUbuntu artful $CHROOT http://old-releases.ubuntu.com/ubuntu
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
elif [ "$version" == "zesty" ] ; then
   oldRelease=true
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesUbuntu zesty $CHROOT http://old-releases.ubuntu.com/ubuntu
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
elif [ "$version" == "yakkety" ] ; then
   oldRelease=true
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesUbuntu yakkety $CHROOT http://old-releases.ubuntu.com/ubuntu
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
elif [ "$version" == "xenial" ] ; then
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesUbuntu xenial $CHROOT http://archive.ubuntu.com/ubuntu
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
elif [ "$version" == "wily" ] ; then
   oldRelease=true
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesUbuntu wily $CHROOT http://old-releases.ubuntu.com/ubuntu
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
elif [ "$version" == "vivid" ] ; then
   oldRelease=true
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesUbuntu vivid $CHROOT http://old-releases.ubuntu.com/ubuntu
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
elif [ "$version" == "utopic" ] ; then
   oldRelease=true
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesUbuntu utopic $CHROOT http://old-releases.ubuntu.com/ubuntu
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
elif [ "$version" == "trusty" ] ; then
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesUbuntu trusty $CHROOT http://archive.ubuntu.com/ubuntu
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
elif [ "$version" == "precise" ] ; then
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesUbuntu precise $CHROOT http://archive.ubuntu.com/ubuntu
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
elif [ "$version" == "lucid" ] ; then
   oldRelease=true
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesUbuntu lucid $CHROOT http://old-releases.ubuntu.com/ubuntu
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
else
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesUbuntu eoan $CHROOT http://archive.ubuntu.com/ubuntu
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
fi

mychrootconf="#Configuracion inicial de Filesystems a montar para la Jaula $CHROOT. El archivo $CHROOT/etc/mychroot.conf segun necesidades.\n\n#Filesystems a montar:
\nFS:/proc\nFS:/dev\nFS:/dev/pts\nFS:/sys\nFS:/home\n
\n\nConfiguracion inicial de Servicios a iniciar:
\nService:/etc/init.d/cron\n#Service:/etc/init.d/rsyslog\n"

if [ $oldRelease ] ; then
   archiveSite="old-releases"
else
   archiveSite="archive"
fi

echo -e $mychrootconf > $CHROOT/etc/mychroot.conf && chmod 640 $CHROOT/etc/mychroot.conf
#Repositorios Ubuntu Linux: https://help.ubuntu.com/community/Repositories
echo "deb http://${archiveSite}.ubuntu.com/ubuntu $version main restricted universe multiverse" > $CHROOT/etc/apt/sources.list
echo "deb http://${archiveSite}.ubuntu.com/ubuntu $version-security main restricted universe multiverse" >> $CHROOT/etc/apt/sources.list
echo "deb http://${archiveSite}.ubuntu.com/ubuntu $version-updates main restricted universe multiverse" >> $CHROOT/etc/apt/sources.list

$(dirname $0)/mount_umount-chroot.sh $1 mount

if [ "$version" == "trusty" ] ; then
   echo "Aplicando FIX(Workarround) a 'udev' y 'cron'. Posiblemente otros paquete necesiten algo similar..."
   cp $CHROOT/etc/init.d/cron $CHROOT/etc/init.d/cron.original #backup
   cp $CHROOT/etc/init.d/udev $CHROOT/etc/init.d/udev.original #backup
   rm -vf $CHROOT/etc/init.d/cron $CHROOT/etc/init.d/udev
   cp -vf $(dirname $0)/ubuntu/trusty_etc_init.d_cron $CHROOT/etc/init.d/cron
   cp -vf $(dirname $0)/ubuntu/trusty_etc_init.d_udev $CHROOT/etc/init.d/udev
   chmod 750 $CHROOT/etc/init.d/cron $CHROOT/etc/init.d/udev
   $(dirname $0)/mount_umount-chroot.sh $1 umount
   $(dirname $0)/mount_umount-chroot.sh $1 mount
fi
chroot $CHROOT /bin/bash -c "apt-get update && apt-get -y upgrade && apt-get clean all"

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
#
#Nota: Antes de utilizar la jaula, considere agregar los repositorios necesarios en /etc/apt/sources.list,
#      puede generarlos en este sitio: http://repogen.simplylinux.ch/index.php, apt-get update, apt-get install ...
"
echo -e "\n$opt\n"

exit 0
