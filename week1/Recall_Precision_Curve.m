%% Code for compute the Recall-Precision Curve

Names = ['RGBManual' 'OtsuRGB' 'HSV' 'Lab' 'YUV' 'HSV&RGB'];
Recall=[0.3443 0.4445 0.5169 0.0313 0.4901 0.3314];
Precision=[0.1227 0.0306 0.2248 0.0032 0.0528 0.2604];

hold on
scatter(Recall(1), Precision(1),'filled','b');
scatter(Recall(2), Precision(2),'filled','r');
scatter(Recall(3), Precision(3),'filled','g');
scatter(Recall(4), Precision(4),'filled','m');
scatter(Recall(5), Precision(5),'filled','k');
scatter(Recall(6), Precision(6),'filled','c');

axis([0 1 0 1])
legend('RGBManual','OtsuRGB','HSV','Lab','YUV','HSV&RGB');
title 'Recall-Precision Curve';
ylabel 'Precision';
xlabel 'Recall';