from numba import jit,autojit
from pdb import set_trace as bp
from math import *
import numpy as np
import pandas as pd
import scipy.linalg as linalg
import scipy.optimize as opt
from UnitCell import cellNodes
import matplotlib.pyplot as plt

def allCoordinates(alpha,d,nx,ny,shape,BC,plot):
	"""
	shape = "HEXAGON"
	BC = 'yes'
	d = 1
	angle = 30
	alpha = radians(angle)
	unitcell = cellNodes(alpha,d,shape)
	xDirection = unitcell
	nx = np.arange(1,20)
	ny = np.arange(1,30)
	bp() # Break point for debugging
	"""
	unitcell = cellNodes(alpha,d,shape)
	xDirection = unitcell
	if shape == "HEXAGON":
		for ii in range(0,len(nx)-1):
			xSweep = unitcell[0:4,:] + [nx[ii]*2*d*cos(alpha),0,0]
			xDirection = np.concatenate((xDirection,xSweep),axis=0)
		df = pd.DataFrame(xDirection) # Converts the array to a dataframe
		xDirection = df.drop_duplicates() # Checks for duplicates
		xDirection = df.drop_duplicates().values # Converts dataframe back to array
		xTop = xDirection[:,1] == (max(xDirection[:,1]))
		xt = xDirection[xTop,:] + [0,d,0]
		xDirection = np.concatenate((xDirection,xt),axis=0)
		yDirection = xDirection
		if len(ny) != 1:
	    		for ii in range(0,len(ny)-1):
	        		ySweep = xDirection[:,:] + [0,ny[ii]*2*d*(1+sin(alpha)),0]
	        		yDirection = np.concatenate((yDirection,ySweep),axis=0)
	    	else:
	        	yDirection = xDirection
		temp  = np.round(yDirection[:,1],4) == round(max(yDirection[:,1] \
										- d*(1+sin(alpha))),4)

		yTop = yDirection[temp,:] + [0,d*(1+2*sin(alpha)),0];
		yDirection = np.concatenate((yDirection,yTop),axis=0)

		del temp
		del yTop
		allCoordinates = yDirection
		del xDirection, yDirection

	##########################;
	# Making Periodic Lattice ;
	##########################;
		if BC=='no':
			temp = np.round(allCoordinates[:,1],4) == round(max(allCoordinates[:,1]),4)
			yTop = allCoordinates[temp,:] + [0,d,0]
			allCoordinates = np.concatenate((allCoordinates,yTop),axis=0)
			del temp
			temp = np.round(allCoordinates[:,1],4) == round(max(allCoordinates[:,1]),4)
			allCoordinates[temp,:] = [0, 0, 0]

	###########;
	# Triangle ;
	###########;
	if shape == "TRIANGLE":
		for ii in range(1,len(nx)-1):
			xSweep = unitcell[0:3,:] + [nx[ii]*d,0,0]
			xDirection = np.concatenate((xDirection,xSweep),axis=0)
		
		df = pd.DataFrame(xDirection) # Converts the array to a dataframe
		xDirection = df.drop_duplicates() # Checks for duplicates
		xDirection = df.drop_duplicates().values # Converts dataframe back to array
		allCoordinates = xDirection
		angle = degrees(alpha)
		
		if angle == 90:
			temp = np.round(allCoordinates[:,0],4) ==\
			 round(max(allCoordinates[:,0]),4)
			allCoordinates[temp,:] = [0, 0, 0]
		
		yDirection = xDirection
		
		for ii in range (1,len(ny)):
        		ySweep = xDirection[:,:] + [0,ny[ii]*2*d*sin(alpha),0];
        		yDirection = np.concatenate((yDirection,ySweep),axis=0)
    		temp = yDirection[:,1] == max(yDirection[:,1])
        	yDirection[temp,:] = [0, 0, 0]
    	
    		del temp
    	
    		allCoordinates = yDirection

    		del xDirection, yDirection

	####################;
	# # Drop Duplicates ;
	####################;
	allCoordinates = np.sort(allCoordinates[:,:],1)
	print allCoordinates
	bp()
	# allCoordinates = allCoordinates[allCoordinates[:,1].argsort(axis=0)]
	df = pd.DataFrame(allCoordinates) # Converts the array to a dataframe
	allCoordinates = df.drop_duplicates() # Checks for duplicates
	allCoordinates = df.drop_duplicates().values
	
	if plot == 1:
		plt.figure(1)
		plt.plot(allCoordinates[:,0],allCoordinates[:,1],'.')
		plt.axis('equal')
		plt.draw()
	np.savetxt('allCoordinates.txt', allCoordinates, delimiter=',')
	return allCoordinates