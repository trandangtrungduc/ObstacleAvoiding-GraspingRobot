%% Trajectory of 4-DOF 1 robot arm to grip the ball
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

% Tracjectory for grip the ball
timespace = [0 190 0 199]';
timespace = [timespace [5 0 -150 120]'];
action = [config no_grip]';
timespace = [timespace [7 0 -150 70]'];
action = [action [task no_grip]'];
timespace = [timespace [8 0 -150 70]'];
action = [action [hold grip_in]'];
timespace = [timespace [10 0 -150 120]'];
action = [action [task grip_in]'];
timespace = [timespace [15 150 -100 40]'];
action = [action [task grip_in]'];
timespace = [timespace [16 150 -100 40]'];
action = [action [hold grip_out]'];
timespace = [timespace [20 190 0 199]'];
action = [action [task no_grip]'];

[t, force, joints] = tracjectory(timespace, action);
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