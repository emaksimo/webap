%%%  zoom on radar U,V,W for specific moments of chosen day 
%%% define : mo, day, hc

clear all
close all

load(['/./media/Transcend/Hymex/ASCII/Pianottoli_UHF_mh_01sept_15oct_normalized_20130906.mat']);
% inDatesVec , inU , inV , inW , inZ , inZabl

%%%%%%%%%%%%%%%%%%%% CONTROL parameters 
year = 2012;
mo = 9;
day = 20;
hc = [2 3]; % hour of the day lowest and upper range)
ca = [-6 6]; % U and V wind color scale
alt = 2000; % the highest altitude


%%%%%%%%%%%%%%%%%%%%%%%
clear modt1 modt2 modt radt TE ZR TR VR UR tt dv du hh vv uu DR SR DIR U1 V1 ER CR
positionvector = [0.03 0.7 0.45 0.29 ; 0.03 0.37 0.45 0.29 ; 0.03 0.04 0.45 0.29 ; 0.54 0.7 0.45 0.29 ; 0.54 0.37 0.45 0.29 ; 0.54 0.04 0.45 0.29 ]; 
raz = max(find(inZ <= alt)) ;
ral =  inZ(raz) ; % the highest radar altitude 

figure(1);
set(gcf,'PaperType','A4','PaperUnits','centimeters','Units','centimeters','PaperSize',[30 30],'Position',[2 2 30 30]); hold on
colormap(jet(64))
JET=get(gcf,'colormap');

radt = find(inDatesVec(:,2) == mo & inDatesVec(:,3) == day & inDatesVec(:,4) >= hc(1) & inDatesVec(:,4) <= hc(2)); % radar  
    
for i = 1 : length(radt) % observation time 
        ZR(:,i) = flipud(inZ(1:raz));
        TR(1:raz,i) = inDatesVec(radt(i),4) +  (inDatesVec(radt(i),5)/60);
        VR(:,i) = rot90(inV(radt(i),1:raz));
        UR(:,i) = rot90(inU(radt(i),1:raz));
        WR(:,i) = rot90(inW(radt(i),1:raz));
        ER(:,i) = rot90(inEPSI(radt(i),1:raz));
        CR(:,i) = rot90(inCN2(radt(i),1:raz));
end

DR = atand(abs(VR)./abs(UR)); % wind direction relative to N, clockwise
DIR = nan([size(DR,1) size(DR,2)]);

DIR(find(VR >= 0 & UR >= 0)) = minus(90,DR(find(VR >= 0 & UR >= 0))); % NE 
DIR(find(VR <= 0 & UR >= 0)) = DR(find(VR <= 0 & UR >= 0)) + 90; % SE
DIR(find(VR <= 0 & UR <= 0)) = minus(270,DR(find(VR <= 0 & UR <= 0))) ; % SW
DIR(find(VR >= 0 & UR <= 0)) = plus(DR(find(VR >= 0 & UR <= 0)),270) ; % NW

SR = sqrt(VR.^2 + UR.^2);% wind speed 

subplot('position',positionvector(1,:)); hold on;    
pcolor(TR,ZR,UR); shading interp; hold on
caxis([ca(1) ca(2)]); hold on
set(gca,'xlim',[hc(1) hc(2)],'xtick',hc(1) : 0.5 : hc(2),'ylim',[5 ral],'ytick',5:150:ral) ;
ylabel('altitude [meters]');
xlabel('radar U component [m/s]'); 
text(0,-250,['DAY ' num2str(day) ],'FontSize',18);  

subplot('position',positionvector(2,:)); hold on;    
pcolor(TR,ZR,VR); shading interp; hold on
caxis([ca(1) ca(2)]); hold on
set(gca,'xlim',[hc(1) hc(2)],'xtick',hc(1) : 0.5 : hc(2),'ylim',[5 ral],'ytick',5:150:ral) ; 
ylabel('altitude [meters]');
xlabel('radar V component [m/s]'); 
text(0,-250,['DAY ' num2str(day) ],'FontSize',18); 

hcb=colorbar;
u=get(hcb,'position') ;
set(hcb,'position',[u(1)+0.05  u(2)  u(3)/2 u(4)]); 
f=get(hcb,'ylabel');
set(f,'string', {'U, V, wind speed [m/s]'},'fontsize',8,'FontWeight','demi');
        

subplot('position',positionvector(3,:)); hold on;    
pcolor(TR,ZR,WR); shading interp; hold on
caxis([-2 2]); hold on
set(gca,'xlim',[hc(1) hc(2)],'xtick',hc(1) : 0.5 : hc(2),'ylim',[5 ral],'ytick',5:150:ral)
ylabel('altitude [meters]');
xlabel('radar W component [m/s]'); 
text(0,-250,['DAY ' num2str(day) ],'FontSize',18); 

clear u hcb f
hcb=colorbar;
u=get(hcb,'position') ;
set(hcb,'position',[u(1)+0.05  u(2)  u(3)/2 u(4)]); 
f=get(hcb,'xlabel');
set(f,'string', {'W wind speed [m/s]'},'fontsize',8,'FontWeight','demi');
  

subplot('position',positionvector(4,:)); hold on;    
[x,y] = meshgrid(1:length(radt),1:raz);
Y = flipud(y); 
pcolor(x,Y,SR); shading interp; hold on
caxis([ca(1) ca(2)]); hold on

%%% normalise U and V wind components for the plot, while preserving the wind direction 
U1 = cosd(atand(abs(VR)./abs(UR)));
V1 = sind(atand(abs(VR)./abs(UR)));
U1(find(UR < 0)) = U1(find(UR < 0))*(-1);
V1(find(VR < 0)) = V1(find(VR < 0))*(-1);
quiver(x(:,1:2:length(radt)),Y(:,1:2:length(radt)),U1(:,1:2:length(radt)),V1(:,1:2:length(radt)),0.3,'color','k'); hold on
ylabel('altitude [meters]');
xlabel('radar wind speed [m/s] and normalised horizontal wind direction'); 
set(gca,'xlim',[0 length(radt)],'xtick',0 : length(radt)/2 : length(radt),'xticklabel',hc(1) : 0.5 : hc(2),'ylim',[0 12],'ytick',0:12,'yticklabel',5:155:1865); 


subplot('position',positionvector(5,:)); hold on;    
[x,y] = meshgrid(1:length(radt),1:1:12);
pcolor(TR,ZR,ER); shading interp; hold on
caxis([0 0.005])
set(gca,'xlim',[hc(1) hc(2)],'xtick',hc(1) : 0.5 : hc(2),'xticklabel',[],'ylim',[5 ral],'ytick',5:150:ral,'yticklabel',[]) ;
% ylabel('altitude [meters]');
xlabel('epsilon [m^2/s^3]'); 


subplot('position',positionvector(6,:)); hold on;    
pcolor(TR,ZR,CR); shading interp; hold on
caxis([0 10^(-12)])
set(gca,'xlim',[hc(1) hc(2)],'xtick',hc(1) : 0.5 : hc(2),'xticklabel',[],'ylim',[5 ral],'ytick',5:150:ral,'yticklabel',[]) ;
% ylabel('altitude [meters]');
xlabel('refractive index [m^{-2/3}]'); 
    


% for lev = 8 : 16 % vertical levels 
%     Tpot(lev) = T(lev,modt)*((1000/level(lev))^0.286) ;
% end

% h4 = plot(Tpot,Z(8:16,modt),'r','linewidth',2); hold on % ERAI data