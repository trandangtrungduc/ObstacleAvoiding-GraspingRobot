function [theta, length] = calc_vector(startPoint, endPoint)
%Calculate the length and angle of the vector from start to end respect to x-axis
x_dis = endPoint(1) - startPoint(1);
y_dis = endPoint(2) - startPoint(2);
length = sqrt(x_dis^2 + y_dis^2);
theta = atan2(y_dis, x_dis);