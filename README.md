# Mantid on Arch Linux

This is a repository for instructions for building [Mantid](https://github.com/mantidproject/mantid) on Arch Linux.

It includes the PKGBUILD files for the following packages:
* hdf4 (without netcdf because it conflicts with opencascade)
* libnexus (install hdf4 before building this)
* poco (version 1.4.7, must be at least 1.4.2 but less than 1.6.0)
* mantid-developer (Meta package to install the dependancies that mantid requires)

To build mantid use the following cmake command then run `make`:
```
cmake -DPYTHON_EXECUTABLE=/usr/bin/python2 -DPYQT4_SIP_DIR=/usr/share/sip/PyQt4 ../Code/Mantid
```
