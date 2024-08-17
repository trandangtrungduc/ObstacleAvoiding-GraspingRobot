function [theta, length] = add_vector(vector1, vector2)

pos1 = vector1(2)*[cos(vector1(1)), sin(vector1(1))];
pos2 = vector2(2)*[cos(vector2(1)), sin(vector2(1))];
[theta, length] = calc_vector([0 0], pos1+pos2);