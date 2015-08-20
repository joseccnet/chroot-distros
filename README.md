Chroot Distros
==============

Instala de una manera profesional ambienes CHROOT con distribuciones Linux: Debian, Ubuntu, Centos, Fedora, OpenSuse o KaliLinux. Arquitecturas i386 y x86_64.

Autor: @joseccnet

Descripción:

 Para instalar rápida y fácilmente un ambiente 'chroot' sólo necesitas:

+ Tener instalado un sistema operativo Linux arquitectura x86_64(Probado en Centos 6.6, Centos 7, Debian 7.7, Debian 8.0, Ubuntu 14.10, Kali Linux 1.0.x y 2.0).
+ En Centos 6, instalar el repositorio EPEL: ``rpm -ivh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm``
+ En Centos 7, instalar el repositorio EPEL: ``rpm -ivh http://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm``
+ En Centos 6 o 7, instalar: ``yum install git pyliblzma debootstrap`` (debootstrap disponible en el repositorio EPEL)
+ En Debian, Ubuntu y Kali Linux, instalar las dependencias: ``apt-get install yum debootstrap python-lzma psmisc git``
+ Descargar/clonar este proyecto con git: ``git clone https://github.com/joseccnet/chroot-distros.git``
+ ``cd chroot-distros ; chmod 700 *.sh``

Estas listo para instalar ambientes 'chroot' (Debian, Ubuntu, Centos, Fedora, OpenSuse o KaliLinux):

+ En el archivo 'chroot.conf', revise y configure la variable de ambiente ROOTJAIL (default: ROOTJAIL=/opt/jaulas)
+ Revise y ejecute con el usuario root el script 'install-all-versions.sh'(Este archivo tiene ejemplos de cómo instalar las diferentes versiones de sistemas operativos), observará algo como esto:

`` ./install-all-versions.sh``

Para continuar, Ejecute:

`` ./install-all-versions.sh I_AM_AGREE NombreDistro &``

   Donde NombreDistro puede ser: Debian , Ubuntu , Centos, Fedora, OpenSuse o KaliLinux


La ejecucion de este script intentara instalar todas las versiones de sistemas operativos en jaulas con 'chroot'.

Tenga en cuenta:
 + Se asume que usted entiende sobre administracion de sistemas operativos Linux, en particular de temas con 'chroot'
 + Revise la configuracion del archivo ./chroot.conf
 + Necesita cerca de 10GB de espacio libre en /opt/jaulas para instalar todas las versiones de Linux soportadas.
 + Despues de ejecutar este script, **NO** elimine los directorios dentro de /opt/jaulas SIN desmontar los File Systems (ejecutar script mount_umount-chroot.sh)
 + Ignorar esta advertencia puede causar inestabilidad en el sistema o incluso BORRAR archivos del sistema(ejemplo /home)

--

Por favor, antes de reportar algún error, favor de revisar el archivo 'issues_and_notes.txt' donde estan documentados algunos de ellos.


Nota de responsabilidad: Usted es responsable de la utilización de estos scripts de forma correcta, por favor revise y pruebe estos de manera exhaustiva en un ambiente controlado antes de llevarlos a producción.
