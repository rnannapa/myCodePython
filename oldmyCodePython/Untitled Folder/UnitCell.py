from math import *
import numpy as np

def cellNodes(alpha,d,shape):
    # shape = "TRIANGLE"
    # angle = 90
    # alpha = radians(angle)
    # d = 1
    if shape == 'HEXAGON':
        Coord = np.zeros((4,3))
        Coord[0,0] = 0; Coord[0,1] = 0; Coord[0,2] = 0
        Coord[1,0] = Coord[0,0]; Coord[1,1] = Coord[0,1]+d; Coord[1,2] = 0
        Coord[2,0] = Coord[1,0] + d*cos(alpha); Coord[2,1] = Coord[1,1] + d*sin(alpha); Coord[2,2] = 0
        Coord[3,0] = Coord[1,0] - d*cos(alpha); Coord[3,1] = Coord[1,1] + d*sin(alpha); Coord[3,2] = 0
        return Coord
        # print(Coord)
    elif shape == 'TRIANGLE':
        Coord = np.zeros((3,3))
        Coord[0,0] = 0; Coord[0,1] = 0; Coord[0,2] = 0
        Coord[1,0] = d; Coord[1,1] = 0; Coord[1,2] = 0
        Coord[2,0] = d*cos(alpha); Coord[2,1] = d*sin(alpha); Coord[2,2] = 0
        return Coord
        # print(Coord)
    else:
        coordinates = 'Shape Not Defined. Try Hexagon or Triangle'
        return