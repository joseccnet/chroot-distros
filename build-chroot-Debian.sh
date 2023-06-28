#!/bin/bash
#
# Build a chroot with a Debian base install.
# Author: josecc@gmail.com
#
#14.0 forky
#13.0 trixie
#12.0 bookworm
#11.0 bullseye
#10.0 buster
#9.0 stretch
#8.0 jessie - 2015-04-25: Initial release: 8.0
#7.0 wheezy May 4th 2013
#6.0 squeeze February 6th 2011
#Diciembre 2014: unstable(sid), testing(jessie), stable(wheezy)
#--variant=minbase|buildd|fakechroot|scratchbox
#--arch amd64 , i386 , armhf

source $(dirname $0)/chroot.conf

if [ ! -f /usr/sbin/debootstrap ] ; then echo -e "\nInstale debootstrap para Centos, Debian, Ubuntu o Kali. Necesario para continuar\n   yum install debootstrap\nor\n   apt-get install debootstrap"; exit -1; fi

echo " - - - - - - - - - - - - - - - - - -"
echo -e "$0 creara una jaula dentro del directorio $ROOTJAIL/$1\n"
echo -e " - - - - - - - - - - - - - - - - - -\n"


if [ "$1" == "" ]; then
 echo -e "#14.0 forky
#13.0 trixie
#12.0 bookworm
#11.0 bullseye
#10.0 buster
#9.0 stretch
#8.0 jessie - 2015-04-25: Initial release: 8.0
#7.0 wheezy May 4th 2013
#6.0 squeeze February 6th 2011
"

 echo -e "Nombre de Jaula requerido\nEjecute:\n"
 echo -e "$0 NombreJaula [sid|forky|trixie|bookworm|bullseye|buster|stretch|jessie|wheezy|squeeze [amd64|i386]]\n"
 exit -1
fi

if [ ! -d $ROOTJAIL ] ; then mkdir -vp $ROOTJAIL; chmod 755 $ROOTJAIL; fi
CHROOT=$ROOTJAIL/$1

mkdir -p $CHROOT

version=$2
arch=$3
if [ "$arch" == "" ] ; then arch=$(uname -m); fi
if [ "$arch" == "x86_64" ] ; then arch="amd64"; fi
if [ "$arch" == "amd64" ] ; then paquetesadiocionalesDeb="$paquetesadiocionalesDeb,libc6-i386"; fi
if [ "$version" == "" ] ; then version="forky"; fi
echo "Instalando..."
echo -e "VERSION: $version \t ARCH: $arch"

#Hacer que debootstrap me permita instalar Debian LINUX:
if [ -d /usr/share/debootstrap/scripts ] ; then
   if [ ! -f /usr/share/debootstrap/scripts/$version ] ; then
      ln -s /usr/share/debootstrap/scripts/sid /usr/share/debootstrap/scripts/$version
   fi
else
   echo -e "Version de debootstrap no soporta instalar Debian Linux. Salir.\n"
   exit -1
fi

if [ "$version" == "forky" ] ; then
   if [ "$arch" == "amd64" ] ; then paquetesadiocionalesDeb="$paquetesadiocionalesDeb14,libc6-i386"; else paquetesadiocionalesDeb=$paquetesadiocionalesDeb14; fi
   #Default:
   #debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesDeb forky $CHROOT http://http.debian.net/debian
   #Otras opciones de descarga:
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesDeb forky $CHROOT http://httpredir.debian.org/debian
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
elif [ "$version" == "trixie" ] ; then
   if [ "$arch" == "amd64" ] ; then paquetesadiocionalesDeb="$paquetesadiocionalesDeb13,libc6-i386"; else paquetesadiocionalesDeb=$paquetesadiocionalesDeb13; fi
   #Default:
   #debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesDeb trixie $CHROOT http://http.debian.net/debian
   #Otras opciones de descarga:
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesDeb trixie $CHROOT http://httpredir.debian.org/debian
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
elif [ "$version" == "bookworm" ] ; then
   if [ "$arch" == "amd64" ] ; then paquetesadiocionalesDeb="$paquetesadiocionalesDeb12,libc6-i386"; else paquetesadiocionalesDeb=$paquetesadiocionalesDeb12; fi
   #Default:
   #debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesDeb bookworm $CHROOT http://http.debian.net/debian
   #Otras opciones de descarga:
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesDeb bookworm $CHROOT http://httpredir.debian.org/debian
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
elif [ "$version" == "bullseye" ] ; then
   if [ "$arch" == "amd64" ] ; then paquetesadiocionalesDeb="$paquetesadiocionalesDeb11,libc6-i386"; else paquetesadiocionalesDeb=$paquetesadiocionalesDeb11; fi
   #Default:
   #debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesDeb bullseye $CHROOT http://http.debian.net/debian
   #Otras opciones de descarga:
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesDeb bullseye $CHROOT http://httpredir.debian.org/debian
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
elif [ "$version" == "buster" ] ; then
   if [ "$arch" == "amd64" ] ; then paquetesadiocionalesDeb="$paquetesadiocionalesDeb10,libc6-i386"; else paquetesadiocionalesDeb=$paquetesadiocionalesDeb10; fi
   #Default:
   #debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesDeb stretch $CHROOT http://http.debian.net/debian
   #Otras opciones de descarga:
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesDeb buster $CHROOT http://httpredir.debian.org/debian
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
elif [ "$version" == "stretch" ] ; then
   if [ "$arch" == "amd64" ] ; then paquetesadiocionalesDeb="$paquetesadiocionalesDeb9,libc6-i386"; else paquetesadiocionalesDeb=$paquetesadiocionalesDeb9; fi
   #Default:
   #debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesDeb stretch $CHROOT http://http.debian.net/debian
   #Otras opciones de descarga:
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesDeb stretch $CHROOT http://httpredir.debian.org/debian
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
elif [ "$version" == "wheezy" ] ; then
   #Default:
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesDeb wheezy $CHROOT http://archive.debian.org/debian
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
elif [ "$version" == "squeeze" ] ; then
   #Default:
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesDeb squeeze $CHROOT http://archive.debian.org/debian
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
elif [ "$version" == "jessie" ] ; then
   #Default:
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesDeb jessie $CHROOT http://archive.debian.org/debian
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
elif [ "$version" == "sid" ] ; then
   #Default:
   #debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesDeb sid $CHROOT http://http.debian.net/debian
   #Otras opciones de descarga:
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesDeb sid $CHROOT http://httpredir.debian.org/debian
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
else
   if [ "$arch" == "amd64" ] ; then paquetesadiocionalesDeb="$paquetesadiocionalesDeb14,libc6-i386"; else paquetesadiocionalesDeb=$paquetesadiocionalesDeb14; fi #For Debian 14 forky
   #Default:
   #debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesDeb forky $CHROOT http://http.debian.net/debian
   #Otras opciones de descarga:
   debootstrap --arch $arch --verbose --no-check-gpg --verbose --include=$paquetesadiocionalesDeb forky $CHROOT http://httpredir.debian.org/debian
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
fi

mychrootconf="#Configuracion inicial de Filesystems a montar para la Jaula $CHROOT. El archivo $CHROOT/etc/mychroot.conf segun necesidades.\n\n#Filesystems a montar:
\nFS:/proc\nFS:/dev\nFS:/dev/pts\nFS:/sys\nFS:/home\n
\n\nConfiguracion inicial de Servicios a iniciar:
\nService:/etc/init.d/cron\n#Service:/etc/init.d/rsyslog\n"

echo -e $mychrootconf > $CHROOT/etc/mychroot.conf && chmod 640 $CHROOT/etc/mychroot.conf
if [ "$version" != "sid" ] ; then #SID no tiene updates por ser de desarrollo.
   if [ "$version" == "forky" ] ; then
      echo "deb http://httpredir.debian.org/debian/ forky main #contrib non-free" > $CHROOT/etc/apt/sources.list
      echo "deb http://httpredir.debian.org/debian/ forky-updates main #contrib non-free" >> $CHROOT/etc/apt/sources.list
      echo "deb http://security.debian.org/debian-security forky-security main #contrib non-free" >> $CHROOT/etc/apt/sources.list
   elif [ "$version" == "trixie" ] ; then
      echo "deb http://httpredir.debian.org/debian/ trixie main #contrib non-free" > $CHROOT/etc/apt/sources.list
      echo "deb http://httpredir.debian.org/debian/ trixie-updates main #contrib non-free" >> $CHROOT/etc/apt/sources.list
      echo "deb http://security.debian.org/debian-security trixie-security main #contrib non-free" >> $CHROOT/etc/apt/sources.list
   elif [ "$version" == "bookworm" ] ; then
      echo "deb http://httpredir.debian.org/debian/ bookworm main #contrib non-free" > $CHROOT/etc/apt/sources.list
      echo "deb http://httpredir.debian.org/debian/ bookworm-updates main #contrib non-free" >> $CHROOT/etc/apt/sources.list
      echo "deb http://security.debian.org/debian-security bookworm-security main #contrib non-free" >> $CHROOT/etc/apt/sources.list
   elif [ "$version" == "bullseye" ] ; then
      echo "deb http://httpredir.debian.org/debian/ bullseye main #contrib non-free" > $CHROOT/etc/apt/sources.list
      echo "deb http://httpredir.debian.org/debian/ bullseye-updates main #contrib non-free" >> $CHROOT/etc/apt/sources.list
      echo "deb http://security.debian.org/debian-security bullseye-security main #contrib non-free" >> $CHROOT/etc/apt/sources.list
   elif [ "$version" == "buster" ] ; then
      echo "deb http://httpredir.debian.org/debian/ buster main #contrib non-free" > $CHROOT/etc/apt/sources.list
      echo "deb http://httpredir.debian.org/debian/ buster-updates main #contrib non-free" >> $CHROOT/etc/apt/sources.list
      echo "deb http://security.debian.org/ buster/updates main #contrib non-free" >> $CHROOT/etc/apt/sources.list
   elif [ "$version" == "stretch" ] ; then
      echo "deb http://httpredir.debian.org/debian/ stretch main #contrib non-free" > $CHROOT/etc/apt/sources.list
      echo "deb http://httpredir.debian.org/debian/ stretch-updates main #contrib non-free" >> $CHROOT/etc/apt/sources.list
      echo "deb http://security.debian.org/ stretch/updates main #contrib non-free" >> $CHROOT/etc/apt/sources.list
   elif [ "$version" == "jessie" ] ; then
      echo "deb http://archive.debian.org/debian/ jessie main #contrib non-free" > $CHROOT/etc/apt/sources.list
      echo "deb http://security.debian.org/ jessie/updates main #contrib non-free" >> $CHROOT/etc/apt/sources.list
      echo "#deb http://httpredir.debian.org/debian/ jessie-updates main #contrib non-free" >> $CHROOT/etc/apt/sources.list
   elif [ "$version" == "wheezy" ] ; then
      echo "deb http://archive.debian.org/debian/ wheezy main #contrib non-free" > $CHROOT/etc/apt/sources.list
   elif [ "$version" == "squeeze" ] ; then
      echo "Acquire::Check-Valid-Until no;" > $CHROOT/etc/apt/apt.conf.d/99no-check-valid-until
      echo "deb http://archive.debian.org/debian/ squeeze main #contrib non-free" > $CHROOT/etc/apt/sources.list
      echo "deb http://archive.debian.org/debian/ squeeze-lts main #contrib non-free" >> $CHROOT/etc/apt/sources.list
      echo "#deb http://archive.debian.org/debian/ squeeze-proposed-updates main #contrib non-free #UPDATES." >> $CHROOT/etc/apt/sources.list
   fi
fi

./mount_umount-chroot.sh $1 mount

chroot $CHROOT /bin/bash -c "apt-get update && apt-get -y install deborphan && deborphan -a"
#chroot $CHROOT /usr/bin/apt-get update
#chroot $CHROOT /usr/bin/apt-get -y install deborphan
#chroot $CHROOT /usr/bin/deborphan -a
for i in $(chroot $CHROOT /usr/bin/deborphan -a | awk '{print $2}' | egrep -v "exclude_pakage_name1|exclude_pakage_name2|deborphan|wget|openssh-|rsyslog"); do chroot $CHROOT /usr/bin/apt-get -y remove $i; done
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
