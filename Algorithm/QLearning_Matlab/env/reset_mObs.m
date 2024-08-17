function [movingObs, hMObs] = reset_mObs(initialMovingObs, hMObs)
%Update position of moving obstacle after a interval dt
[countObs, ~] = size(initialMovingObs);
if countObs ~= 0
    delete(hMObs);
    hMObs = [];
    movingObs = initialMovingObs;
    for i=1:size(countObs, 1)
        startObs = movingObs(i,1:2);
        radObs = movingObs(i,4);
        hObs = viscircles(startObs, radObs, 'LineWidth', 1, 'Color', 'yellow');
        hMObs = [hMObs hObs];
    end
else
    movingObs = [];
    hMObs = [];
end
