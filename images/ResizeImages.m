clear all
close all

Ibase=imread('Pavillion-ballroom-3 - med.JPG');

IBic2=imread('BIC2 copy_original.jpeg');
IBic2=IBic2(50:end,:,:);
f= size(Ibase,1)/size(IBic2,1);

pix2remove=(size(IBic2,2)*f - size(Ibase,2))/f;
IBic2=IBic2(:,pix2remove:end,:);
imshow(IBic2)
imwrite(IBic2,'BIC2.jpeg')


IBic3=imread('Copy_of_BIC3.jpeg');
%IBic3=IBic3(50:end,:,:);
f= size(Ibase,1)/size(IBic3,1);

pix2remove=(size(IBic3,2)*f - size(Ibase,2))/f;
IBic3=IBic3(:,1:(end-pix2remove),:);
imshow(IBic3)
imwrite(IBic3,'BIC3.jpeg')
size(IBic3)


% pier 2
IBic3=imread('Copy_of_PIER2.jpeg');
%IBic3=IBic3(50:end,:,:);
f= size(Ibase,1)/size(IBic3,1);

pix2remove=(size(IBic3,2)*f - size(Ibase,2))/f;
IBic3=IBic3(:,1:(end-pix2remove),:);
imshow(IBic3)
imwrite(IBic3,'PIER2.jpeg')
size(IBic3)


% pier 1
IBic3=imread('Copy_of_PIER1.jpeg');
%IBic3=IBic3(50:end,:,:);
f= size(Ibase,2)/size(IBic3,2);
IBic3=imresize(IBic3,f);

pix2remove=size(IBic3,1)-size(Ibase,1);
IBic3=IBic3(round((pix2remove/2)):(end-round(pix2remove/2)),:,:);
imshow(IBic3)
imwrite(IBic3,'PIER1.jpeg')
size(IBic3)



% pavillion 
IBic3=imread('Copy_of_pavillion_out.jpeg');
%IBic3=IBic3(50:end,:,:);
f= size(Ibase,1)/size(IBic3,1);

pix2remove=(size(IBic3,2)*f - size(Ibase,2))/f;
IBic3=IBic3(:,1:(end-pix2remove),:);
imshow(IBic3)
imwrite(IBic3,'pavillion_out.jpeg')
size(IBic3)



