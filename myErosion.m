function imEroded = myErosion (Img, se)
    % Initialize output image.
    imEroded = zeros(size(Img));
    % Structuring element.
    halfHeight = floor(size(se,1)/2);
    halfWidth = floor(size(se,2)/2);
    %Pad zeros on all the sides.
    Img=padarray(Img,[halfHeight halfWidth],'replicate');
    [row, col]=size(Img);

    % Perform local min operation.
    for i = (halfHeight + 1) : (row - halfHeight)
        for j = (halfWidth + 1) : (col - halfWidth)
            imEroded(i,j)=min(min(se&Img(i-halfHeight:i+halfHeight,j-halfWidth:j+halfWidth)));
        end
    end
    imEroded = imEroded(halfHeight+1:row-halfHeight,halfWidth+1:col-halfWidth);
end    