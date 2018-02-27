
function[Nodes] = nodes(alpha,d,nx,ny,shape,BC)
%
%
% % clear all;close all;clc;
% % commandwindow
% % alpha = pi/2;
% % d = 1;
% % row = 3;
% % col = 5;
% % nx=0:col;
% % ny = 0:row;
% % %shape = 'hexagon';
% % shape = 'triangle'
% % tol = 1e-16;
% % nodes(pi/6,1,0:4,0:4,'hexagon')
% % nodes(pi/6,1,0:4,0:4,'triangle')
% % Written by: Raj Gopal Nannapaneni
% % Last Updated: 6/23/2017
% %
base_cell = coord(alpha,d,shape);

%%%%%%%%%%%
% Hexagon ;
%%%%%%%%%%%
tic
if strcmpi(shape,'hexagon') == 1
    for p = 1:length(nx)-1
        xSweep = base_cell + [nx(p)*2*d*cos(alpha),0];
        x{p} = xSweep;
    end
    x = cell2mat(x');
    xTop_id = x(:,2) == max(x(:,2));
    xt = x(xTop_id,:) + [0,d] ;
    X = [x;xt];
    
    if length(ny) ~= 1
    for p = 1:length(ny)-1
        ySweep = X + [0,ny(p)*2*d*(1+sin(alpha))];
        
        y{p} = ySweep;
    end
    clear temp
    Y1 = cell2mat(y');
    
    else
        Y1 = X;
    end
    
    temp  = round(Y1(:,2),4) == round(max(Y1(:,2) - d*(1+sin(alpha))),4);
    Y_top = Y1(temp,:) + [0,d*(1+2*sin(alpha))];
    Y = [Y1;Y_top];
    
    clear temp Y_top
    %%Making Periodic Lattice%%
    if strcmpi(BC,'yes') == 1
        temp = round(Y(:,2),4) == round(max(Y(:,2)),4);
        Y_top = Y(temp,:) + [0,d];
        Y = [Y;Y_top];
        clear temp
    end
    %%%%
    temp = X(:,2) == min(X(:,2));
    X(temp,:) = [];
    Y(temp,:) = [];
    clear temp
end

%%%%%%%%%%%%
% Triangle ;
%%%%%%%%%%%%
if strcmpi(shape,'triangle')
    for p = 1:length(nx)-1
        xSweep = base_cell + [nx(p)*d,0];
        x{p} = xSweep;
    end
    X = cell2mat(x');
    if alpha == pi/2
        X(X(:,1) == max(X(:,1)),:) = [];
    end
    
    for p = 1:length(ny)
        ySweep = X + [0,ny(p)*2*d*sin(alpha)];
        y{p} = ySweep;
    end
    Y = cell2mat(y');
    temp = Y(:,2) == max(Y(:,2));
        Y(temp,:) = [];
    clear temp
end


allnodes = [X;Y];
Nodes = uniquetol(allnodes,'ByRows',true);
Nodes = sortrows(Nodes,2);
Nodes = round(Nodes,5);
plot(Nodes(:,1),Nodes(:,2),'o')
axis('equal')
toc