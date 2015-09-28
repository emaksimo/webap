clear all
close all

%%%%%%%%%%%%%%%%%%%% CONTROL parameters 
%%% Pianatoli radar position : 41.4722 N and 9.0656 E

%%% AROME-WMED coordinates closest to Pianatoli radar
ala = 41.48;  alai = 242; % find(lati(:,1) == ala)
alo = 9.08;   aloi = 704; % find(loni(1,:) == alo)

%%%%%
alt = 3000; % the highest altitude for the comparison
year = 2012;
mo = 9;
%ca = [-25 25] ; % horisontal wind speed color limits

%%%%%%%%%%     AROME-WMED    %%%%%%%%%%%
if mo < 10 
      mmon = [num2str(0), num2str(mo)];
else
      mmon = num2str(mo);
end
                                
core_dir = '/media/elena/Transcend/Hymex/AROME_WMED/matfile/';  % see   read_aromewmed.m
% core_dir = '/media/elena/SAMSUNG/AROME-WMED-REANALYSIS/matfile/';
if exist(fullfile(core_dir,['aromewmed_analys_step3h_2012', mmon, '_T_' , num2str(ala), 'N', '_', num2str(alo), 'E.mat'])) == 2
    load(fullfile(core_dir,['aromewmed_analys_step3h_2012', mmon, '_T_' , num2str(ala), 'N', '_', num2str(alo), 'E.mat'])) ; 
%     load(fullfile(core_dir,['aromewmed_analys_step3h_2012', mmon, '_P_' , num2str(ala), 'N', '_', num2str(alo), 'E.mat'])) ; 
%     load(fullfile(core_dir,['aromewmed_analys_step3h_2012', mmon, '_RH_' , num2str(ala), 'N', '_', num2str(alo), 'E.mat'])) ; 
    load(fullfile(core_dir,['aromewmed_analys_step3h_2012', mmon, '_Q_' , num2str(ala), 'N', '_', num2str(alo), 'E.mat'])) ; 
    load(fullfile(core_dir,['aromewmed_analys_step3h_2012', mmon, '_TKE_' , num2str(ala), 'N', '_', num2str(alo), 'E.mat'])) ; 
    load(fullfile(core_dir,['aromewmed_analys_step3h_2012' , mmon, '_IWV_', num2str(latv), 'N', '_', num2str(lonv), 'E.mat']));
    load(fullfile(core_dir,['aromewmed_analys_step3h_2012' , mmon, '_BLH_', num2str(latv), 'N', '_', num2str(lonv), 'E.mat']));
    % 'P, 'RH','T','Q','latv','lonv','alti','rla','rlo','ht','data_description');
%     ARH = RH(find(alti == alt):length(alti),:,:);
    AT = TA(find(alti == alt):length(alti),:,:); 
%     AP = P(find(alti == alt):length(alti),:,:); 
    AQ = Q(find(alti == alt):length(alti),:,:); 
    ATKE = TKE(find(alti == alt):length(alti),:,:);    
    clear RH TA P Q TKE
end

load(['/media/elena/Transcend/Hymex/AROME_WMED/matfile/3hourly_wind_profiles_radar_and _arome' num2str(mo) '_' num2str(ala), 'N', '_', num2str(alo), 'E.mat']); % radar_monthly.m
%%% variables: 'AUT','AVT','AWST', 'WSPRI','VRI','URI','TAT','ZAT','BL','data_description','latv','lonv','mo'
clear AUT AVT AWST WSPRI VRI URI ZAT data_description latv lonv 

cpt = 1;
for day = 1 : eomday(year,mo);
%     AUR(:,cpt:cpt+7) = ARH(find(alti == alt):length(alti),:,day);
    AUT(:,cpt:cpt+7) = AT(find(alti == alt):length(alti),:,day);    
%     AUP(:,cpt:cpt+7) = AP(find(alti == alt):length(alti),:,day);   
    AUQ(:,cpt:cpt+7) = AQ(find(alti == alt):length(alti),:,day);   
    AUTKE(:,cpt:cpt+7) = ATKE(find(alti == alt):length(alti),:,day);   
    
    AUIWV(1,cpt:cpt+7) = IWV(:,day);
    AUBLH(1,cpt:cpt+7) = BLH(:,day); 
    
    TA(1,cpt:cpt+7) = ht + (day-1)*24;
    cpt = cpt + 8;
end

for it = 1 : size(AUT,1)
    TAT(it,:) = TA;
end

for  it = 1 : size(AUT,2)
    ZAT(:,it) = alti(find(alti == alt):length(alti));
end


%%%%%%%%%%%%  RADAR %%%%%%%%%%%%%%%%%%%%%%%%
load(['/./media/elena/Transcend/Hymex/ASCII/Pianottoli_UHF_mh_01sept_15oct_normalized_20130906.mat']);
% inDatesVec , inU , inV , inW , inZ , inZabl
clear AllData  Pianottoli_UHF_mh_1oct_15oct12_V0  Pianottoli_UHF_mh_sept12_V0 Q T logicalindex inSKEWw inASPT 

%%%%%%%%%%%%%%%%%%%% 
positionvector = [0.06 0.7 0.88 0.29 ; 0.06 0.37 0.88 0.29 ; 0.06 0.04 0.88 0.29 ]; 

clf(figure(1))
figure(1);
set(gcf,'PaperType','A4','PaperUnits','centimeters','Units','centimeters','PaperSize',[27 27],'Position',[2 -1 27 27]); 
colormap(jet(64))
JET=get(gcf,'colormap');
    
subplot('position',positionvector(1,:)); hold on;
pcolor(TAT,ZAT,minus(AUT,273.15)); shading interp; hold on % 'air temperature' [C]
caxis([0 25]); hold on
set(gca,'xlim',[1 24*eomday(year,mo)],'xtick',[1, 24:24:24*eomday(year,mo)],'xticklabel',1:1:eomday(year,mo)+1,'ylim',[0 alt],'ytick',[0:250:alt]); 
ylabel('altitude [meters]');
box on; grid on ;
hcb=colorbar('vertic');
u=get(hcb,'position') ;
set(hcb,'position',[u(1)+0.07  u(2)+0.025  u(3)/2 u(4)/1.2]); 


subplot('position',positionvector(2,:)); hold on;    
pcolor(TAT,ZAT,AUQ); shading interp; hold on % 'specific humidity [g/kg]
caxis([5 13]); box on; grid on ; hold on
set(gca,'xlim',[1 24*eomday(year,mo)],'xtick',[1, 24:24:24*eomday(year,mo)],'xticklabel',1:1:eomday(year,mo)+1,'ylim',[0 alt],'ytick',[0:250:alt]); 
ylabel('altitude [meters]');
h5 = plot(TAT(1,:),AUBLH,'color','k','linewidth',1.5); hold on  % Model Boundary Layer height
h5 = plot(TAT(1,:),BL,'color','w','linewidth',1.5); hold on % Radar Boundary Layer height
hcb=colorbar('vertic');
u=get(hcb,'position') ;
set(hcb,'position',[u(1)+0.07  u(2)+0.025  u(3)/2 u(4)/1.2]); 

subplot('position',positionvector(3,:)); hold on;
pcolor(TAT,ZAT,AUTKE); shading interp; hold on  % TKE m2/s2
caxis([0 2.5]); hold on
set(gca,'xlim',[1 24*eomday(year,mo)],'xtick',[1, 24:24:24*eomday(year,mo)],'xticklabel',1:1:eomday(year,mo)+1,'ylim',[0 alt],'ytick',[0:250:alt]); 
ylabel('altitude [meters]');
box on; grid on ;
h6 = plot(TAT(1,:),AUIWV*10,'color','w','linewidth',1.5); hold on  

hcb=colorbar('vertic');
u=get(hcb,'position') ;
set(hcb,'position',[u(1)+0.07  u(2)+0.025  u(3)/2 u(4)/1.2]); 


