function imTopHat = myTopHat (Img, se)
    imOpened = myOpening(Img,se);
    imTopHat = Img - imOpened;
end
