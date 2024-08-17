%% Trajectory of 4-DOF 2 robot arm assemble 2 object
clear, clc

% Global parametes
global dt F
dt = 0.005;         % second
F = 1;              % N (force of gripper)

% Define enum value for move action
config = -1;
hold   =  0;
task   =  1;

% Define enum value for grip action
grip_out = -1;
no_grip  =  0;
grip_in  =  1;

%% Trajectory of robot arm 1;
timespace1 = [0 190 0 199]';
timespace1 = [timespace1 [5 150 -50 50]'];
action1 = [config no_grip]';
timespace1 = [timespace1 [7 150 -50 10]'];
action1 = [action1 [task no_grip]'];
timespace1 = [timespace1 [8 150 -50 10]'];
action1 = [action1 [hold grip_in]'];
timespace1 = [timespace1 [10 150 -50 120]'];
action1 = [action1 [task grip_in]'];
timespace1 = [timespace1 [15 0 100 120]'];
action1 = [action1 [task grip_in]'];
timespace1 = [timespace1 [18 0 100 120]'];
action1 = [action1 [hold grip_in]'];
timespace1 = [timespace1 [25 0 -150 90]'];
action1 = [action1 [config grip_in]'];
timespace1 = [timespace1 [26 0 -150 60]'];
action1 = [action1 [task grip_in]'];
timespace1 = [timespace1 [27 0 -150 60]'];
action1 = [action1 [hold grip_out]'];
timespace1 = [timespace1 [28 0 -150 199]'];
action1 = [action1 [task no_grip]'];
timespace1 = [timespace1 [30 190 0 199]'];
action1 = [action1 [config no_grip]'];

[t, force, joints] = tracjectory(timespace1, action1);
theta1 = joints(1,:);
theta2 = joints(2,:);
theta3 = joints(3,:);
theta4 = joints(4,:);

%Input for simulink model (the coordinate frame in simulink not match with
%our frame so I make some modification to pass this difficulty)
theta1_in = [t' (theta1)'];
theta2_in = [t' ((pi/2-theta2))'];
theta3_in = [t' ((pi+theta3))'];
theta4_in = [t' (theta4)'];
force1_input = [t' force(1,:)'];
force2_input = [t' force(2,:)'];

%% Trajectory of robot arm 2;
timespace2 = [0 190 0 199]';
timespace2 = [timespace2 [5 117 117 70]'];
action2 = [config no_grip]';
timespace2 = [timespace2 [7 117 117 25]'];
action2 = [action2 [task no_grip]'];
timespace2 = [timespace2 [8 117 117 25]'];
action2 = [action2 [hold grip_in]'];
timespace2 = [timespace2 [10 117 117 200]'];
action2 = [action2 [task grip_in]'];
timespace2 = [timespace2 [15 0 -100 200]'];
action2 = [action2 [config grip_in]'];
timespace2 = [timespace2 [16 0 -100 150]'];
action2 = [action2 [task grip_in]'];
timespace2 = [timespace2 [17 0 -100 150]'];
action2 = [action2 [hold grip_out]'];
timespace2 = [timespace2 [18 0 -100 250]'];
action2 = [action2 [task no_grip]'];
timespace2 = [timespace2 [25 190 0 199]'];
action2 = [action2 [task no_grip]'];
timespace2 = [timespace2 [30 190 0 199]'];
action2 = [action2 [hold no_grip]'];


[t, force, joints] = tracjectory(timespace2, action2);
theta5 = joints(1,:);
theta6 = joints(2,:);
theta7 = joints(3,:);
theta8 = joints(4,:);

%Input for simulink model (the coordinate frame in simulink not match with
%our frame so I make some modification to pass this difficulty)
theta5_in = [t' (theta5)'];
theta6_in = [t' ((pi/2-theta6))'];
theta7_in = [t' ((pi+theta7))'];
theta8_in = [t' (theta8)'];
force3_input = [t' force(1,:)'];
force4_input = [t' force(2,:)'];
%% Helper function
%-------------------------------------------------------------------------%
function [t, force, joints] = tracjectory(timespace, action)
    global dt
    t_range = timespace(1,:);
    x_range = timespace(2,:);
    y_range = timespace(3,:);
    z_range = timespace(4,:);
    t = t_range(1):dt:t_range(end);
    joints = zeros(4,length(t));
    force = zeros(2,length(t));
    N1 = 1;
    for i=1:(length(t_range)-1)
        t0 = t_range(i);    tf = t_range(i+1);
        N2 = N1 + (tf-t0)/dt;
        x0 = x_range(i);    xf = x_range(i+1);
        y0 = y_range(i);    yf = y_range(i+1);
        z0 = z_range(i);    zf = z_range(i+1);
        action_move = action(1,i);
        action_grip = action(2,i);
        joints(:,N1:N2) = arm_action([t0 tf], [x0 xf], [y0 yf], [z0 zf], action_move);
        force(:,N1:N2)    = gripper_action([t0 tf], action_grip);
        N1 = N2;
    end
end
        
function joints = hold_space(t_range, x_range, y_range, z_range)
    global dt
    N = (t_range(2)-t_range(1))/dt + 1;
    joints_0 = invKinematics([x_range(1), y_range(1), z_range(1)]);
    joints = zeros(4, N);
    for i =1:4
        joints(i,:) = joints_0(i)*ones(1,N);
    end
end

function joints = config_space(t_range, x_range, y_range, z_range)
    global dt
    N = (t_range(2)-t_range(1))/dt + 1;
    joints = zeros(4, N);
    joints_0 = invKinematics([x_range(1), y_range(1), z_range(1)]);
    joints_f = invKinematics([x_range(2), y_range(2), z_range(2)]);
    for i =1:4
        joints(i,:) = linspace(joints_0(i), joints_f(i), N);
    end
end

function joints = task_space(t_range, x_range, y_range, z_range)
    global dt
    N = (t_range(2)-t_range(1))/dt + 1;
    x = linspace(x_range(1), x_range(2), N);
    y = linspace(y_range(1), y_range(2), N);
    z = linspace(z_range(1), z_range(2), N);
    joints = zeros(4, N);
    for i = 1:N
        joints_i = invKinematics([x(i), y(i), z(i)]);
        for j = 1:4
            joints(j,i) = joints_i(j);
        end
    end
end

function joints = arm_action(t_range, x_range, y_range, z_range, action)
    switch action
        case -1
            joints = config_space(t_range, x_range, y_range, z_range);
        case 0
            joints = hold_space(t_range, x_range, y_range, z_range);
        case 1
            joints = task_space(t_range, x_range, y_range, z_range);
    end
end

function force = gripper_action(t_range, action)
    global F dt
    N = (t_range(2)-t_range(1))/dt + 1;
    switch action
        case -1
            % Grip out
            N1 = 10;
            force(1,:) = zeros(1,N);
            force(2,:) = zeros(1,N);
            force(1,1:N1) = -F*ones(1,N1);
            force(2,1:N1) =  F*ones(1,N1);
        case 0
            % No grip
            force(1,:) = zeros(1,N);
            force(2,:) = zeros(1,N);
        case 1
            % Grip in
            force(1,:) =   F*ones(1,N);
            force(2,:) =  -F*ones(1,N);
    end        
end
%-------------------------------------------------------------------------%