# import cProfile
# cProfile.run('')
import time
# from numba import jit,autojit
from pdb import set_trace as bp
from math import *
import numpy as np
import pandas as pd
import scipy.linalg as linalg
import scipy.optimize as opt
from Coordinates import allCoordinates
from Connectivity import Connectivity
import matplotlib.pyplot as plt
from sklearn.neighbors import KDTree

"""
This is the main code file that calls all the other functions

Written By: Raj Gopal
Last Update: 03/25/2018

# Lx = input("Enter Length in X-axis:")
# Ly = input("Enter Length in Y-axis:")
# shape = raw_input("Enter the shape of the unit cell:")
# shape = shape.upper()
# angle = input("Enter the angle between the edges in Degrees:")
# # alpha = math.radians(angle)
# alpha = radians(angle)
# Nx = input("Number of cells along X-axis:")
# dofpernode = input("Degrees of freedom per node:")
# BC = raw_input("Are Boundary Conditions Periodic?(Yes/No):")
# BC = BC.upper()
"""

tCoordinates = time.time()
plot = 0

Lx = 10.
Ly = 10.
shape = "TRIANGLE"
shape = shape.upper()
angle = 60
alpha = radians(angle)
Nx = 10.
plot = 0
dofpernode = 2
BC = "no"
BC = BC.upper()
eps = 1E-6

if shape == "HEXAGON":
	d = float(Lx)/(2*Nx*cos(alpha))
	Ny = float(Ly)/(d*(2 + 2*sin(alpha)))
	Ny = int(Ny)
	print(Ny)

if shape == "TRIANGLE":
	d = float(Lx)/Nx
	Ny = float(0.5*Ly)/(d*sin(alpha))
	Ny = int(Ny)

nx = np.arange(0,Nx+1)
ny = np.arange(0,Ny)

tCoordinates = time.time()
allCoordinates = allCoordinates(alpha,d,nx,ny,shape,BC,plot)
print allCoordinates
print "Time required for generating allCoordinates:",time.time() - tCoordinates


# tConnectivity = time.time()
# Connectivity = Connectivity(allCoordinates,angle,d,shape,eps,plot)
# print Connectivity
# print "Time required for generating Connectivity:",time.time() - tCoordinates

# plt.show()
# bp()
# # #######;
# # # Time ;
# # #######;
# tStart = 0; tEnd = 300; dt = 1;
# if (tEnd - tStart)<dt:
#     dt = (tEnd - tStart)
# t = np.arange(tStart,tEnd,dt)
# lenth =t[len(t)-1]

# tMax = 60; w = 0.5; dw = 0.05
