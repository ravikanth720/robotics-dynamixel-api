clear all;
figure; 
h = imfreehand;data=get(h); 
xydata=get(data.Children(4)); 
x=xydata.XData; 
y=xydata.YData; 
figure; plot(x,y,'.') 