% RGBOtsu HSV Lab HSV&RGB RGBManual
Recall=[0.4450 0.5169 0.313 0.3314 0.3443];
Precision=[0.0306 0.22 0.032 0.2604 0.1227];

plot(Recall, Precision),'scatter';

Dist = zeros(5,1);

for i=1:5
Dist(i) = sqrt((1-Recall(i))^2+(1-Precision(i)^2));
end