function template = template_model2(siz)
%Square Template
template = zeros(siz(1), siz(2));
template(3:end-2,3:siz(2)-2)= 1;
% figure,imshow(template)
end