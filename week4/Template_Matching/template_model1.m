function template = template_model1(siz)
%Circle Template
template=zeros(siz(1), siz(2));

ry=siz(1)/2 -.5;
rx=siz(2)/2 -.5;
[x,y] = meshgrid(-rx:rx,-ry:ry);

template = double((((x/rx).^2 + (y/ry).^2) <= 1));

end