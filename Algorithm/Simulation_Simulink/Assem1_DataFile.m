% Simscape(TM) Multibody(TM) version: 7.1

% This is a model data file derived from a Simscape Multibody Import XML file using the smimport function.
% The data in this file sets the block parameter values in an imported Simscape Multibody model.
% For more information on this file, see the smimport function help page in the Simscape Multibody documentation.
% You can modify numerical values, but avoid any other changes to this file.
% Do not add code to this file. Do not edit the physical units shown in comments.

%%%VariableName:smiData


%============= RigidTransform =============%

%Initialize the RigidTransform structure array by filling in null values.
smiData.RigidTransform(13).translation = [0.0 0.0 0.0];
smiData.RigidTransform(13).angle = 0.0;
smiData.RigidTransform(13).axis = [0.0 0.0 0.0];
smiData.RigidTransform(13).ID = '';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(1).translation = [0 39 0];  % mm
smiData.RigidTransform(1).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(1).axis = [-0.57735026918962584 -0.57735026918962584 -0.57735026918962584];
smiData.RigidTransform(1).ID = 'B[Part1-1:-:Part2-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(2).translation = [0 0 0];  % mm
smiData.RigidTransform(2).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(2).axis = [-0.57735026918962584 -0.57735026918962584 -0.57735026918962584];
smiData.RigidTransform(2).ID = 'F[Part1-1:-:Part2-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(3).translation = [0 0 12.5];  % mm
smiData.RigidTransform(3).angle = 3.1415926535897931;  % rad
smiData.RigidTransform(3).axis = [-1 -0 -0];
smiData.RigidTransform(3).ID = 'B[Part3-1:-:Part2-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(4).translation = [-12.5 55 -10];  % mm
smiData.RigidTransform(4).angle = 2.0943951023931988;  % rad
smiData.RigidTransform(4).axis = [0.57735026918962629 0.57735026918962684 0.57735026918962407];
smiData.RigidTransform(4).ID = 'F[Part3-1:-:Part2-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(5).translation = [105 0 7.5];  % mm
smiData.RigidTransform(5).angle = 3.1415926535897931;  % rad
smiData.RigidTransform(5).axis = [-1 -0 -0];
smiData.RigidTransform(5).ID = 'B[Part3-1:-:Part4-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(6).translation = [100 0 7.5];  % mm
smiData.RigidTransform(6).angle = 3.1415926535897905;  % rad
smiData.RigidTransform(6).axis = [-1 0 0];
smiData.RigidTransform(6).ID = 'F[Part3-1:-:Part4-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(7).translation = [0 0 7.5];  % mm
smiData.RigidTransform(7).angle = 3.1415926535897931;  % rad
smiData.RigidTransform(7).axis = [1 0 0];
smiData.RigidTransform(7).ID = 'B[Part4-1:-:Part5-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(8).translation = [0 0 7.5];  % mm
smiData.RigidTransform(8).angle = 3.1415926535897913;  % rad
smiData.RigidTransform(8).axis = [1 0 0];
smiData.RigidTransform(8).ID = 'F[Part4-1:-:Part5-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(9).translation = [-33 0 0];  % mm
smiData.RigidTransform(9).angle = 0;  % rad
smiData.RigidTransform(9).axis = [-1 0 0];
smiData.RigidTransform(9).ID = 'B[Part5-1:-:Part6-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(10).translation = [0 0 -22.5];  % mm
smiData.RigidTransform(10).angle = 3.1415926535897922;  % rad
smiData.RigidTransform(10).axis = [0 0 -1];
smiData.RigidTransform(10).ID = 'F[Part5-1:-:Part6-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(11).translation = [-33 0 0];  % mm
smiData.RigidTransform(11).angle = 0;  % rad
smiData.RigidTransform(11).axis = [-1 0 0];
smiData.RigidTransform(11).ID = 'B[Part5-1:-:Part6-2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(12).translation = [0 0 -22.5];  % mm
smiData.RigidTransform(12).angle = 3.1415926535897931;  % rad
smiData.RigidTransform(12).axis = [0 -1 0];
smiData.RigidTransform(12).ID = 'F[Part5-1:-:Part6-2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(13).translation = [0 0 0];  % mm
smiData.RigidTransform(13).angle = -2*pi/3;  % rad
smiData.RigidTransform(13).axis = [-0.57735 0.57735 0.57735];
smiData.RigidTransform(13).ID = 'RootGround[Robot Arm 1]';

%============= Solid =============%
%Center of Mass (CoM) %Moments of Inertia (MoI) %Product of Inertia (PoI)

%Initialize the Solid structure array by filling in null values.
smiData.Solid(6).mass = 0.0;
smiData.Solid(6).CoM = [0.0 0.0 0.0];
smiData.Solid(6).MoI = [0.0 0.0 0.0];
smiData.Solid(6).PoI = [0.0 0.0 0.0];
smiData.Solid(6).color = [0.0 0.0 0.0];
smiData.Solid(6).opacity = 0.0;
smiData.Solid(6).ID = '';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(1).mass = 0.3;  % kg
smiData.Solid(1).CoM = [0 0 0];  % mm
smiData.Solid(1).MoI = [5.7419194039188941 6.3313083180481762 5.7166750843414071];  % kg*mm^2
smiData.Solid(1).PoI = [0.56749813017252593 0 0];  % kg*mm^2
smiData.Solid(1).color = [0.792156862745098 0.81960784313725488 0.93333333333333335];
smiData.Solid(1).opacity = 1;
smiData.Solid(1).ID = 'Part2*:*Default';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(2).mass = 0.2;  % kg
smiData.Solid(2).CoM = [0 0 0];  % mm
smiData.Solid(2).MoI = [1.5558606930377259 20.632842245123218 19.457766719353788];  % kg*mm^2
smiData.Solid(2).PoI = [0 0 0];  % kg*mm^2
smiData.Solid(2).color = [0.792156862745098 0.81960784313725488 0.93333333333333335];
smiData.Solid(2).opacity = 1;
smiData.Solid(2).ID = 'Part4*:*Default';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(3).mass = 0.1;  % kg
smiData.Solid(3).CoM = [0 0 0];  % mm
smiData.Solid(3).MoI = [47.16243728183526 54.119222910624124 44.505526258779419];  % kg*mm^2
smiData.Solid(3).PoI = [-2.0905702131134167 0.027722066488422382 0.022756781207777056];  % kg*mm^2
smiData.Solid(3).color = [0.792156862745098 0.81960784313725488 0.93333333333333335];
smiData.Solid(3).opacity = 1;
smiData.Solid(3).ID = 'Part1*:*Default';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(4).mass = 0.1;  % kg
smiData.Solid(4).CoM = [0 0 0];  % mm
smiData.Solid(4).MoI = [0.74155381518946617 25.90197795367143 25.833667068707722];  % kg*mm^2
smiData.Solid(4).PoI = [0 0 0];  % kg*mm^2
smiData.Solid(4).color = [0.792156862745098 0.81960784313725488 0.93333333333333335];
smiData.Solid(4).opacity = 1;
smiData.Solid(4).ID = 'Part3*:*Default';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(5).mass = 0.1;  % kg
smiData.Solid(5).CoM = [0 0 0];  % mm
smiData.Solid(5).MoI = [0.0090150300524244678 0.38545795838630537 0.38787337270690697];  % kg*mm^2
smiData.Solid(5).PoI = [0 0.00047487228604065968 0];  % kg*mm^2
smiData.Solid(5).color = [0.792156862745098 0.81960784313725488 0.93333333333333335];
smiData.Solid(5).opacity = 1;
smiData.Solid(5).ID = 'Part6*:*Default';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(6).mass = 0.1;  % kg
smiData.Solid(6).CoM = [0 0 0];  % mm
smiData.Solid(6).MoI = [1.6555250577290297 2.9236373250150045 1.8139500859520765];  % kg*mm^2
smiData.Solid(6).PoI = [0 0 0];  % kg*mm^2
smiData.Solid(6).color = [0.792156862745098 0.81960784313725488 0.93333333333333335];
smiData.Solid(6).opacity = 1;
smiData.Solid(6).ID = 'Part5*:*Default';


%============= Joint =============%
%X Revolute Primitive (Rx) %Y Revolute Primitive (Ry) %Z Revolute Primitive (Rz)
%X Prismatic Primitive (Px) %Y Prismatic Primitive (Py) %Z Prismatic Primitive (Pz) %Spherical Primitive (S)
%Constant Velocity Primitive (CV) %Lead Screw Primitive (LS)
%Position Target (Pos)

%Initialize the PrismaticJoint structure array by filling in null values.
smiData.PrismaticJoint(2).Pz.Pos = 0.0;
smiData.PrismaticJoint(2).ID = '';

smiData.PrismaticJoint(1).Pz.Pos = 0;  % m
smiData.PrismaticJoint(1).ID = '[Part5-1:-:Part6-1]';

smiData.PrismaticJoint(2).Pz.Pos = 0;  % m
smiData.PrismaticJoint(2).ID = '[Part5-1:-:Part6-2]';


%Initialize the RevoluteJoint structure array by filling in null values.
smiData.RevoluteJoint(4).Rz.Pos = 0.0;
smiData.RevoluteJoint(4).ID = '';

smiData.RevoluteJoint(1).Rz.Pos = 0;  % deg
smiData.RevoluteJoint(1).ID = '[Part1-1:-:Part2-1]';

smiData.RevoluteJoint(2).Rz.Pos = 0;  % deg
smiData.RevoluteJoint(2).ID = '[Part3-1:-:Part2-1]';

smiData.RevoluteJoint(3).Rz.Pos = 90;  % deg
smiData.RevoluteJoint(3).ID = '[Part3-1:-:Part4-1]';

smiData.RevoluteJoint(4).Rz.Pos = 0;  % deg
smiData.RevoluteJoint(4).ID = '[Part4-1:-:Part5-1]';

%% New parameters
%============= Environment Parameters =============%
addpath(genpath('Libraries'));
floor_dimensions = [400,600,10];
sub1Data.RigidTransform(1).translation = [0 100 -5];
sub1Data.RigidTransform(1).ID = 'World-Floor';

base_dimensions = [100,50,50];
sub1Data.RigidTransform(2).translation = [0 -130 25];
sub1Data.RigidTransform(2).ID = 'Floor-Base';

sub1Data.RigidTransform(3).translation = [30 0 0];
sub1Data.RigidTransform(3).ID = 'Gripper';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(14).translation = [0 200 0];  % mm
smiData.RigidTransform(14).angle = -2*pi/3;  % rad
smiData.RigidTransform(14).axis = [-0.57735 0.57735 0.57735];
smiData.RigidTransform(14).ID = 'RootGround[Rbot Arm 2]';
%% Mechanical parameters
% Joint parameters
joint_damping = 0.2;    % Revolute joint damping
grip_stiffness = 50;     % Gripper stiffness
grip_damping = 20;       % Gripper damping

%Ball parameters
ball_mass = 0.01;       % kg
ball_radius = 20;       % in mm
initPosX = 0;           % in mm
initVelX = 0;
initPosY = -150;        % in mm
initVelY = 0;
initPosZ = 90;          % in mm
initVelZ = 0;
ball_damping  = 0.005;   % Damping for vertical translation of ball
ball_rot_damping = 0.01; % Damping for rotation of ball

%Object1 paramater
object1_mass = 0.01; 
initPosX1 = 150;            % in mm
initVelX1 = 0;
initPosY1 = -50;            % in mm
initVelY1 = 0;
initPosZ1 = 0;          	% in mm
initVelZ1 = 0;
object1_xy_damping = 0;     % Damping for xy translation
object1_z_damping  = 0.05;   % Damping for translation of object1
object1_rot_damping = 10;  % Damping for rotation of object1

%Object2 paramater
object2_mass = 0.01; 
initPosX2 = 100;            % in mm
initVelX2 = 0;
initPosY2 = 300;            % in mm
initVelY2 = 0;
initPosZ2 = 0;              % in mm
initVelZ2 = 0;
object2_xy_damping = 0;     % Damping for xy translation
object2_z_damping  = 0.05;   % Damping for vertical translation of object2
object2_rot_damping = 10;  % Damping for rotation of object2

%Base contact parameters
contact_base.planeLength.x = 100;       %in mm
contact_base.planeLength.y = 0.05;      %in m    
contact_base.planeDepth = 0.05;         %in m
contact_base.stiffness = 1000;
contact_base.damping = 100;
contact_base.kFrictionCoeff = 0.0250;   %kinetic friction
contact_base.sFrictionCoeff = 0.1;      %static friction
contact_base.dampingCoeff = 1.000e-04;  %damping for linear motion
contact_base.dampingCoeffR = 5.000e-06; %damping for rotational motion

%Gripper contact parameters
contact_gripper.planeLength.x = 80;     %in mm  
contact_gripper.planeLength.y = 30;     %in mm
contact_gripper.planeDepth = 2;         %in mm
contact_gripper.stiffness = 1000;
contact_gripper.damping = 100;
contact_gripper.kFrictionCoeff = 0.8;   %kinetic friction
contact_gripper.sFrictionCoeff = 0.9;   %static friction