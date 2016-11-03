function template = template_model3(siz)
%Triangle Template
template=zeros(siz(1), siz(2));

ry=siz(1)-1;
rx=siz(2)-1;
[x,y] = meshgrid(0:rx,0:ry);

template = double((2*ry*(x-rx/2)/rx <= y)&(-2*ry*(x+rx/2)/rx + 2*ry <= y));

end