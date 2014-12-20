Chroot Distros
==============

Instala de una forma profesional ambienes CHROOT con distribuciones Linux: Debian, Ubuntu, Centos, Fedora, OpenSuse o KaliLinux. Arquitecturas i386 y x86_64.

Autor: @joseccnet

Descripción:

 Para instalar rápida y fácilmente un ambiente 'chroot' sólo necesitas:

+ Tener instalado un sistema operativo Linux basado 'Centos 6 x86_64'(Por el momento lo desarrollé para esta distribución).
+ Instalar/configurar el repositorio EPEL para Centos 6: rpm -ivh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
+ Instalar el paquete 'debootstrap': yum install debootstrap (Disponible en el repositorio EPEL)
+ Descargar/clonar este proyecto con git: git clone https://github.com/joseccnet/chroot-distros.git

Estas listo para instalar ambientes 'chroot' (Debian, Ubuntu, Centos, Fedora, OpenSuse o KaliLinux) completos:

+ En el archivo 'chroot.conf', revise y configure la variable de ambiente ROOTJAIL (default: ROOTJAIL=/opt/jaulas)
+ Revise y ejecute con el usuario root el script 'install-all-versions.sh', observará algo como esto:

\# ./install-all-versions.sh

Para continuar, Ejecute:
   ./install-all-versions.sh I_AM_AGREE NombreDistro &

   Donde NombreDistro puede ser: Debian , Ubuntu , Centos, Fedora, OpenSuse o KaliLiinux


La ejecucion de este script intentara instalar todas las versiones de sistemas operativos en jaulas con 'chroot'.

Tenga en cuenta:
 + Se asume que usted entiende sobre administracion de sistemas operativos Linux, en particular de temas con 'chroot'
 + Revise la configuracion del archivo ./chroot.conf
 + Necesita cerca de 10GB de espacio libre en /opt/jaulas
 + Despues de ejecutar este script, **NO** elimine los directorios dentro de /opt/jaulas SIN desmontar los File Systems (ejecutar script mount_umount-chroot.sh)
 + Ignorar esta advertencia puede causar inestabilidad en el sistema o incluso BORRAR archivos del sistema(ejemplo /home)






Nota de responsabilidad: Usted es responsable de la utilización de estos scripts de forma correcta, por favor revise y pruebe estos de manera exhaustiva en un ambiente controlado antes de llevarlos a producción.
