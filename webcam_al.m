function [  ] = webcam_al(  )
close all
objects = imaqfind;
delete(objects);
vid = videoinput('winvideo',1);

set(vid, 'FramesPerTrigger', Inf);

set(vid, 'ReturnedColorspace', 'rgb')

vid.FrameGrabInterval = 5;

start(vid)

while(vid.FramesAcquired<=300)
    
    imges = getsnapshot(vid);
    
    mt_im = imsubtract(imges(:,:,3), rgb2gray(imges));
    
    mt_im = medfilt2(mt_im, [3 3]);
    
    mt_im = im2bw(mt_im,0.18);
    
    mt_im = bwareaopen(mt_im,300);
    
    bw = bwlabel(mt_im, 8);
    
    stats = regionprops(bw, 'BoundingBox', 'Centroid');
    
    imshow(imges)
    
    hold on
    
    for object = 1:length(stats)
        bb = stats(object).BoundingBox;
        bc = stats(object).Centroid;
        rectangle('Position',bb,'EdgeColor','r','LineWidth',2)
        plot(bc(1),bc(2), '-m+')
        a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
        set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
    end
    
    hold off
end

stop(vid);

flushdata(vid);

clear all
