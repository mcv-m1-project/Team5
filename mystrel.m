function se = mystrel(element,size)
    switch element
        case 'square'
            se=ones(size);
        case 'circle'
            se=zeros(2*size+1,2*size+1);
            for i=1:2*size+1
                for j=1:2*size+1
                    if((i-size-1)^2+(j-size-1)^2<=size^2)
                        se(i,j)=1;
                    else
                        se(i,j)=0;
                    end
                end
            end
        case 'rectangle'
            se=ones(size.height,size.width);
    end

end