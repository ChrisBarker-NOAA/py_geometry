#!/usr/bin/env python

"""
Some tests of the point in polygon functions in the cython code.

Designed to be run with py.test

"""

import pytest

import numpy as np

## the Cython version:


from py_geometry.line_crossings import cross_product, side_of_line, segment_cross


def test_cross_product1():
    assert cross_product(0, 0, 0, 0) == 0.0
    assert cross_product(1, 1, 1, 1) == 0.0

def test_cross_product2():
    """
    erros if non-numbers pased in"
    """
    with pytest.raises(TypeError):
        cross_product(1,2,3,'string')

def test_side_of_line_right():
    x1, y1 = ( 0, 0)
    x2, y2 = (10,10)

    Px, Py = (10, 5)
    assert side_of_line(x1, y1, x2, y2, Px, Py) < 0 # right of line is < 0

    Px, Py = (0, -1)
    assert side_of_line(x1, y1, x2, y2, Px, Py) < 0 # right of line is < 0

    Px, Py = (5.000000001, 5)
    assert side_of_line(x1, y1, x2, y2, Px, Py) < 0 # right of line is < 0


def test_side_of_line_left():
    x1, y1 = ( 0, 0)
    x2, y2 = (10,10)

    Px, Py = (5, 10)
    assert side_of_line(x1, y1, x2, y2, Px, Py) > 0 # left of line is > 0

    Px, Py = (-0.000001, 0.0)
    assert side_of_line(x1, y1, x2, y2, Px, Py) > 0 # left of line is > 0

    Px, Py = (4.9999999999, 5.0)
    assert side_of_line(x1, y1, x2, y2, Px, Py) > 0 # left of line is > 0


def test_side_of_line_on_line():
    x1, y1 = ( 0, 0)
    x2, y2 = (10,10)

    Px, Py = (10, 10)
    assert side_of_line(x1, y1, x2, y2, Px, Py) == 0 # on line is  0 (might not be exact with FP...)

    Px, Py = (0, 0)
    assert side_of_line(x1, y1, x2, y2, Px, Py) == 0 # on line is  0 (might not be exact with FP...)

    Px, Py = (-10, -10)
    assert side_of_line(x1, y1, x2, y2, Px, Py) == 0 # on line is  0 (might not be exact with FP...)


def test_segment_cross_yes():
    S1 = ( (0.0, 0.0), (10.0, 10.0) )

    for S2 in [ ( (10.0,  0.0), ( 0.0, 10.0) ),
                ( ( 0.0,  0.0), ( 1.0,  0.0) ),
                ( (10.0, 10.0), (20.0, 10.0) ), # just touch the end
                ( (10.0, 10.0), (20.0, 10.0) ),
                (( 5.0, 5.0), ( 0.0,  5.0)),
              ]:
    
        assert segment_cross(S1, S2)


def test_segment_cross_no():
    S1 = ((0.0, 0.0), (10.0, 10.0))

    for S2 in [ ((10.0, 0.0), (10.0, -10.0)),
                ((-1.0, 0.0), ( 0.0,  -1.0)),
                ((11.0, 9.0), ( 9.0, -11.0)),
                (( 5.0, 5.00000000000001), ( 0.0,  5.0)),
              ]:
        assert not segment_cross(S1, S2)

# def test_as_mv_2x2_double():
#     mv = as_mv_2x2_double( ( (1,2), (3,4) ) )

#     print mv

#     assert False


