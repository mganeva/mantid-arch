# Mantid on Arch Linux

This repository includes packages and instructions for building [Mantid](https://github.com/mantidproject/mantid) on Arch Linux.

It includes the PKGBUILD files for the following packages:
* hdf4 (without netcdf because it conflicts with opencascade)
* libnexus (install hdf4 before building this)
* poco (version 1.4.7, must be at least 1.4.2 but less than 1.6.0)
* python2-matplotlib-qt4 (Qt4 over Qt5 as default backend because conflicts with Mantid Qt)
* mantid-developer (Meta package to install the dependencies that mantid requires)

To build mantid use the following cmake command then run `make`:
```
cmake -DPYTHON_EXECUTABLE=/usr/bin/python2 -DPYQT4_SIP_DIR=/usr/share/sip/PyQt4 -DOPENCASCADE_LIBRARY_DIR=/opt/opencascade/lib -DOPENCASCADE_INCLUDE_DIR=/opt/opencascade/inc ../Code/Mantid
```
or with VATES
```
cmake -DPYTHON_EXECUTABLE=/usr/bin/python2 -DPYQT4_SIP_DIR=/usr/share/sip/PyQt4 -DOPENCASCADE_LIBRARY_DIR=/opt/opencascade/lib -DOPENCASCADE_INCLUDE_DIR=/opt/opencascade/inc -DMAKE_VATES=TRUE -DParaView_DIR=~paraview/build ../Code/Mantid
```
