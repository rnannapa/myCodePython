function[coordinates] = coord(alpha,d,shape)
%
if strcmpi(shape,'hexagon') == 1
    x(1) = 0; y(1) = 0;
    x(2) = x(1); y(2) = y(1)+d;
    x(3) = x(2) + d*cos(alpha); y(3) = y(2) + d*sin(alpha);
    x(4) = x(2) - d*cos(alpha); y(4) = y(2) + d*sin(alpha);
    coordinates = [x;y]';
elseif strcmpi(shape,'triangle') == 1
    x(1) = 0; y(1) = 0;
    x(2) = d; y(2) = 0;
    x(3) = d*cos(alpha); y(3) = d*sin(alpha);
    coordinates = [x;y]';
else
    coordinates = 'Shape Not Defined. Try Hexagon or Triangle';
end
end