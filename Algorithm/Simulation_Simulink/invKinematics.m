function joints = invKinematics(position)

%Position in world frame
x = position(1);
y = position(2);
z = position(3);
%We want the direction of gripper parallel to the ground
theta = 0;      

%Robot parameters
l1 = 94; e = 10;
l2 = 105;
l3 = 100;
l4 = 80;

%Joint angle 1
theta1 = atan2(y, x);

%Joint angle 3
A = x - l4*cos(theta1)*cos(theta) - e*cos(theta1);
B = y - l4*sin(theta1)*cos(theta) - e*sin(theta1);
C = z - l1 - l4*sin(theta);

%Value of theta3 is in [0; pi] when using acos
theta3 = -acos((A^2 + B^2 + C^2 - l2^2 -l3^2)/(2*l2*l3));

%Joint angle 2
a = l3*sin(theta3);
b = l3*cos(theta3) + l2;
r = sqrt(a^2 + b^2);
theta2 = atan2(C, sqrt(r^2-C^2)) - atan2(a, b); 

%Joint angle 4
theta4 = theta - theta2 - theta3;

joints = [theta1, theta2, theta3, theta4];
