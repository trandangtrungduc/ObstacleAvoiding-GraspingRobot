%% Inverse kinematics of 4-DOF robot arm
clear, clc

N = 10001;
t = linspace(0,5,N);

%Safe range of position (note: x,y,z maybe not able to reach its threshold
%x: [-250; 250]
%y: [-250; 250]
%z: [  24; 250]

% %Example to test inv formula
% theta1_0 =     0;   theta1_f = -pi/2;
% theta2_0 =  pi/2;   theta2_f = pi/3;
% theta3_0 = -pi/2;   theta3_f = -pi/2;
% theta4_0 =     0;   theta4_f = -theta2_f-theta3_f;
% x0 = 210;   xf = 0;         
% y0 =   0;   yf = -249.1025; 
% z0 = 199;   zf = 134.9327;

x0 = 210;   xf = 100;         
y0 =   0;   yf = -200; 
z0 = 199;   zf = 120;

%Calculate inverse kinematics results
joints_0 = invKinematics([x0, y0, z0]);
joints_f = invKinematics([xf, yf, zf]);
theta1_0 = joints_0(1);   theta1_f = joints_f(1);
theta2_0 = joints_0(2);   theta2_f = joints_f(2);
theta3_0 = joints_0(3);   theta3_f = joints_f(3);
theta4_0 = joints_0(4);   theta4_f = joints_f(4);

%Output that we give to the robot
theta1 = linspace(theta1_0, theta1_f, N); 
theta2 = linspace(theta2_0, theta2_f, N); 
theta3 = linspace(theta3_0, theta3_f, N); 
theta4 = linspace(theta4_0, theta4_f, N);

%Input for simulink model (the coordinate frame in simulink not match with
%our frame so I make some modification to pass this difficulty)
theta1_in = [t' (linspace(theta1_0, theta1_f, N)/pi*180)'];
theta2_in = [t' ((pi/2-linspace(theta2_0, theta2_f, N))/pi*180)'];
theta3_in = [t' ((pi+linspace(theta3_0, theta3_f,N))/pi*180)'];
theta4_in = [t' ((linspace(theta4_0, theta4_f, N))/pi*180)'];
