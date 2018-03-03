clear all; close all; clc;
commandwindow

alpha = input('Angle in radians:','s');
alpha = str2num(alpha);
% alpha = pi/2;
shape = input('Shape (Triangle/Hexagon):','s');
LX = 10; % Length along X axis
LY=5;   % Length along Y axis
NumCells = input('Number of cells along X-axis:','s');
NX = str2double(NumCells); % Number of Cells along X axis

if strcmpi(shape,'hexagon') ==1
    d = LX/(2*NX*cos(alpha)); % Length of Unit Cell
    NY = LY/(d*(2+2*sin(alpha))); % Number of Cells along Y axis
end
if strcmpi(shape,'triangle') == 1
    d = LX/NX;
    NY = LY/(d*sin(alpha));
end


NY = 2; % Gives (2n+1) nodes on Y axis
dofpernode = 2;
nx = 0:NX; % NOT THE UNIT CELLS IN X DIRECTION
ny = 0:NY; % NOT THE UNIT CELLS IN Y DIRECTION
tol = 1e-5; % Tolerance

BC = input('Are Boundary conditions Periodic (Yes/No):','s');

%%%%%%%;
% Time ;
%%%%%%%;
t_start = 0; t_end = 300; dt = 2;
if (t_end - t_start)<dt
    dt = (t_end - t_start);
end
t = t_start:dt:t_end;
t(length(t)+1) = t_end;
t_max = 60;w = 0.5;dw = 0.05;

tic
Nodes = nodes(alpha,d,nx,ny,shape,BC);
toc

tic
NODE_CONN = node_conn(alpha,d,Nodes,shape,tol);
toc

dof = [1:dofpernode:dofpernode*size(Nodes,1)-1;
    2:dofpernode:dofpernode*size(Nodes,1)];
tdof = dof(:);

%%%%%%%%%%%%%%%%%%%%
% Boundaries Nodes ;
%%%%%%%%%%%%%%%%%%%%

x_min = min(Nodes(:,1)); x_max = max(Nodes(:,1));
y_min = min(Nodes(:,2)); y_max = max(Nodes(:,2));

id_x_min = find(Nodes(:,1) == x_min); Left_nodes = sort(id_x_min,'ascend');
id_x_max = find(Nodes(:,1) == x_max); Right_nodes = sort(id_x_max,'ascend');

id_y_min = find(Nodes(:,2) == y_min); Bottom_nodes = sort(id_y_min,'ascend');
id_y_max = find(Nodes(:,2) == y_max); Top_nodes = sort(id_y_max,'ascend');

bdof_Bottom  = [dofpernode*Bottom_nodes-1, dofpernode*Bottom_nodes];
bdof_Top = [dofpernode*Top_nodes-1, dofpernode*Top_nodes];
bdof_Right = [dofpernode*Right_nodes-1, dofpernode*Right_nodes];
bdof_Left = [dofpernode*Left_nodes-1, dofpernode*Left_nodes];

%%%%%%%%%%%%%%%%%%%%%%%
% Boundary Conditions ;
%%%%%%%%%%%%%%%%%%%%%%%
% % Right Edge Fixed
bdof = bdof_Right(:);

% % Right Edge and Top and Bottom "Y" Fixed
% bdof = [bdof_Right(:); bdof_Bottom(:,2); bdof_Top(:,2)];

% % Right Edge and Top and Bottom "X" Fixed
% bdof = [bdof_Right(:); bdof_Bottom(:,1); bdof_Top(:,1)];

% % All Edge Nodes Fixed
% bdof = [bdof_Right(:); bdof_Bottom(:); bdof_Top(:)];

bdof = sort(unique(bdof,'rows'),'ascend');
fdof = setdiff(tdof,bdof);
tdof = [fdof;bdof];
sort(unique(tdof,'rows'),'descend');

%%%%%%%%%%%%%%%%%%%%%%
% Initial Conditions ;
%%%%%%%%%%%%%%%%%%%%%%
[force,dis,vel,acc] = initialconditions(Nodes);
Energy = sparse(length(t)-1,1);
dEnergy = sparse(length(t)-1,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stiffness & Mass Matrices ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
K = global_stiffness_matrix(Nodes,NODE_CONN,dofpernode,1,0); %det(K) ;
K(bdof,:) = 0;
M = sparse(eye(size(tdof,1)));
toc


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Periodic Boundary Conditons Top and Bottom ; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pbdof_Top = sort(bdof_Top(:),'ascend');
pbdof_Top = setdiff(sort(bdof_Top(:),'ascend'),bdof_Right(:)); % Making corner nodes fixed 
% pbdof_Bottom = sort(bdof_Bottom(:),'ascend');
pbdof_Bottom = setdiff(sort(bdof_Bottom(:),'ascend'),bdof_Right(:)); % Making corner nodes fixed
pbdof = [pbdof_Bottom,pbdof_Top];

%%%%%%%%%%%%%%%%%%%%%%%%
% Time Stepping Scheme ;
%%%%%%%%%%%%%%%%%%%%%%%%
% Central Difference
%    beta = 0; gamma = 1/2;
% Average Accleration
% gamma = 1/2; beta = 1/4;
gamma = 0.6; beta = 0.5*gamma;
% Linear Accleration
%   beta = 1/6; gamma = 1/2;

forceLoc = id_x_min;

tic
[D,V,A,E,dE,iForce] = newmarktimestepping(BC,dofpernode,t,dt,t_max,w,dw,...
    force,forceLoc,dis,vel,acc,Energy,dEnergy,beta,gamma,M,K,pbdof);
toc

figure
plot(t,iForce)

figure
plot(t,E)

X_dis = D(1:2:end,:);
Y_dis = D(2:2:end,:);

testidbottomnodes = find(Nodes(:,2) == min(Nodes(:,2)));
testidtopnodes = find(Nodes(:,2) == max(Nodes(:,2)));
figure
hold on

plot(t,X_dis(testidbottomnodes(1),:),'r-')
plot(t,X_dis(testidtopnodes(1),:),'bo')
% D(testidbottomnodes,:)
% D(testidtopnodes,:)

figure('units','normalized','outerposition',[0 0 1 1])
for i = 2:length(t)
    plot3(Nodes(:,1),Nodes(:,2),X_dis(:,i),'o')
    view([0,-1,0])
%     view([1,0,0])
%     view(3)
    hold on
    zlim([-1 1])
    grid on
    hold off
    pause(0.05)
    MOVIE(i) = getframe;
end

