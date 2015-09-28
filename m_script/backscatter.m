%%% retrieve the shape of the Instrumental function within d = 28 - 25
%%% prescribe the same lidar ratio at all distances "d"

clear S gama beta figure(11) figure(12) figure(13) BS k 

S = 30:10:90;

for k = 1 : length(S) ; 
    for d = 1 : length(alpha)   % 28 : 45 ;  
        if ~isnan(alpha(d))
            BS(d,k) = abs((alpha(d))/S(k)); 
            beta(d,k) = 10*log10(BS(d,k)) ;          
            gama(d,k) = minus(FM(d), beta(d,k)) ; % gama(R) = 10*log10(F(R)) + K
            G(d,k) = 10^(gama(d,k)/10) ;
        else
            BS(d,k) = NaN;
            beta(d,k) = NaN;
            gama(d,k) = FM(d) ;
            G(d,k) = 10^(gama(d,k)/10) ;
        end        
    end    
end

figure(11)

 
for k = 1 : length(S)
    plot(gama(:,k),'LineWidth',2.5,'Color','b','LineStyle','-'); hold on
%     text(length(dist)/1.5, -27+k ,{['Sr = ' num2str(S(k)) ]}); hold on
end

% xlim([1 length(dist)]); 
% ylim([-27 -13]); 
% set(gca,'xtick',1:8:length(dist),'xticklabel',round(dist(1)):200:round(dist(length(dist))),'FontSize',10,'fontWeight','demi','box','on'); hold on
title({['Instrumental Function 10*log10(F(R)) plus offset (K)'];[datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
' - ',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20)];[num2str(length(rng)) ' tirs: ' num2str(min(rng)) ' - ' num2str(max(rng)) ]},'color','k') ;
ylabel(['   10*log10(F(R)) plus the unknown offset K '],'color','k');
xlabel(['   scanning distance (R) in meters'],'color','k');


figure(12)
plot(BS(:,1),'LineWidth',2.5,'Color','b','LineStyle','-'); hold on
text(length(dist)/1.5, .00003 ,{['Sr = ' num2str(S(1)) ]},'Color','b'); hold on

plot(BS(:,4),'LineWidth',2.5,'Color','r','LineStyle','-'); hold on
text(length(dist)/1.5, .0000275 ,{['Sr = ' num2str(S(4)) ]},'Color','r'); hold on

plot(BS(:,7),'LineWidth',2.5,'Color','g','LineStyle','-'); hold on
text(length(dist)/1.5, .000025 ,{['Sr = ' num2str(S(7)) ]},'Color','g'); hold on

xlim([1 length(dist)]);
set(gca,'xtick',1:8:length(dist),'xticklabel',round(dist(1)):200:round(dist(length(dist))),'FontSize',10,'fontWeight','demi','box','on'); hold on

title({['Backscatter coefficient (BETTA) as a function of distance (R), lidar ratio and alpha(R)'];[datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
' - ',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20)];[num2str(length(rng)) ' tirs: ' num2str(min(rng)) ' - ' num2str(max(rng)) ]},'color','k') ;
ylabel(['   Backscatter coeff [m^-^1 sr^-^1] '],'color','k');
xlabel(['   scanning distance (R) in meters'],'color','k');


figure(13)
for k = 1 : length(S)
    plot(G(:,k)/10000,'LineWidth',2.5,'Color','b','LineStyle','-'); hold on
    title({['F x K' ]}) ;
end
ylim([0 1]);



