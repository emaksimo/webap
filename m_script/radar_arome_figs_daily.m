

clear all
close all

B = 13 ;

%%%%%%%%%%%%%%%%%%%% CONTROL parameters 
%%% Pianatoli radar position : 41.4722 N and 9.0656 E

%%% ERAI coordinates closest to Pianatoli radar
pla = 41.25 ; % deg N
plo = 9; % deg est

%%% AROME-WMED coordinates closest to Pianatoli radar
ala = 41.48;  alai = 242; % find(lati(:,1) == ala)
alo = 9.08;   aloi = 704; % find(loni(1,:) == alo)

%%%%%
alt = 3000; % the highest altitude for the comparison
year = 2012;
mo = 9;
h = 12;
mm = 00; % minutes
ca = [-25 25] ; % horisontal wind speed color limits
cw = [-2 2] ; % vertical wind speed color limits


%%%%%%%%%%%    ERA-Interim   %%%%%%%%%%%
% load(['/./media/elena/Transcend/Hymex/ASCII/Pianatoli_ERAI_UVWZTQ_verticle.mat']); %'U','V','W','Z','T','Q','level','lat','lon','time'); 
% EU = U;
% EV = V;
% EZ = Z;
% ET = time;
% clear U V W Z T Q  level lat lon time
%     for i = 1 : 9
%         TE(i,:) = 0 : 6 : 24; 
%     end

%%%%%%%%%%     AROME-WMED    %%%%%%%%%%%
if mo < 10 
      mmon = [num2str(0), num2str(mo)];
else
      mmon = num2str(mo);
end
                                
% core_dir = '/media/elena/SAMSUNG/AROME-WMED-REANALYSIS/matfile/';  % see   read_aromewmed.m
core_dir = '/media/elena/Transcend/Hymex/AROME_WMED/matfile/';  % see   read_aromewmed.m
% fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_U_' , num2str(ala), 'N', '_', num2str(alo), 'E.mat'])
if exist(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_U_' , num2str(ala), 'N', '_', num2str(alo), 'E.mat'])) == 2
    load(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_U_' , num2str(ala), 'N', '_', num2str(alo), 'E.mat'])) ; 
    load(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_V_' , num2str(ala), 'N', '_', num2str(alo), 'E.mat'])) ; 
    % 'U, 'V','latv','lonv','alti','rla','rlo','ht','data_description');
    AU = U(find(alti == alt):length(alti),:,:);
    AV = V(find(alti == alt):length(alti),:,:); 
    clear U V 
end

AWS = sqrt(AU.^2 + AV.^2);  % wind speed profile every 3h avery day of month

for i = 1 : length(find(alti == alt):length(alti))
    TA(i,:) = ht; % for plots of vertical profiles
end

for i = 1 : length(ht)
    ZA(:,i) = alti(find(alti == alt):length(alti));
end

%%%%%%%%%%%%  RADAR %%%%%%%%%%%%%%%%%%%%%%%%

load(['/./media/elena/Transcend/Hymex/ASCII/Pianottoli_UHF_mh_01sept_15oct_normalized_20130906.mat']);
% inDatesVec , inU , inV , inW , inZ , inZabl
clear AllData  Pianottoli_UHF_mh_1oct_15oct12_V0  Pianottoli_UHF_mh_sept12_V0 Q T logicalindex inSKEWw inASPT 

%%%%%%%%%%%%%%%%%%%% 
positionvector = [0.06 0.7 0.4 0.28 ; 0.06 0.37 0.4 0.28 ; 0.06 0.04 0.4 0.28 ; 0.55 0.7 0.4 0.28 ; 0.55 0.37 0.4 0.28 ; 0.55 0.04 0.4 0.28 ]; 
raz = max(find(inZ <= alt)) ; % radar altitude index within the matrix
ral =  inZ(raz) ; % the highest radar altitude 

% eaz = min(find(Z(:,1) <= alt)) ; % the highest erai altitude 
%%% the lowest erai altitude is about 100 - 130m above the ground,
%%% corresponding to the pressure level

for day = B : eomday(year,mo); % day range
    close all
    clear modt1 modt2 modt radt ZR TR VR UR WR ER CR tt dv du hh vv uu STDRW BL
    figure(1);
    set(gcf,'PaperType','A4','PaperUnits','centimeters','Units','centimeters','PaperSize',[27 27],'Position',[2 -1 27 27]); 
    hold on
    colormap(jet(64))
    JET=get(gcf,'colormap');
    
%     modt1 = find(time(:,2) == mo & time(:,3) == day); % erai
%     modt2 = find(time(:,2) == mo & time(:,3) == day+1 & time(:,4) == 0); % erai
%     if length(modt1) & length(modt2) > 0 % if the last day of month
%         modt = [modt1; modt2];
%     else
%         modt2 = modt1(length(modt1)) + 1;
%         modt = [modt1; modt2];
%     end
            
    radt = find(inDatesVec(:,2) == mo & inDatesVec(:,3) == day & inDatesVec(:,4) >= 0 & inDatesVec(:,4) <= 24); % radar  

    if length(radt) == 0 % if no radar data on this day
        continue
    end

    %%% daily evolution of ERA Interim U wind component
%     subplot('position',positionvector(1,:)); hold on;    
%     pcolor(TE,Z(eaz:16,modt),U(eaz:16,modt)); shading interp; hold on
%     caxis([ca(1) ca(2)]); hold on
%     set(gca,'xlim',[0 24],'xtick',0:3:24,'ylim',[0 alt],'ytick',[0:250:alt]); 
%     ylabel('altitude [meters]');
%     xlabel('erai U wind [m/s]'); 
%     
%     %%% daily evolution of ERA Interim V wind component
%     subplot('position',positionvector(2,:)); hold on;    
%     pcolor(TE,Z(eaz:16,modt),V(eaz:16,modt)); shading interp; hold on
%     caxis([ca(1) ca(2)]); hold on
%     set(gca,'xlim',[0 24],'xtick',0:3:24,'ylim',[0 alt],'ytick',[0:250:alt]); 
%     ylabel('altitude [meters]');
%     xlabel('erai V wind [m/s]'); 
%     
%     %%% daily evolution of ERA Interim W wind component
%     subplot('position',positionvector(3,:)); hold on;    
%     pcolor(TE,Z(eaz:16,modt),W(eaz:16,modt)); shading interp; hold on
%     caxis([cw(1) cw(2)]);
%     set(gca,'xlim',[0 24],'xtick',0:3:24,'ylim',[0 alt],'ytick',[0:250:alt]); 
%     ylabel('altitude [meters]');
%     xlabel('erai V wind [m/s]'); 
    
    % arome profile at pianatoly at given moment
% alti(1:find(alti == alt))
% U(alai,aloi,1:find(alti == alt))
% V(alai,aloi,1:find(alti == alt))
% WS(:,1)
% 

    subplot('position',positionvector(1,:)); hold on;    
    if day < eomday(year,mo)
        pcolor([TA,TA(:,1)+24],[ZA,ZA(:,1)],[AU(find(alti == alt):length(alti),:,day),AU(find(alti == alt):length(alti),1,day+1)]); shading interp; hold on
    else
        pcolor(TA,ZA,AU(find(alti == alt):length(alti),:,day)); shading interp; hold on
    end
    caxis([ca(1) ca(2)]); hold on
    set(gca,'xlim',[0 24],'xtick',0:3:24,'ylim',[0 alt],'ytick',[0:250:alt]); 
    ylabel('altitude [meters]');
    xlabel(['arome U wind [m/s], ' num2str(day) '/' num2str(mo) '/2012, ' num2str(ala), 'N', ' ', num2str(alo), 'E']); 
    box on; grid on ;
    hcb=colorbar('vertic');
	u=get(hcb,'position') ;
	set(hcb,'position',[u(1)+0.06  u(2)  u(3)/1.7 u(4)]);
    
    subplot('position',positionvector(2,:)); hold on;    
    if day < eomday(year,mo)
        pcolor([TA,TA(:,1)+24],[ZA,ZA(:,1)],[AV(find(alti == alt):length(alti),:,day),AV(find(alti == alt):length(alti),1,day+1)]); shading interp; hold on
    else
        pcolor(TA,ZA,AV(find(alti == alt):length(alti),:,day)); shading interp; hold on
    end
    caxis([ca(1) ca(2)]); hold on
    set(gca,'xlim',[0 24],'xtick',0:3:24,'ylim',[0 alt],'ytick',[0:250:alt]); 
    ylabel('altitude [meters]');
    xlabel(['arome V wind [m/s], ' num2str(day) '/' num2str(mo) '/2012, ' num2str(ala), 'N', ' ', num2str(alo), 'E']);    
    box on; grid on ;
    hcb=colorbar('vertic');
	u=get(hcb,'position') ;
	set(hcb,'position',[u(1)+0.06  u(2)  u(3)/1.7 u(4)]);
    
    subplot('position',positionvector(3,:)); hold on;    
    if day < eomday(year,mo)
        pcolor([TA,TA(:,1)+24],[ZA,ZA(:,1)],[AWS(find(alti == alt):length(alti),:,day),AWS(find(alti == alt):length(alti),1,day+1)]); shading interp; hold on
    else
        pcolor(TA,ZA,AWS(find(alti == alt):length(alti),:,day)); shading interp; hold on
    end
    caxis([ca(1) ca(2)]); hold on
    set(gca,'xlim',[0 24],'xtick',0:3:24,'ylim',[0 alt],'ytick',[0:250:alt]); 
    ylabel('altitude [meters]');
    xlabel(['arome wind speed [m/s], ' num2str(day) '/' num2str(mo) '/2012, ' num2str(ala), 'N', ' ', num2str(alo), 'E']);  
    box on; grid on ;
    hcb=colorbar('vertic');
	u=get(hcb,'position') ;
	set(hcb,'position',[u(1)+0.06  u(2)  u(3)/1.7 u(4)]);
    
    text(-3,-220,['DAY ' num2str(day) ],'FontSize',14); 
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    %%% reshape radar vector data into matrix
    
    for i = 1 : length(radt) % observation time 
        ZR(:,i) = flipud(inZ(1:raz));
        TR(1:raz,i) = inDatesVec(radt(i),4) +  (inDatesVec(radt(i),5)/60);
        VR(:,i) = rot90(inV(radt(i),1:raz));
        UR(:,i) = rot90(inU(radt(i),1:raz));
        WR(:,i) = rot90(inW(radt(i),1:raz));
        ER(:,i) = rot90(inEPSI(radt(i),1:raz));
        CR(:,i) = rot90(inCN2(radt(i),1:raz));
        STDRW(:,i) = rot90(in2STDw(radt(i),1:raz));
    end
   
    BL = inZabl(radt);
    WSPR = sqrt(UR.^2 + VR.^2);  % wind speed profile
    
    %%% daily evolution of RADAR U wind component
    subplot('position',positionvector(4,:)); hold on;    
    pcolor(TR,ZR,UR); shading interp; hold on
    caxis([ca(1) ca(2)]); box on; grid on ; hold on
    set(gca,'xlim',[0 24],'xtick',0:3:24,'ylim',[0 alt],'ytick',[0:250:alt]); 
%     ylabel('altitude [meters]');
    xlabel('radar U wind [m/s]'); 
    hcb=colorbar('vertic');
	u=get(hcb,'position') ;
	set(hcb,'position',[u(1)+0.06  u(2)  u(3)/1.7 u(4)]);
    
    %%% daily evolution of RADAR V wind component
    subplot('position',positionvector(5,:)); hold on;    
    pcolor(TR,ZR,VR); shading interp; hold on
    caxis([ca(1) ca(2)]); box on; grid on ; hold on
    set(gca,'xlim',[0 24],'xtick',0:3:24,'ylim',[0 alt],'ytick',[0:250:alt]); 
%     ylabel('altitude [meters]');
    xlabel('radar V wind [m/s]'); 
    hcb=colorbar('vertic');
	u=get(hcb,'position') ;
	set(hcb,'position',[u(1)+0.06  u(2)  u(3)/1.7 u(4)]);  
    
    %%% daily evolution of RADAR wind speed
    subplot('position',positionvector(6,:)); hold on;    
    pcolor(TR,ZR,WSPR); shading interp; hold on
    caxis([ca(1) ca(2)]); box on; grid on ; hold on
    set(gca,'xlim',[0 24],'xtick',0:3:24,'ylim',[0 alt],'ytick',[0:250:alt]); %,'yticklabel',inZ(1:4:56))
%     ylabel('altitude [meters]');
    xlabel('radar wind speed [m/s]'); 
    hcb=colorbar('vertic');
	u=get(hcb,'position') ;
	set(hcb,'position',[u(1)+0.06  u(2)  u(3)/1.7 u(4)]); 
    
    %     %%% daily evolution of RADAR W wind component
%     subplot('position',positionvector(6,:)); hold on;    
%     pcolor(TR,ZR,WR); shading interp; hold on
%     caxis([cw(1) cw(2)]);
%     set(gca,'xlim',[0 24],'xtick',0:3:24,'ylim',[0 alt],'ytick',[0:250:alt]); %,'yticklabel',inZ(1:4:56))
%     ylabel('altitude [meters]');
%     xlabel('radar W wind [m/s]'); 
    
    hcb=colorbar('horiz');
	u=get(hcb,'position') ;
	set(hcb,'position',[u(1)-0.18  u(2)-0.045  u(3)/1.5 u(4)/2],'xtick',[ca(1) : 5 : ca(2)]); 
    f=get(hcb,'xlabel');
    set(findall(gcf,'type','text'),'fontsize',9)
    hcb=colorbar('vertic');
	u=get(hcb,'position') ;
	set(hcb,'position',[u(1)+0.06  u(2)  u(3)/1.7 u(4)]); 



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

    clf(figure(5))
    figure(5)
    colormap(jet(64))
    set(gcf,'PaperType','A4','PaperUnits','centimeters','Units','centimeters','PaperSize',[40 20],'Position',[-1 -1 40 20]); hold on
    subplot('position', [0.05 0.1 0.94 0.87]); hold on;  
    y = 4;
    un1 = UR./sqrt(UR.^2+VR.^2);
    vn1 = VR./sqrt(UR.^2+VR.^2);
    
    pcolor(TR,ZR/100,WSPR); shading interp; hold on
    caxis([ca(1) ca(2)]); box on; grid on ; hold on

    hcb=colorbar('horiz');
	u=get(hcb,'position') ;
	set(hcb,'position',[u(1)+.74 u(2)-0.1 u(3)/4.8 u(4)/1.6]); 
    
    a1 = quiver(TR(:,1:y:size(TR,2)),ZR(:,1:y:size(TR,2))/100,un1(:,1:y:size(TR,2)),vn1(:,1:y:size(TR,2)),0.4,'color','k'); hold on 
    set(gca,'xlim',[0 25],'xtick',0:3:24,'ylim',[0 alt/100],'ytick',0:2.5:alt/100,'yticklabel',0:250:alt); 
    ylabel('altitude [meters]');
    xlabel(['UHF horizontal wind speed (m/s, color) and direction (arrows), hours [GMT], ' num2str(day) '/' num2str(mo) '/2012, ' num2str(ala), 'N', ' ', num2str(alo), 'E'])
    grid on; box on;
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    figure(3);
    colormap(jet(64))
    set(gcf,'PaperType','A4','PaperUnits','centimeters','Units','centimeters','PaperSize',[15 27],'Position',[30 -1 15 27]); hold on
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
%     pcolor(TR,ZR,STDRW); shading interp; hold on
%     caxis([1 5]);
%     set(gca,'xlim',[0 24],'xtick',0:3:24,'ylim',[0 alt],'ytick',[0:250:alt]); 
%     ylabel('altitude [meters]');
%     xlabel('2 std of W-component [m/s]'); 
%     h5 = plot(TR(1,:),BL,'k'); hold on
%     grid on; box on;
%     hcb=colorbar('vertic');
% 	u=get(hcb,'position') ;
% 	set(hcb,'position',[u(1)+0.12  u(2)  u(3)/1.7 u(4)]); 
    
    %%%% daily evolution of RADAR W wind component
%     pcolor(TR,ZR,WR); shading interp; hold on
%     caxis([cw(1) cw(2)]);
%     set(gca,'xlim',[0 24],'xtick',0:3:24,'ylim',[0 alt],'ytick',[0:250:alt]); hold on
%     ylabel('altitude [meters]');
%     xlabel(['radar W wind [m/s], ' num2str(day) '/' num2str(mo) '/2012, ' num2str(ala), 'N', ' ', num2str(alo), 'E']); 
%     hcb=colorbar('vertic');
% 	u=get(hcb,'position') ;
% 	set(hcb,'position',[u(1)+0.12  u(2)  u(3)/1.7 u(4)]);  hold on
%     grid on; box on;
%     set(findall(gcf,'type','text'),'fontsize',9)
    
   break
end


figure(4);
colormap(jet(64))
set(gcf,'PaperType','A4','PaperUnits','centimeters','Units','centimeters','PaperSize',[27 27],'Position',[2 -1 27 27]); 
   
subplot('position',positionvector(1,:)); hold on;    
pcolor(TR,ZR,UR); shading interp; hold on
caxis([ca(1) ca(2)]); box on; grid on ; hold on
set(gca,'xlim',[0 24],'xtick',0:3:24,'ylim',[0 alt],'ytick',[0:250:alt]); 
ylabel('altitude [meters]');
xlabel('radar U wind [m/s]'); 
hcb=colorbar('vertic');
u=get(hcb,'position') ;
set(hcb,'position',[u(1)+0.06  u(2)  u(3)/1.7 u(4)]);

subplot('position',positionvector(4,:)); hold on;
pcolor(TR,ZR,WR); shading interp; hold on
caxis([cw(1) cw(2)]);
set(gca,'xlim',[0 24],'xtick',0:3:24,'ylim',[0 alt],'ytick',[0:250:alt]); hold on
xlabel(['radar W wind [m/s], ' num2str(day) '/' num2str(mo) '/2012, ' num2str(ala), 'N', ' ', num2str(alo), 'E']); 
hcb=colorbar('vertic');
u=get(hcb,'position') ;
set(hcb,'position',[u(1)+0.06  u(2)  u(3)/1.7 u(4)]);
grid on; box on;
set(findall(gcf,'type','text'),'fontsize',9)


