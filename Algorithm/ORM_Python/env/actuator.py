def calc(aRef, aCur, aMax, da):
    if (aRef - aCur) < -da/2:
        aNext = aCur - da      
    elif (aRef - aCur) > da/2:
        aNext = aCur + da
    else:
        aNext = aCur
    if aNext > aMax:
        aNext = aMax
    return aNext

def actuator(curParams, refParams, robotParams, dt):
    """ Calculate the next state of robot up to current and reference state """
    vMax = robotParams[1]
    wMax = robotParams[2]
    av = robotParams[3]
    aw = robotParams[4]
    vCur = curParams[0]
    wCur = curParams[1]
    vRef = refParams[0]
    wRef = refParams[1]
    dv = av*dt;
    dw = aw*dt;
    
    if vRef < 0:
        vRef = 0
    vRobot = calc(vRef, vCur, vMax, dv)
    wRobot = calc(wRef, wCur, wMax, dw)
    if vRobot < 0:
       vRobot = 0
    return [vRobot, wRobot]