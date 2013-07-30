#!/usr/bin/env python

"""
test_p_in_p

Test code for Point in Polygon module

Designed to be run with py.test
"""

import numpy as np

from py_geometry import p_in_p

# the very simplest test
poly1 = np.array( ( (0,0),
                    (0,1),
                    (1,1),
                    (1,0),
                    ), np.float )

# this one has first and last points duplicated
poly2 = np.array( ( (0,0),
                    (0,1),
                    (1,1),
                    (1,0),
                    (0,0),
                    ), np.float )


def test_inside1():
    assert p_in_p.CrossingsTest( poly1, (0.5, 0.5) ) is True

def test_inside2():
    assert p_in_p.CrossingsTest( poly2, (0.5, 0.5) ) is True

def test_on_vertex():
    assert p_in_p.CrossingsTest( poly1, (1, 1) ) is True

def test_outside1():
    assert p_in_p.CrossingsTest( poly1, (2, 2) ) is False

def test_outside2():
    assert p_in_p.CrossingsTest( poly2, (2, 2) ) is False

def test_float():
    poly = ( (-50, -30), (-50, 30), (50, 30), (50, -30) )
    poly = np.array(poly, dtype = np.float64)
    
    #assert p_in_p.CrossingsTest( poly, (0, 0) ) is True
    
    assert p_in_p.CrossingsTest( poly, (100.0, 1.0) ) is False

## test the points in polygon code:

def test_points_in_poly_scalar():

    assert p_in_p.points_in_poly( poly1, (0.5, 0.5, 0.0)) is True

    assert p_in_p.points_in_poly( poly1, (1.5, 0.5, 0.0)) is False

def test_points_in_poly_array_one_element():

    assert np.array_equal( p_in_p.points_in_poly( poly1, ( (0.5, 0.5, 0.0), ) ),
                          np.array((True,)) 
                          )

    assert np.array_equal( p_in_p.points_in_poly( poly1, ( (1.5, -0.5, 0.0), ) ),
                          np.array((False,)) 
                          )

def test_points_in_poly_array():
    points = np.array( ((0.5, 0.5, 0.0),
                        (1.5, 0.5, 0.0),
                        (0.5, 0.5, 0.0),
                        (0.5, 0.5, 0.0),
                        (-0.5, 0.5, 0.0),
                        (0.5, 0.5, 0.0),) )

    result = np.array((True,
                       False,
                       True,
                       True,
                       False,
                       True,
                       )) 

    assert np.array_equal( p_in_p.points_in_poly( poly2, points),
                          result )


               