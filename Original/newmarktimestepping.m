function [D,V,A,E,dE,iForce] = newmarktimestepping(BC,dofpernode,t,dt,t_max,w,dw,...
    force,forceLoc,dis,vel,acc,Energy,dEnergy,beta,gamma,M,K,pbdof)
% %
% %
% % Written By: Raj Gopal
% % Updated on: 9/6/2017
% %%%

AM = M + ((beta*dt^2)*K);
if strcmpi(BC,'yes') == 1
for ii = 1:size(pbdof,1)   
    AM(pbdof(ii,1),:) = AM(pbdof(ii,1),:) + AM(pbdof(ii,2),:);
    AM(:,pbdof(ii,1)) = AM(:,pbdof(ii,1)) + AM(:,pbdof(ii,2));
    AM(pbdof(ii,2),:) = 0;
    AM(:,pbdof(ii,2)) = 0;
    AM(pbdof(ii,2),pbdof(ii,1)) = -1;
    AM(pbdof(ii,2),pbdof(ii,2)) = +1;
end
end

for s = 1:length(t)-1
    
    %%%%%%%%%
    % Force ;
    %%%%%%%%%
    myForce = forcing_function(force,forceLoc,s,t,t_max,w,dw);
    ForceVec = myForce(:);
    if strcmpi(BC,'yes') == 1
    for ii = 1:size(pbdof,1)
    ForceVec(pbdof(ii,1)) = ForceVec(pbdof(ii,1)) + ForceVec(pbdof(ii,2));
    ForceVec(pbdof(ii,2)) = 0;
    end
    end
    iF(s+1) = ForceVec(dofpernode*forceLoc(1)-1);
    
    %%%%%%%%%%%%%%%
    % Accleration ;
    %%%%%%%%%%%%%%%
    acc(:,s+1) = AM \ (ForceVec -...
        (K*((dis(:,s)) + (dt*vel(:,s)) + (0.5*dt^2*(1-2*beta)*acc(:,s)))));
    
    %%%%%%%%%%%%
    % Velocity ;
    %%%%%%%%%%%%
    vel(:,s+1) = vel(:,s) + dt*(((1-gamma)*acc(:,s)) + (gamma*acc(:,s+1)));
    
    %%%%%%%%%%%%%%%%
    % Displacement ;
    %%%%%%%%%%%%%%%%
    dis(:,s+1) = dis(:,s) + (dt*vel(:,s)) + ...
        (0.5*dt^2*(((1-2*beta)*acc(:,s)) + (2*beta*acc(:,s+1))));
    
    
    %%%%%%%%%%
    % Energy ;
    %%%%%%%%%%
    Energy(s+1) = (0.5*dis(:,s+1).'*K*dis(:,s+1)) +...
        (0.5*vel(:,s+1).'*M*vel(:,s+1));
    
    %%%%%%%%%%%%%%%%%%%%
    % Change in Energy ;
    %%%%%%%%%%%%%%%%%%%%
    
    dEnergy(s+1) = ((0.5*dis(:,s+1).'*K*dis(:,s+1) +...
        0.5*vel(:,s+1).'*M*vel(:,s+1)) -...
        (0.5*dis(:,s).'*K*dis(:,s) + ...
        0.5*vel(:,s).'*M*vel(:,s)));
    
end

D = dis;
V = vel;
A = acc;
E = Energy;
dE = dEnergy;
iForce = iF;

