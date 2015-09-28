% see also radar.m  where we make a day-by-day comparison of wind data
% here we compare U and V  parameters between Arome and Radar 
% altitudes in both records are normalized above the sea level
% to get the altitude of given grid location above the sea level, use :
% Radar wind measurement altitude [meters] is already relative to the sea level

clear all
close all

%%%%%%%%%%%%%%%%%%%% CONTROL parameters 
%%% Pianatoli radar position : 41.4722 N and 9.0656 E

%%% AROME-WMED coordinates closest to Pianotoli radar
ala = 41.48;  % alai = 242; % find(lati(:,1) == ala)
alo = 9.08;   % aloi = 704; % find(loni(1,:) == alo)
slcm = 54 ; % altitude of model land surface above the sea level [meters]

%%% Levant (arome coordinates)
% ala = 43.03 ; % decimal degrees [N]
% alo = 6.45 ; % decimal degrees [E]
% slcm = 12; 

%%% Candillargues (arome coordinates)
% ala = 43.6 ; % decimal degrees [N]
% alo = 4.08 ; % decimal degrees [E]
% slcm = 1 ; 

alt = 3000; % the highest altitude for the comparison
year = 2012;
mo = 10;
ca = [-25 25] ; % horisontal wind speed color limits
chemin2=(['/./media/elena/Transcend/Hymex/figures/monthly/']);   

%%%%%%%%%%     AROME-WMED    %%%%%%%%%%%
if mo < 10 
      mmon = [num2str(0), num2str(mo)];
else
      mmon = num2str(mo);
end
                                
core_dir = '/media/elena/Transcend/Hymex/AROME_WMED/matfile/';  % see   read_aromewmed.m
if exist(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_U_' , num2str(ala), 'N', '_', num2str(alo), 'E.mat'])) == 2
    load(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_U_' , num2str(ala), 'N', '_', num2str(alo), 'E.mat'])) ; 
    load(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_V_' , num2str(ala), 'N', '_', num2str(alo), 'E.mat'])) ; 
    % 'U, 'V','latv','lonv','alti','rla','rlo','ht','data_description');
    AU = U(find(alti == alt):length(alti),:,:);
    AV = V(find(alti == alt):length(alti),:,:); 
    clear U V 
end

AWS = sqrt(AU.^2 + AV.^2);  % wind speed profile every 3h avery day of month

cpt = 1;
for day = 1 : eomday(year,mo);
    AUT(:,cpt:cpt+7) = AU(find(alti == alt):length(alti),:,day);
    AVT(:,cpt:cpt+7) = AV(find(alti == alt):length(alti),:,day);
    AWST(:,cpt:cpt+7) = AWS(find(alti == alt):length(alti),:,day);
    
    TA(1,cpt:cpt+7) = ht + (day-1)*24;
    cpt = cpt + 8;
end

for it = 1 : size(AUT,1)
    TAT(it,:) = TA;
end

for  it = 1 : size(AUT,2)
    ZAT(:,it) = alti(find(alti == alt):length(alti))+slcm; % correct the model height by the surface height above the sea level
end

%%%%%%%%%%%%  RADAR data %%%%%%%%%%%%%%%%%%%%%%%%
if ala == 41.48 & alo == 9.08    % Pianottoli (these are the arome grid coordinates closest to the Radar position)
    load(['/./media/elena/Transcend/Hymex/ASCII/Pianottoli_UHF_mh_01sept_15oct_normalized_20130906.mat']); % inDatesVec , inU , inV , inW , inZ , inZabl
    clear AllData  Pianottoli_UHF_mh_1oct_15oct12_V0  Pianottoli_UHF_mh_sept12_V0 Q T logicalindex inSKEWw inASPT 
elseif ala == 43.03  &  alo == 6.45     % Levant (arome coordinates)
    load(['/./media/elena/Transcend/Hymex/ASCII/Levant_UHF_mh_01sept_06nov2012_normalized.mat']);
    clear AllData Q T logicalindex inSKEWw inASPT 
elseif ala == 43.6 & alo == 4.08 % Candillargues (arome coordinates)
    load(['/./media/elena/Transcend/Hymex/ASCII/Candi_UHF_mh_13sept_30nov2012_normalized.mat']);
    clear AllData Q T logicalindex inSKEWw inASPT 
end

 %%%%%%%%%%%%%%%%%%%% 
positionvector = [0.06 0.71 0.87 0.28 ; 0.06 0.39 0.87 0.28 ; 0.06 0.07 0.87 0.28 ]; 
raz = max(find(inZ <= alt)+2) ; % radar altitude index within the matrix
ral =  inZ(raz) ; % the highest radar altitude 
TY = inDatesVec(:,4) +  (inDatesVec(:,5)./60);

mom = 1;
for day = 1 : eomday(year,mo); % day range
    for hh = 0 : 3 : 21
        clear r1 r2 radt 
        
        ZR(:,mom) = flipud(inZ(1:raz)); % measurement height  = height above sea surface
        TR(1:raz,mom) = hh + 24*(day-1);

        if hh == 0 & day > 1 
            r1 = find(inDatesVec(:,2) == mo & inDatesVec(:,3) == day-1 & TY >= 22.5 );   
            r2 = find(inDatesVec(:,2) == mo & inDatesVec(:,3) == day & TY <= 1.5 ); 
            radt = [r1;r2];
        elseif hh == 0 & day == 1 
            r1 = find(inDatesVec(:,2) == mo-1 & inDatesVec(:,3) == eomday(year,mo-1) & TY >= 22.5 );   
            r2 = find(inDatesVec(:,2) == mo & inDatesVec(:,3) == day & TY <= 1.5 ); 
            radt = [r1;r2];
        elseif hh > 0
            radt = find(inDatesVec(:,2) == mo & inDatesVec(:,3) == day & TY >= hh-1.5 & TY <= hh+1.5); % radar  
        else
            VR(1:raz,mom) = NaN; VRI(1:size(ZAT,1),mom) = NaN; VR_ST(1:raz,mom) = NaN;
            UR(1:raz,mom) = NaN; URI(1:size(ZAT,1),mom) = NaN; UR_ST(1:raz,mom) = NaN;
            WR(1:raz,mom) = NaN; WRI(1:size(ZAT,1),mom) = NaN; WR_ST(1:raz,mom) = NaN;
            NB(1:raz,mom,1:3) = 0; % data amount on this moment (available for averaging)
            BL(mom) = NaN;  % bounday layer height
            mom = mom + 1;
            continue
        end
    
        if length(radt) == 0 % if no radar data on this day
            VR(1:raz,mom) = NaN; VRI(1:size(ZAT,1),mom) = NaN; VR_ST(1:raz,mom) = NaN;
            UR(1:raz,mom) = NaN; URI(1:size(ZAT,1),mom) = NaN; UR_ST(1:raz,mom) = NaN;
            WR(1:raz,mom) = NaN; WRI(1:size(ZAT,1),mom) = NaN; WR_ST(1:raz,mom) = NaN;
            BL(mom) = NaN;
            NB(1:raz,mom,1:3) = NaN; % data amount on this moment
            mom = mom + 1;
            continue
        end 
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        %%% reshape radar vector data into matrix
        %%% fisrt calculate the average profile within a 3h window
        VR(:,mom) = rot90(nanmean(inV(radt,1:raz),1));  % average V-wind profile     
        a = zeros([length(radt) length(1:raz)]);
        a(find(~isnan(inV(radt,1:raz)))) = 1;
        NB(1:raz,mom,1) = rot90(sum(a)); % amount of V-wind data at each altitude within a 3-hour window
        clear a
        
        UR(:,mom) = rot90(nanmean(inU(radt,1:raz),1));  % average U-wind profile 
        a = zeros([length(radt) length(1:raz)]);
        a(find(~isnan(inU(radt,1:raz)))) = 1;
        NB(1:raz,mom,2) = rot90(sum(a)); % amount of U-wind data at each altitude within a 3-hour window
        clear a
        
        WR(:,mom) = rot90(nanmean(inW(radt,1:raz))); % average W-wind profile 
        a = zeros([length(radt) length(1:raz)]);
        a(find(~isnan(inW(radt,1:raz)))) = 1;
        NB(1:raz,mom,3) = rot90(sum(a)); % amount of W-wind data at each altitude within a 3-hour window
        clear a

        BL(mom) = nanmean(inZabl(radt)); % radar bounday layer height
        
        %%% what is the variance of 5-min wind values withina 3h window?
        VR_ST(:,mom) = rot90(nanstd(inV(radt,1:raz),1)); 
        UR_ST(:,mom) = rot90(nanstd(inU(radt,1:raz),1));        
        WR_ST(:,mom) = rot90(nanstd(inW(radt,1:raz),1));
        
        %%% second interpolate 3-hourly radar wind profile into AROME vertical resolution
        VRI(:,mom) = interp1(ZR(:,1),VR(:,mom),ZAT(:,1)); 
        URI(:,mom) = interp1(ZR(:,1),UR(:,mom),ZAT(:,1));    
        WRI(:,mom) = interp1(ZR(:,1),WR(:,mom),ZAT(:,1));        
        mom = mom + 1;
    end
end

WSPR  = sqrt(UR.^2 + VR.^2);  % wind speed profile
WSPRI = sqrt(URI.^2 + VRI.^2);  % wind speed profile of radar wind interpolated into AROME coordinates

data_description = {['see radar_monthly.m script'];...
     ['Arome-Wmed wind data: AUT,AVT,AWST (u-wind, v-wind and wind speed)'];...
     ['Radar wind data: URI,VRI,WSPRI, WRI (original values averaged into 3h resolution and thenafter interpolated into Arome coordinates)'];...
     ['TAT,ZAT are the common time (3hourly) and altitude (above sea level) coordinates '];...     
     ['UR,VR,WSPR (speed), WR (vertical wind comp) original Radar wind values averaged into 3h resolution, corresponding to TR (time) and ZR (altitude) coordinates'];...
     ['VR_ST, UR_ST, WR_ST (vertical wind comp : std of all Radar wind values within a 3h window, corresponding to TR (time) and ZR (altitude) coordinates'];...
     ['NB(:,:,1:3) is the amount of V(1), U(2), W(3) wind data at each altitude within a 3-hour window, corresponding to TR (time) and ZR (altitude) coordinates'];...
     ['BL is the bounday layer height automatically deduced from Radar measurements, corresponding to TR (time)'];...
     ['at the model grid location (latv,lonv) closest to the Radar position'];...
     ['data for 2012/' num2str(mo) ];...
     ['the 5-min radar data is averaged 1h30min before and 1h30min after the reference Arome time : 00 03 06 09 12 15 18 21 GMT']};

 save(['/media/elena/Transcend/Hymex/AROME_WMED/matfile/3hourly_wind_profiles_radar_and _arome' num2str(mo) '_' num2str(latv), 'N', '_', num2str(lonv), 'E.mat'],...
     'WR_ST','UR_ST','VR_ST','UR','VR','WSPR','WR','AUT','AVT','AWST', 'WSPRI','VRI','URI','WRI','TAT','ZAT','BL','TR','ZR','NB','data_description','latv','lonv','mo');

break

%%%%%%%%%%%%%%%%%%%%    U-wind component   %%%%%%%%%%%%%%
clf(figure(1))
figure(1);
set(gcf,'PaperType','A4','PaperUnits','centimeters','Units','centimeters','PaperSize',[27 27],'Position',[2 -1 27 27]); 
colormap(jet(64))
JET=get(gcf,'colormap');
    
subplot('position',positionvector(1,:)); hold on;
pcolor(TAT,ZAT,AUT); shading interp; hold on
caxis([ca(1) ca(2)]); hold on
set(gca,'xlim',[1 24*eomday(year,mo)],'xtick',[1, 24:24:24*eomday(year,mo)],'xticklabel',1:1:eomday(year,mo)+1,'ylim',[0 alt],'ytick',[0:250:alt]); 
ylabel('altitude above sea level [meters]');
xlabel('AromeWMed U wind [m/s]');
box on; grid on ;

hcb=colorbar('vertic');
u=get(hcb,'position') ;
set(hcb,'position',[u(1)+0.07  u(2)  u(3)/2 u(4)],'ytick',[ca(1) : 5 : ca(2)]); 

%%% daily evolution of RADAR U wind component
subplot('position',positionvector(2,:)); hold on;    
pcolor(TR,ZR,UR); shading interp; hold on
caxis([ca(1) ca(2)]); box on; grid on ; hold on
set(gca,'xlim',[1 24*eomday(year,mo)],'xtick',[1, 24:24:24*eomday(year,mo)],'xticklabel',1:1:eomday(year,mo)+1,'ylim',[0 alt],'ytick',[0:250:alt]); 
ylabel('altitude above sea level [meters]'); 
xlabel('Radar U wind [m/s]'); 

hcb=colorbar('vertic');
u=get(hcb,'position') ;
set(hcb,'position',[u(1)+0.07  u(2)  u(3)/2 u(4)],'ytick',[ca(1) : 5 : ca(2)]); 

subplot('position',positionvector(3,:)); hold on;
pcolor(TAT,ZAT,minus(AUT,URI)); shading interp; hold on
caxis([-10 10]); hold on
set(gca,'xlim',[1 24*eomday(year,mo)],'xtick',[1, 24:24:24*eomday(year,mo)],'xticklabel',1:1:eomday(year,mo)+1,'ylim',[0 alt],'ytick',[0:250:alt],'fontsize',10); 
ylabel('altitude above sea level [meters]');
xlabel('U wind difference: AromeWMed minus Radar [m/s]'); 
box on; grid on ;

hcb=colorbar('vertic');
u=get(hcb,'position') ;
set(hcb,'position',[u(1)+0.07  u(2)  u(3)/2 u(4)]); 

set(findall(gcf,'type','text'),'fontsize',9)
export_fig(fullfile(chemin2,['Uwind_arome_vs_radar_' num2str(mmon) '2012_', num2str(round(latv)), 'N', '_', num2str(round(lonv)), 'E_sealevcorrection.png']),'-painters','-nocrop')


%%%%%%%%%%%%%%%%%%%%    V-wind component   %%%%%%%%%%%%%%
clf (figure(2))
figure(2);
colormap(jet(64))
JET=get(gcf,'colormap');
set(gcf,'PaperType','A4','PaperUnits','centimeters','Units','centimeters','PaperSize',[27 27],'Position',[2 -1 27 27]); 
subplot('position',positionvector(1,:)); hold on;
pcolor(TAT,ZAT,AVT); shading interp; hold on
caxis([ca(1) ca(2)]); hold on
set(gca,'xlim',[1 24*eomday(year,mo)],'xtick',[1, 24:24:24*eomday(year,mo)],'xticklabel',1:1:eomday(year,mo)+1,'ylim',[0 alt],'ytick',[0:250:alt]); 
ylabel('altitude above sea level [meters]');
xlabel('AromeWMed V wind [m/s]'); 
box on; grid on ;

hcb=colorbar('vertic');
u=get(hcb,'position') ;
set(hcb,'position',[u(1)+0.07  u(2)  u(3)/2 u(4)],'ytick',[ca(1) : 5 : ca(2)]); 

subplot('position',positionvector(2,:)); hold on;    
pcolor(TR,ZR,VR); shading interp; hold on
caxis([ca(1) ca(2)]); box on; grid on ; hold on
set(gca,'xlim',[1 24*eomday(year,mo)],'xtick',[1, 24:24:24*eomday(year,mo)],'xticklabel',1:1:eomday(year,mo)+1,'ylim',[0 alt],'ytick',[0:250:alt]); 
ylabel('altitude above sea level [meters]');
xlabel('Radar V wind [m/s]'); 

hcb=colorbar('vertic');
u=get(hcb,'position') ;
set(hcb,'position',[u(1)+0.07  u(2)  u(3)/2 u(4)],'ytick',[ca(1) : 5 : ca(2)]); 

subplot('position',positionvector(3,:)); hold on;
pcolor(TAT,ZAT,minus(AVT,VRI)); shading interp; hold on
caxis([-10 10]); hold on
set(gca,'xlim',[1 24*eomday(year,mo)],'xtick',[1, 24:24:24*eomday(year,mo)],'xticklabel',1:1:eomday(year,mo)+1,'ylim',[0 alt],'ytick',[0:250:alt]); 
ylabel('altitude above sea level [meters]');
xlabel('V wind difference: AromeWMed minus Radar, [m/s]'); 
box on; grid on ;

hcb=colorbar('vertic');
u=get(hcb,'position') ;
set(hcb,'position',[u(1)+0.07  u(2)  u(3)/2 u(4)]); 

set(findall(gcf,'type','text'),'fontsize',9)
export_fig(fullfile(chemin2,['Vwind_arome_vs_radar_' num2str(mmon) '2012_', num2str(round(latv)), 'N', '_', num2str(round(lonv)), 'E_sealevcorrection.png']),'-painters','-nocrop')


%%%%%%%%%%%%%%%%%%%%    Wind Speed   %%%%%%%%%%%%%%%%%%%%
clf (figure(3))
figure(3);
colormap(jet(64))
JET=get(gcf,'colormap');
set(gcf,'PaperType','A4','PaperUnits','centimeters','Units','centimeters','PaperSize',[27 27],'Position',[2 -1 27 27]); 
subplot('position',positionvector(1,:)); hold on;
pcolor(TAT,ZAT,AWST); shading interp; hold on
caxis([ca(1) ca(2)]); hold on
set(gca,'xlim',[1 24*eomday(year,mo)],'xtick',[1, 24:24:24*eomday(year,mo)],'xticklabel',1:1:eomday(year,mo)+1,'ylim',[0 alt],'ytick',[0:250:alt]); 
ylabel('altitude above sea level [meters]');
xlabel('AromeWMed wind speed [m/s]'); 
box on; grid on ;

hcb=colorbar('vertic');
u=get(hcb,'position') ;
set(hcb,'position',[u(1)+0.07  u(2)  u(3)/2 u(4)],'ytick',[ca(1) : 5 : ca(2)]); 


subplot('position',positionvector(2,:)); hold on;    
pcolor(TR,ZR,WSPR); shading interp; hold on
caxis([ca(1) ca(2)]); box on; grid on ; hold on
set(gca,'xlim',[1 24*eomday(year,mo)],'xtick',[1, 24:24:24*eomday(year,mo)],'xticklabel',1:1:eomday(year,mo)+1,'ylim',[0 alt],'ytick',[0:250:alt]); 
ylabel('altitude above sea level [meters]');
xlabel('Radar wind speed [m/s]');

hcb=colorbar('vertic');
u=get(hcb,'position') ;
set(hcb,'position',[u(1)+0.07  u(2)  u(3)/2 u(4)],'ytick',[ca(1) : 5 : ca(2)]); 


subplot('position',positionvector(3,:)); hold on;    
pcolor(TAT,ZAT,minus(AWST,WSPRI)); shading interp; hold on
caxis([-10 10]); box on; grid on ; hold on
set(gca,'xlim',[1 24*eomday(year,mo)],'xtick',[1, 24:24:24*eomday(year,mo)],'xticklabel',1:1:eomday(year,mo)+1,'ylim',[0 alt],'ytick',[0:250:alt]); 
ylabel('altitude above sea level [meters]');
xlabel('Wind speed difference: AromeWMed minus Radar, [m/s]'); 

hcb=colorbar('vertic');
u=get(hcb,'position') ;
set(hcb,'position',[u(1)+0.07  u(2)  u(3)/2 u(4)]); 

set(findall(gcf,'type','text'),'fontsize',9)
export_fig(fullfile(chemin2,['WSwind_arome_vs_radar_' num2str(mmon) '2012_', num2str(round(latv)), 'N', '_', num2str(round(lonv)), 'E_sealevcorrection.png']),'-painters','-nocrop')


break
%%
%%%%%%%%%%%%    typical wind difference (error) between Arome and Radar     %%%%%%%%%%%%
%%% teh altitude in both data is normalized to the sea level
clear all
close all

%%% Pianatolli (arome coordinates)
latv = 41.48;  
lonv = 9.08;   

%%% Levant (arome coordinates)
% latv = 43.03 ; % decimal degrees [N]
% lonv = 6.45 ; % decimal degrees [E]

%%% Candillargues (arome coordinates)
% latv = 43.6 ; % decimal degrees [N]
% lonv = 4.08 ; % decimal degrees [E]

%%%%%%%%%%%%%%%%%%%%  cattenate the data for the entire common period :  Sept - Oct 2012
load(['/media/elena/Transcend/Hymex/AROME_WMED/matfile/3hourly_wind_profiles_radar_and _arome9' '_' num2str(latv), 'N', '_', num2str(lonv), 'E.mat']);
%     'AUT','AVT','AWST', 'WSPRI','VRI','URI','TAT','ZAT','data_description','latv','lonv','mo');
AUT9 = AUT;  AVT9 = AVT; AWST9 = AWST;
URI9 = URI; VRI9 = VRI ; WSPRI9 = WSPRI;
clear AUT AVT AWST URI VRI WSPRI

load(['/media/elena/Transcend/Hymex/AROME_WMED/matfile/3hourly_wind_profiles_radar_and _arome10' '_' num2str(latv), 'N', '_', num2str(lonv), 'E.mat']);   
AUT10 = AUT; AVT10 = AVT; AWST10 = AWST; 
URI10 = URI; VRI10 = VRI ; WSPRI10 = WSPRI;
clear AUT AVT AWST URI VRI WSPRI

if latv == 41.48
    AUT = [AUT9,AUT10];  AVT = [AVT9, AVT10]; AWST = [AWST9, AWST10];
    URI = [URI9,URI10]; VRI = [VRI9,VRI10]; WSPRI = [WSPRI9, WSPRI10];
else
    load(['/media/elena/Transcend/Hymex/AROME_WMED/matfile/3hourly_wind_profiles_radar_and _arome11' '_' num2str(latv), 'N', '_', num2str(lonv), 'E.mat']);   
    AUT11 = AUT; AVT11 = AVT; AWST11 = AWST; 
    URI11 = URI; VRI11 = VRI ; WSPRI11 = WSPRI;
    clear AUT AVT AWST URI VRI WSPRI
    
    AUT = [AUT9, AUT10, AUT11]; AVT = [AVT9, AVT10, AVT11]; AWST = [AWST9, AWST10, AWST11];
    URI = [URI9, URI10, URI11]; VRI = [VRI9, VRI10, VRI11]; WSPRI = [WSPRI9, WSPRI10, WSPRI11];
end

%%%%%%%  at each altitude: consider only those 3h moments where both radar and arome data is available
for i = 1:size(AUT,1) % altitude
    le(i,1) = length(URI(i,find(~isnan(URI(i,:)) & ~isnan(AUT(i,:)))))-1;
end
le(find(le == -1)) = NaN;

%%%% normalized wind difference at each altitude
dU(:,1) = sqrt(nansum((minus(AUT,URI)).^2,2)./le)  ;
dV(:,1) = sqrt(nansum((minus(AVT,VRI)).^2,2)./le) ;
dWS(:,1) = sqrt(nansum((minus(AWST,WSPRI)).^2,2)./le) ;

clf (figure(4))
figure(4)
h1 = plot(dU,ZAT(:,1),'r','linewidth',2,'linestyle','-.'); hold on 
h2 = plot(dV,ZAT(:,1),'r','linewidth',2); hold on 
h3 = plot(dWS,ZAT(:,1),'k','linewidth',2); hold 
set(gca,'ylim',[250 3100],'xlim',[1.78 3.2]);
ylabel('altitude above sea level [meters]');
xlabel('normalized wind difference [m/s]'); 
title({['V-wind (red plain) and U-wind (red dashed) difference'];['wind speed difference (black)'];[' Arome vs Radar at ' num2str(latv), '^oN', ' ', num2str(lonv), '^oE']}); 
box on; grid on ;



%%

 
%     %%% daily evolution of RADAR W wind component
%     subplot('position',positionvector(6,:)); hold on;    
%     pcolor(TR,ZR,WR); shading interp; hold on
%     caxis([cw(1) cw(2)]);
%     set(gca,'xlim',[0 24],'xtick',0:3:24,'ylim',[0 alt],'ytick',[0:250:alt]); %,'yticklabel',inZ(1:4:56))
%     ylabel('altitude [meters]');
%     xlabel('radar W wind [m/s]'); 
    
    hcb=colorbar('horiz');
	u=get(hcb,'position') ;
	set(hcb,'position',[u(1)-0.18  u(2)-0.045  u(3)/1.5 u(4)/2]); 
    f=get(hcb,'xlabel');
%	set(f,'string', {'wind speed, U, V [m/s]'},'fontsize',8,'FontWeight','demi');
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    %%%% plot the hourly average radar profile 
%     figure(2);
%     set(gcf,'PaperType','A4'); %,'PaperUnits','centimeters','Units','centimeters','PaperSize',[20 28],'Position',[1 1 20 28]); 
%     hold on
%       
%     tt = inDatesVec(radt,4:5);
%     dv = inV(radt,1:raz);
%     du = inU(radt,1:raz);
%     
%     for hh = 0 : 23
%         vv(hh+1,:) = nanmean(dv(find(tt(:,1) == hh),1:raz),1);   
%         uu(hh+1,:) = nanmean(du(find(tt(:,1) == hh),1:raz),1);   
%     end
%     
%     
%     %%% U component hourly (both radar and erai)
%     subplot('position',[0.54 0.05 0.45 0.9]); hold on;
%     %%% plot 1-h average radar profile
%     ct = 1; ht = 1 ;
%     for hh = 0 : 24
%         RGB = JET(ceil(ht),:);
%         if hh < 23
%             h2 = plot(vv(hh+1,:)',inZ(1:raz),'color',[RGB(1),RGB(2),RGB(3)],'linewidth',2); hold on 
%         end
%         
% %         if hh == 0 | hh == 6 | hh == 18 | hh == 24 
% %             h3 = plot(V(eaz:16,modt(ct)),Z(eaz:16,modt(ct)),'color',[RGB(1),RGB(2),RGB(3)],'linewidth',2,'linestyle','-.'); hold on % ERAI data
% %             ct = ct + 1 ;
% %         end   
%         ht = ht + 2.5 ;
%     end
%     
%     %%% plot each 3-min profile
% %     h2 = plot(nanmean(inV(radt(1) : radt(length(radt)),1:12),1),inZ(1:12),'k','linewidth',2); hold on 
%     
%     %%% plot 6-hourly ERAI profile
% %     h3 = plot(V(8:16,modt),Z(8:16,modt),'g','linewidth',2); hold on % ERAI data
%     set(gca,'xlim',[ca(1) ca(2)],'ylim',[0 alt],'ytick',[0:250:alt]); 
%     grid on
%     ylabel('altitude [meters]');
%     xlabel('V wind : radar (plain) and erai (dashed) m/s]'); 
%     
%     %%%% V component hourly (both radar and erai)
%     subplot('position',[0.05 0.05 0.45 0.9]); hold on;
%     %%% plot 1-h average radar profile
%     ct = 1; ht = 1 ;
%     for hh = 0 : 24
%         RGB = JET(ceil(ht),:);
%         if hh < 23
%             h2 = plot(uu(hh+1,:)',inZ(1:raz),'color',[RGB(1),RGB(2),RGB(3)],'linewidth',2); hold on 
%         end
% %         if hh == 0 | hh == 6 | hh == 18 | hh == 24 
% %             h3 = plot(U(eaz:16,modt(ct)),Z(eaz:16,modt(ct)),'color',[RGB(1),RGB(2),RGB(3)],'linewidth',2,'linestyle','-.'); hold on % ERAI data
% %             ct = ct + 1 ;
% %         end   
%         ht = ht + 2.5 ;
%     end
    
%     %%% plot each 3-min profile
% %     h2 = plot(nanmean(inV(radt(1) : radt(length(radt)),1:12),1),inZ(1:12),'k','linewidth',2); hold on 
%     
%     %%% plot 6-hourly ERAI profile
% %     h3 = plot(V(8:16,modt),Z(8:16,modt),'g','linewidth',2); hold on % ERAI data
%     set(gca,'xlim',[ca(1) ca(2)],'ylim',[0 alt],'ytick',[0:250:alt]); 
%     grid on
%     ylabel('altitude [meters]');
%     xlabel('U wind : radar (plain) and erai (dashed) [m/s]'); 
%     
    figure(3);
    set(gcf,'PaperType','A4','PaperUnits','centimeters','Units','centimeters','PaperSize',[15 27],'Position',[30 1 15 27]); hold on
    subplot('position', [0.07 0.7 0.83 0.29]); hold on;    
    pcolor(TR,ZR,ER); shading interp; hold on
    caxis([0 0.001]);
    set(gca,'xlim',[0 24],'xtick',0:3:24,'ylim',[0 alt],'ytick',0:250:alt); 
    ylabel('altitude [meters]');
    xlabel('epsilon [m^2/s^3]'); 
    h5 = plot(TR(1,:),BL,'k'); hold on
    grid on; box on;
    hcb=colorbar('vertic');
	u=get(hcb,'position') ;
	set(hcb,'position',[u(1)+0.12  u(2)  u(3)/1.7 u(4)/1.05]); 
    
    subplot('position', [0.07 0.37 0.83 0.29]); hold on;    
    pcolor(TR,ZR,CR); shading interp; hold on
    caxis([0 10^(-12)]);
    set(gca,'xlim',[0 24],'xtick',0:3:24,'ylim',[0 alt],'ytick',[0:250:alt]); 
    ylabel('altitude [meters]');
    xlabel('refractive index [m^{-2/3}]'); 
    h5 = plot(TR(1,:),BL,'k'); hold on
    grid on; box on;
    hcb=colorbar('vertic');
	u=get(hcb,'position') ;
	set(hcb,'position',[u(1)+0.12  u(2)  u(3)/1.7 u(4)]); 
    
    subplot('position', [0.07 0.04 0.83 0.29]); hold on; 
    pcolor(TR,ZR,STDRW); shading interp; hold on
    caxis([1 5]);
    set(gca,'xlim',[0 24],'xtick',0:3:24,'ylim',[0 alt],'ytick',[0:250:alt]); 
    ylabel('altitude [meters]');
    xlabel('2 std of W-component [m/s]'); 
    h5 = plot(TR(1,:),BL,'k'); hold on
    grid on; box on;
    hcb=colorbar('vertic');
	u=get(hcb,'position') ;
	set(hcb,'position',[u(1)+0.12  u(2)  u(3)/1.7 u(4)]); 
    
    keyboard
% end

