#!/bin/bash
#
# Build a chroot with a Linux Mint base install.
# Author: josecc@gmail.com
#
#Tessa 19.1
#Tara 19
#Sylvia 18.3
#Sonya 18.2 - 2017??
#Serena 18.1 - 2016_2017
#Sarah 18 - 2016
#18.x => Ubuntu 16.04, Xenial
#Rosa 17.3 - 2015_2016
#Rafaela 17.2 - 2015
#Rebecca 17.1 - 2014_2015
#Qiana 17 - 2014
#17.x => Ubuntu 14.04, Trusty
#--arch amd64 , i386

source $(dirname $0)/chroot.conf

echo " - - - - - - - - - - - - - - - - - -"
echo -e "$0 creara una jaula dentro del directorio $ROOTJAIL/$1\n"
echo -e " - - - - - - - - - - - - - - - - - -\n"


if [ "$1" == "" ]; then
echo -e "#Tessa 19.1
#Tara 19
#Sylvia 18.3
#Sonya 18.2 - 2017??
#Serena 18.1 - 2016_2017
#Sarah 18 - 2016
#Rosa 17.3 - 2015_2016
#Rafaela 17.2 - 2015
#Rebecca 17.1 - 2014_2015
#Qiana 17 - 2014
"
echo -e "Nombre de Jaula requerido\nEjecute:\n"
echo -e "$0 NombreJaula [tessa|tara|sylvia|sonya|serena|sarah|rosa|rafaela|rebecca|qiana [amd64|i386]]\n"
exit -1
fi

if [ ! -d $ROOTJAIL ] ; then mkdir -vp $ROOTJAIL; chmod 755 $ROOTJAIL; fi
CHROOT=$ROOTJAIL/$1

mkdir -p $CHROOT

version=$2
arch=$3
if [ "$arch" == "" ] ; then arch=$(uname -m); fi
if [ "$arch" == "x86_64" ] ; then arch="amd64"; fi
if [ "$version" == "" ] ; then version="serena"; fi #Ultima version
echo "Instalando..."
echo -e "VERSION: $version \t ARCH: $arch"

echo -e "\n ***Instalando la base Ubuntu Linux de la que depende Linux Mint ...***"
if [ "$version" == "tessa" ] ; then
   $(dirname $0)/build-chroot-Ubuntu.sh $1 bionic $arch #Linux Mint based on Ubuntu Bionic
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
   chroot $CHROOT/ /bin/bash -c "apt-get clean all"
   cp -vf $(dirname $0)/linuxMint/19.1_tessa_etc_apt_preferences.d_official-package-repositories.pref $CHROOT/etc/apt/preferences.d/official-package-repositories.pref
   cp -vf $(dirname $0)/linuxMint/19.1_tessa_etc_apt_sources.list.d_official-package-repositories.list $CHROOT/etc/apt/sources.list.d/official-package-repositories.list
elif [ "$version" == "tara" ] ; then
   $(dirname $0)/build-chroot-Ubuntu.sh $1 bionic $arch #Linux Mint based on Ubuntu Bionic
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
   chroot $CHROOT/ /bin/bash -c "apt-get clean all"
   cp -vf $(dirname $0)/linuxMint/19_tara_etc_apt_preferences.d_official-package-repositories.pref $CHROOT/etc/apt/preferences.d/official-package-repositories.pref
   cp -vf $(dirname $0)/linuxMint/19_tara_etc_apt_sources.list.d_official-package-repositories.list $CHROOT/etc/apt/sources.list.d/official-package-repositories.list
elif [ "$version" == "sylvia" ] ; then
   $(dirname $0)/build-chroot-Ubuntu.sh $1 xenial $arch #Linux Mint based on Ubuntu Xenial
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
   chroot $CHROOT/ /bin/bash -c "apt-get clean all"
   cp -vf $(dirname $0)/linuxMint/18.3_sylvia_etc_apt_preferences.d_official-package-repositories.pref $CHROOT/etc/apt/preferences.d/official-package-repositories.pref
   cp -vf $(dirname $0)/linuxMint/18.3_sylvia_etc_apt_sources.list.d_official-package-repositories.list $CHROOT/etc/apt/sources.list.d/official-package-repositories.list
elif [ "$version" == "sonya" ] ; then
   $(dirname $0)/build-chroot-Ubuntu.sh $1 xenial $arch #Linux Mint based on Ubuntu Xenial
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
   chroot $CHROOT/ /bin/bash -c "apt-get clean all"
   cp -vf $(dirname $0)/linuxMint/18.2_sonya_etc_apt_preferences.d_official-package-repositories.pref $CHROOT/etc/apt/preferences.d/official-package-repositories.pref
   cp -vf $(dirname $0)/linuxMint/18.2_sonya_etc_apt_sources.list.d_official-package-repositories.list $CHROOT/etc/apt/sources.list.d/official-package-repositories.list
elif [ "$version" == "serena" ] ; then
   $(dirname $0)/build-chroot-Ubuntu.sh $1 xenial $arch #Linux Mint based on Ubuntu Xenial
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
   chroot $CHROOT/ /bin/bash -c "apt-get clean all"
   cp -vf $(dirname $0)/linuxMint/18.1_serena_etc_apt_preferences.d_official-package-repositories.pref $CHROOT/etc/apt/preferences.d/official-package-repositories.pref
   cp -vf $(dirname $0)/linuxMint/18.1_serena_etc_apt_sources.list.d_official-package-repositories.list $CHROOT/etc/apt/sources.list.d/official-package-repositories.list
elif [ "$version" == "sarah" ] ; then
   $(dirname $0)/build-chroot-Ubuntu.sh $1 xenial $arch #Linux Mint based on Ubuntu Xenial
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
   chroot $CHROOT/ /bin/bash -c "apt-get clean all"
   cp -vf $(dirname $0)/linuxMint/18_sarah_etc_apt_preferences.d_official-package-repositories.pref $CHROOT/etc/apt/preferences.d/official-package-repositories.pref
   cp -vf $(dirname $0)/linuxMint/18_sarah_etc_apt_sources.list.d_official-package-repositories.list $CHROOT/etc/apt/sources.list.d/official-package-repositories.list
elif [ "$version" == "rosa" ] ; then
   $(dirname $0)/build-chroot-Ubuntu.sh $1 trusty $arch #Linux Mint based on Ubuntu Trusty
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
   chroot $CHROOT/ /bin/bash -c "apt-get clean all"
   cp -vf $(dirname $0)/linuxMint/17.3_rosa_etc_apt_preferences.d_official-package-repositories.pref $CHROOT/etc/apt/preferences.d/official-package-repositories.pref
   cp -vf $(dirname $0)/linuxMint/17.3_rosa_etc_apt_sources.list.d_official-package-repositories.list $CHROOT/etc/apt/sources.list.d/official-package-repositories.list
elif [ "$version" == "rafaela" ] ; then
   $(dirname $0)/build-chroot-Ubuntu.sh $1 trusty $arch #Linux Mint based on Ubuntu Trusty
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
   chroot $CHROOT/ /bin/bash -c "apt-get clean all"
   cp -vf $(dirname $0)/linuxMint/17.2_rafaela_etc_apt_preferences.d_official-package-repositories.pref $CHROOT/etc/apt/preferences.d/official-package-repositories.pref
   cp -vf $(dirname $0)/linuxMint/17.2_rafaela_etc_apt_sources.list.d_official-package-repositories.list $CHROOT/etc/apt/sources.list.d/official-package-repositories.list
elif [ "$version" == "rebecca" ] ; then
   $(dirname $0)/build-chroot-Ubuntu.sh $1 trusty $arch #Linux Mint based on Ubuntu Trusty
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
   chroot $CHROOT/ /bin/bash -c "apt-get clean all"
   cp -vf $(dirname $0)/linuxMint/17.1_rebecca_etc_apt_preferences.d_official-package-repositories.pref $CHROOT/etc/apt/preferences.d/official-package-repositories.pref
   cp -vf $(dirname $0)/linuxMint/17.1_rebecca_etc_apt_sources.list.d_official-package-repositories.list $CHROOT/etc/apt/sources.list.d/official-package-repositories.list
elif [ "$version" == "qiana" ] ; then
   $(dirname $0)/build-chroot-Ubuntu.sh $1 trusty $arch #Linux Mint based on Ubuntu Trusty
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
   chroot $CHROOT/ /bin/bash -c "apt-get clean all"
   cp -vf $(dirname $0)/linuxMint/17_qiana_etc_apt_preferences.d_official-package-repositories.pref $CHROOT/etc/apt/preferences.d/official-package-repositories.pref
   cp -vf $(dirname $0)/linuxMint/17_qiana_etc_apt_sources.list.d_official-package-repositories.list $CHROOT/etc/apt/sources.list.d/official-package-repositories.list
else
   $(dirname $0)/build-chroot-Ubuntu.sh $1 xenial $arch #Linux Mint based on Ubuntu Xenial
   if [ "$?" != "0" ] ; then echo "Ocurrio un error? Revise."; exit -1; fi
   chroot $CHROOT/ /bin/bash -c "apt-get clean all"
   cp -vf $(dirname $0)/linuxMint/18.2_sonya_etc_apt_preferences.d_official-package-repositories.pref $CHROOT/etc/apt/preferences.d/official-package-repositories.pref
   cp -vf $(dirname $0)/linuxMint/18.2_sonya_etc_apt_sources.list.d_official-package-repositories.list $CHROOT/etc/apt/sources.list.d/official-package-repositories.list
fi

chroot $CHROOT/ /bin/bash -c "echo '' > /etc/apt/sources.list; apt-get -y update; apt-get -y install add-apt-key; add-apt-key --keyserver keyserver.ubuntu.com A6616109451BBBF2; add-apt-key --keyserver keyserver.ubuntu.com 3EE67F3D0FF405B2; apt-get update ; apt-get -fy --reinstall install mintsystem base-files ; apt-get -y dist-upgrade; apt-get clean all"
sed -i -e 's/exit $?/exit 0/' $(find $CHROOT/var/lib/dpkg/info/ -name 'libpam-systemd*postinst') #Fix(Workarround para error con libpam-systemd)
chroot $CHROOT/ /bin/bash -c "apt-get -y update; apt-get -y upgrade; apt-get clean all"
fuser -k $CHROOT/
$(dirname $0)/mount_umount-chroot.sh $1 umount
$(dirname $0)/mount_umount-chroot.sh $1 mount

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
#
#Nota2: Linux Mint. Tener en cuenta es una instalacion base de Linux Mint. Si necesitas algun paquete adicional: 'apt-get update', 'apt-cache search mint | grep ^mint' ... etc.
"
echo -e "\n$opt\n"

exit 0
