%% Foward kinematics of 4-DOF robot arm
clear, clc
% %DH parameters (general)
% syms theta1 theta2 theta3 theta4;
% syms e l1 l2 l3 l4;
N = 10001;
t = linspace(0,5,N);

%DH parmeters (particular)
e = 10; l1 = 94; 
l2 = 105; 
l3 = 100; 
l4 = 80;

%Safe range of joint angles
%theta1: [-4pi/9,  4pi/9]
%theta2: [  pi/6,  5pi/6]
%theta3: [ -pi/4, -3pi/4]
%theta4: [     0,  4pi/9]

theta1_0 =     0;   theta1_f = -pi/2;
theta2_0 =  pi/2;   theta2_f = pi/3;
theta3_0 = -pi/2;   theta3_f = -pi/2;
theta4_0 =     0;   theta4_f = -theta2_f-theta3_f;

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

a1 = e; d1 = l1; alpha1 = pi/2;        % link 0-1
a2 = l2; d2 = 0; alpha2 = 0;           % link 1-2
a3 = l3; d3 = 0; alpha3 = 0;           % link 2-3
a4 = l4; d4 = 0; alpha4 = 0;           % link 3-4

position = zeros(N, 3);
for i=1:N
    joints = [theta1(i), theta2(i), theta3(i), theta4(i)];
    %DH table
    DH_params(1,:) = [a1 alpha1 d1 joints(1)]; % row 1
    DH_params(2,:) = [a2 alpha2 d2 joints(2)]; % row 2
    DH_params(3,:) = [a3 alpha3 d3 joints(3)]; % row 3
    DH_params(4,:) = [a4 alpha4 d4 joints(4)]; % row 4
    position(i,:) = fwdKinematics(DH_params);
end
%Position solution (estimated)
theta = theta2 + theta3 + theta4;
x = cos(theta1).*(l3*cos(theta2+theta3)+l2*cos(theta2)+l4*cos(theta) + e);
y = sin(theta1).*(l3*cos(theta2+theta3)+l2*cos(theta2)+l4*cos(theta) + e);
z = l1 + l3*sin(theta2+theta3) + l2*sin(theta2) + l4*sin(theta);

% %Test handed-calculate results and MATLAB computation
% simplify(position(1)-x)
% simplify(position(2)-y)
% simplify(position(3)-z)
% %Passed
