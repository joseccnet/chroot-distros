Chroot Distros
==============

Instala de una manera profesional ambienes CHROOT con distribuciones Linux: Debian, Ubuntu, Centos, Fedora, OpenSuse, Linux Mint, KaliLinux o Devuan(Debian 8.0 jessie, Debian Without systemd). Arquitecturas i386 y x86_64.

Autor: @joseccnet

Descripción:

 Para instalar rápida y fácilmente un ambiente 'chroot' sólo necesitas:

+ Tener instalado un sistema operativo Linux arquitectura x86_64(Prácticamente cualquier distro Debian, Ubuntu, Centos, etc. Con una versión de kernel reciente si necesitas instalar una distro "moderna"/reciente).
+ En Centos 6, instalar el repositorio EPEL: ``rpm -ivh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm``
+ En Centos 7, instalar el repositorio EPEL: ``rpm -ivh http://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm``
+ En Centos 6 o 7, instalar: ``yum install git pyliblzma debootstrap`` (debootstrap disponible en el repositorio EPEL)
+ En Debian, Ubuntu y Kali Linux, instalar las dependencias: ``apt-get install yum debootstrap python-lzma psmisc git``
+ Descargar/clonar este proyecto con git: ``git clone https://github.com/joseccnet/chroot-distros.git``
+ ``cd chroot-distros ; chmod 700 *.sh``

Estas listo para instalar ambientes 'chroot' (Debian, Ubuntu, Centos, Fedora, OpenSuse, Linux Mint, KaliLinux o Devuan):

+ En el archivo 'chroot.conf', revise y configure la variable de ambiente ROOTJAIL (default: ROOTJAIL=/opt/jaulas)

Tenga en cuenta:
 + Se asume que usted entiende sobre administracion de sistemas operativos Linux, en particular de temas con 'chroot'
 + Revise la configuracion del archivo ./chroot.conf
 + Despues de instalar alguna distro, **NO** elimine los directorios dentro de /opt/jaulas SIN desmontar los File Systems (ejecutar script mount_umount-chroot.sh)
 + Ignorar la advertencia anterior puede causar inestabilidad en el sistema o incluso BORRAR archivos del sistema(ejemplo /home)

--

Por favor, antes de reportar algún error, favor de revisar el archivo 'issues_and_notes.txt' donde estan documentados algunos de ellos.

Nota de responsabilidad: Usted es responsable de la utilización de estos scripts de forma correcta, por favor revise y pruebe estos de manera exhaustiva en un ambiente controlado antes de llevarlos a producción.
