function imDualTopHat = myDualTopHat (Img, se)
    imClosed = myClosing(Img, se);
    imDualTopHat = imClosed - Img;
end
