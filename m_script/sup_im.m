%Superpose les PPI sur la carte map.png
clear all ;
close all;
chemin0='/Users/patrick/2010/WLS100/';
%chemin1='/Users/patrick/2010/WLS100/2013_09_11__15_05_36/';
%chemin1='/Users/patrick/2010/WLS100/test/';
chemin1='/Users/patrick/2010/WLS100/21aout2013/';

chemin3=strcat(chemin1,'supfig/');
chemin3bis=strcat(chemin1,'supfig_eps/');
[s,mess,messid]=mkdir([chemin3]);
[s,mess,messid]=mkdir([chemin3bis]);

%file=[chemin1,'WLS100S-9_2013_09_11__15_10_55_PPI.rtd'];
chemin2=strcat(chemin0,'map.png');
%chemin2bis=strcat(chemin1,'fig_eps/');

mode='PPI';
location='Dunkerque';

%chemin='/Users/patrick/2010/Manip Letia 05 11 2010/seq/';%********************************ICI
imref0=imread(chemin2);
imref=imresize(imref0,3);

repdir=[chemin1,'fig'];
list = dir([repdir,'/','CNR_PPI*.png']);

k=0;
for klist = 1:length(list),
   if ~list(klist).isdir,k=k+1;
       fichier(k) = cellstr(list(klist).name);      
   end;
end;

for g=1:length(fichier),
 [num2str(g),'/',num2str(length(fichier))]
 clear im0 im im3
 clf (figure(11))
 im0=imread([repdir,'/',char(fichier(g))]);
  
% figure(1)
% image(imref0);
% axis('image')
%  axis on
%  axis equal
% hold on


%figure(2)
 %image(imref);
 %axis on
 %axis equal
 %hold on

%figure(3)
 % image(im0);
  
  
  %Resample im0
 line1=230;
 line2=2660;
 col1=670;
 col2=3110;
 im=im0(line1:line2,col1:col2,1:3);
 
%  figure(4)
%  image(im);
%   axis('image')
%    axis off
   
%   figure(10)
%     image(imref);
%     hold on 
%   axis('image')
%   axis on
%   axis equal
%   
%   xdelta=875;
%   ydelta=15;
%   iim2=imagesc([xdelta xdelta+size(im,2)], [ydelta ydelta+size(im,1)], im);
% 
%   set(iim2,'AlphaData',0.45);
  
  
 line1=1;
 line2=size(imref,1);
 col1=880;
 col2=3310;
 imref1=imref(line1:line2,col1:col2,1:3);

  figure(11)
    image(imref1);
    hold on 
 axis('image')
  axis on
  axis equal

  titre=char(fichier(g));
  titreok=['SUP-CNR-',titre(11:38),' (UTC)'];


 im3=image(im);
  axis('image')
  axis off
set(im3,'AlphaData',0.45);
 hold on
 posiy=size(imref1,2);
 delta2=10;
text(1,posiy-delta2,titreok);

imageok=[chemin3,'/',titreok,'.png'];
print (figure(11),'-dpng','-r500',imageok);
%print (figure(1),'-depsc2',imageokbis);





end;
