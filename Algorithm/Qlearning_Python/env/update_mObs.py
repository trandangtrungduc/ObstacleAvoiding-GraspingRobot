import numpy as np
from helper.calc_add_limit_vector import limit_angle, calc_vector


def update_mObs(movingObs, dt):
    """ Update position of moving obstacle after a interval dt """
    countObs = movingObs.shape[0]
    posObs_total = []
    for i in range(0, countObs):
        if movingObs[i, 7] == 0:  # movingObs 2x8
            posObs = movingObs[i, 0:2]
            disObs = movingObs[i, 2]
            radObs = movingObs[i, 3]
            dirObs = movingObs[i, 4]
            lenObs = movingObs[i, 5]
            vObs = movingObs[i, 6]
            disObs = disObs + vObs*dt
            posObs = posObs + vObs*dt * \
                np.array([np.cos(dirObs), np.sin(dirObs)])
            if disObs >= lenObs:
                dirObs = limit_angle(dirObs + np.pi)
                disObs = 0
            movingObs[i, :] = [posObs[0], posObs[1],
                               disObs, radObs, dirObs, lenObs, vObs, 0]
        elif movingObs[i, 7] == 1:
            posObs = movingObs[i, 0:2]
            radCir = movingObs[i, 2]
            radObs = movingObs[i, 3]
            centerCir = movingObs[i, 4:6]
            vObs = movingObs[i, 6]
            [angleObs, _] = calc_vector(centerCir, posObs)
            angleObs = angleObs - vObs*dt/radCir
            posObs = centerCir + radCir * \
                np.array([np.cos(angleObs), np.sin(angleObs)])
            movingObs[i, :] = [posObs[0], posObs[1],
                               radCir, radObs, centerCir, vObs, 1]
        else:
            posObs = movingObs[i, 0:2]
            radCir = movingObs[i, 2]
            radObs = movingObs[i, 3]
            centerCir = movingObs[i, 4:6]
            vObs = movingObs[i, 6]
            [angleObs, _] = calc_vector(centerCir, posObs)
            angleObs = angleObs + vObs*dt/radCir
            posObs = centerCir + radCir * \
                np.array([np.cos(angleObs), np.sin(angleObs)])
            movingObs[i, :] = [posObs[0], posObs[1],
                               radCir, radObs, centerCir, vObs, -1]
        posObs_total.append(posObs)

    return [movingObs, posObs_total]
