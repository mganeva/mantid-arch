# Mantid on Arch Linux

This repository includes packages and instructions for building [Mantid](https://github.com/mantidproject/mantid) on Arch Linux.

It includes the PKGBUILD files for the following packages:
* hdf4 (without netcdf because it conflicts with opencascade)
* libnexus (install hdf4 before building this)
* mantid-developer (Meta package to install the dependencies that mantid requires to build)

To build mantid use the following cmake command then run `make`:
```sh
cmake -DPYTHON_EXECUTABLE=/usr/bin/python2 .
```
or with VATES
```sh
cmake -DPYTHON_EXECUTABLE=/usr/bin/python2 -DMAKE_VATES=TRUE -DParaView_DIR=~/ParaView/build .
```

If cmake can't find opencascade add the following:
```sh
-DOPENCASCADE_LIBRARY_DIR=/opt/opencascade/lib -DOPENCASCADE_INCLUDE_DIR=/opt/opencascade/inc
```
