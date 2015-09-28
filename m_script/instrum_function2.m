%%%% reconstruct CNR alues based on alpha(r), cos(teta) and distance "d"

clear figure(6)  ccnr kcnr resol pas AF gama figure(7) betta myscale
% ccnr(1:length(dist)) = NaN ;
% kcnr(1:length(dist)) = NaN ;
% 
% for d = 1:length(FM);  % distance off the lidar
%     clear x 
%     x = 2*epsilon*dist(d) ;
%     kcnr(d) = alpha(d)*x + FM(d); % alpha is unique at each scanning distance
%     ccnr(d) = .0006*-x + FM(d); % constant alpha = 0.6
% end
% 
% figure(6)
% scatter(dist,ccnr,'r','fill') ; hold on  % reconstructed cnr
% scatter(dist,kcnr,'g','fill') ; hold on % reconstructed cnr
% 
% %%% rng = list of all CNR profiles within the sector (in original resolution)
% for profile = rng(1):rng(length(rng)) ;
%     scatter(r_0(profile,:)*cosd(profile-ref),BBT(profile,:),3,'k','fill'); hold on
% end
% title({['black dots: all CNR(d) measurements'];['in green : CNR reconstructed with calcualated alpha(d) and calculated b(d)'];['in red : CNR(d) reconstructed with constant alpha = 0.6 and calculated b(d)'];[datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
% ' - ',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
% ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20)];[num2str(length(rng)) ' tirs: ' num2str(min(rng)) ' - ' num2str(max(rng)) ]},'color','k') ;
% ylabel(['   CNR [dB] '],'color','k');
% xlabel(['   scanning distance projected on the reference axis (d) in meters'],'color','k');

figure(7)
profile = 13 ;
% colormap(jet);
% JET=get(gcf,'colormap');

resol = r_0(profile,:)*cosd(profile-ref);
pas = 13;
S = 30 : 60 : 90 ;


for k = 1 : length(S)
for  i = 1 : length(resol)
        clear d c
        d = find(dist > resol(i)-pas & dist < resol(i) + pas);
       
        if isempty(d)       
            continue
        elseif d > length(FM)
            break            
        elseif ~isempty(d) & d > 0
% %         AF(i) = (minus(BBT(profile,i),FM(d)))/(-2*epsilon*dist(d));  
% %         AF(i) = minus(BBT(profile,i),(2*epsilon*dist(d)*0.0006)); %alpha(d)));  
             betta(d,k) = abs(alpha(d))/S(k)   ;
             gama(d,k) = minus(FM(d),10*log10(alpha(d)/S(k)))   ;
             myscale(d) = dist(d);
        end
end % d
        c(1:length(myscale)) = k*10;
        myscale(find(myscale == 0)) = NaN;
        gama(find(gama ==0))=NaN;
        scatter(myscale,gama(:,k),25,c,'filled'); hold on
%         scatter(myscale,betta(:,k),25,c); hold on       
end % k
xlabel(['   scanning distance (d) in meters'],'color','k');
%  ylabel(['  betta(d) in m^-^1 sr^-^1 '],'color','k');
ylabel(['  b(d) - betta(d) = K + F(d) '],'color','k');
title({['K + 10*log10(F(d)) using calculated abs(alpha(d)) and calculated b(d)'];...
% title({['Backscatter Coefficient evaluated using calculated abs(alpha(d)) and calculated b(d)'];...
    [datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
' - ',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20)];[num2str(length(rng)) ' tirs: ' num2str(min(rng)) ' - ' num2str(max(rng)) ]},'color','k') ;
box on

%%% original alpha(d) vs recalculated alpha(d) as a function of cnr measured and b(d)
% clear figure(7)
% figure(7)
% scatter(dist(1:length(alpha)), abs(alpha),'fill','k'); hold on
% scatter(resol(1:length(AF)),abs(AF),'m','fill'); hold on


%%%%% free element b(d) recalculated using original alpha(d) and original cnr(d)
% clear figure(7)
% figure(7)
% scatter(dist(1:length(alpha)), FM ,'fill','k'); hold on
% scatter(resol(1:length(AF)),AF,'m','fill'); hold on






    