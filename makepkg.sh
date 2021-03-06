#!/usr/bin/bash
#
# https://gist.github.com/Earnestly/bebad057f40a662b5cc3
#
# Run this script in your build directory to package mantid for Arch Linux.
#

# install package
# cd to build directory or set BUILD_DIR
BUILD_DIR=$PWD
echo $BUILD_DIR
rm -rf pkg
mkdir pkg
fakeroot -- make DESTDIR=pkg install
mkdir -p pkg/etc/profile.d

# fix executable name, add symlinks, install profile.d scripts
mv pkg/opt/mantidunstable/bin/MantidPlot pkg/opt/mantidunstable/bin/MantidPlot_exe
ln -s /opt/mantidunstable/bin/launch_mantidplot.sh pkg/opt/mantidunstable/bin/MantidPlot
ln -s /opt/mantidunstable/bin/launch_mantidplot.sh pkg/opt/mantidunstable/bin/mantidplot
ln -s /opt/mantidunstable/etc/mantid.sh pkg/etc/profile.d/
ln -s /opt/mantidunstable/etc/mantid.csh pkg/etc/profile.d/

# install paraview
# get paraview build directory from CMakeCache.txt
PARAVIEW_BUILD_DIR=`grep ParaView_DIR CMakeCache.txt | sed 's/.*=//'`
echo $PARAVIEW_BUILD_DIR
cd $PARAVIEW_BUILD_DIR
DESTDIR=$BUILD_DIR/pkg/opt/mantidunstable fakeroot -- cmake -DCMAKE_INSTALL_PREFIX= -P cmake_install.cmake
cd $BUILD_DIR

# create .PKGINFO
pkgver=`bin/MantidPlot --version | sed 's/ .*$//'`
cd pkg
pkgname=mantid
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

depend = boost-libs
depend = glu
depend = gperftools
depend = gsl
depend = hdf4
depend = hdf5
depend = intel-tbb
depend = ipython2
depend = jsoncpp
depend = libnexus
depend = libxslt
depend = muparser
depend = opencascade
depend = poco
depend = python2
depend = python2-dateutil
depend = python2-h5py
depend = python2-numpy
depend = python2-pyqt4
depend = python2-pyzmq
depend = python2-qtconsole
depend = python2-scipy
depend = python2-sip
depend = python2-yaml
depend = qscintilla-qt4
depend = qtwebkit
depend = qwt5
depend = qwtplot3d

makedepend = boost
makedepend = cmake
makedepend = doxygen

EOF

# create .MTREE
fakeroot -- env LANG=C bsdtar -czf .MTREE --format=mtree --options='!all,use-set,type,uid,gid,mode,time,size,md5,sha256,link' .PKGINFO *

# package
fakeroot -- env LANG=C bsdtar -cf - .MTREE .PKGINFO * | xz -T 0 -c -z - > ../$pkgname-$pkgver-$pkgrel-$arch.tar.xz
