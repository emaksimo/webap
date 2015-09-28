%Superpose les PPI sur la carte map.png
clear all ;
close all;
chemin0='/Users/patrick/2010/WLS100/';
%chemin1='/Users/patrick/2010/WLS100/2013_09_11__15_05_36/';
%chemin1='/Users/patrick/2010/WLS100/test/';
chemin1='/Users/patrick/2010/WLS100/02aout2013/';

%chemin3=strcat(chemin1,'supfig/');
%chemin3bis=strcat(chemin1,'supfig_eps/');
%[s,mess,messid]=mkdir([chemin3]);
%[s,mess,messid]=mkdir([chemin3bis]);

%file=[chemin1,'WLS100S-9_2013_09_11__15_10_55_PPI.rtd'];
%chemin2=strcat(chemin0,'map.png');
%chemin2bis=strcat(chemin1,'fig_eps/');

%mode='PPI';
location='Dunkerque';

%chemin='/Users/patrick/2010/Manip Letia 05 11 2010/seq/';%********************************ICI
%imref0=imread(chemin2);
%imref=imresize(imref0,3);

repdir=[chemin1,'fig'];

list = dir([repdir,'/','VR_PPI*.png']);
k=0;
for klist = 1:length(list),
   if ~list(klist).isdir,k=k+1;
       fichier_PPI(k) = cellstr(list(klist).name);      
   end;
end;

list = dir([repdir,'/','VR_RHI*.png']);
k=0;
for klist = 1:length(list),
   if ~list(klist).isdir,k=k+1;
       fichier_RHI(k) = cellstr(list(klist).name);      
   end;
end;


list = dir([repdir,'/','0CHT_VH*.png']);
k=0;
for klist = 1:length(list),
   if ~list(klist).isdir,k=k+1;
       fichier_CHT(k) = cellstr(list(klist).name);      
   end;
end;


list = dir([repdir,'/','CNR_PPI*.png']);
k=0;
for klist = 1:length(list),
   if ~list(klist).isdir,k=k+1;
       fichier_CNR_PPI(k) = cellstr(list(klist).name);      
   end;
end;

nb_PPI=length(fichier_PPI);
nb_RHI=length(fichier_RHI);
%nb_CHT=length(fichier_CHT);
nb_fig=min([nb_PPI nb_RHI])

for g=1:nb_fig,
  titre1=char(fichier_CHT(1));
  titre2=char(fichier_RHI(g));
  titre3=char(fichier_PPI(g));
  titre4=char(fichier_CNR_PPI(g)); 

 [num2str(g),'/',num2str(length(fichier_PPI))]
 clear im1 im2 im3 im4
 clf (figure(10))
 im1=imread([repdir,'/',char(fichier_CHT(1))]);
 im2=imread([repdir,'/',char(fichier_RHI(g))]);
 im3=imread([repdir,'/',char(fichier_PPI(g))]);
 im4=imread([repdir,'/',char(fichier_CNR_PPI(g))]);
%   
%  figure(1)
%  image(im1);
% axis('image')
% axis off
% 
%  
%   figure(2)
%  image(im2);
% axis('image')
% axis off
% 
%  figure(3)
%  image(im3);
% axis('image')
% axis off
%  
 
 figure(10)
m=2;%nbligne 
n=2;%nbcolonne
fact=0.12;
%title(['Time Heigh section, RHI and PPI at ',location,'(',titre2(12:30),'UTC)']);
h=subplot(m,n,3); 
ax=get(h,'Position');
set(h,'Position',ax);
set(h,'position',[ax(1)-0.1 ax(2)-0.13 ax(3)+fact ax(4)+fact]);
image(im1);%subplot(nb lignee, nb col, n°de la ligne/nbtotal)
title(['Time-height section (',location,', ',titre2(12:21),')']);
axis('image')
axis off
hold on
h=subplot(m,n,1);
ax=get(h,'Position');
set(h,'Position',ax);
set(h,'position',[ax(1)-0.1 ax(2)-0.09 ax(3)+fact ax(4)+fact]);
image(im2);%subplot(nb lignee, nb col, n°de la ligne/nbtotal)
title(['RHI of radial wind speed (',titre2(12:39),')']);
axis('image')
axis off
hold on
h=subplot(m,n,2);
ax=get(h,'Position');
set(h,'Position',ax);
set(h,'position',[ax(1)-0.1 ax(2)-0.09 ax(3)+fact ax(4)+fact]);
image(im3);%subplot(nb lignee, nb col, n°de la ligne/nbtotal)
title(['PPI of radial wind speed (',titre3(12:37),')']);
 axis('image')
axis off
hold on
h=subplot(m,n,4);
ax=get(h,'Position');
%set(h,'Position',ax);
set(h,'position',[ax(1)-0.1 ax(2)-fact ax(3)+fact ax(4)+fact]);
image(im4);%subplot(nb lignee, nb col, n°de la ligne/nbtotal)
title(['PPI of CNR (',titre3(12:37),')']);
 axis('image')
axis off

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
%  line1=230;
%  line2=2660;
%  col1=670;
%  col2=3110;
%  im=im0(line1:line2,col1:col2,1:3);
%  
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
%   
%   
%  line1=1;
%  line2=size(imref,1);
%  col1=880;
%  col2=3310;
%  imref1=imref(line1:line2,col1:col2,1:3);
% 
%   figure(11)
%     image(imref1);
%     hold on 
%  axis('image')
%   axis on
%   axis equal
% 
%   titre=char(fichier(g));
  %titreok=['',num2str(g)];
% 
% 
%  im3=image(im);
%   axis('image')
%   axis off
% set(im3,'AlphaData',0.45);
%  hold on
%  posiy=size(imref1,2);
%  delta2=10;
% text(1,posiy-delta2,titreok);
% 
 titreok=['0Screen-',titre2(11:30)];

 imageok=[repdir,'/',titreok,'.png'];
 print (figure(10),'-dpng','-r400',imageok);
% %print (figure(1),'-depsc2',imageokbis);
% 
% 



end;
