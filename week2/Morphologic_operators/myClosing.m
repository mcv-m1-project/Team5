function imClosed = myClosing (Img, se)
    imDilated = myDilation(Img,se);
    imClosed = myErosion(imDilated,se);
end
