import numpy as np
from helper.calc_add_limit_vector import limit_angle


def sort_range(pair):
    if pair[0] > pair[1]:
        pair = [pair[1], pair[0]]
    return pair

""" Detect dangerous obstacle which can collide with robot """
def sense_danger(senseObs, robotParams, disDanger): # 23x5 , 1x5, 0
    radRobot = robotParams[0]
    numObs = senseObs.shape[0]
    dangerObs = np.zeros((numObs, 4), dtype=np.float64) 
    countDanger = 0
    
    for i in range(0, numObs):
        disObs = senseObs[i, 0]
        radObs = senseObs[i, 2]
        dirObs = senseObs[i, 1]
        vObs = senseObs[i,3]
        disSafe = radObs + radRobot
        disObs_real = disObs - disSafe
        if  disObs_real < disDanger:
            countDanger = countDanger + 1
            try:
                beta_high = abs(np.arctan2(disSafe, np.sqrt(np.power(disObs,2) - np.power(disSafe,2))))
                beta_low = beta_high
                if vObs != 0:
                    k1 = min(1, 150.0/(50.0+disObs_real))
                    k2 = 1
                    del_angle = limit_angle(senseObs[i,4] - dirObs)              
                    if del_angle > 0:
                        beta_high = np.pi/2
                        #beta_high = min(beta_high*(k1 + k2*abs(np.cos(del_angle))), np.pi/2)
                        beta_low = min(beta_low*k1, np.pi/2)
                    elif del_angle < 0:
                        beta_high = min(beta_high*k1, np.pi/2)
                        #beta_low = np.pi/2
                        beta_low = min(beta_low*(k1 + k2*abs(np.cos(del_angle))), np.pi/2)
                    vObs = np.cos(del_angle)*vObs
            except:
                beta_high = np.pi/2
                beta_low = beta_high  
            rangeObs =  sort_range([limit_angle(dirObs+beta_high) , limit_angle(dirObs-beta_low)])
            dangerObs[countDanger-1, :] = [disObs_real, rangeObs[0], rangeObs[1], vObs]
    
    if countDanger == 0:
        dangerObs = np.array([])  # np.zeros((10,4))
    else:
        dangerObs = dangerObs[0:countDanger,:]
    return dangerObs
            