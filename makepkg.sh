#!/usr/bin/bash
#
# https://gist.github.com/Earnestly/bebad057f40a662b5cc3
#
# Run this script in your build directory to package mantid for Arch Linux.
#

# install package
# cd to build directory
rm -rf pkg
mkdir pkg
fakeroot -- make DESTDIR=pkg install
mkdir -p pkg/etc/profile.d

# fix executable name, add symlinks, install profile.d scripts
mv pkg/opt/Mantid/bin/MantidPlot pkg/opt/Mantid/bin/MantidPlot_exe
ln -s /opt/Mantid/bin/launch_mantidplot.sh pkg/opt/Mantid/bin/MantidPlot
ln -s /opt/Mantid/bin/launch_mantidplot.sh pkg/opt/Mantid/bin/mantidplot
ln -s /opt/Mantid/etc/mantid.sh pkg/etc/profile.d/
ln -s /opt/Mantid/etc/mantid.csh pkg/etc/profile.d/

# create .PKGINFO
pkgver=`bin/MantidPlot --version | sed 's/ .*$//'`
cd pkg
pkgname=mantidnightly
pkgrel=1
pkgdesc="Data analysis toolkit for neutron based instrument data"
url="http://www.mantidproject.org/"
license="GPL"
arch=$(uname -m)

cat << EOF > .PKGINFO
pkgname = $pkgname
pkgver = $pkgver-$pkgrel
pkgdesc = $pkgdesc

url = $url
license = $license

builddate = $(date -u '+%s')
size = $(du -sb --apparent-size | awk '{print $1}')

arch = $arch

depend = libnexus
depend = qwt5
depend = qwtplot3d
depend = qscintilla
depend = boost-libs
depend = poco
depend = muparser
depend = qtwebkit
depend = jsoncpp
depend = ipython2
depend = python2
depend = python2-numpy
depend = python2-pyqt4
depend = python2-pyzmq
depend = python2-scipy
depend = python2-sip
depend = python2-yaml
depend = hdf5-cpp-fortran
depend = hdf4
depend = gsl

makedepend = cmake
makedepend = boost
makedepend = doxygen

EOF

# create .MTREE
fakeroot -- env LANG=C bsdtar -czf .MTREE --format=mtree --options='!all,use-set,type,uid,gid,mode,time,size,md5,sha256,link' .PKGINFO *

# package
fakeroot -- env LANG=C bsdtar -cf - .MTREE .PKGINFO * | xz -c -z - > ../$pkgname-$pkgver-$pkgrel-$arch.tar.xz
