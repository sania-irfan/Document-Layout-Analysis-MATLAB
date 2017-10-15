function slider(paper)

for i=1:paper.Count
    imgCell{i} = read(paper,i);
end
img=cat(1,imgCell{:});
hFig = figure('Toolbar','none',...
              'Menubar','none');
hIm = imshow(img);
SP = imscrollpanel(hFig,hIm);