import numpy as np
from helper.calc_add_limit_vector import calc_vector, limit_angle


def sense_obs(staticObs, movingObs, robot):
    """ Calculate the distance and direction from each obstacle to the robot """
    numSObs = staticObs.shape[0]
    numMObs = movingObs.shape[0]
    senseObs = np.zeros((numSObs+numMObs, 5), dtype=np.float64)
    posRobot = robot[0:2]

    for i in range(0, numSObs):
        posObs = staticObs[i, 0:2]
        radObs = staticObs[i, 2]
        [dirObs, disObs] = list(calc_vector(posRobot, posObs))
        senseObs[i, :] = [posObs, disObs, dirObs, radObs]

    for i in range(0, numMObs):
        posObs = movingObs[i, 0:2]
        radObs = movingObs[i, 3]
        [dirObs, disObs] = calc_vector(posRobot, posObs)
        senseObs[numSObs+i, :] = [posObs, disObs, dirObs, radObs]
    # return senseObs

    """ Sort the senseObs from nearest to farest (bubble sort) """
    numObs = numSObs+numMObs
    if numObs > 1:
        for i in range(0, numObs):
            not_swapped = True
            for j in range(1, numObs-i):
                if senseObs[j-1, 2] > senseObs[j, 2]:
                    temp = senseObs[j-1, :]
                    senseObs[j-1, :] = senseObs[j, :]
                    senseObs[j, :] = temp
                    not_swapped = False
            if not_swapped:
                break
    return senseObs
