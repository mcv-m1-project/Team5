function template = template_model4(siz)
%Inverted triangle Template
template=zeros(siz(1), siz(2));
template2 = zeros(siz(1)-2, siz(2)-2);
ry=siz(1)-1;
rx=siz(2)-1;
[x,y] = meshgrid(2:rx,2:ry);

template2 = double((2*ry*x/rx >= y)&(-2*ry*x/rx + 2*ry >= y));
template(2:end-1,2:end-1) = template2;

end