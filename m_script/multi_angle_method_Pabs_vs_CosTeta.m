% clear ze T D DC d a  figure(14) figure(15) f1 thresh zone z1 d1 list dat dPz dP col ccnr az PP DI BBT
% clear figure(16) figure(17)

% if exist('f1')
%     clf(f1) ;
% elseif exist('f2')
%     clf(f2) ;
% elseif exist('f3')
%     clf(f3) ; 
% end
clear alpha FM FM_ERR ERR
clf (figure(21)); clf (figure(20)) ;

if loopme == 1
        clf (figure(14)); 
        lm = 14 ; % figure number
        p = 1 ; % subplot counter
end

dt = 2 ; % meters around the reference "d" value
ct = 1; % counter used to regroup all CNR data within the "peak of F(R)" 

for d = 1:length(dist);  % distance off the lidar
    clear B BINT R RINT STATS XX Y a aa b bb c cc s ss z zz ai bi ci si zi u ui
     
%     u = z2(find(fi <= dist(d)+dt & fi >= dist(d)-dt)) ; % corresponding projection of each interpolated CNR value on the reference axis 
    
    %%% (delta CNR/epsilon) + 2lnxR1 are compared against (1/cos(teta1) minus  1/cos(teta2)) to retrieve alpha    
    a = BI(find(fi < dist(d)+dt & fi >= dist(d)-dt)) ; % all CNR values within the good (homeneguous) sector, roughly corresponding to distance "d" 
    
    if length(find(~isnan(a))) == 0
        alpha(d) = NaN ; ERR(d,1:2) = NaN ; FM(d) = NaN; FM_ERR(d,1:2) = NaN ;
        continue % d loop
    end
    b = (CS(find(fi < dist(d)+dt & fi >= dist(d)-dt)).^(-1)); % corresponding 1/cos(teta) relative to the new axis "ref"
%     c = distance(find(fi < dist(d)+dt & fi >= dist(d)-dt)) ;  % corresponding radius
%     z = AZI(find(fi < dist(d)+dt & fi >= dist(d)-dt)) ;  % corresponding azimuthal angle
    s = d2(find(fi < dist(d)+dt & fi >= dist(d)-dt)) ;  % projection of cnr on OX axis
    
    ai = a(find(~isnan(a)));  % cnr
%     zi = z(find(~isnan(a)));  % azimuthal angle
    bi = b(find(~isnan(a)));  % 1/cos(teta)
%     ci = c(find(~isnan(a)));  % radius
%     ui = u(find(~isnan(a)));  % projection of cnr on OY axis
%     si = s(find(~isnan(a)));  % projection of cnr on OX axis    
    
%     [ai*10,zi,bi*1000,ci,ui,si]
%                    clf (figure(6));
%                    figure(6)
%                    scatter(si,ui,45,bi,'fill'); %'Marker','o','MarkerFaceColor',[col],,MarkerEdgeColor','none'; 
%                    colorbar    
    
%     aa(1:length(ai),1:length(ai)) = NaN; bb = aa; cc = aa ; ss = aa;
%     for i = 1:length(ai)-1    % all cnr data that have the same projection of cnr on OY axis
%         clear l
%         aa(i+1:length(ai),i) = minus(ai(i+1:length(ai)), ai(i)) ; % delta CNR 
%         bb(i+1:length(ai),i) = minus(bi(i+1:length(ai)), bi(i)) ; % delta cos teta
%         cc(i+1:length(ai),i) = minus(ci(i+1:length(ai)), ci(i)) ; % corresponding delta R
%         ss(i+1:length(ai),i) = abs(minus(si(i+1:length(ai)), si(i))) ; % linear (the shortest) distance between two values, perpendicular to AY  
        %%% if CNR values are symmetrically located, or located within 60m around the "reference" CNR value, than do not compare these CNR values
%         l = NaN([length(ai) 1]); 
%         l(i+1:length(ai)) = si(i+1:length(ai)) ; 
%         aa(find(abs(l) <= abs(si(i))+10 & abs(l) >= abs(si(i))-10),i) = NaN;
%         bb(find(abs(l) <= abs(si(i))+10 & abs(l) >= abs(si(i))-10),i) = NaN;
%         cc(find(abs(l) <= abs(si(i))+10 & abs(l) >= abs(si(i))-10),i) = NaN;
%         ss(find(abs(l) <= abs(si(i))+10 & abs(l) >= abs(si(i))-10),i) = NaN;
%         [aa(:,1),bb(:,1),cc(:,1),ss(:,1)/1000]
%         zi(find(bb(:,1) < 0)) ;
%     end
    
%     Y = aa(find(~isnan(aa))); % delta CNR
%     XX(1:length(Y),2) = bb(find(~isnan(aa))); % predictor
    
    Y = ai;  % CNR
    XX(1:length(Y),2) = bi ; % predictor
    XX(1:length(Y),1)=1;
    XX(find(abs(XX(:,2)) <= 0.001),2) = NaN;
    Y(find(abs(XX(:,2)) <= 0.001),1) = NaN;

    YN(ct : ct+length(Y)-1,1) = Y; % delta CNR
    XN(ct : ct+length(Y)-1,1) = XX(:,2); % predictor
    ct = ct + length(Y) ;
    
    clear a b c s z aa bb cc zz ss ai bi ci zi si
    
    %%% linear fit: interpolated CNR value vs delta cos teta for each combination of observations
    if length(find(~isnan(Y))) <= 3
         alpha(d) = NaN;
         ERR(d,1:2) = NaN ;
         FM(d) = NaN ;
         FM_ERR(d,1:2) = NaN;
%          RMSE(d) = NaN;
    else        
        [B,BINT,R,RINT,STATS]=regress(Y,XX,0.01);
        %  B = intercept and the coef for the linear regression
        %  BINT = conf intervals for the coefficients B
        %  R =  vector of residuals: reality minus the linear model
        %  RINT = vector of confidence intervals for the residuals
        %  STATS = r-square, f-stat, p-value   
%         RMSE(d)=sqrt(nansum(R.^2)/(length(find(~isnan(XX(:,2))))-1)); % erros when predicting CNR values with delta(cos(teta)) in [dB] 
        alpha(d) = B(2)/(-2*dist(d)); % angle of the linear fit
        FM(d) = B(1); % the free coefficient "b" of the linear fit
        ERR(d,:) = BINT(2,:)/(-2*dist(d));
        FM_ERR(d,:) = BINT(1,:);

%         clf (figure(4));
%         figure(4)
%         scatter(XX(:,2),Y); hold on ;
%         plot(XX(:,2),XX(:,2)*B(2)+B(1)); hold on;
%         continue
           
%         ALP(1:length(Y),d) = Y./XX(:,2);
        
            %%% plot the linear regression (delta CNR vs
            %%% dist(d)/delta(cos(teta))) : one subplot for each distance range
            if d > 101 & d <= 250 & loopme == 1
                    if p == 1 | p == 26
                        p = 1;
                        clear f1
                        clf (figure(lm)) ;
                        f1 = figure(lm); hold on ;
                        my_big_figure ; % empty figure (full screen) with many subplots
                        lm = lm + 1 ; % figure counter                                                                        
                    end
                    _vs_
                    get(f1); 
                    subplot('Position',loc(p,:)); hold on
                    scatter(XX(:,2),Y); hold on ;
                    plot(XX(:,2),XX(:,2)*B(2)+B(1),'r','linewidth',2); hold on;
                    text(nanmin(XX(:,2)) + 0.01 , nanmin(Y) + 0.02, {['d = ' num2str(round(dist(d))) ' meters']});
                    p = p+1 ; % subplot counter
                    
% % %                     ylim([-3 3]);s
% %                     
% %                     %%% to have common (same) AX and AY axis on all subplots
% %         %             pas = (2*epsilon*max(dist)/nanmax(nanmax(CS)))/10;  
% %         %             z = 0 : pas : 2*epsilon*max(dist)/nanmax(nanmax(CS)) ;
% %         %             xlim([0 2*epsilon*max(dist)/nanmax(nanmax(CS))]);
% %         %             ylim([-28 -18]);
% % %                     text(nanmean(XX(:,2))/15, -27,{['RMSE for CNR = ' num2str(RMSE(d),'%4.2f') ' [dB]' ]});
% % %                     text(nanmean(XX(:,2))/15, -26,{['alpha err : ' num2str(BINT(2,1)*1000,'%4.2f') ' - ' num2str(BINT(2,2)*1000,'%4.2f') ' [km-1]' ]});
% % %                     text(nanmean(XX(:,2))/15, -25,{['alpha = ' num2str(B(2)*1000,'%4.2f') ' [km-1]' ]});
% % %                     text(nanmean(XX(:,2))/15, -24,{['CNR = ' num2str(B(2)*1000,'%6.4f') '* X + ' num2str(B(1),'%4.2f')]});
% % %                     text(nanmean(XX(:,2))/15, -23 ,{['d = ' num2str(round(dist(d))) ' meters']});
                    ylabel([' delta CNR [dB] '],'color','k');
                    xlabel([' delta R [meters] '],'color','k');
            end
    end  % for more than two CNR values axist at diven "d" distance
% keyboard
end % d

clf (figure(20)); clear h1;
h1 = figure(20)
set(h1,'Position',[1030 54 560 420]); 
plot(dist,alpha*1000,'LineWidth',2.5,'Color','r','LineStyle','-.'); hold on
plot(dist,ERR(:,1)*1000,'LineWidth',2,'Color','r','LineStyle',':'); hold on
plot(dist,ERR(:,2)*1000,'LineWidth',2,'Color','r','LineStyle',':'); hold on
% am(1:length(alpha))=alphaP*1000; 
% plot(am,'LineWidth',2,'Color','b','LineStyle',':'); hold on
ylim([-1 1]); 

% xlim([1 length(dist)]); 
% ylim([ max(alpha*1000)+0.1]); 

% ylim([0.05 0.51]); 
% set(gca,'xtick',1:8:length(dist),'xticklabel',round(dist(1)):200:round(dist(length(dist))),'FontSize',10,'fontWeight','demi','box','on'); hold on
grid on
% title({['extinction coefficient at different radius [km-1]']},'color','k') ;
    
% title({['extinction coefficient at different radius [km-1]'];[datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
% ' - ',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
% ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20)];[num2str(length(rng)) ' tirs: ' num2str(min(rng)) ' - ' num2str(max(rng)) ]},'color','k') ;
ylabel(['   alpha [km-1] '],'color','k');
xlabel(['   projection of scanning distance (d) in meters'],'color','k');

clf (figure(21)); clear h1;
h1 = figure(21)
set(h1,'Position',[1030 500 560 420]); 
plot(dist,FM,'LineWidth',2.5,'Color','k','LineStyle','-'); hold on
plot(dist,FM_ERR(:,1),'LineWidth',2,'Color','k','LineStyle',':'); hold on
plot(dist,FM_ERR(:,2),'LineWidth',2,'Color','k','LineStyle',':'); hold on

% xlim([1 length(dist)]); 
% ylim([min(FM) max(FM)]); 
% ylim([-40 0]); 
% ylim([-0.01 0.01]); 
% set(gca,'xtick',1:8:length(dist),'xticklabel',round(dist(1)):200:round(dist(length(dist))),'FontSize',10,'fontWeight','demi','box','on'); hold on
grid on
% title({['free element (b) of the linear regression in a form y = ax + b (at each distance "d" ']},'color','k') ;
% title({['free element (b) of the linear regression in a form y = ax + b (at each distance "d" '];[datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
% ' - ',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
% ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20)];[num2str(length(rng)) ' tirs: ' num2str(min(rng)) ' - ' num2str(max(rng)) ]},'color','k') ;
ylabel([' lin regr offset'],'color','k');
xlabel(['  projection of the scanning distance (d) in meters'],'color','k');


clear XX B BINT R RINT STATS dist AZI CS fi zaxe u seuil_cnr max_dvr max_range1 max_cnr mm nl l k it i hh hv fuseau entete BI fichier_rhi

% clf (figure(22));
% figure(22)
% XX = [ones([length(XN) 1]), XN]; 
% [B,BINT,R,RINT,STATS]=regress(YN,XX,0.01);
% al = B(2)/(-2); % angle of the linear fit
% fe = B(1); % the free coefficient "b" of the linear fit
% al_err = BINT(2,:)/(-2);
% fe_err = BINT(1,:);
% 
% scatter(XX(:,2),YN); hold on ;
% plot(XX(:,2),XX(:,2)*B(2)+B(1),'r','linewidth',2); hold on;
% ylabel([' delta cnr [dB]'],'color','k');
% xlabel([' delta R [meters]'],'color','k');
