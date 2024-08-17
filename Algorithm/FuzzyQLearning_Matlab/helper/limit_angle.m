function theta = limit_angle(theta)
%Limit the value of angle in the range [-pi;pi]
if theta > pi
    theta = theta - 2*pi;
elseif theta < -pi
    theta = theta + 2*pi;
end