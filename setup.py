#!/usr/bin/env python

"""
setup.py for geometry package

"""

from setuptools import setup # to support "develop" mode
from distutils.extension import Extension
from Cython.Build import cythonize

import numpy # for the includes for the Cython code


ext_modules = cythonize([Extension("py_geometry.cy_point_in_polygon",
                                   sources=["py_geometry/cy_point_in_polygon.pyx",
                                            "py_geometry/c_point_in_polygon.c"],
                                   include_dirs=[numpy.get_include()]),
                        ])

modules = ["py_geometry/BBox.py"
           "py_geometry/polygons.py",
           "py_geometry/PinP.py"]

setup(
    name = "py_geometry",
    version = "0.03",
    author = "Chris Barker",
    author_email = "Chris.Barker@noaa.gov",
    description = ("some basic computational geometry utilities"),
#    long_description=read('README'),
    classifiers=[
                 "Development Status :: 3 - Alpha",
                 "Topic :: Utilities",
                 ],
    packages = ["py_geometry"],
    ext_modules = ext_modules,
    modules = modules, 
    scripts = [],
    )
