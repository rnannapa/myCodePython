function[Node_Conn] = node_conn(alpha,d,Nodes,shape,tol)
%
% Written by: Raj Gopal Nannapaneni
% Last Updated: 6/23/2017
%
%

Mdl = ExhaustiveSearcher(Nodes);
[Idx,~] = rangesearch(Mdl,Nodes,d+tol);

j = 0;

if strcmpi(shape,'hexagon') == 1
    for ii = 1:size(Idx,1)
        A = cell2mat(Idx(ii));
        for p = 2:length(A)
            j = j+1;
            if round(Nodes(A(1),2),5) ~= round(Nodes(A(p),2),5)
            C(j,:) = [A(1),A(p)];
            end
        end
    end
end

if strcmpi(shape,'triangle') == 1 && alpha ~= pi/2
    for ii = 1:size(Idx,1)
        A = cell2mat(Idx(ii));
        for p = 2:length(A)
            j = j+1;
            if round(Nodes(A(1),1),5) ~= round(Nodes(A(p),1),5)
            C(j,:) = [A(1),A(p)];
            end
        end
    end
end


if strcmpi(shape,'triangle') == 1 && alpha == pi/2
    for ii = 1:size(Idx,1)
        A = cell2mat(Idx(ii));
        for p = 2:length(A)
            j = j+1;
            C(j,:) = [A(1),A(p)];
        end
    end
end


for ii = 1:size(C,1)
    if C(ii,1) > C(ii,2)
        temp = C(ii,1);
        C(ii,1) = C(ii,2);
        C(ii,2) = temp;
    end
end

C( ~any(C,2), : ) = [];

Node_Conn = uniquetol(C,'ByRows',true);

for ii=1:size(Node_Conn,1)
    hold on
    line([Nodes(Node_Conn(ii,1),1), Nodes(Node_Conn(ii,2),1)]...
        ,[Nodes(Node_Conn(ii,1),2), Nodes(Node_Conn(ii,2),2)],'Color','red');
    %set(gca,'visible','off')

end
