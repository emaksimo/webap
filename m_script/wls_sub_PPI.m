
%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Donn�es d'entr�e %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%



entete=42;
root=importdata([chemin1,'/',char(fichier(L))],'\t',entete);
dte0=root.textdata(:,1);
nline0=size(dte0,1);
dte(:,1)=dte0(entete+1:nline0,1);
sdte=char(dte);
 aa=str2num(sdte(:,1:4));
 mm=str2num(sdte(:,6:7));
 jj=str2num(sdte(:,9:10));
 hh=str2num(sdte(:,12:14));
 mn=str2num(sdte(:,16:17));
 ss=str2num(sdte(:,19:20));
% 
 xdate=datenum(aa',mm',jj',hh',mn',ss');
% xdate=xdate';
% 
% 
nb_porte=(max_range-50)/res;
nbline=size(aa,1);

cc=root.data(1:nbline,:);
%cc(ligne, colonne)

gps=cc(:,1);
int_temp=cc(:,2);
ext_temp=cc(:,3);
press=cc(:,4);
hum=cc(:,5);
azcol=cc(:,6);
elcol=cc(:,7);



%%%%%%%%%%%%% CNR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_col=10;
compteur=1;
for i=num_col:nb_par:size(cc,2)
 cnr(:,compteur)=cc(:,i);
 compteur=compteur+1;
end;
ncol=compteur-1;

cnr(cnr<seuil_cnr)=seuil_cnr;
cnr(cnr<seuil_cnr-ad_seuil)=seuil_cnr;

for k=1:nbline
    for j=1:ncol
        r_0(k,j)=50*j+50;
    end;
end;
% 
 for k=1:nbline  
       for j=1:ncol
        el(k,j)=elcol(k); 
        az(k,j)=azcol(k);
        d1(k,j)=r_0(k,j).*sin(az(k)*pi/180);
        z1(k,j)=r_0(k,j).*cos(az(k)*pi/180);
       end;
 end;
 
   colordef black
      %whitebg('k')
%       
% fid=fopen([chemin0,'couleurmapok1.txt'],'r');
% 
% mat = fscanf(fid,'%f',[3,64]);
%   c1(:,1)=mat(1,:)';
%   c2(:,1)=mat(2,:)';
%   c3(:,1)=mat(3,:)';
% fclose(fid);
% h1=[c1,c2,c3];

      
   % %$$$$$$$$$$$$$$$$$$$$$$$$$$ SCAN CNR $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
clf (figure(1))
  figure(1)
 surf(d1,z1,cnr,'EdgeLighting','phong','LineStyle','none'); 
view(0,90);
title([mode, ' of CNR [dB] at ',location,' (',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
    ' -',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
    ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20),') ']);
caxis([seuil_cnr max_cnr]);
axis equal;
xlabel(['     Range West / East ', '(m)']);
ylabel(['     Range South / North ', '(m)']);
xlim([-max_range1 max_range1]);%complet
ylim([-max_range1 max_range1]);%complet
hold on;
box on;
grid off;
colorbar;
%orientation_RHI;
axe_PPI;
titre1=['PPI_',num2str(round(el(1))),'_',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),31),'-',datestr(datenum(aa(nbline),...
mm(nbline),jj(nbline),hh(nbline),mn(nbline),ss(nbline)),13)];   
imageok=[chemin2,'CNR_',titre1,'.png'];
imageokbis=[chemin2bis,'CNR_',titre1,'.eps'];
set(gcf,'InvertHardcopy','off')
print (figure(1),'-dpng','-r500',imageok);
%print (figure(1),'-depsc2',imageokbis);



trace=0;
if trace==1
%%%%%%%%%%%%%Radial wind speed%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_col=8;
compteur=1;
for i=num_col:nb_par:size(cc,2)
 vr(:,compteur)=cc(:,i);
 compteur=compteur+1;
end;
vr(cnr<=seuil_cnr)=NaN;
% %$$$$$$$$$$$$$$$$$$$$$$$$$$ SCAN Vr $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
clf (figure(2))
figure(2)
 surf(d1,z1,vr,'EdgeLighting','phong','LineStyle','none'); 
title([mode, ' of radial wind speed [m/s] at ',location,' (',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
    ' -',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
    ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20),') ']);
 %shading interp
view(0,90);
axis equal;
xlabel(['     Range West / East ', '(m)']);
ylabel(['     Range South / North ', '(m)']);
xlim([-max_range1 max_range1]);%complet
ylim([-max_range1 max_range1]);%complet
caxis([-max_vr max_vr]);
hold on;
box on;
grid off;
%colormap(h1);
colorbar;
 axe_PPI;
 titre1=['PPI_',num2str(round(el(1))),'_',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),31),'-',datestr(datenum(aa(nbline),...
    mm(nbline),jj(nbline),hh(nbline),mn(nbline),ss(nbline)),13)];   
imageok=[chemin2,'VR_',titre1,'.png'];
imageokbis=[chemin2bis,'VR_',titre1,'.eps'];

set(gcf,'InvertHardcopy','off')
print (figure(2),'-dpng','-r400',imageok);
%print (figure(2),'-depsc2',imageokbis);

% trace=0;
% if trace==1
%%%%%%%%%%%%%Radial wind speed DISPERSION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_col=9;
compteur=1;
for i=num_col:nb_par:size(cc,2)
 dvr(:,compteur)=cc(:,i);
 compteur=compteur+1;
end;
dvr(cnr<=seuil_cnr)=NaN;
% %$$$$$$$$$$$$$$$$$$$$$$$$$$ SCAN DVR $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
clf (figure(3)) 
figure(3)
 surf(d1,z1,dvr,'EdgeLighting','phong','LineStyle','none'); 
title([mode, ' of radial wind speed dispersion [m/s] at ',location,' (',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
    ' -',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
    ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20),') ']);
 %shading interp
view(0,90);
axis equal;
xlabel(['     Range West / East ', '(m)']);
ylabel(['     Range South / North ', '(m)']);
xlim([-max_range1 max_range1]);%complet
ylim([-max_range1 max_range1]);%complet
caxis([0 max_dvr]);
hold on;
box on;
grid off;
colorbar;
axe_PPI;
 titre1=['PPI_',num2str(round(el(1))),'_',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),31),'-',datestr(datenum(aa(nbline),...
    mm(nbline),jj(nbline),hh(nbline),mn(nbline),ss(nbline)),13)];   
imageok=[chemin2,'DVR_',titre1,'.png'];
imageokbis=[chemin2bis,'DVR_',titre1,'.eps'];
set(gcf,'InvertHardcopy','off')
print (figure(3),'-dpng','-r500',imageok);
%print (figure(3),'-depsc2',imageokbis);
end; 

clear el elcol dte0 root nline0 dte sdte
clear xdate nb_porte cc gps int_temp ext_temp press hum 
clear vr dvr titre1 imageok imageokbis alti
% clear d1 z1 cnr r_0 az azcol aa  mm jj hh mn ss nbline
 
 