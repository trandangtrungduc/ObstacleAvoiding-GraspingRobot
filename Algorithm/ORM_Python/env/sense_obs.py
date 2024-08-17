import numpy as np
from helper.calc_add_limit_vector import calc_vector, limit_angle

def sense_obs(staticObs, movingObs, robot, radSafe):
    """ Calculate the distance and direction from each obstacle to the robot """
    numSObs = staticObs.shape[0]  # 12
    numMObs = movingObs.shape[0]  # 2
    senseObs = np.zeros((numSObs+numMObs, 5),dtype=np.float64)
    posRobot = robot[0:2]
    
    for i in range(0,numSObs):
        posObs = staticObs[i,0:2]
        radObs = staticObs[i,2] + radSafe
        [dirObs, disObs] = list(calc_vector(posRobot, posObs))  
        senseObs[i,:] = [disObs, dirObs, radObs, 0, 0]
        
    for i in range(0,numMObs):
        posObs = movingObs[i,0:2]
        radObs = movingObs[i,3] + radSafe
        vObs = movingObs[i,6]
        [dirObs, disObs] = calc_vector(posRobot, posObs)
        if movingObs[i,7] == -1:
            [dirMove,_] = calc_vector(movingObs[i,4:6], posObs)
            dirMove = limit_angle(dirMove + np.pi/2)
        elif movingObs[i,7] == 0: 
            dirMove = movingObs[i,5]
        elif movingObs[i,7] == 1: 
            [dirMove,_] = calc_vector(movingObs[i,4:6], posObs)
            dirMove = limit_angle(dirMove - np.pi/2)
        senseObs[numSObs+i,:] = [disObs, dirObs, radObs, vObs, dirMove]
    return senseObs

    """ Sort the senseObs from nearest to farest (bubble sort) """
    numObs = numSObs+numMObs
    if numObs > 1:
        for i in range(0,numObs):
            not_swapped = True
            for j in range(1,numObs-i):
                if senseObs[j-1,0] > senseObs[j,0]:
                    temp = senseObs[j-1,:]
                    senseObs[j-1,:] = senseObs[j,:]
                    senseObs[j,:] = temp
                    not_swapped = False
            if not_swapped:
                break
    return senseObs  # 23x5