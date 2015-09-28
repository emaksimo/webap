
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
 
 nb_liss=25;
 nb_liss2=11;
 nbr=59;
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

nbaz=length(azcol);

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
       for j=1:ncol,
        el(k,j)=elcol(k); 
        az(k,j)=azcol(k);
        d1(k,j)=r_0(k,j).*sin(az(k)*pi/180);
        z1(k,j)=r_0(k,j).*cos(az(k)*pi/180);
       end;
     end;
 
   colordef black
      %whitebg('k')

%%%%%%%%%%%%%Radial wind speed%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_col=8;
compteur=1;
for i=num_col:nb_par:size(cc,2)
 vr(:,compteur)=cc(:,i);
 compteur=compteur+1;
end;
vr(cnr<=seuil_cnr)=NaN;
for k=1:nbr

vr1(:,k)=smooth(vr(:,k),nb_liss);
az1(:,k)=az(:,k);

% figure(29)
% plot(vr(:,k),'o-k');
 %hold on
 %plot(vr1,'o-r');

end;




 
 
%%%%%%%%%%%%%Radial wind speed DISPERSION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_col=9;
compteur=1;
for i=num_col:nb_par:size(cc,2)
 dvr(:,compteur)=cc(:,i);
 compteur=compteur+1;
end;
dvr(cnr<=seuil_cnr)=NaN;




% 
trace0=0;
if trace0==1
figure(290)
  plot(vr(:,2),'o-G');
  hold on
  plot(vr1(:,2),'o-r');
end; 


% figure(30)
% plot(az1,vr1,'o-r');
% hold on
%%%%%******************************%FFT method
% Y1=fft(vr1);
% Y1(1)=[];

% 
% figure(31)
% plot(Y1,'ok');
% title('Fourier Coefficients in the Complex Plane');
% xlabel('Real Axis');
% ylabel('Imaginary Axis');

% 
% n=length(Y1);
% power = abs(Y1(1:floor(n/2))).^2;
% nyquist = 1/2;
% freq = (1:n/2)/(n/2)*nyquist;
% 
% figure(32)
% plot(freq,power,'o-k')
% xlabel('Frequence')
% title('Power Spectrum')
% 
% nbfx=30;
% % figure(33)
% % plot(freq(1:nbfx),power(1:nbfx),'o-k')
% % xlabel('Frequence')
% 
% figure(34)% 
%  period=1./freq;
%  plot(period,power,'o-r');
%  %axis([0 360 0 2e+5]);
%  ylabel('Power');
%  xlabel('Index)');
% % 
% 
%  hold on;
%  index=find(power==max(power));
%  mainPeriodStr=num2str(period(index));
%  plot(period(index),power(index),'r.', 'MarkerSize',25);
%  text(period(index)+2,power(index),['Period = ',mainPeriodStr]);
%  hold off;
%  
%  afft=((1/n).*fft(Y1)) ;%oef decomp
%  af=abs((1/n)*fft(Y1)); 
%  
 
 
 
 
 %%%%%%*******************VAD method (2)
 %vh1=(max(vr1)-min(vr1))./(2.*cos(el(1).*pi./180));
 ni=1;
 
 uu2(:,ni)=sum(vr1(:,ni).*cos(az(:,ni).*pi/180))./sum(cos(az(:,ni).*pi/180).*cos(az(:,ni).*pi/180));
 vv2(:,ni)=sum(vr1(:,ni).*sin(az(:,ni).*pi/180))./sum(sin(az(:,ni).*pi/180).*sin(az(:,ni).*pi/180));
 
 vh2=sqrt(uu2.^2+vv2.^2);
 dir2=atan2(vv2,uu2)*180/pi+180;
 

 
  %%%%%%*******************VAP method (3)**************************
  k=1;
  
 delta_az=az(2,1)-az(1,1);
 
 for i=1:nbaz-1
     for k=1:nbr %size(vr1,2)
 uu3(i,k)=-(vr1(i+1,k).*sin(az(i,k).*pi./180)-vr1(i,k).*sin(az(i+1,k).*pi./180))./sin(delta_az.*pi./180);
 vv3(i,k)=(vr1(i+1,k).*cos(az(i,k).*pi./180)-vr1(i,k).*cos(az(i+1,k).*pi./180))./sin(delta_az.*pi./180);

   end;
   
     end; 
  
     %i=nbaz;
  for k=1:nbr
 %uu3(nbaz,k)=-(vr1(1,k).*sin(az(nbaz,k).*pi./180)-vr1(nbaz,k).*sin(az(1,k).*pi./180))./sin(delta_az.*pi./180);
 %vv3(nbaz,k)=(vr1(1,k).*cos(az(nbaz,k).*pi./180)-vr1(nbaz,k).*cos(az(1,k).*pi./180))./sin(delta_az.*pi./180);
 uu3(nbaz,k)=NaN;
 vv3(nbaz,k)=NaN;
  end;
  
  
vh3=sqrt(uu3.^2+vv3.^2);
dir3=atan2(vv3,uu3)*180/pi+180;
  
%   
%   
% uu3_moy=mean(uu3);
% vv3_moy=mean(vv3);
% vh3_moy=mean(vh3);
% dir3_moy=atan2(vv3_moy,uu3_moy)*180/pi+180;




for i=1:nbaz
    sdir3(i,:)=smooth(dir3(i,:),nb_liss2);
    svh3(i,:)=smooth(vh3(i,:),nb_liss2);    
end;


sdir3(cnr<=seuil_cnr)=NaN;
vh3(cnr<=seuil_cnr)=NaN;
svh3(cnr<=seuil_cnr)=NaN;


%***********************Correction*****************

%svh3=svh3_0.*cos(el(1,1).*pi./180);
%

nj=2;
trace=0;
if trace==1

% figure(100)
% plot(uu3(nj,:),'*-y')
% hold on
% plot(vv3(nj,:),'*-g')
% hold on

figure(100)
plot(uu3(nj,:),'*-y')
hold on
plot(vv3(nj,:),'*-g')
hold on


figure(101)
plot(vr1(nj,:),'*-y')
hold on
plot(vr1(nj,:),'*-g')
hold on
    
figure(36)
plot(dir3(nj,:),'*-b')
hold on
plot(sdir3(nj,:),'*-r')
title ('Wind direction')
hold on



figure(37)
plot(vh3(nj,:),'*-b')
hold on
plot(svh3(nj,:),'*-r')
title ('Horizontal wind speed')

hold on

% 
% figure(370)
% plot(vh3(nj,:),'*-b')
% hold on
% plot(svh3(nj,:),'*-r')
% title ('Horizontal wind speed')
% hold on
% %plot(svh3(nj+1,:),'*-y')


figure(371)
plot(cnr(nj,:),'*-b')
hold on
%plot(cnr(nj+1,:),'*-y')
hold on


figure(372)
plot(vr1(nj,:),'*-b')
hold on
%plot(vr1(nj+1,:),'*-y')
hold on


end;

%********************Scan DIRECTION*********************


clf (figure(38))
figure(38)
 surf(d1(1:nbaz,1:nbr),z1(1:nbaz,1:nbr),sdir3(1:nbaz,1:nbr),'EdgeLighting','phong','LineStyle','none'); 
title([mode, ' of wind direction [�] at ',location,' (',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
    ' -',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
    ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20),') ']);
 shading interp
view(0,90);
caxis([0 359]);
axis equal;
xlabel(['     Range West / East ', '(m)']);
ylabel(['     Range South / North ', '(m)']);
xlim([-max_range1 max_range1]);%complet
ylim([-max_range1 max_range1]);%complet
hold on
box on;
grid off;


colorbar;

%orientation_RHI;
axe_PPI;

 u_dir=-sin((sdir3).*pi/180);
 v_dir=-cos((sdir3).*pi/180);
 tz=u_dir.*0+500;
 
 
 dep_r0=5;
 nbr0=15;
 gap_r0=5;
 gap_az0=45;%45
 
 dep_r1=10;
 dep_az1=22;
 nbr1=15;
 gap_r1=5;
 gap_az1=45;
 
% dep_r2=nbr1+gap_r1;
 dep_r2=20;
 nbr2=nbr;
 gap_r2=5;
 gap_az2=11;
 
 %qscaley=0.0001;
 qscale1=0.01; % scaling factor for all vectors
 qscale0=0.007;
 % scaling factor for all vectors
 size_arrow=0.5;
 size_arrow0=size_arrow;
 
 
  
 h0=quiver3(d1(1:gap_az0:nbaz,dep_r0:gap_r0:nbr0),z1(1:gap_az0:nbaz,dep_r0:gap_r0:nbr0),tz(1:gap_az0:nbaz,dep_r0:gap_r0:nbr0)...
     ,u_dir(1:gap_az0:nbaz,dep_r0:gap_r0:nbr0)./qscale0,v_dir(1:gap_az0:nbaz,dep_r0:gap_r0:nbr0)./qscale0,tz(1:gap_az0:nbaz,dep_r0:gap_r0:nbr0),size_arrow0,'k');
 
 hold on
 
  h1=quiver3(d1(dep_az1:gap_az1:nbaz,dep_r1:gap_r1:nbr1),z1(dep_az1:gap_az1:nbaz,dep_r1:gap_r1:nbr1),tz(dep_az1:gap_az1:nbaz,dep_r1:gap_r1:nbr1)...
      ,u_dir(dep_az1:gap_az1:nbaz,dep_r1:gap_r1:nbr1)./qscale1,v_dir(dep_az1:gap_az1:nbaz,dep_r1:gap_r1:nbr1)./qscale1,tz(dep_az1:gap_az1:nbaz,dep_r1:gap_r1:nbr1),size_arrow,'k');

 hold on
  
 h2=quiver3(d1(1:gap_az2:nbaz,dep_r2:gap_r2:nbr2),z1(1:gap_az2:nbaz,dep_r2:gap_r2:nbr2),tz(1:gap_az2:nbaz,dep_r2:gap_r2:nbr2)...
     ,u_dir(1:gap_az2:nbaz,dep_r2:gap_r2:nbr2)./qscale1,v_dir(1:gap_az2:nbaz,dep_r2:gap_r2:nbr2)./qscale1,tz(1:gap_az2:nbaz,dep_r2:gap_r2:nbr2),size_arrow,'k');
 
 hold on;
axis equal
 
 xlim([-max_range1 max_range1]);%complet
ylim([-max_range1 max_range1]);%complet

 
 axe_PPI;
   titre1=['PPI_',num2str(round(el(1))),'_',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),31),'-',datestr(datenum(aa(nbline),...
    mm(nbline),jj(nbline),hh(nbline),mn(nbline),ss(nbline)),13)];   
imageok=[chemin2,'VA_DIR_',titre1,'.png'];
%imageokbis=[chemin2bis,'CNRR_',titre1,'.eps'];

set(gcf,'InvertHardcopy','off')
print (figure(38),'-dpng','-r500',imageok);

 
 
%********************Scan Radial wind speed*********************
 
 

clf (figure(39))
 figure(39)
 surf(d1(1:nbaz,1:nbr),z1(1:nbaz,1:nbr),vr(1:nbaz,1:nbr),'EdgeLighting','phong','LineStyle','none'); 
title([mode, ' of radial wind speed [m/s] at ',location,' (',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
    ' -',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
    ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20),') ']);
 shading interp
view(0,90);
caxis([-max_vr max_vr]);

axis equal;
xlabel(['     Range West / East ', '(m)']);
ylabel(['     Range South / North ', '(m)']);
xlim([-max_range1 max_range1]);%complet
ylim([-max_range1 max_range1]);%complet

box on;
grid off;

hold on
colorbar;

  
 h0=quiver3(d1(1:gap_az0:nbaz,dep_r0:gap_r0:nbr0),z1(1:gap_az0:nbaz,dep_r0:gap_r0:nbr0),tz(1:gap_az0:nbaz,dep_r0:gap_r0:nbr0)...
     ,u_dir(1:gap_az0:nbaz,dep_r0:gap_r0:nbr0)./qscale0,v_dir(1:gap_az0:nbaz,dep_r0:gap_r0:nbr0)./qscale0,tz(1:gap_az0:nbaz,dep_r0:gap_r0:nbr0),size_arrow0,'k');
 
 hold on
 
  h1=quiver3(d1(dep_az1:gap_az1:nbaz,dep_r1:gap_r1:nbr1),z1(dep_az1:gap_az1:nbaz,dep_r1:gap_r1:nbr1),tz(dep_az1:gap_az1:nbaz,dep_r1:gap_r1:nbr1)...
      ,u_dir(dep_az1:gap_az1:nbaz,dep_r1:gap_r1:nbr1)./qscale1,v_dir(dep_az1:gap_az1:nbaz,dep_r1:gap_r1:nbr1)./qscale1,tz(dep_az1:gap_az1:nbaz,dep_r1:gap_r1:nbr1),size_arrow,'k');

 hold on
  
 h2=quiver3(d1(1:gap_az2:nbaz,dep_r2:gap_r2:nbr2),z1(1:gap_az2:nbaz,dep_r2:gap_r2:nbr2),tz(1:gap_az2:nbaz,dep_r2:gap_r2:nbr2)...
     ,u_dir(1:gap_az2:nbaz,dep_r2:gap_r2:nbr2)./qscale1,v_dir(1:gap_az2:nbaz,dep_r2:gap_r2:nbr2)./qscale1,tz(1:gap_az2:nbaz,dep_r2:gap_r2:nbr2),size_arrow,'k');
 
 hold on;
axis equal
 
 xlim([-max_range1 max_range1]);%complet
ylim([-max_range1 max_range1]);%complet

 
 axe_PPI;
   titre1=['PPI_',num2str(round(el(1))),'_',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),31),'-',datestr(datenum(aa(nbline),...
    mm(nbline),jj(nbline),hh(nbline),mn(nbline),ss(nbline)),13)];   
imageok=[chemin2,'VA_VR_',titre1,'.png'];
%imageokbis=[chemin2bis,'CNRR_',titre1,'.eps'];

set(gcf,'InvertHardcopy','off')
print (figure(39),'-dpng','-r500',imageok);

%********************Scan Horizontal wind speed*********************
 

clf (figure(40))
 figure(40)
 surf(d1(1:nbaz,1:nbr),z1(1:nbaz,1:nbr),svh3(1:nbaz,1:nbr),'EdgeLighting','phong','LineStyle','none'); 
title([mode, ' of horizontal wind speed [m/s] at ',location,' (',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
    ' -',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
    ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20),') ']);
 shading interp
view(0,90);
caxis([0 10]);

axis equal;
xlabel(['     Range West / East ', '(m)']);
ylabel(['     Range South / North ', '(m)']);
xlim([-max_range1 max_range1]);%complet
ylim([-max_range1 max_range1]);%complet

box on;
grid off;

hold on
colorbar;

  
 h0=quiver3(d1(1:gap_az0:nbaz,dep_r0:gap_r0:nbr0),z1(1:gap_az0:nbaz,dep_r0:gap_r0:nbr0),tz(1:gap_az0:nbaz,dep_r0:gap_r0:nbr0)...
     ,u_dir(1:gap_az0:nbaz,dep_r0:gap_r0:nbr0)./qscale0,v_dir(1:gap_az0:nbaz,dep_r0:gap_r0:nbr0)./qscale0,tz(1:gap_az0:nbaz,dep_r0:gap_r0:nbr0),size_arrow0,'k');
 
 hold on
 
  h1=quiver3(d1(dep_az1:gap_az1:nbaz,dep_r1:gap_r1:nbr1),z1(dep_az1:gap_az1:nbaz,dep_r1:gap_r1:nbr1),tz(dep_az1:gap_az1:nbaz,dep_r1:gap_r1:nbr1)...
      ,u_dir(dep_az1:gap_az1:nbaz,dep_r1:gap_r1:nbr1)./qscale1,v_dir(dep_az1:gap_az1:nbaz,dep_r1:gap_r1:nbr1)./qscale1,tz(dep_az1:gap_az1:nbaz,dep_r1:gap_r1:nbr1),size_arrow,'k');

 hold on
  
 h2=quiver3(d1(1:gap_az2:nbaz,dep_r2:gap_r2:nbr2),z1(1:gap_az2:nbaz,dep_r2:gap_r2:nbr2),tz(1:gap_az2:nbaz,dep_r2:gap_r2:nbr2)...
     ,u_dir(1:gap_az2:nbaz,dep_r2:gap_r2:nbr2)./qscale1,v_dir(1:gap_az2:nbaz,dep_r2:gap_r2:nbr2)./qscale1,tz(1:gap_az2:nbaz,dep_r2:gap_r2:nbr2),size_arrow,'k');
 
 hold on;
axis equal
 
 xlim([-max_range1 max_range1]);%complet
ylim([-max_range1 max_range1]);%complet

 
 axe_PPI;
 
   titre1=['PPI_',num2str(round(el(1))),'_',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),31),'-',datestr(datenum(aa(nbline),...
    mm(nbline),jj(nbline),hh(nbline),mn(nbline),ss(nbline)),13)];   
imageok=[chemin2,'VA_VH_',titre1,'.png'];

set(gcf,'InvertHardcopy','off')
print (figure(40),'-dpng','-r500',imageok);

 
 %********************Scan CNR*********************

clf (figure(41))
 figure(41)
 surf(d1(1:nbaz,1:nbr),z1(1:nbaz,1:nbr),cnr(1:nbaz,1:nbr),'EdgeLighting','phong','LineStyle','none'); 
title([mode, ' of CNR [dB] at ',location,' (',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
    ' -',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
    ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20),') ']);
 shading interp
view(0,90);
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



  
 h0=quiver3(d1(1:gap_az0:nbaz,dep_r0:gap_r0:nbr0),z1(1:gap_az0:nbaz,dep_r0:gap_r0:nbr0),tz(1:gap_az0:nbaz,dep_r0:gap_r0:nbr0)...
     ,u_dir(1:gap_az0:nbaz,dep_r0:gap_r0:nbr0)./qscale0,v_dir(1:gap_az0:nbaz,dep_r0:gap_r0:nbr0)./qscale0,tz(1:gap_az0:nbaz,dep_r0:gap_r0:nbr0),size_arrow0,'k');
 
 hold on
 
  h1=quiver3(d1(dep_az1:gap_az1:nbaz,dep_r1:gap_r1:nbr1),z1(dep_az1:gap_az1:nbaz,dep_r1:gap_r1:nbr1),tz(dep_az1:gap_az1:nbaz,dep_r1:gap_r1:nbr1)...
      ,u_dir(dep_az1:gap_az1:nbaz,dep_r1:gap_r1:nbr1)./qscale1,v_dir(dep_az1:gap_az1:nbaz,dep_r1:gap_r1:nbr1)./qscale1,tz(dep_az1:gap_az1:nbaz,dep_r1:gap_r1:nbr1),size_arrow,'k');

 hold on
  
 h2=quiver3(d1(1:gap_az2:nbaz,dep_r2:gap_r2:nbr2),z1(1:gap_az2:nbaz,dep_r2:gap_r2:nbr2),tz(1:gap_az2:nbaz,dep_r2:gap_r2:nbr2)...
     ,u_dir(1:gap_az2:nbaz,dep_r2:gap_r2:nbr2)./qscale1,v_dir(1:gap_az2:nbaz,dep_r2:gap_r2:nbr2)./qscale1,tz(1:gap_az2:nbaz,dep_r2:gap_r2:nbr2),size_arrow,'k');
 
 hold on;
axis equal
 
 xlim([-max_range1 max_range1]);%complet
ylim([-max_range1 max_range1]);%complet

 
 axe_PPI;
 
  titre1=['PPI_',num2str(round(el(1))),'_',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),31),'-',datestr(datenum(aa(nbline),...
    mm(nbline),jj(nbline),hh(nbline),mn(nbline),ss(nbline)),13)];   
imageok=[chemin2,'VA_CNR_',titre1,'.png'];
%imageokbis=[chemin2bis,'CNRR_',titre1,'.eps'];

set(gcf,'InvertHardcopy','off')
print (figure(41),'-dpng','-r500',imageok);






% %$$$$$$$$$$$$$$$$$$$$$$$$$$ SCAN DVR $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
clf (figure(42)) 
figure(42)
 surf(d1(1:nbaz,1:nbr),z1(1:nbaz,1:nbr),dvr(1:nbaz,1:nbr),'EdgeLighting','phong','LineStyle','none'); 
title([mode, ' of radial wind dispersion [m/s] at ',location,' (',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
    ' -',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
    ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20),') ']);
 shading interp
view(0,90);
caxis([0 max_dvr]);

axis equal;
xlabel(['     Range West / East ', '(m)']);
ylabel(['     Range South / North ', '(m)']);
xlim([-max_range1 max_range1]);%complet
ylim([-max_range1 max_range1]);%complet

box on;
grid off;

hold on
colorbar;

  
 h0=quiver3(d1(1:gap_az0:nbaz,dep_r0:gap_r0:nbr0),z1(1:gap_az0:nbaz,dep_r0:gap_r0:nbr0),tz(1:gap_az0:nbaz,dep_r0:gap_r0:nbr0)...
     ,u_dir(1:gap_az0:nbaz,dep_r0:gap_r0:nbr0)./qscale0,v_dir(1:gap_az0:nbaz,dep_r0:gap_r0:nbr0)./qscale0,tz(1:gap_az0:nbaz,dep_r0:gap_r0:nbr0),size_arrow0,'k');
 
 hold on
 
  h1=quiver3(d1(dep_az1:gap_az1:nbaz,dep_r1:gap_r1:nbr1),z1(dep_az1:gap_az1:nbaz,dep_r1:gap_r1:nbr1),tz(dep_az1:gap_az1:nbaz,dep_r1:gap_r1:nbr1)...
      ,u_dir(dep_az1:gap_az1:nbaz,dep_r1:gap_r1:nbr1)./qscale1,v_dir(dep_az1:gap_az1:nbaz,dep_r1:gap_r1:nbr1)./qscale1,tz(dep_az1:gap_az1:nbaz,dep_r1:gap_r1:nbr1),size_arrow,'k');

 hold on
  
 h2=quiver3(d1(1:gap_az2:nbaz,dep_r2:gap_r2:nbr2),z1(1:gap_az2:nbaz,dep_r2:gap_r2:nbr2),tz(1:gap_az2:nbaz,dep_r2:gap_r2:nbr2)...
     ,u_dir(1:gap_az2:nbaz,dep_r2:gap_r2:nbr2)./qscale1,v_dir(1:gap_az2:nbaz,dep_r2:gap_r2:nbr2)./qscale1,tz(1:gap_az2:nbaz,dep_r2:gap_r2:nbr2),size_arrow,'k');
 
 hold on;
axis equal
 
 xlim([-max_range1 max_range1]);%complet
ylim([-max_range1 max_range1]);%complet

 
 axe_PPI;
 titre1=['PPI_',num2str(round(el(1))),'_',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),31),'-',datestr(datenum(aa(nbline),...
    mm(nbline),jj(nbline),hh(nbline),mn(nbline),ss(nbline)),13)];   
imageok=[chemin2,'VA_DVR_',titre1,'.png'];
%imageokbis=[chemin2bis,'CNRR_',titre1,'.eps'];

set(gcf,'InvertHardcopy','off')
print (figure(42),'-dpng','-r500',imageok);


 
%  figure(35)
%  plot(uu,'o-m')
%  hold on;
%  plot(vv,'o-c');
% %  
%  figure(35)
% nn = pow2(nextpow2(n));
%  Y2=fft(vr1,nn);

% 
% 
%  p2bis=Y2.*conj(Y2)/nn;
% f = (0:nn-1)*(1/nn);
% plot(f,p2bis);
% 
% 
% m = length(Y1);
% M = floor((m+1)/2);
% a0 = Y1(1)/n;
% %a0 = d(1)/m; 
% %an = 2*real(d(2:M))/m;
% an = 2*real(Y1(2:M))/m;
% 
% %a6 = d(M+1)/m;
% %bn = -2*imag(d(2:M))/m;
% 
% 

 clear el elcol az azcol z1 r_0 d1 dte0 root nline0 dte sdte aa  mm jj hh mn ss ho h1 h2
 clear xdate nb_porte nbline cc gps int_temp ext_temp press hum u_dir v_dir vh3 svh3 
 clear cnr vr dvr titre1 imageok imageokbis alti tz vr1 az1
%  
%  