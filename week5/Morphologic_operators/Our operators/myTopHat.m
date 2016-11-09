function imTopHat = myTopHat (Img, se)
    imOpened = myOpening(Img,se);
    imTopHat = double(Img) - imOpened;
end
