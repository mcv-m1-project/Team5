%Task 1 w4
function template = Template(signType,siz)

    switch signType
        case 1
            template = template_model1(siz);
            template = edge(template,'canny');
    %         figure();
    %         imshow(circle);
        case 2
            template = template_model2(siz);
            template = edge(template,'canny');
    %         figure();
    %         imshow(square);
        case 3
            template = template_model3(siz);
            template = edge(template,'canny');
    %         figure();
    %         imshow(triangle);
        case 4
            template = template_model4(siz);
            template = edge(template,'canny');
    %         figure();
    %         imshow(itriangle);
    end
end
