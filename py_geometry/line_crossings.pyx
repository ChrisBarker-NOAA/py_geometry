"""
functions for 2-d line crossing checks
"""

from libc.stdint cimport  int32_t, uint32_t

import numpy as np
cimport numpy as cnp

# from cython.view cimport array as cvarray
# from cython.view cimport memoryview

# cpdef memoryview as_mv_2x2_double(obj):
#     """
#     takes an arbitray object and returns a 2x2 memory view of it
    
#     If the input object has a compatible buffer, it will be used,
#     otherwise the data will be copied and converted if possible.
#     """

#     cdef uint32_t row, col
#     cdef double [:,:] mv 
#     cdef cvarray cyarr

#     try:
#         mv = memoryview(obj)
#     except ValueError:
#         # Memoryview on a Cython array
#         cyarr = cvarray(shape=(2, 2), itemsize=sizeof(double), format="d", mode='c')
#         try:
#             mv = cyarr
#             for row in range(2):
#                 for col in range(2):
#                     mv[row, col] = obj[row][col]
#         except IndexError:
#             raise ValueError("input object must be 2x2 is shape")
#         except ValueError:
#             raise ValueError("input object element can not be converted to double")

#     return mv

# def call_as_mv_2x2_double(obj):

#     print obj

#     obj = call_as_mv_2x2_double(obj)

#     print obj

#     return obj



cpdef double cross_product(double x1, double x2, double y1, double y2):
    """
    compute the cross product of two 2-d vectors

    used by side of line checks, etc.
    :param x1, x2, y1, y2: coordintes of vectors
    :type x1, x2, y1, y2: doubles (python floats)
    """

    return (x1*y2 - y1*x2)


cpdef double side_of_line(double x1, double y1,
                          double x2, double y2,
                          double Px, double Py):

    """
    Given a line segment x1,y1 to x2,y2
    it checks to see if point Px,Py is to the right
    or to the left of the line segment looking from
    point x1,y1 to point x2,y2.


    If result is positive, then the point Px,Py is to the LEFT of the
    line segment.  If result is negative, P is to the right of segment.
    If result is zero then, P is on the segment
    If result =0 then that means that the point P is on the line
    defined by the two points...they may not be on the segment

    The check is done by taking the
    cross product of the vectors x1,y1 to x2,y2
    and x1,y1 to Px,Py
   
    """

    cdef double dx, dy, dxp, dyp

    dx = x2 - x1
    dy = y2 - y1
    dxp = Px - x1
    dyp = Py - y1
  
    return cross_product(dx, dy, dxp, dyp)


cdef int32_t c_segment_cross(double px1, double py1,
                       double px2, double py2,
                       double px3, double py3,
                       double px4, double py4,
                       ):
    """
    cython version of segment crossing.

    called by segment_cross (after unpacking tuples..)
    """
    cdef double D1, D2

    #   Check to see if point 3 is to the left of segment 1
  


    D1 = side_of_line(px1,py1,px2,py2,px3,py3)

    # Now check if point 4 is to the left of segment 1
    D2 = side_of_line(px1,py1,px2,py2,px4,py4)

    # if points 3 and 4 are on the same side of line 1
    # then they don't cross

    if (D1*D2 > 0.0):
        return  0

    # now check the other way..      
    
    # Check to see if point 1 is to the left of segment 2 */
    D1 = side_of_line(px3,py3,px4,py4,px1,py1)

    # check if point 2 is to the left of segment 2

    D2 = side_of_line(px3,py3,px4,py4,px2,py2);

    # if points 1 and 2 are on the same side of line 2 then they don't cross
  
    if(D1*D2 > 0.0):
       return 0
    
    # if we get here, they cross
    return 1

def segment_cross(s1, s2):
    """
    Routine to check if two line segments intersect 

    :param s1: first segment: ((x1, y1), (x2, y2))
    :type s1: 2-tuple of 2-tuples of floats 
    :param s2: second segment: ((x1, y1), (x2, y2))
    :type s2: 2-tuple of 2-tuples of floats 

    :returns: True if they intersect, False if they don't 
    """
 
    return bool(c_segment_cross(s1[0][0],  s1[0][1],
                                s1[1][0],  s1[1][1],
                                s2[0][0],  s2[0][1],
                                s2[1][0],  s2[1][1],
                                ))


def multi_segment_cross(double[:,:]points, int32_t[:,:] segments):
    """
    does a line-segment cross check on a set of segments
    
    line segments are defined by indexing into an array of points
    
    NOTE: pure python version took about 1 minute to run with 1000 segments on my machine.
          this version took 1.5 seconds
    """
    cdef double s1x1, s1y1, s1x2, s1y2, s2x1, s2y1, s2x2, s2y2
    cdef uint32_t i, j, num_lines
    cdef int32_t p11, p12, p21, p22
    num_lines = segments.shape[0]
    crosses = []
    for i in range(num_lines):
        s1x1 = points[segments[i,0]][0]
        s1y1 = points[segments[i,0]][1]
        s1x2 = points[segments[i,1]][0]
        s1y2 = points[segments[i,1]][1]
        p11 = segments[i,0]
        p12 = segments[i,1]
        for j in range(i+1, num_lines):
            p21 = segments[j,0]
            p22 = segments[j,1]
            # check if the segments match
            #print "segment 1:",p11, p12
            #print "segment 2:",p21, p22
            if (p11 == p21 and p12 == p22) or (p11 == p22 and p12 == p21): # they are the same two points:
                #print "segments are the same"
                crosses.append( (<int32_t> i, <int32_t> j) )
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
            s2x1 = points[p21][0]
            s2y1 = points[p21][1]
            s2x2 = points[p22][0]
            s2y2 = points[p22][1]
            if c_segment_cross( s1x1,  s1y1,
                                s1x2,  s1y2,
                                s2x1,  s2y1,
                                s2x2,  s2y2,
                               ):
                crosses.append( (<int32_t> i, <int32_t> j) )
    return crosses

    
        
