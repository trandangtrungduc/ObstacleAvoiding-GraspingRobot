def reset_mObs(initialMovingObs, hMObs):
    countObs = initialMovingObs.shape[0]
    if countObs != 0:
        hMObs = []
        movingObs = initialMovingObs
        for i in range(0, countObs):
            startObs = movingObs[i, 0:2]
            # radObs = movingObs[i, 3]
            hMObs.append(startObs)
    else:
        movingObs = [];
        hMObs = [];
    return [movingObs, hMObs]