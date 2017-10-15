function [stats,Ibox,bwSub]=dilated(img)

[g,b]=size(img);
I = rgb2gray(img);    
level = graythresh(I);
BW = im2bw(I,level); 
BW=~BW;

%DILATION

%FOR COLUMN and IMAGE

seType1 = strel('line',40,180);
seType2 = strel('line',50,90);
bwSub = imdilate(BW,[seType1 seType2]);
bwSub=imfill(bwSub,'holes');

%FOR HEADING

cropped=imcrop(bwSub,[1 1 3075 380]);
se=strel('square',25);
cropped=imdilate(cropped,se);

Pos=[1 1 3075 370];
r = round(Pos(1));
c = round(Pos(2));
if(r ==0)
    r=1;
end
sizeR = size(cropped,1);
sizeC = size(cropped,2);
bwSub(r:sizeR+r-1,c:sizeC+c-1) = cropped;

%segmentation

[Ilabel num]=bwlabel(bwSub);
stats = regionprops(Ilabel, 'BoundingBox');
Iprops=regionprops(Ilabel);
Ibox=[Iprops.BoundingBox];
Ibox=reshape(Ibox,[4 num]);

end