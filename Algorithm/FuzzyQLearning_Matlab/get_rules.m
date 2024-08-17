function activate = get_rules(heading_angle, obs_data)

% Degree of fuzzy set of heading_angle
% NB - Negative big, NS - Negative small, Z - Zero, PS - Positive small, PB
% - Positve big

NB = tri_mf(-90, -45, 0, heading_angle, 'start');
NS  = tri_mf(-90, -45, 0, heading_angle, 'tria'); 
Z  = tri_mf(-45, 0, 45, heading_angle, 'tria');    
PS = tri_mf(0, 45, 90, heading_angle, 'tria'); 
PB = tri_mf(45, 90, 0, heading_angle, 'end'); 

% Degree of fuzzy set of obs_data
% NB - Negative big, NS - Negative small, Z - Zero, PS - Positive small, PB
% - Positve big
LB = tri_mf(-165, -120, -75, obs_data, 'tria');
LS = tri_mf(-105, -60, -15, obs_data, 'tria');
ZR = tri_mf(-45, 0, 45, obs_data, 'tria');
RS = tri_mf(15, 60, 105, obs_data, 'tria');
RB = tri_mf(75, 120, 165, obs_data, 'tria');

% LB = obs_data(1);
% LS = obs_data(2);
% ZR = obs_data(3);
% RS = obs_data(4);
% RB = obs_data(5);
    
% Activation degree
activate = zeros(25,1);
activate(1)=min([NB LB]);
activate(2)=min([NB LS]);
activate(3)=min([NB ZR]);
activate(4)=min([NB RS]);
activate(5)=min([NB RB]);

activate(6)=min([NS LB]);
activate(7)=min([NS LS]);
activate(8)=min([NS ZR]);
activate(9)=min([NS RS]);
activate(10)=min([NS RB]);

activate(11)=min([Z LB]);
activate(12)=min([Z LS]);
activate(13)=min([Z ZR]);
activate(14)=min([Z RS]);
activate(15)=min([Z RB]);

activate(16)=min([PS LB]);
activate(17)=min([PS LS]);
activate(18)=min([PS ZR]);
activate(19)=min([PS RS]);
activate(20)=min([PS RB]);

activate(21)=min([PB LB]);
activate(22)=min([PB LS]);
activate(23)=min([PB ZR]);
activate(24)=min([PB RS]);
activate(25)=min([PB RB]);

end