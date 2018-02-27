function [f,dis,vel,acc] = initialconditions(Nodes)

numNodes = size(Nodes,1);

f_x = zeros(numNodes,1);
f_y = zeros(numNodes,1);
F = [f_x,f_y];

acc_x(:,1) = zeros(numNodes,1);
acc_y(:,1) = zeros(numNodes,1);
acc = [acc_x,acc_y].';

dis_x(:,1) = zeros(numNodes,1);
dis_y(:,1) = zeros(numNodes,1);
dis = [dis_x,dis_y].';

vel_x(:,1) = zeros(numNodes,1);
vel_y(:,1) = zeros(numNodes,1);
vel = [vel_x,vel_y].';

f = F;
acc = acc(:);
dis = dis(:);
vel = vel(:);
