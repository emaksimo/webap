

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Données d'entrée %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

% ouverture et lectures des fichiers
k=1; %cgap=1;
nb_profil=1;
nb_file=length(fichier);
for i=1:length(fichier),
    
 [num2str(i),'/',num2str(length(fichier))]
 fichier(i)
 entete=42;


root=importdata([chemin1,char(fichier(i))],'\t',entete);
dte0=root.textdata(:,1);
nline0=size(dte0,1);
dte(:,1)=dte0(entete+1:nline0,1);
sdte=char(dte);
nnline=size(sdte,1);
a1=nnline-nb_profil+1;


% 
 cc=root.data(1:nnline,:);
 nb_porte=(max_range-50)/res;

% 
for j=1:nb_profil
 aa(k+j-1)=str2num(sdte(nnline-j+1,1:4));
 mm(k+j-1)=str2num(sdte(nnline-j+1,6:7));
 jj(k+j-1)=str2num(sdte(nnline-j+1,9:10));
 hh(k+j-1)=str2num(sdte(nnline-j+1,12:14));
 mn(k+j-1)=str2num(sdte(nnline-j+1,16:17));
 ss(k+j-1)=str2num(sdte(nnline-j+1,19:20));
 %el(k+j-1)=cc(nnline-j+1,7);
 el(k+j-1)=90;
 
 
%%%%%%%%%%%%% CNR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_col=10;
 compteur=1;
 for ii=num_col:nb_par:size(cc,2)
  cnr(compteur,k+j-1)=cc(nnline-j+1,ii);
   r_0(compteur,k+j-1)=res*compteur+res;
   z1(compteur,k+j-1)=r_0(compteur,k+j-1).*sin(el(k)*pi/180)+gl;
   
  compteur=compteur+1;
% ncol=compteur-1;

 end;
 
 
% %%%%%%%%%%%%% VH %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  num_col=11;
  compteur=1;
 for ii=num_col:nb_par:size(cc,2)
  vh(compteur,k+j-1)=cc(nnline-j+1,ii);
  r_0_vh(compteur,k+j-1)=res*compteur+res;
  z1_vh(compteur,k+j-1)=r_0_vh(compteur,k+j-1).*sin(el(k)*pi/180)+gl;
  compteur=compteur+1;
 end;

 
   %%%%%%%%%%%%% VZ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_col=15;
compteur=1;
for ii=num_col:nb_par:size(cc,2)
  vz(compteur,k+j-1)=cc(nnline-j+1,ii);
  r_0_vz(compteur,k+j-1)=res*compteur+res;
  z1_vz(compteur,k+j-1)=r_0_vz(compteur,k+j-1).*sin(el(k)*pi/180)+gl;
  compteur=compteur+1;
end;
%ncol=compteur-1;

 
 


  %%%%%%%%%%%%% Radial wind speed DISPERSION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_col=9;
compteur=1;
for ii=num_col:nb_par:size(cc,2)
  dvr(compteur,k+j-1)=cc(nnline-j+1,ii);
  r_0_dvr(compteur,k+j-1)=res*compteur+res;
  z1_dvr(compteur,k+j-1)=r_0_dvr(compteur,k+j-1).*sin(el(k)*pi/180)+gl;
 compteur=compteur+1;
end;
 
  %%%%%%%%%%%%% DIR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  
  num_col=12;
compteur=1;
for ii=num_col:nb_par:size(cc,2)
 direction(compteur,k+j-1)=cc(nnline-j+1,ii);
  r_0_dir(compteur,k+j-1)=res*compteur+res;  
  z1_dir(compteur,k+j-1)=r_0_dir(compteur,k+j-1).*sin(el(k)*pi/180)+gl;
  date_dir(compteur,k+j-1)=datenum(aa(k),mm(k),jj(k),hh(k),mn(k),ss(k));
  tz(compteur,k+j-1)=500;
  tz0(compteur,k+j-1)=0;
  valz(compteur,k+j-1)=0;
 compteur=compteur+1;
end;
 
 end;

 xdate=datenum(aa',mm',jj',hh',mn',ss');
 xdate=xdate';
 datevec(xdate);

 k=k+nb_profil;
end

cnr(cnr<seuil_cnr)=NaN;%seuil_cnr;
%cnr(isnan(cnr))=seuil_cnr;
dvr(isnan(cnr))=NaN; 

%max_range=1500;

   figure(1);
surf(xdate',z1,cnr,'EdgeLighting','phong','LineStyle','none'); 
shading interp
box on;
colorbar;
 view(0,90);


if jj(1)==jj(nb_file)
      title(['Time height section of CNR at ',location,' (',datestr(datenum(aa(1),mm(1),jj(1)),20),')' ]);
  end;
if jj(1)~=jj(nb_file)
    title(['Time height section of CNR at ',location,...
     ' (',datestr(datenum(aa(1),mm(1),jj(1)),20),'-',datestr(datenum(aa(nb_file),mm(nb_file),jj(nb_file)),20),')' ]);
  end;
datetick('x','keeplimits');%IOPC

imageok=[chemin2,'0CHT_CNR_',datestr(datenum(aa(1),mm(1),jj(1)),1),'.png'];
 print (figure(1),'-dpng','-r500',imageok);


% 
% 
%  figure(2);
% surf(xdate',z1_vh,direction,'EdgeLighting','phong','LineStyle','none'); 
% shading interp
% colorbar
%  view(0,90);
%  datetick('x','keeplimits');%IOPC
% hold on
%  
 
  u_dir=-sin((direction).*pi/180);
  v_dir=-cos((direction).*pi/180);
  tz0(isnan(v_dir)==1)=NaN;%ENLEVE POINTS PR v_dir=NaN
  tz(isnan(v_dir)==1)=NaN;%ENLEVE POINTS PR v_dir=NaN

 qscaley=0.0001;
 qscale1=0.0001; % scaling factor for all vectors
 qscale2=0.0001; % scaling factor for all vectors
 size_arrow=0.35;
 nn=size(z1_dir,1);
 gap_tps=2;%résolution temps graph: 2=>2*10min=20min;3=>3*10min=30min; 6=>6*10min=60 min 
 gap_alti=2;%résolution alti graph: 2=>2*50m=100m;4=>4*50m=200m; 6=>6*50m=300m 
 size_x=round(size(date_dir,2));
 gaptick_alti=6;% graduation 6=>6*50m=300m à partir de 100m;
 

  %**********************************%Direction
 figure(3);
  
surf(xdate(1:gap_tps:size_x),z1_vh(1:gap_alti:nn,1:gap_tps:size_x).*qscaley,direction(1:gap_alti:nn,1:gap_tps:size_x),'EdgeLighting','phong','LineStyle','none'); 
 shading interp
 view(0,90); 
 caxis([0 360])
 
 %%%% Changement du code couleur %%%%
%chemin2='C:\Users\Cyril\Desktop\Nano-Indus\Nano-Indus tableau jours vent de N\col5.txt'; %%Windows
 fid2=fopen([chemin0,'col5.txt'],'r');
mat2=fscanf(fid2,'%f',[3,64]);
  c1(:,1)=mat2(1,:)';
  c2(:,1)=mat2(2,:)';
  c3(:,1)=mat2(3,:)';
fclose(fid2);
h1=[c1,c2,c3];
colormap(h1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 colorbar;
 box on;
 hold on
nn=58;
 h1=quiver3(date_dir(1:gap_alti:nn,1:gap_tps:size_x),z1_dir(1:gap_alti:nn,1:gap_tps:size_x).*qscaley,tz(1:gap_alti:nn,1:gap_tps:size_x),...
u_dir(1:gap_alti:nn,1:gap_tps:size_x)./qscale1,v_dir(1:gap_alti:nn,1:gap_tps:size_x)./qscale1,tz(1:gap_alti:nn,1:gap_tps:size_x),size_arrow,'k');

 
set(gca,'YTick',z1_dir(1:gaptick_alti:nn,1)'.*qscaley);
set(gca,'YTickLabel',(100:res*gaptick_alti:max_range));% De 100 m à 3000 m
ylim([0 max_range*qscaley]);
datetick('x');

  alti=['Altitude ',niveau,' (m)'];
  ylabel(alti);
  xlabel(' Time (UTC)');
  
  if jj(1)==jj(nb_file)
      title(['Time height section of wind direction at ',location,' (',datestr(datenum(aa(1),mm(1),jj(1)),20),')' ]);

  end;
if jj(1)~=jj(nb_file)
    title(['Time height section of wind direction at ',location,...
     ' (',datestr(datenum(aa(1),mm(1),jj(1)),20),'-',datestr(datenum(aa(nb_file),mm(nb_file),jj(nb_file)),20),')' ]);
  end;
  
imageok=[chemin2,'0CHT_DIR_',datestr(datenum(aa(1),mm(1),jj(1)),1),'.png'];
 print (figure(3),'-dpng','-r500',imageok);

  %**********************************%Vitesse horizontale
figure(4);
 surf(xdate(1:gap_tps:size_x),z1_vh(1:gap_alti:nn,1:gap_tps:size_x).*qscaley,vh(1:gap_alti:nn,1:gap_tps:size_x),'EdgeLighting','phong','LineStyle','none'); 
 shading interp
 view(0,90); 
 caxis([0 max_vh])
 colorbar;
 hold on
  h1 = quiver3(date_dir(1:gap_alti:nn,1:gap_tps:size_x),z1_dir(1:gap_alti:nn,1:gap_tps:size_x).*qscaley,tz(1:gap_alti:nn,1:gap_tps:size_x),...
  u_dir(1:gap_alti:nn,1:gap_tps:size_x)./qscale1,v_dir(1:gap_alti:nn,1:gap_tps:size_x)./qscale1,tz(1:gap_alti:nn,1:gap_tps:size_x),size_arrow,'k');
 
set(gca,'YTick',z1_dir(1:gaptick_alti:nn,1)'.*qscaley);
set(gca,'YTickLabel',(100:res*gaptick_alti:max_range));% De 100 m à 3000 m
ylim([0 max_range*qscaley]);
datetick('x');

  alti=['Altitude ',niveau,' (m)'];
  ylabel(alti);
  xlabel(' Time (UTC)');
  
  if jj(1)==jj(nb_file)
 title(['Time height section of wind direction and horizontal wind speed at ',location,' (',datestr(datenum(aa(1),mm(1),jj(1)),20),')' ]);
  end;
if jj(1)~=jj(nb_file)
 title(['Time height section of wind direction and horizontal wind speed at ',location,...
     ' (',datestr(datenum(aa(1),mm(1),jj(1)),20),'-',datestr(datenum(aa(nb_file),mm(nb_file),jj(nb_file)),20),')' ]);
  end;

    
imageok=[chemin2,'0CHT_VH_DIR_',datestr(datenum(aa(1),mm(1),jj(1)),1),'.png'];
 print (figure(4),'-dpng','-r500',imageok);

  %**********************************%Vitesse verticale
figure(5);
 surf(xdate(1:gap_tps:size_x),z1_vz(1:gap_alti:nn,1:gap_tps:size_x).*qscaley,vz(1:gap_alti:nn,1:gap_tps:size_x),'EdgeLighting','phong','LineStyle','none'); 
 shading interp
 view(0,90); 
 caxis([-max_vz max_vz])
 colorbar;
 hold on
  h1 = quiver3(date_dir(1:gap_alti:nn,1:gap_tps:size_x),z1_dir(1:gap_alti:nn,1:gap_tps:size_x).*qscaley,tz(1:gap_alti:nn,1:gap_tps:size_x),...
  u_dir(1:gap_alti:nn,1:gap_tps:size_x)./qscale1,v_dir(1:gap_alti:nn,1:gap_tps:size_x)./qscale1,tz(1:gap_alti:nn,1:gap_tps:size_x),size_arrow,'k');
 
set(gca,'YTick',z1_dir(1:gaptick_alti:nn,1)'.*qscaley);
set(gca,'YTickLabel',(100:res*gaptick_alti:max_range));% De 100 m à 3000 m
ylim([0 max_range*qscaley]);
datetick('x');

 alti=['Altitude ',niveau,' (m)'];
  ylabel(alti);
  xlabel(' Time (UTC)');
  
  if jj(1)==jj(nb_file)
 title(['Time height section of wind direction and vertical wind speed at ',location,' (',datestr(datenum(aa(1),mm(1),jj(1)),20),')' ]);
  end;
if jj(1)~=jj(nb_file)
 title(['Time height section of wind direction and vertical wind speed at ',location,...
     ' (',datestr(datenum(aa(1),mm(1),jj(1)),20),'-',datestr(datenum(aa(nb_file),mm(nb_file),jj(nb_file)),20),')' ]);
  end;
  
  imageok=[chemin2,'0CHT_Vz_DIR_',datestr(datenum(aa(1),mm(1),jj(1)),1),'.png'];
 print (figure(5),'-dpng','-r500',imageok);

  
  %***********************************%Dispersion vitesse radiale***********
figure(6);
 surf(xdate(1:gap_tps:size_x),z1_dvr(1:gap_alti:nn,1:gap_tps:size_x).*qscaley,dvr(1:gap_alti:nn,1:gap_tps:size_x),'EdgeLighting','phong','LineStyle','none'); 
 shading interp
 view(0,90); 
 caxis([0 max_dvr])
 colorbar;
 hold on
  h1 = quiver3(date_dir(1:gap_alti:nn,1:gap_tps:size_x),z1_dir(1:gap_alti:nn,1:gap_tps:size_x).*qscaley,tz(1:gap_alti:nn,1:gap_tps:size_x),...
  u_dir(1:gap_alti:nn,1:gap_tps:size_x)./qscale1,v_dir(1:gap_alti:nn,1:gap_tps:size_x)./qscale1,tz(1:gap_alti:nn,1:gap_tps:size_x),size_arrow,'k');

set(gca,'YTick',z1_dir(1:gaptick_alti:nn,1)'.*qscaley);
set(gca,'YTickLabel',(100:res*gaptick_alti:max_range));% De 100 m à 3000 m
ylim([0 max_range*qscaley]);
datetick('x');

if jj(1)==jj(nb_file)
 title(['Time height section of wind direction and wind speed dispersion at ',location,' (',datestr(datenum(aa(1),mm(1),jj(1)),20),')' ]);
  end;
if jj(1)~=jj(nb_file)
 title(['Time height section of wind direction and wind speed dispersion at ',location,...
     ' (',datestr(datenum(aa(1),mm(1),jj(1)),20),'-',datestr(datenum(aa(nb_file),mm(nb_file),jj(nb_file)),20),')' ]);
  end;

imageok=[chemin2,'0CHT_DVR_DIR_',datestr(datenum(aa(1),mm(1),jj(1)),1),'.png'];
 print (figure(6),'-dpng','-r500',imageok);

 %*************************************************************************








