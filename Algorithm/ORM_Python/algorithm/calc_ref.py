import numpy as np
from env.sense_goal import sense_goal
from helper.calc_add_limit_vector import calc_vector, limit_angle

def intersect(range1, range2):
    a = max(range1[0], range2[0])
    b = min(range1[1], range2[1])
    if a > b:
        _range = []
    else:
        _range = [a, b]
    return np.array(_range)

""" Add a new accepted range of direction into current list of available  range """
def update_rangeRobot(rangeRobot, rangeObs): # range robot is a matrix 2x2, range Obs is a vector
    new_numRange = 0
    numRange = rangeRobot.shape[0]
    new_rangeRobot = np.zeros([numRange+1, 2])
    if rangeObs[1] - rangeObs[0] <= np.pi:
        _range = np.zeros((2,2),dtype=np.float64)
        _range[0,:] = np.array([-np.pi, rangeObs[0]])
        _range[1,:] = np.array([rangeObs[1], np.pi])
        for j in range(0,numRange):
            new_range1 = intersect(_range[0,:], rangeRobot[j,:]) 
            new_range2 = intersect(_range[1,:], rangeRobot[j,:])
            if new_range1.size != 0:
                new_numRange= new_numRange + 1
                new_rangeRobot[new_numRange-1, :] = new_range1
            if new_range2.size != 0:
                new_numRange= new_numRange + 1
                new_rangeRobot[new_numRange-1, :] = new_range2
    else:
        _range = rangeObs
        for j in range(0,numRange):
            new_range = intersect(_range, rangeRobot[j,:])
            if new_range.size != 0:
                new_numRange = new_numRange + 1
                new_rangeRobot[new_numRange-1, :] = new_range
    if new_numRange == 0:
        new_rangeRobot = np.array([])  # np.zeros([1, 2])
    else:
        new_rangeRobot = new_rangeRobot[0:new_numRange,:]
    return new_rangeRobot

""" Calculate dirRef of robot depend on rangeRobot, dirGoal and closestObs """
def calc_dirRef(rangeRobot, closestObs, dirGoal):
    maxDis = 300
    minDis = 100
    k = np.pi/180.0
    dirRef = 0
    if rangeRobot.size == 0:
        if abs(closestObs[1] - dirGoal) > abs(closestObs[2] - dirGoal):
            dirRef = closestObs[2]-k*maxDis/(minDis+closestObs[0])
        else:
            dirRef = closestObs[1]+k*maxDis/(minDis+closestObs[0])
    else:
        numRange = rangeRobot.shape[0]
        if dirGoal < rangeRobot[0,0]:
            dirRef = rangeRobot[0,0] + k*maxDis/(minDis+closestObs[0])
        elif dirGoal > rangeRobot[numRange-1,1]:
            dirRef = rangeRobot[numRange-1,1]-k*maxDis/(minDis+closestObs[0])
        else:
            for j in range(0,numRange):
                if (dirGoal >= rangeRobot[j,0]) and (dirGoal <= rangeRobot[j,1]):
                    dirRef = dirGoal
                    break
                elif (j+1<=numRange-1) and (dirGoal < rangeRobot[j+1,0]):
                    if (dirGoal - rangeRobot[j,1]) > (rangeRobot[j+1,0] - dirGoal):
                        dirRef = rangeRobot[j+1,0] + min(k*maxDis/(minDis+closestObs[0]), (rangeRobot[j+1,1] - rangeRobot[j+1,0])/2.0)
                    else:
                        dirRef = rangeRobot[j,1] - min(k*maxDis/(minDis+closestObs[0]), (rangeRobot[j,1] - rangeRobot[j,0])/2.0)
    return dirRef


def calc_ref(robot, dangerObs, goal):
    """ Calculate the reference velocity and angular speed depend on goal and danger obstacles """
    numObs = dangerObs.shape[0]
    k1 = 1.6
    k2 = 20 # 15
    k3 = 0.4
    k4 = 6
    kv = 26 # 20
    
    dirRobot = robot[2]
    eGoal = sense_goal(robot, goal)
    [dirGoal, disGoal] = calc_vector(robot[0:2], goal)
    rangeRobot = np.zeros((1,2), dtype=np.float64)
    rangeRobot[0,:] = [-np.pi, np.pi]
    vObsMin = 300
    dirRef = dirGoal
    """ When no obstacle is detected in the danger zone (Lyapunov controller) """
    vRef = k1*eGoal[0]
    wRef = k2*np.sin(eGoal[2])    
    if numObs != 0 and disGoal > 300:
        """ There are obstacles in danger zone """
        nearestObs = dangerObs[0,:]
        for i in range(0,numObs):
           disObs = dangerObs[i,0]
           rangeObs = dangerObs[i,1:3]
           if disObs < 300:
               rangeRobot = update_rangeRobot(rangeRobot, rangeObs)
           if rangeRobot.size == 0:
               break
        dirRef = calc_dirRef(rangeRobot, nearestObs, dirGoal)
        """ vRef proportional to distance of closest obstacle """ 
        del_theta = abs(limit_angle(nearestObs[2]-dirRobot))
        if  del_theta < np.pi/2:
            vObsMin = min((vObsMin)*np.sin(del_theta)*kv, vObsMin)
        vRef = min(vRef, max(0, vObsMin + k3*nearestObs[0]))
        wRef = k4*np.sin(dirRef - dirRobot)
    refParams = [vRef, wRef]
    return [refParams, rangeRobot, dirRef]