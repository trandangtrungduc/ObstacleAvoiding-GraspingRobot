import math

from matplotlib.pyplot import switch_backend
from helper.calc_vector_limit_angle import limit_angle

def get_env_state(robot, nearestObs):
    # % get_env_state - function to get the state between robot and the obstacle
    # addpath('helper');

    # % Variables
    dirRobot = robot(3)
    dirObs = nearestObs(4)
    wRegion = math.pi/4

    # % Identify which state of the robot depend on difference of directions
    theta = limit_angle(dirObs-dirRobot)
    region = math.floor(theta / wRegion)
    switcher= {
        0: 1,
        1: 2,
        2: 3,
        3: 4,
        4: 5,
        -4: 5,
        -3: 6,
        -2: 7,
        -1: 8
    }
    state = switcher.get(region, "nothing")
    # switch region
    #     case 0
    #         state = 1;  #%Range: [0 45) (deg)
    #     case 1
    #         state = 2;  #%Range: [45 90) (deg)
    #     case 2 
    #         state = 3;  #%Range: [90 135) (deg)
    #     case 3
    #         state = 4;  #%Range: [135 180) (deg)
    #     case 4
    #         state = 5;  #%Range: [-180 -135) (deg)
    #     case -4
    #         state = 5;  #%Range: [-180 -135) (deg)
    #     case -3
    #         state = 6;  #%Range: [-135 -90) (deg)
    #     case -2
    #         state = 7;  #%Range: [-90 -45) (deg)
    #     case -1
    #         state = 8; # %Range: [-45 0) (deg)
    # end
    return state
