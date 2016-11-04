function template = template_model2(siz)
%Square Template
template = zeros(siz(1), siz(2));
template(2:end-1,2:siz(2)-1)= 1;
end