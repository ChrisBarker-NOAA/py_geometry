Installing
=====================

py_geometry consists of both python and cython (`*.pyx` files) code.


It needs to be installed from source: you'll need cython and an appropriate compiler.

Dependencies
---------------------
pyGNOME depends on:

numpy
cython

sphinx (if you want to build the docs)

Building
---------------------

Ideally, it is as simple as::

    $ python setup.py build
    $ python setup.py install
or

    $ python setup.py develop

(develop mode installs links to the code, rather than copying the code into python's site-packages -- it is helpful if you want to be updating the code, and have the new version run right away.)
