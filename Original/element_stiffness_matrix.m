function [K_Element] = element_stiffness_matrix(node_xy,kn,ks)
%
%
% Written By: Raj Gopal
% Updated on: 4/29/2017
%%%

ele_b = node_xy(1,:);
ele_e = node_xy(2,:);

x1 = ele_b(1); y1 = ele_b(2);
x2 = ele_e(1); y2 = ele_e(2);

theta = atan2((y2-y1),(x2-x1))*180/pi;

c = cosd(theta);
s = sind(theta);

%%%%%%%%%%%%%%%%%%
% NORMAL SPRINGS %
%%%%%%%%%%%%%%%%%%

k_normal = [ c^2, c*s, -c^2, -c*s;
             c*s, s^2, -c*s, -s^2;
            -c^2, -c*s, c^2, c*s;
            -c*s, -s^2, c*s, s^2 ] * kn;

%%%%%%%%%%%%%%%%%
% SHEAR SPRINGS %
%%%%%%%%%%%%%%%%%
k_shear = [ s^2, -c*s, -s^2, c*s;
           -c*s, c^2, c*s, -c^2;
           -s^2, c*s, s^2, -c*s;
            c*s, -c^2, -c*s, c^2 ] * ks;

K_Element = k_normal + k_shear;
    
      
    
    