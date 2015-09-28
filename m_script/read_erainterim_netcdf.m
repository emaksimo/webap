% read era interim NetCDF files
% variables : U, V and Geopotential (mb)
% at two pressure levels
% one month data file, 0.75 deg lat x 0.75 deg lon, global
% downloaded from :
% http://apps.ecmwf.int/datasets/data/interim-full-daily/?levtype=pl
% data are obtained at pressure levels
% fout rimes daily : at 00, 06, 12 and 18 GMT 
% each value is the average for the last 10 min preceeding the analysis

clear all 
close all

startup ; 
%%% reference measurement site lat and lon coordinates
% if you want to get the wind data at the closest grid point, for ex

lar = 14.5; % N 
lor = -17.5 ; % E

core_dir = '/home/elena/Downloads/';
fname = 'erai_feb2015.nc';
fullfile(core_dir,fname);
mon = 2; % in my example I took the month of February

%%% get the information about variable names (u,v,z,...) and their dimentions 
%NC = ncinfo(fullfile(core_dir,fname)) 

Z = ncread(fullfile(core_dir,fname),'z',[1 1 1 1],[inf inf inf inf])/10;  % Geopotential is initially in [dkm] units
%%% height of a pressure surface above the sea-level
%%% here Z(:,:,2,:) = heigh of XXXX pressure level 

U = ncread(fullfile(core_dir,fname),'u',[1 1 1 1],[inf inf inf inf]); % get in matlab the entire matrice 'u'
V = ncread(fullfile(core_dir,fname),'v',[1 1 1 1],[inf inf inf inf]);

lon = double(ncread(fullfile(core_dir,fname),'longitude',1,inf)); 
lat = double(ncread(fullfile(core_dir,fname),'latitude',1,inf));   
L = ncread(fullfile(core_dir,fname),'level',1,inf); 
TI  = ncread(fullfile(core_dir,fname),'time',1,inf);
time=datevec(double(TI)/24+datenum(1900,1,1)); 


%%%%%%%%%%%%%%%%% altitude - day cross-section quiver plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% create a time serie for the altitude - day cross-section plot
% %%% so that day 1 06:00 GMT = 0.25, day 2 00:00 GMT == 2, day 2 12:00 GMT = 2.5 ...
% tp = plus(time(:,3),time(:,4)./24); 
% 
% %%% coordinates of the grid point closest to reference measurement site 
clo = find(lon <= lor+0.25 & lon >= lor-0.25) ; % 43.5
cla = find(lat <= lar+0.25 & lat >= lar-0.25) ; % 5.25
 
% Zup  = reshape(Z(clo,cla,1,:),[size(tp) 1]); % vector of altitudes for 900 mb level
% Zlow = reshape(Z(clo,cla,2,:),[size(tp) 1]); % vector of altitudes for 925 mb level 
% 
% %%% normalize the wind vector by the wind speed, so that we could plot the wind direction only
% du = reshape(U(clo,cla,1,:),[size(tp) 1]); % U(clo,cla,1,:) = at 900mb
% dv = reshape(V(clo,cla,1,:),[size(tp) 1]);
% un1 = du./sqrt(du.^2+dv.^2);
% vn1 = dv./sqrt(du.^2+dv.^2);
% 
% figure(1);
% set(gcf,'PaperType','A4','PaperUnits','centimeters','Units','centimeters','PaperSize',[40 20],'Position',[0 0 40 20]); hold on
% subplot('position', [0.05 0.1 0.94 0.87]); hold on;  
%     
% %%% chose what period do we plot ?
% cp = 1 ; % day of month = 1
% pp = 30 ; % day of month = 30
% 
% %%% to plot the quiver we need the same scale in Ax (1 - 31 days) and Ay dimentions
% %%% difference in altitude of HXXX surface
% dp = (minus(ceil(max(Zup)),floor(min(Zup))))/minus(pp,cp); % step along Ay dimention of the plot
% 
% a1 = quiver(tp,Zup/dp,un1,vn1,0.4,'color','k'); hold on % 900mb
% set(gca,'ylim',[floor(min(Zup/dp)) ceil(max(Zup/dp))],'ytick', floor(min(Zup/dp)) : 1 : ceil(max(Zup/dp)),'yticklabel', floor(min(Zup)) : dp : ceil(max(Zup))+10);  
% ylabel('altitude above the sea-level [meters]');
% xlabel('day of month'); 
% box on; grid on ;


%%%%%%%%%%%%%%%%%%%% regional map of the wind (for a given day and time of the day)   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% define the lat-lon domain for the map

latmi = 2;  % southern limit of the study area [deg N]
latma = 30; % northern limit of the study area [deg N]
lonmi = -30;  % western limit of the study area [deg W]
lonma = -1; % eastern limit of the study area [deg E]

%%% define day and time
day = 1;
tm = 12; % GMT
lev = 1; % see 'level'  variable

st = find(time(:,2) == mon & time(:,3) == day & time(:,4) == tm ) ; 

D  =  round(reshape(Z(:,:,lev,st),[size(Z,1) size(Z,2)])); 
U1 = reshape(U(:,:,lev,st),[size(Z,1) size(Z,2)]); 
V1 = reshape(V(:,:,lev,st),[size(Z,1) size(Z,2)]); 

lon(find(lon > 180)) = lon(find(lon > 180)) - 360; % western hemisphere = negative longitude
lo = [max(lon(find(lon < lonmi))) min(lon(find(lon > lonma)))];
loi = [find(lon == lo(1)) find(lon == lo(2))];

la = [max(lat(find(lat < latmi))) min(lat(find(lat > latma))) ] ;
lai = [find(lat == la(1)) find(lat == la(2))];
    
P = D(loi(1):loi(2),lai(2):lai(1));
PU = U1(loi(1):loi(2),lai(2):lai(1));
PV = V1(loi(1):loi(2),lai(2):lai(1));

for j = 1 : size(P,2)
    LO(j,:) = [lon(loi(1):loi(2))];
end

for i = 1 : size(P,1)
    LA(:,i) = lat(lai(2):lai(1));
end           

for i = 1 : size(P,1)
    for j = 1 : size(P,2)
        H(j,i) = P(i,j);
        U900(j,i) = PU(i,j);
        V900(j,i) = PV(i,j);
    end
end

figure(1);
subplot('position',[0.01 0.1 0.9 0.9]); box off ;
set(gca,'visible','off');
set(gcf,'color','w');
axesm('MapProjection','lambert','MapLatLimit',[latmi latma],'MapLonLimit',[lonmi lonma],'PlineLocation',5,'MlineLocation',5); hold on   
quiverm(LA,LO,V900,U900,'k'); hold on;
geoshow('landareas.shp','Facecolor','none'); hold on    
setm(gca,'GLineWidth',1.5,'fontsize',10,'meridianlabel','on','parallellabel','on');  gridm on; framem('on');
textm(lar,lor,'x','FontSize',14,'Color','r');   
dp = minus(max(max(H)),min(min(H)))/10;
contourm(LA,LO,H,min(min(H)):dp:max(max(H))); 
textm(latma-3,lonma+1.5,{['Era Interim '];['H' num2str(L(lev)) ];['geopotential (contour)'];['wind direction (arrows)'];[ num2str(time(st,4)) ':00GMT '];[ num2str(time(st,3)) '/' num2str(time(st,2)) '/' num2str(time(st,1)) ]},'FontSize',12,'color','k');  hold on     %


