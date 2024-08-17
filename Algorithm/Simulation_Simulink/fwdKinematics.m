function position = fwdKinematics(DH_params)

%Transform matrix
T1 = transform_matrix(DH_params(1,:));    % link 0-1 
T2 = transform_matrix(DH_params(2,:));    % link 1-2
T3 = transform_matrix(DH_params(3,:));    % link 2-3
T4 = transform_matrix(DH_params(4,:));    % link 3-4

T = T1*T2*T3*T4;                          % link 0-4

position = T(1:3,4);

%--------------------------Helper function--------------------------------%
function T = transform_matrix(DH_params)
    a       = DH_params(1);
    alpha   = DH_params(2);
    d       = DH_params(3);
    theta   = DH_params(4);
    
    %Link transformation
    T(1,:) = [cos(theta), -sin(theta)*cos(alpha),  sin(theta)*sin(alpha), a*cos(theta)];
    T(2,:) = [sin(theta),  cos(theta)*cos(alpha), -cos(theta)*sin(alpha), a*sin(theta)];
    T(3,:) = [0         ,  sin(alpha)           ,  cos(alpha)           , d           ];
    T(4,:) = [0         ,  0                    ,  0                    , 1           ];
end
end    



