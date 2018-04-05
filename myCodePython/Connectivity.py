import time
from numba import jit,autojit
from pdb import set_trace as bp
from math import *
import numpy as np
import pandas as pd
import scipy.linalg as linalg
import scipy.optimize as opt
from Coordinates import allCoordinates
import matplotlib.pyplot as plt
from sklearn.neighbors import KDTree

def Connectivity(allCoordinates,angle,d,shape,eps,plot):
	kdt = KDTree(allCoordinates, leaf_size=2, metric='euclidean')
	NNid = kdt.query_radius(allCoordinates, r=d+eps)
	
	Connectivity = np.array([0,0])

	for nid in range(0,int(NNid.shape[0])):
		startId = np.where(NNid[nid] == nid)
		# startId = np.array(startId)
		NNid[nid][0],NNid[nid][startId[0],] = NNid[nid][startId[0],],NNid[nid][0]

		NNVecSize = int(NNid[nid].shape[0])
		
		for ij in range (1,NNVecSize):
			
			temp = np.array([NNid[nid][0],NNid[nid][ij]])

			if shape == "HEXAGON":
				if allCoordinates[temp[0],1] == allCoordinates[temp[1],1]:
					temp = np.array([0,0])
			Connectivity = np.concatenate((Connectivity,temp),axis=0)
			# Connectivity = np.array(Connectivity)

			if shape =="TRIANGLE" and angle != 90:
				if allCoordinates[temp[0],0] == allCoordinates[temp[1],0]:
					temp = np.array([0,0])

	Connectivity = np.reshape(Connectivity,(-1,2)) 
	Connectivity = np.sort(Connectivity)
	
	df = pd.DataFrame(Connectivity) 
	Connectivity = df.drop_duplicates()
	Connectivity = df.drop_duplicates().values
	
	np.savetxt('Connectivity.txt', Connectivity, delimiter=',')

	if plot == 0:
		for ii in range (0,int(Connectivity.shape[0])):
			plt.plot([allCoordinates[Connectivity[ii,0],0],\
				allCoordinates[Connectivity[ii,1],0]],\
				[allCoordinates[Connectivity[ii,0],1],\
				allCoordinates[Connectivity[ii,1],1]],'k',lw = 2)
			plt.axis('equal')
		plt.draw()
	Connectivity = Connectivity[~(Connectivity == 0).all(1)]
	return Connectivity