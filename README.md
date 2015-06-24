# mantid-arch
Mantid on Arch Linux

This is a repository for instructions for building [Mantid](https://github.com/mantidproject/mantid) on Arch Linux.

It includes the PKGBUILD files for the following packages:
* hdf4 (without netcdf)
* libnexus
* poco (version 1.4.7)

To build mantid use the following cmake command then run `make`:
```
cmake -DPYTHON_EXECUTABLE=/usr/bin/python2 -DPYQT4_SIP_DIR=/usr/share/sip/PyQt4 ../Code/Mantid
```
