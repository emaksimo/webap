%%% compare ERAI H700 and AROME-WMED wind vectors at 3km

clear all
close all
startup ; 

%%%  at 3 km ~= 700mb
lev = 5; % for ERAI
alt = 20; % for AROME-WMED

%%%% define the common lat-lon domain (exactly == AROME limits)
latmi = 34.5;  % southern limit of the study area [deg N]
latma = 47.5; % northern limit of the study area [deg N]
lonmi = -8.5;  % western limit of the study area [deg W]
lonma = 16.75; % eastern limit of the study area [deg E]

%%% define day and time
mon = 10;
day = 7;
tm = 18;

%%% get ERAI geopotential (z), U and V components

main = (['/./media/elena/Transcend/Hymex/ERAI/']);
rep=dir(main);
var = [500 700 850 950 1000];
par = {'msl','u','v','w','t','q','z','time'};
pp = 7; % chose this meteo parameter
ix = 0 ; 

for ii = 3 : length(rep)  
     clear rep2 D TI TM zl gptlev lon lat TY time DD  ERAI Hd P
     rep2 = dir([main rep(ii).name ]);
     NC = ncinfo([main rep(ii).name ]);
%     NC.Variables.Name
     %NC.Variables.Attributes
     for lm = 1 : size(NC.Variables,2)
        if strncmp(NC.Variables(lm).Name,par(pp),1) == 1   
            ix = 1;
            break % lm loop
        end
     end
     if ix == 0
         continue % ii (file) loop
     end
     
     gptlev = double(ncread([main rep(ii).name ],'level',1,inf)) ;
     zl = find(gptlev == var(lev));
     
     lon = double(ncread([main rep(ii).name ],'longitude',1,inf));  
     lat = double(ncread([main rep(ii).name ],'latitude',1,inf));  
     TI  = ncread([main rep(ii).name ],'time',1,inf);
     time=datevec(double(TI)/24+datenum(1900,1,1));   
    
     st = find(time(:,2) == mon & time(:,3) == day & time(:,4) == tm ) ; 

     D = squeeze((ncread([main rep(ii).name ],NC.Variables(lm).Name,[1 1 zl 1],[inf inf 1 inf]))/100); 

%      for lev  = 1 : 4  % if length(var) > 1

    lon(find(lon > 180)) = lon(find(lon > 180)) - 360; % western hemisphere = negative longitude
    
  
    lo = [max(lon(find(lon < lonmi))) min(lon(find(lon > lonma)))];
    loi = [find(lon == lo(1)) find(lon == lo(2))];

    la = [max(lat(find(lat < latmi))) min(lat(find(lat > latma))) ] ;
    lai = [find(lat == la(1)) find(lat == la(2))];
    P = cat(1,D(loi(1):length(lon),lai(2):lai(1),st), D(1:loi(2),lai(2):lai(1),st));

    for j = 1 : size(P,2)
        LO(j,:) = [lon(loi(1):length(lon));lon(1:loi(2))];
    end

    for i = 1 : size(P,1)
        LA(:,i) = lat(lai(2):lai(1));
    end

    for i = 1 : size(P,1)
        for j = 1 : size(P,2)
            ERAI(j,i) = P(i,j,1); % 6-hourly reanalysis, rotate dimentions
        end
    end
    
    
    clear lon lat lo loi DD lai loi P
                
%         save(['/./media/Transcend/Hymex/ASCII/' strvcat(var(lev)) '_6hdaily_y2012_SeptOct.mat'], 'H', 'Hd','LO','LA','time')
%         ['/./media/Transcend/Hymex/ASCII/' strvcat(var(lev)) '_6hdaily_y2012_SeptOct.mat']
%         [ min(min(min(Hd))), mean(mean(mean(Hd))), max(max(max(Hd)))]
%          keyboard
% %      end 

      break
end

%%

%%% get AROME data, see   read_aromewmed_all.m
if mon < 10
      mmon = [num2str(0), num2str(mon)];
else
      mmon = num2str(mon);
end

if day < 10
      dday = [num2str(0), num2str(day)];
else
      dday = num2str(day);
end

if tm < 10
      H = [num2str(0), num2str(tm)];
else
      H = num2str(tm);
end
                                  
core_dir = '/media/elena/SAMSUNG/AROME-WMED-REANALYSIS/matfile/';
if exist(fullfile(core_dir,['aromewmed_analysis_2012', strvcat(mmon), strvcat(dday), '_' , strvcat(H), 'GMT_U.mat'])) == 2
    load(fullfile(core_dir,['aromewmed_analysis_2012', strvcat(mmon), strvcat(dday), '_' , strvcat(H), 'GMT_U.mat'])) ; 
    load(fullfile(core_dir,['aromewmed_analysis_2012', strvcat(mmon), strvcat(dday), '_' , strvcat(H), 'GMT_V.mat'])) ; 
    % 'V','lati','loni','alti','day','mon','data_description'
end

WS = sqrt((U(:,:,find(alti == alt))).^2 + (V(:,:,find(alti == alt))).^2 );

%%

clf (figure(1))
figure(1);
load coast
%set(gcf,'PaperType','A4','PaperUnits','centimeters','Units','centimeters','PaperSize',[25 15],'Position',[40 25 25 15]); hold on
% positionvector = [.05 .05 .9 .9];
% subplot('position',positionvector); hold on;
%axesm('MapProjection','lambert','MapLatLimit',[34 47],'MapLonLimit',[-8 17]); %,'PlineLocation',5,'MlineLocation',5); hold on   
 
pcolor(loni,lati,WS); shading flat; hold on  % ERAI
caxis([0 20]); % m/s
colorbar
% contourm(LA,LO,round(ERAI),nanmin(nanmin(round(ERAI))):2:nanmax(nanmax(round(ERAI))),'showtext','off','fill','off','linewidth',1,'color','k'); hold on;
contourm(LA,LO,round(ERAI),nanmin(nanmin(round(ERAI))):2:nanmax(nanmax(round(ERAI))),'showtext','on','fill','off','linewidth',1,'color','k'); hold on;
quiver(loni(1:50:500,1:50:1000),lati(1:50:500,1:50:1000),U(1:50:500,1:50:1000,find(alti == alt)),V(1:50:500,1:50:1000,find(alti == alt)),'color','k'); hold on %,'autoscale','off'

%caxis([nanmin(nanmin(nanmin(H))) nanmax(nanmax(nanmax(H)))]);
  geoshow('landareas.shp','Facecolor','none'); hold on 
% setm(gca,'GLineWidth',1.5,'fontsize',10,'meridianlabel','on','parallellabel','on'); box off ; gridm on; framem('on');
title({['arome-med wind (color) at ' num2str(alt) 'm, erai H' num2str(var(lev)) ' (contour)'];[ num2str(time(st,4)) ':00GMT ' num2str(time(st,3)) '/' num2str(time(st,2)) '/' num2str(time(st,1)) ]},'FontSize',12);  hold on     %
%%


%%%%%%%% compare two models at Radar location :  see script radar.m



