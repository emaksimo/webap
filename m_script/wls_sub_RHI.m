%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Données d'entrée %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%


entete=42;
root=importdata([chemin1,char(fichier(L))],'\t',entete);
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

%cnr(cnr<seuil_cnr)=seuil_cnr;
cnr(cnr<seuil_cnr-ad_seuil)=NaN;

for k=1:nbline
    for j=1:ncol
        r_0(k,j)=50*j+50;
    end;
end;
% 
 for k=1:nbline  
       for j=1:ncol,
        el(k,j)=elcol(k); 
        az(k,j)=azcol(k);
        z1(k,j)=r_0(k,j).*sin(el(k)*pi/180)+gl;
        d1(k,j)=r_0(k,j).*cos(el(k)*pi/180);
       end;
     end;
 
   colordef black
  
   % %$$$$$$$$$$$$$$$$$$$$$$$$$$ SCAN CNR $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
clf (figure(1))
  figure(1)
 surf(d1,z1,cnr,'EdgeLighting','phong','LineStyle','none'); 
view(0,90);
title([mode, ' of CNR [dB] at ',location,' (',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
    ' -',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
    ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20),') ']);
%caxis([seuil_cnr 0]);
caxis([seuil_cnr max_cnr]);
axis equal;
alti=['Altitude ',niveau,' (m)'];
ylabel(alti);
xlim([-max_range1 max_range1]);%complet
ylim([0 max_range1]);%complet
hold on;
box on;
grid off;
colorbar;
orientation_RHI;
xlabel(['     Range ',orientation,' (m)'])%µµµµµ
axe_RHI;
 titre1=['RHI_',num2str(round(az(1))),'_',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),31),'-',datestr(datenum(aa(nbline),...
 mm(nbline),jj(nbline),hh(nbline),mn(nbline),ss(nbline)),13)];   
%  titre1=['RHI_',num2str(round(az(1))),'_',str2num(aa(1)),str2num(mm(1)),jj(1),str2num(hh(1)),str2num(mn(1)),str2num(ss(1)),'-',str2num(aa(nbline)),...
% str2num(mm(nbline)),str2num(jj(nbline)),str2num(hh(nbline)),str2num(mn(nbline)),ss(nbline)),13)];   



imageok=[chemin2,'CNR_',titre1,'.png'];
imageokbis=[chemin2bis,'CNR_',titre1,'.eps'];
set(gcf,'InvertHardcopy','off')
print (figure(1),'-dpng','-r400',imageok);
%print (figure(1),'-depsc2',imageokbis);



%%%%%%%%%%%%%Radial wind speed%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_col=8;
compteur=1;
for i=num_col:nb_par:size(cc,2)
 vr(:,compteur)=cc(:,i);
 compteur=compteur+1;
end;
vr(isnan(cnr))=NaN;
% %$$$$$$$$$$$$$$$$$$$$$$$$$$ SCAN VR $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
clf (figure(2))
figure(2)
 surf(d1,z1,vr,'EdgeLighting','phong','LineStyle','none'); 
title([mode, ' of radial wind speed [m/s] at ',location,' (',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
    ' -',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
    ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20),') ']);
 %shading interp
view(0,90);
axis equal;
alti=['Altitude ',niveau,' (m)'];
ylabel(alti);
xlim([-max_range1 max_range1]);%complet
ylim([0 max_range1]);%complet
caxis([-max_vr max_vr]);
hold on;
box on;
grid off;
%colormap(h1);
colorbar;
xlabel(['     Range ',orientation,' (m)'])%µµµµµ
 axe_RHI;
 titre1=['RHI_',num2str(round(az(1))),'_',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),31),'-',datestr(datenum(aa(nbline),...
    mm(nbline),jj(nbline),hh(nbline),mn(nbline),ss(nbline)),13)];   
imageok=[chemin2,'VR_',titre1,'.png'];
imageokbis=[chemin2bis,'VR_',titre1,'.eps'];

set(gcf,'InvertHardcopy','off')
print (figure(2),'-dpng','-r400',imageok);
%print (figure(2),'-depsc2',imageokbis);
 
 
%%%%%%%%%%%%%Radial wind speed DISPERSION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_col=9;
compteur=1;
for i=num_col:nb_par:size(cc,2)
 dvr(:,compteur)=cc(:,i);
 compteur=compteur+1;
end;
dvr(isnan(cnr))=NaN;
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
alti=['Altitude ',niveau,' (m)'];
ylabel(alti);
xlim([-max_range1 max_range1]);%complet
ylim([0 max_range1]);%complet
caxis([0 max_dvr]);
hold on;
box on;
grid off;
colorbar;
xlabel(['     Range ',orientation,' (m)'])%µµµµµ
 axe_RHI;
 titre1=['RHI_',num2str(round(az(1))),'_',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),31),'-',datestr(datenum(aa(nbline),...
    mm(nbline),jj(nbline),hh(nbline),mn(nbline),ss(nbline)),13)];   
imageok=[chemin2,'DVR_',titre1,'.png'];
imageokbis=[chemin2bis,'DVR_',titre1,'.eps'];
set(gcf,'InvertHardcopy','off')
print (figure(3),'-dpng','-r400',imageok);
%print (figure(3),'-depsc2',imageokbis);
 


clear el elcol az azcol z1 r_0 d1 dte0 root nline0 dte sdte aa  mm jj hh mn ss
clear xdate nb_porte nbline cc gps int_temp ext_temp press hum 
clear cnr vr dvr titre1 imageok imageokbis alti
 