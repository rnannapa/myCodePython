%function[myForce] = forcing_function(force,forceLoc,s,t,t_max,w,dw)
% force(forceLoc,1) = 0.1*heaviside(t_max-t(s+1))*sin(w*t(s+1))*sin(dw*t(s+1));
% force(forceLoc,2) = 0;%heaviside(t_max-t(s+1))*sin(w*t(s+1))*sin(dw*t(s+1));
% myForce = force.';
% myForce = myForce(:);
% return
%%
function[ForceVec] = forcing_function(force,forceLoc,s,t,t_max,w,dw)
force(forceLoc,1) = 0.1*heaviside(t_max-t(s+1))*sin(w*t(s+1))*sin(dw*t(s+1));
force(forceLoc,2) = 0;%1*heaviside(t_max-t(s+1))*sin(w*t(s+1))*sin(dw*t(s+1));
ForceVec = force.';
%myForceMatrix(:,i+1) = ForceVec(:);