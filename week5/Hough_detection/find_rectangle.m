function [ BBox_rectangle ] = find_rectangle( Rectangle )
BBox_rectangle = struct('x', 0, 'y', 0, 'w', 0, 'h', 0);
% Rectangle(5) = P_k(k, 7);%rho
% Rectangle(6) = P_k(k, 8);%theta
% 
% Rectangle(7) = P_k(k, 9);
% Rectangle(8) = P_k(k, 10);
% 
% Rectangle(9) = P_k(l, 7);
% Rectangle(10) = P_k(l, 8);
% 
% Rectangle(11) = P_k(l, 9);
% Rectangle(12) = P_k(l, 10);
X = zeros(4, 2);

A = [cos(Rectangle(6)) sin(Rectangle(6)); cos(Rectangle(10)) sin(Rectangle(10)) ];
b = [Rectangle(5); Rectangle(9)];

X(1, :) = linsolve(A, b)';

A = [cos(Rectangle(6)) sin(Rectangle(6)); cos(Rectangle(12)) sin(Rectangle(12)) ];
b = [Rectangle(5); Rectangle(11)];

X(2, :) = linsolve(A, b)';


A = [cos(Rectangle(8)) sin(Rectangle(8)); cos(Rectangle(10)) sin(Rectangle(10)) ];
b = [Rectangle(7); Rectangle(9)];

X(3, :) = linsolve(A, b)';

A = [cos(Rectangle(8)) sin(Rectangle(8)); cos(Rectangle(12)) sin(Rectangle(12)) ];
b = [Rectangle(7); Rectangle(11)];

X(4, :) = linsolve(A, b)';

BBox_rectangle.y = min(X(:, 1));
BBox_rectangle.x = min(X(:, 2));
BBox_rectangle.w = max(X(:, 1)) - BBox_rectangle.y;
BBox_rectangle.h = max(X(:, 2)) - BBox_rectangle.x;
end

