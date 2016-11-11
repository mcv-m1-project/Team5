function f = Recall_Precision_Curve(Names,Recall,Precision)
% Code for computing the Recall-Precision Curve
	f=figure();
	gscatter(Recall, Precision,Recall);
    axis([0 1 0 1])
	legend(Names);
	title 'Recall-Precision Curve';
	ylabel 'Precision';
	xlabel 'Recall';
end