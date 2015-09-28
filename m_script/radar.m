% see also radar.m  where we make a day-by-day comparison of wind data
% here we compare U and V  parameters between Arome and Radar 
% altitudes in both records are normalized above the sea level
% to get the altitude of given grid location above the sea level, use :
% Radar wind measurement altitude [meters] is already relative to the sea level

clear all
close all

day = 10 ;
%%%%%%%%%%%%%%%%%%%% CONTROL parameters 
%%% Pianatoli radar position : 41.4722 N and 9.0656 E

%%% AROME-WMED coordinates closest to Pianatoli radar
latv = 41.48;  % alai = 242; % find(lati(:,1) == ala)
lonv = 9.08;   % aloi = 704; % find(loni(1,:) == alo)
slcm = 54 ; % altitude of model land surface above the sea level [meters]

%%% Levant (arome coordinates)
% latv = 43.03 ; % decimal degrees [N]
% lonv = 6.45 ; % decimal degrees [E]
% slcm = 12; 

%%% Candillargues (arome coordinates)
% latv = 43.6 ; % decimal degrees [N]
% lonv = 4.08 ; % decimal degrees [E]
% slcm = 1 ; 

alt = 3000; % the highest altitude for the comparison
year = 2012;
mo = 9;
ca = [-15 15] ; % horizontal wind speed color limits
cs = [0 5] ; % wind std color limits
positionvector = [0.06 0.7 0.4 0.28 ; 0.06 0.37 0.4 0.28 ; 0.06 0.04 0.4 0.28 ; 0.55 0.7 0.4 0.28 ; 0.55 0.37 0.4 0.28 ; 0.55 0.04 0.4 0.28 ]; 

if mo < 10 ; mmon = [num2str(0), num2str(mo)]; else ; mmon = num2str(mo); end
       
%%%%%%%%%%%%  brute RADAR data %%%%%%%%%%%%%%%%%%%%%%%%
if latv == 41.48 & lonv == 9.08    % Pianottoli (these are the arome grid coordinates closest to the Radar position)
    load(['/./media/elena/Transcend/Hymex/ASCII/Pianottoli_UHF_mh_01sept_15oct_normalized_20130906.mat']); % inDatesVec , inU , inV , inW , inZ , inZabl 
elseif latv == 43.03  &  lonv == 6.45     % Levant (arome coordinates)
    load(['/./media/elena/Transcend/Hymex/ASCII/Levant_UHF_mh_01sept_06nov2012_normalized.mat']);
elseif latv == 43.6 & lonv == 4.08 % Candillargues (arome coordinates)
    load(['/./media/elena/Transcend/Hymex/ASCII/Candi_UHF_mh_13sept_30nov2012_normalized.mat']);
end
clear AllData Q T logicalindex inSKEWw inASPT 

%%%%%%%%%%   upload 3-hourly Radar and AROME-WMED data (same time and vertical resoltution)
%%%%%%%%%%% see radar_monthly.m script'
load(['/media/elena/Transcend/Hymex/AROME_WMED/matfile/3hourly_wind_profiles_radar_and _arome' num2str(mo) '_' num2str(latv), 'N', '_', num2str(lonv), 'E.mat']);
% AUT,AVT,AWST =  Arome-Wmed u-wind, v-wind and wind speed
% TAT,ZAT are the common time (3hourly) and altitude (above sea level) coordinates
% BL is a 3-hourly averaged bounday layer height (automatically deduced from Radar measurement)
% BL(mom) 3-hourly averaged radar bounday layer height      
% VRI(:,mom) & URI(:,mom) = 3-hourly averaged radar wind profiles interpolated into AROME resolution   
% WSPR  radar wind speed profile 3-hourly averaged
% WSPRI wind speed profile of radar wind interpolated into AROME coordinates (3-hourly averaged)

pb = day*8-7; % starting time
pe = day*8+1;   % ending time

%%%%%%%%%%%%%%%%%%%%    U-wind component   %%%%%%%%%%%%%%
figure(1);
set(gcf,'PaperType','A4','PaperUnits','centimeters','Units','centimeters','PaperSize',[27 27],'Position',[2 -1 27 27]); 
colormap(jet(64));

%%% daily evolution of RADAR U wind component
subplot('position',positionvector(1,:)); hold on; 
pcolor((TAT(:,pb:pe)-(day-1)*24),ZAT(:,pb:pe),URI(:,pb:pe)); shading interp; hold on
caxis([ca(1) ca(2)]); box on; grid on ; hold on
set(gca,'xlim',[0 24],'xtick',0:3:24,'xticklabel',0:3:24,'ylim',[0 alt],'ytick',[0:250:alt]); 
ylabel('altitude above sea level [meters]'); 
xlabel(['vertic interp 3h ave Radar U-wind [m/s], ' num2str(day) '/' num2str(mo) '/2012, ' num2str(latv), 'N', ' ', num2str(lonv), 'E'] ); 
hcb=colorbar('vertic');
u=get(hcb,'position') ;
set(hcb,'position',[u(1)+0.06  u(2)  u(3)/1.7 u(4)]); 
  
subplot('position',positionvector(4,:)); hold on;
pcolor((TAT(:,pb:pe)-(day-1)*24),ZAT(:,pb:pe),minus(AUT(:,pb:pe),URI(:,pb:pe))); shading interp; hold on
caxis([-5 5]); hold on
xlabel(['U-wind: Arome minus Radar [m/s], ' num2str(day) '/' num2str(mo) '/2012, ' num2str(latv), 'N', ' ', num2str(lonv), 'E'] ); 
% ylabel('altitude above sea level [meters]');
box on; grid on ;
set(gca,'xlim',[0 24],'xtick',0:3:24,'xticklabel',0:3:24,'ylim',[0 alt],'ytick',[0:250:alt]); 
hcb=colorbar('vertic');
u=get(hcb,'position') ;
set(hcb,'position',[u(1)+0.06  u(2)  u(3)/1.7 u(4)]); 


%%%%%%%%%%%%%%%%%%%%    V-wind component   %%%%%%%%%%%%%% 
subplot('position',positionvector(2,:)); hold on;    
pcolor((TAT(:,pb:pe)-(day-1)*24),ZAT(:,pb:pe),VRI(:,pb:pe)); shading interp; hold on
caxis([ca(1) ca(2)]); box on; grid on ; hold on
set(gca,'xlim',[0 24],'xtick',0:3:24,'xticklabel',0:3:24,'ylim',[0 alt],'ytick',[0:250:alt]); 
ylabel('altitude above sea level [meters]');
xlabel(['vertic interp 3h ave Radar V-wind [m/s], ' num2str(day) '/' num2str(mo) '/2012, ' num2str(latv), 'N', ' ', num2str(lonv), 'E']); 
hcb=colorbar('vertic');
u=get(hcb,'position') ;
set(hcb,'position',[u(1)+0.06  u(2)  u(3)/1.7 u(4)]); 

subplot('position',positionvector(5,:)); hold on; 
pcolor((TAT(:,pb:pe)-(day-1)*24),ZAT(:,pb:pe),minus(AVT(:,pb:pe),VRI(:,pb:pe))); shading interp; hold on
caxis([-5 5]); hold on
xlabel(['V-wind: Arome minus Radar [m/s], ' num2str(day) '/' num2str(mo) '/2012, ' num2str(latv), 'N', ' ', num2str(lonv), 'E']); 
set(gca,'xlim',[0 24],'xtick',0:3:24,'xticklabel',0:3:24,'ylim',[0 alt],'ytick',[0:250:alt]); 
%ylabel('altitude above sea level [meters]');
box on; grid on ;
hcb=colorbar('vertic');
u=get(hcb,'position') ;
set(hcb,'position',[u(1)+0.06  u(2)  u(3)/1.7 u(4)]); 
set(findall(gcf,'type','text'),'fontsize',9)

%%%%%%%%%%%%%%%%%%%%    Wind Speed   %%%%%%%%%%%%%%%%%%%%
% subplot('position',positionvector(3,:)); hold on;    
% pcolor((TAT(:,pb:pe)-(day-1)*24),ZAT(:,pb:pe),WSPRI(:,pb:pe)); shading interp; hold on
% caxis([ca(1) ca(2)]); box on; grid on ; hold on
% set(gca,'xlim',[0 24],'xtick',0:3:24,'xticklabel',0:3:24,'ylim',[0 alt],'ytick',[0:250:alt]); 
% ylabel('altitude above sea level [meters]');
% xlabel(['vertic interp 3h ave Radar wind speed [m/s], ' num2str(day) '/' num2str(mo) '/2012, ' num2str(latv), 'N', ' ', num2str(lonv), 'E']);
% hcb=colorbar('vertic');
% u=get(hcb,'position') ;
% set(hcb,'position',[u(1)+0.12  u(2)  u(3)/1.7 u(4)]); 


%%%%%%%%%%%%%%%%%%%%%%%%%
figure(5);
set(gcf,'PaperType','A4','PaperUnits','centimeters','Units','centimeters','PaperSize',[27 27],'Position',[2 -1 27 27]); 
colormap(jet(64))

% ST of 5-min U-wind data within a 3h window
subplot('position',positionvector(1,:)); hold on;
pcolor((TR(:,pb:pe)-(day-1)*24),ZR(:,pb:pe),UR_ST(:,pb:pe)); shading interp; hold on
caxis([cs(1) cs(2)]); hold on
xlabel('Radar U-wind variations (std) within a 3h window');
set(gca,'xlim',[0 24],'xtick',0:3:24,'ylim',[0 alt],'ytick',0:250:alt); 
ylabel('altitude [meters]');
grid on; box on;
box on; grid on ;
hcb=colorbar('vertic');
u=get(hcb,'position') ;
set(hcb,'position',[u(1)+0.06  u(2)  u(3)/1.7 u(4)]); 

subplot('position',positionvector(4,:)); hold on;
pcolor((TR(:,pb:pe)-(day-1)*24),ZR(:,pb:pe),NB(:,pb:pe,2)); shading interp; hold on
caxis([10 80]);
set(gca,'xlim',[0 24],'xtick',0:3:24,'ylim',[0 alt],'ytick',0:250:alt); 
%ylabel('altitude [meters]');
xlabel('availability of U-data within 3h'); 
grid on; box on;
box on; grid on ;
hcb=colorbar('vertic');
u=get(hcb,'position') ;
set(hcb,'position',[u(1)+0.06  u(2)  u(3)/1.7 u(4)]); 

subplot('position',positionvector(2,:)); hold on;
pcolor((TR(:,pb:pe)-(day-1)*24),ZR(:,pb:pe),VR_ST(:,pb:pe)); shading interp; hold on
caxis([cs(1) cs(2)]); hold on
xlabel('Radar V-wind variations (std) within a 3h window');
set(gca,'xlim',[0 24],'xtick',0:3:24,'ylim',[0 alt],'ytick',0:250:alt); 
ylabel('altitude [meters]');
grid on; box on;
box on; grid on ;
hcb=colorbar('vertic');
u=get(hcb,'position') ;
set(hcb,'position',[u(1)+0.06  u(2)  u(3)/1.7 u(4)]); 

subplot('position',positionvector(5,:)); hold on;
pcolor((TR(:,pb:pe)-(day-1)*24),ZR(:,pb:pe),NB(:,pb:pe,1)); shading interp; hold on
caxis([10 80]);
set(gca,'xlim',[0 24],'xtick',0:3:24,'ylim',[0 alt],'ytick',[0:250:alt]); 
%ylabel('altitude [meters]');
xlabel('availability of V-data within 3h'); 
grid on; box on;
hcb=colorbar('vertic');
u=get(hcb,'position') ;
set(hcb,'position',[u(1)+0.06  u(2)  u(3)/1.7 u(4)]); 

subplot('position',positionvector(3,:)); hold on;
pcolor((TR(:,pb:pe)-(day-1)*24),ZR(:,pb:pe),WR_ST(:,pb:pe)); shading interp; hold on
caxis([0 2]); hold on
xlabel('Radar W-wind variations (std) within a 3h window');
set(gca,'xlim',[0 24],'xtick',0:3:24,'xticklabel',0:3:24,'ylim',[0 alt],'ytick',[0:250:alt]); 
ylabel('altitude above sea level [meters]');
box on; grid on ;
box on; grid on ;
hcb=colorbar('vertic');
u=get(hcb,'position') ;
set(hcb,'position',[u(1)+0.06  u(2)  u(3)/1.7 u(4)]); 

subplot('position',positionvector(6,:)); hold on;
pcolor((TR(:,pb:pe)-(day-1)*24),ZR(:,pb:pe),NB(:,pb:pe,3)); shading interp; hold on
caxis([10 80]);
set(gca,'xlim',[0 24],'xtick',0:3:24,'ylim',[0 alt],'ytick',[0:250:alt]); hold on
%ylabel('altitude [meters]');
xlabel(['availability of W-data within 3h, ' num2str(day) '/' num2str(mo) '/2012, ' num2str(latv), 'N', ' ', num2str(lonv), 'E']); 
grid on; box on;
box on; grid on ;
hcb=colorbar('vertic');
u=get(hcb,'position') ;
set(hcb,'position',[u(1)+0.06  u(2)  u(3)/1.7 u(4)]); 
set(findall(gcf,'type','text'),'fontsize',9)




