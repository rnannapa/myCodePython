function[K_Global] = global_stiffness_matrix(Nodes,Node_Conn,dof,kn,ks)
%
%
% Written By: Raj Gopal
% Updated on: 4/29/2017
%%%

NumNodes = size(Nodes,1);
NumEle = size(Node_Conn,1);
K_Global = sparse((NumNodes * dof),(NumNodes * dof));
% K_Global = zeros((NumNodes * dof),(NumNodes * dof));
for ii = 1:NumEle
    ele_nodes = Node_Conn(ii,1:2);
    node_xy = Nodes(ele_nodes,:);
    k_el = element_stiffness_matrix(node_xy,kn,ks);
    eldof = [dof*(ele_nodes(1))-1:dof*(ele_nodes(1))...
        dof*(ele_nodes(2))-1:dof*(ele_nodes(2))];    
    K_Global(eldof,eldof) = K_Global(eldof,eldof) + k_el;
end
