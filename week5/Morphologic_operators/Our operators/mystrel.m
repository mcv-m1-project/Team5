% Task 1. mystrel is a function that creates the morphological structuring
% element that will be used by the morphological operators. The function
% has the next three input parameters (IP) and one output parameter (OP).
%
% size1: (IP) parameter used to create the circle and square structuring element
% size2: (IP) parameter used to create the rectangle structuring element
% element:(IP) is the name of the structuring element that we want to
% create.
%                                  ------Element------
%       square -> squared matrix of ones with size specified by size1
%       circle -> circle of ones with radius = size1 created in a squared matrix
%       rectangle -> matrix of ones and size: size1 and size2 

% se:(OP) Is a binary matrix created with the shape of the element's name
% where the ones are the structuring element.

function myse = mystrel(element,size1,size2)
    switch element
        case 'square'
            myse=ones(size1);
        case 'circle'
            myse=zeros(2*size1+1,2*size1+1);
            for i=1:2*size1+1
                for j=1:2*size1+1
                    if((i-size1-1)^2+(j-size1-1)^2<=size1^2)
                        myse(i,j)=1;
                    end
                end
            end           
        case 'rectangle'
            myse=ones(size1,size2);
    end
end