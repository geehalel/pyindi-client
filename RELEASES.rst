Instructions
============

Extract the archive and run `python setup.py install` as root from the extracted directory.
See other instructions in the `svn tree`_.

Releases
========

- v0.2.6: `indibase/refactoring`_: INDI::Property::apply and ::define are ignored (varargs following optional arg issue in swig).
- v0.2.5: Fix package build with newer setuptools.
- v0.2.4: Corrections suggested by Radek Kaczorek (include stdind.i).
- v0.2.3: Corrections suggested by Georg Viehoever and Marco Gulino (`StarQuew`_).
- v0.2.2: Use std=c++11 flag for compiling the swig wrapper.
- v0.2.1: Use default string wrapping in swig.
- v0.2.0: Changed libraries flag in setup.cfg for libindi 1.4.1. Edit setup.cfg if you use an older libindi version.
- v0.1.0a1: Added multiarch search
- v0.1.0: Initial release. Tested on Ubuntu 15.10 (x86_64, python2, hand compiled indi-svn) and Fedora 22 (x86_64, python2, hand compiled indi-svn-2671)


.. _svn tree: https://sourceforge.net/p/pyindi-client/code/HEAD/tree/trunk/pip/pyindi-client/
.. _StarQuew: https://github.com/GuLinux/StarQuew/
.. _indibase/refactoring: https://github.com/indilib/indi/pull/1302
