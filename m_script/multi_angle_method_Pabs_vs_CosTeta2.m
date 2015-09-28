clear ze T D DC d bb aa st nnt figure(12) figure(13) figure(14) figure(15) f1 alpha FM FM_ERR thresh zone z1 d1 list dat dPz dP col ccnr az PP BBT BT % DI ZI
% clear figure(16) figure(17)

% if exist('f1')
%     clf(f1) ;
% elseif exist('f2')
%     clf(f2) ;
% elseif exist('f3')
%     clf(f3) ; 
% end

epsilon = 10/log(10) ;

f1 = figure(12);
my_big_figure ; % empty figure with many subplots
pit = 1;
dt = 12.5 ; % meters around the reference "d" value

% BBT = (plus(cnr./epsilon,RC));

for d = 1:length(dist);  % distance off the lidar
    clear B BINT R RINT STATS XX a b c Y i nt s fd
    
    %%% (delta CNR/epsilon) + 2lnxR1 are compared against -2d/cos(teta) to retrieve alpha
%     s = SIN(find(fi <= dist(d)+dt & fi >= dist(d)-dt)); %  sin(teta)
    c = SS(find(fi <= dist(d)+dt & fi >= dist(d)-dt)); % perpendicular distance of given CNR value relative to the new reference axis [meters]
    s = CS(find(fi <= dist(d)+dt & fi >= dist(d)-dt)) ;
    fd = fi(find(fi <= dist(d)+dt & fi >= dist(d)-dt)) ;
    a = BI(find(fi <= dist(d)+dt & fi >= dist(d)-dt))./epsilon ; % all CNR values within the good (homeneguous) sector, roughly corresponding to distance "d" 
%     b = ((CS(find(fi <= dist(d)+dt & fi >= dist(d)-dt))).^(-1)).*fi(find(fi <= dist(d)+dt & fi >= dist(d)-dt)); % corresponding cos(teta) relative to the new axis "ref"
%     b = s.\c  ; % corresponding R = c/sin(teta) ; "b" is always positive!
    b = s.\fd ; %  corresponding R
             
    for i=1:length(a)  % find all pairs at given distance "d"   
        for nt = .00001:0.00001:0.03 % search for the pair CNR value that has the most similar cos(teta) or sin(teta) value 
            clear lb al ac cc coord sa cd
            coord = find(abs(s) <= abs(s(i)) + nt & abs(s) >= abs(s(i)) - nt) ;
            
            if isempty(coord) | length(coord) < 2
                continue
            elseif ~isempty(coord) & length(coord) >= 2  
                c(coord);
                
                cd = coord(1:2); clear coord
                coord = cd ; clear cd
                sa = c(coord);
            end            
            
            if (length(coord) == 2) & ( (sa(1)<0 & sa(2)>0 ) || ( sa(1)>0 && sa(2)<0 ) )% as soon as we found the pair CNR value, we can work with it
%                 bb(i,d) = diff(b(find(b <= b(i) + nt & b >= b(i) - nt))); % predictor  = d/cos(teta1) + d/cos(teta2), d is individual for each CNR !
                bb(i,d) = abs(diff(b(coord))) ;  % predictor  = st1/sin(teta1) - st2/sin(teta2)              
                lb(1,:) = 2*log(b(coord));  % correction by 2ln(R)  
                al(1,:) = a(coord) ;        % pair of CNR values with almost the same coordinates
                ac = diff(sum(cat(3,al,lb),3)) ; % delta CNR (each CNR previously corrected by its own 2*ln(R^2) )
                aa(i,d) = ac/(-2)   ;            % our predictable variable
%                 cc(1,:) = c(coord) ;         % perpendicular distance between each CNR and the reference axis
                st(i,d) = sum(abs(sa));
                
%                 if ( cc(1,1)<0 & cc(1,2)<0 ) || ( cc(1,1)>0 && cc(1,2)>0 )  % impossible if my earlier calculations are correct!
% %                     st(i,d)  = abs(minus(cc(1,1),cc(1,2))) ; % perpendicular distance
%                         keyboard
%                 else
%                     st(i,d)  = plus(abs(cc(1,1)), abs(cc(1,2))) ; % the total perpendicular distance between compared CNR values (of given couple) 
%                 end       
                
                nnt(i,d) = nt ;
                s(coord) = NaN; % those values that are already used we hide 
                break % as soon as we found a symmetric CNR value for a given one, we take the next CNR value
            end
        end
    end
    
    if exist('aa','var') == 1
    [aa(:,d), bb(:,d) , st(:,d)] 
    end
    d
end % d
    
st(find(st ==0)) = NaN;
nanmean(st)

for d = 1:length(dist);  % distance off the lidar
    clear B BINT R RINT STATS XX a b c Y i nt
    
    
    Y(1:length(aa),1) = aa(1:length(aa),d) ;
    XX(1:length(aa),1)=1;
    XX(1:length(aa),2) = bb(1:length(aa),d) ;
       
    %%% linear fit: interpolated CNR value vs delta cos teta for each combination of observations
    if length(find(~isnan(Y))) <= 3
         alpha(d) = NaN;
         ERR(d,1:2) = NaN ;
         FM(d) = NaN ;
         FM_ERR(d,1:2) = NaN;
         RMSE(d) = NaN;
    else        
        [B,BINT,R,RINT,STATS]=regress(Y,XX,0.01);
        %  B = intercept and the coef for the linear regression
        %  BINT = conf intervals for the coefficients B
        %  R =  vector of residuals: reality minus the linear model
        %  RINT = vector of confidence intervals for the residuals
        %  STATS = r-square, f-stat, p-value   
        RMSE(d)=sqrt(nansum(R.^2)/(length(find(~isnan(XX(:,2))))-1)); % erros when predicting CNR values with delta(cos(teta)) in [dB] 
        alpha(d) = B(2); % angle of the linear fit
        FM(d) = B(1); % the free coefficient "b" of the linear fit
        ERR(d,:) = BINT(2,:);
        FM_ERR(d,:) = BINT(1,:);

%         ALP(1:length(Y),d) = Y./XX(:,2);
        
            %%% plot the linear regression (delta CNR vs
            %% dist(d)/delta(cos(teta))) : one subplot for each distance range
%             if d <= 25   
%                     get(f1);
%                     subplot('Position',loc(d,:)); hold on
%             elseif d > 25 && d <= 50
%                     if pit == 1
%                             f2 = f1; 
%                             clear f1
%                             f1 = figure(13); hold on;
%                             my_big_figure ; hold on ; % empty figure with many subplots
%                             pit = 2;
%                     end
%                     get(f1);
%                     subplot('Position',loc(d-25,:)); hold on
%             elseif d > 50 && d <= 75
%                     if pit == 2
%                             f3 = f1; 
%                             clear f1
%                             f1 = figure(14); hold on;
%                             my_big_figure ; hold on ; % empty figure with many subplots
%                             pit = 3;
%                     end
%                     get(f1);
%                     subplot('Position',loc(d-50,:)); hold on
%                     
%             elseif d > 75 && d <= 100
%                     if pit == 3
%                             f4 = f1; 
%                             clear f1
%                             f1 = figure(15); hold on;
%                             my_big_figure ; hold on ; % empty figure with many subplots
%                             pit = 4;
%                     end
%                     get(f1);
%                     subplot('Position',loc(d-75,:)); hold on
%             end
% 
%             if d < 100
%                      scatter(XX(:,2),Y); hold on ;
%                      plot(XX(:,2),XX(:,2)*B(2)+B(1)); hold on;
% %                      
% %                     scatter(ST,ALP(1:length(ST),d)); hold on ;
% %                     text(nanmean(ST)/15, -1 ,{['d = ' num2str(round(dist(d))) ' meters']});
% %                     ylim([-3 3]);s
%                     
%                     %%% to have common (same) AX and AY axis on all subplots
%         %             pas = (2*epsilon*max(dist)/nanmax(nanmax(CS)))/10;  
%         %             z = 0 : pas : 2*epsilon*max(dist)/nanmax(nanmax(CS)) ;
%         %             xlim([0 2*epsilon*max(dist)/nanmax(nanmax(CS))]);
%         %             ylim([-28 -18]);
% %                     text(nanmean(XX(:,2))/15, -27,{['RMSE for CNR = ' num2str(RMSE(d),'%4.2f') ' [dB]' ]});
% %                     text(nanmean(XX(:,2))/15, -26,{['alpha err : ' num2str(BINT(2,1)*1000,'%4.2f') ' - ' num2str(BINT(2,2)*1000,'%4.2f') ' [km-1]' ]});
% %                     text(nanmean(XX(:,2))/15, -25,{['alpha = ' num2str(B(2)*1000,'%4.2f') ' [km-1]' ]});
% %                     text(nanmean(XX(:,2))/15, -24,{['CNR = ' num2str(B(2)*1000,'%6.4f') '* X + ' num2str(B(1),'%4.2f')]});
% %                     text(nanmean(XX(:,2))/15, -23 ,{['d = ' num2str(round(dist(d))) ' meters']});
% %                     ylabel([' CNR [dB] '],'color','k');
% %                     xlabel([' (2*eps*d)/cos(teta) '],'color','k');
%             end
    end  % for more than two CNR values axist at diven "d" distance
end % d

figure(16)
plot(-alpha*1000,'LineWidth',2.5,'Color','k','LineStyle','-'); hold on
% plot(-ERR(:,1)*1000,'LineWidth',2,'Color','r','LineStyle',':'); hold on
% plot(-ERR(:,2)*1000,'LineWidth',2,'Color','r','LineStyle',':'); hold on
am(1:length(alpha))=alphaP*1000; 
plot(am,'LineWidth',2,'Color','b','LineStyle',':'); hold on

xlim([1 length(dist)]); 
ylim([min(-alpha*1000)-0.1 max(-alpha*1000)+0.1]); 
% ylim([-1.8 1.8]); 
% ylim([0.05 0.51]); 
set(gca,'xtick',1:8:length(dist),'xticklabel',round(dist(1)):200:round(dist(length(dist))),'FontSize',10,'fontWeight','demi','box','on'); hold on
grid on
title({['extinction coefficient at different radius [km-1]']},'color','k') ;
    
% title({['extinction coefficient at different radius [km-1]'];[datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
% ' - ',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
% ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20)];[num2str(length(rng)) ' tirs: ' num2str(min(rng)) ' - ' num2str(max(rng)) ]},'color','k') ;
ylabel(['   alpha [km-1] '],'color','k');
xlabel(['   scanning distance (d) in meters'],'color','k');

figure(17)
plot(FM,'LineWidth',2.5,'Color','r','LineStyle','-'); hold on
plot(FM_ERR(:,1),'LineWidth',2,'Color','r','LineStyle',':'); hold on
plot(FM_ERR(:,2),'LineWidth',2,'Color','r','LineStyle',':'); hold on

xlim([1 length(dist)]); 
ylim([min(FM) max(FM)]); 
% ylim([-40 0]); 
% ylim([-60 -20]); 
set(gca,'xtick',1:8:length(dist),'xticklabel',round(dist(1)):200:round(dist(length(dist))),'FontSize',10,'fontWeight','demi','box','on'); hold on
grid on
title({['free element (b) of the linear regression in a form y = ax + b (at each distance "d" ']},'color','k') ;
% title({['free element (b) of the linear regression in a form y = ax + b (at each distance "d" '];[datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
% ' - ',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
% ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20)];[num2str(length(rng)) ' tirs: ' num2str(min(rng)) ' - ' num2str(max(rng)) ]},'color','k') ;
ylabel(['  b = K + F(d) + Beta(d) '],'color','k');
xlabel(['   scanning distance (d) in meters'],'color','k');

