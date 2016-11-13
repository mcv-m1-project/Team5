
Window = 255*Template(1, [130 130]);

min_rad = 10;%??
max_rad = 40;%??
radrange = [min_rad max_rad];
[accum, circen, cirrad] = CircularHough_Grd(Window, radrange);
if ~(isempty(cirrad))
    circle_detected = 1;
end
rawimg = Window;

% figure(1); imagesc(accum); axis image;
% title('Accumulation Array from Circular Hough Transform');
figure(2); imagesc(rawimg); colormap('gray'); axis image;
hold on;
plot(circen(:,1), circen(:,2), 'r+');
for k = 1 : size(circen, 1),
    DrawCircle(circen(k,1), circen(k,2), cirrad(k), 32, 'b-');
end
hold off;
title(['Raw Image with Circles Detected ', ...
    '(center positions and radii marked)']);
% figure(3); surf(accum, 'EdgeColor', 'none'); axis ij;
% title('3-D View of the Accumulation Array');