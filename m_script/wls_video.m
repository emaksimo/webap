%Création d'une séquence vidéo avec figure 
clear all ;
close all;
% lambda=1543;
% lambda_mic=1.543;
% lambdaN=1543;
% res=50;
% max_range=3000;
% max_range2=4000;
% ad_range=50;
% max_range1=max_range+ad_range;
% max_cnr=-10;
% max_vr=10;
% max_dvr=3;
% fuseau=0;
% temps='UTC';
% % niveau='ASL';
% % gl=15;
% niveau='AGL';
% gl=0;
% nb_par=8; %nb parametre par niveau
% seuil_cnr=-27;
% ad_seuil=1;
% %Superpose les PPI sur la carte map.png

chemin0='/Users/patrick/2010/WLS100/';
chemin1='/Users/patrick/2010/WLS100/02aout2013/';
chemin3=strcat(chemin1,'supfig/');
%chemin3=strcat(chemin1,'testfig/');

repdir=[chemin3];
list = dir([repdir,'/','SUP-CNR*.png']);

k=0;
for klist = 1:length(list),
   if ~list(klist).isdir,k=k+1;
       fichier(k) = cellstr(list(klist).name);      
   end;
end;



aviobj = avifile([chemin3,'VIDEO_SUP_CNR.avi'],'compression','None','fps',2,'quality',100);%ok video1


for g=1:length(fichier),
   % fid=fopen([repdir,'/','select/',char(fichier(g))],'r');
 [num2str(g),'/',num2str(length(fichier))]
%length(fichier)


ima0=imread([repdir,'/',char(fichier(g))]);

col1=830;%200
col2=size(ima0,2)-690;%nbc1;

line1=220;%1
line2=size(ima0,1)-320;
ima1=ima0(line1:line2,col1:col2,1:3);
%im0=im01(line1:line2,col1:col2,1:3);
figure(10)
image(ima1);
axis('image')
 axis off

F = getframe(figure(10));%ok video2
  aviobj = addframe(aviobj,F)% ok video3
    
    
    
    
end;

%figure(17)
%imhist(ima1ok);

aviobj = close(aviobj); %ok video4


% 
% 
% for g=1:length(fichier),
%  [num2str(g),'/',num2str(length(fichier))]
%  clear im0 im im3
%  clf (figure(11))
%  im0=imread([repdir,'/',char(fichier(g))]);
  