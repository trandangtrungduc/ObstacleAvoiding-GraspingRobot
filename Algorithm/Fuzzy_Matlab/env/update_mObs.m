function [movingObs, hMObs] = update_mObs(movingObs, hMObs, dt)
%Update position of moving obstacle after a interval dt
[countObs, ~] = size(movingObs);
delete(hMObs);
hMObs = [];

for i=1:countObs
    if movingObs(i,8) == 0
        posObs = movingObs(i, 1:2);
        disObs = movingObs(i, 3);
        radObs = movingObs(i, 4);
        dirObs = movingObs(i, 5);
        lenObs = movingObs(i, 6);
        vObs   = movingObs(i, 7);
        disObs = disObs + vObs*dt;
        posObs = posObs + vObs*dt*[cos(dirObs) sin(dirObs)];
        if disObs >= lenObs
            dirObs = limit_angle(dirObs + pi);
            disObs = 0;
        end
        movingObs(i, :) = [posObs, disObs, radObs, dirObs, lenObs, vObs, 0];
    elseif movingObs(i,8) == 1
        posObs = movingObs(i, 1:2);
        radCir = movingObs(i, 3);
        radObs = movingObs(i, 4);
        centerCir = movingObs(i,5:6);
        vObs = movingObs(i,7);
        [angleObs, ~] = calc_vector(centerCir, posObs);
        angleObs = angleObs - vObs*dt/radCir;
        posObs = centerCir + radCir*[cos(angleObs) sin(angleObs)];
        movingObs(i, :) = [posObs, radCir, radObs, centerCir, vObs, 1];
    else
        posObs = movingObs(i, 1:2);
        radCir = movingObs(i, 3);
        radObs = movingObs(i, 4);
        centerCir = movingObs(i,5:6);
        vObs = movingObs(i,7);
        [angleObs, ~] = calc_vector(centerCir, posObs);
        angleObs = angleObs + vObs*dt/radCir;
        posObs = centerCir + radCir*[cos(angleObs) sin(angleObs)];
        movingObs(i, :) = [posObs, radCir, radObs, centerCir, vObs, -1];
    end
    hObs = viscircles(posObs, radObs, 'LineWidth', 1, 'Color', 'blue');
    hMObs = [hMObs, hObs];        
end

    
