"""
functions for 2-d line crossing checks
"""

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

#     cdef unsigned int row, col
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


cdef int c_segment_cross(double px1, double py1,
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


def segment_cross(s1_in, s2_in):
    """
    Routine to check if two line segments intersect 

    :param S1: first segment: ((x1, y1), (x2, y2))
    :type S1: 2-tuple of 2-tuples of floats 

    :returns: True if the intersect, False if they don't 
    """
 
    cdef cnp.float64_t[:,:] s1 = np.ascontiguousarray(s1_in, dtype=np.float64)
    cdef cnp.float64_t[:,:] s2 = np.ascontiguousarray(s2_in, dtype=np.float64)


    return bool(c_segment_cross(s1[0,0],  s1[0,1],
                                s1[1,0],  s1[1,1],
                                s2[0,0],  s2[0,1],
                                s2[1,0],  s2[1,1],
                                ))

