#!/usr/bin/env python

"""
a test of how long it takes to do a LOT of line crossings
"""
import timeit
import numpy as np

from py_geometry.line_crossings import segment_cross, multi_segment_cross

n_p = 10000

n_l = 100

# do the line cross check:

def make_data(n_p = 10, n_l = 10):
    points = np.random.rand(n_p, 2) * 100
    lines = np.random.randint(0, n_p, (n_l,2))
    return points, lines

def check_all(points, lines):
    crosses = []
    for i in xrange(len(lines)):
        s1 = points[lines[i,0]], points[lines[i,1]]
        p11 = lines[i,0]
        p12 = lines[i,1]
        for j in xrange(i+1, len(lines)):
            p21 = lines[j,0]
            p22 = lines[j,1]
            #print "segment 1:",p11, p12
            #print "segment 2:",p21, p22
            if (p11 == p21 and p12 == p22) or (p11 == p22 and p12 == p21): # they are the same two points:
                #print "segments are the same"
                crosses.append( (i, j) )
                break # no need to check further
            elif p11 == p21:
                #print "first point matches first point"
                break                    
            elif p11 == p22:
                #print "first point matches second point"
                break                    
            elif p12 == p21:
                #print "second point matches first point"
                break                    
            elif p12 == p22:
                #print "second point matches second point"
                break                    
            s2 = points[lines[j,0]], points[lines[j,1]]
            if segment_cross(s1, s2):
                crosses.append( (i,j) )
    return crosses

points, lines = make_data(n_p, n_l)

sol1 = check_all(points, lines)
sol2 = multi_segment_cross(points, lines)
assert  sol1 == sol2

print "time for python version:",
print  timeit.timeit("check_all(points, lines)",
                     "from __main__ import check_all, points, lines",
                     number=10)

print "time for cython version:",
print  timeit.timeit("multi_segment_cross(points, lines)",
                     "from __main__ import multi_segment_cross, points, lines",
                     number=10)



