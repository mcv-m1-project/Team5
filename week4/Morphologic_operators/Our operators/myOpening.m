function imOpened = myOpening (Img, se)
    imEroded = myErosion(Img,se);
    imOpened = myDilation(imEroded,se);
end