import numpy as np
from env.actuator import actuator


def update_robot(robot, robotParams, refParams, dt):  # robot,robotParams should be a vector
    """ Update state of the robot after the time dt """
    posRobot = robot[0:2]
    dirRobot = robot[2]
    vRobot = robot[3]
    wRobot = robot[4]
    radRobot = robotParams[0]

    [vRobot, wRobot] = actuator([vRobot, wRobot], refParams, robotParams, dt)
    posRobot = posRobot + vRobot*dt * \
        np.array([np.cos(dirRobot), np.sin(dirRobot)])
    dirRobot = dirRobot + wRobot*dt
    """ Keep the dirRobot always in the range [-pi;pi] """
    if dirRobot > np.pi:
        dirRobot = dirRobot - 2*np.pi
    elif dirRobot < -np.pi:
        dirRobot = dirRobot + 2*np.pi
    robot = np.array([posRobot[0], posRobot[1], dirRobot, vRobot, wRobot])
    return [robot, posRobot, radRobot, dirRobot]
