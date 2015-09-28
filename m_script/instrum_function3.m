clear d figure(12) figure(13) figure(14) figure(15) f1 alpha FM FM_ERR thresh zone z1 d1 PP DI BBT beta

epsilon = 10/log(10) ;

% f1 = figure(12);
% my_big_figure ; % empty figure with many subplots
% pit = 1;
% pt = 8 ;
   
% for d = 1 : size(r_0,2)-1;  % distance off the lidar
%     clear y1 y2 x1 x2 yy xx B BINT R RINT STATS XX Y i
    
    %%% abs CNR are compared against -2d/cos(teta) to retrieve alpha
    y1 = plus(ccnr(19:size(ccnr,2),d)./epsilon ,  2*log(r_0(19:size(ccnr,2))));   % all CNR values at the first radius   
    
    y2 = plus(ccnr(:,d+1)./epsilon, 2*log(r_0(1,d+1))); % all CNR values at the next radius
   
    x1 = az(:,d) ;
    x2 = az(:,d+1) ;
    
    %%% delta cnr
    yy = nan([length(y1) length(y1)]);     
    xx = yy ; daz = yy ; % ccd = yy ; lr1 = yy; lr2 = yy;
    
    for i = 1:size(r_0,1)-1    % azimuthal angle   
       % clear beta zeta trap_base lr1 lr2
        yy(i+1:length(y1),i)   = minus(y1(i+1:length(y1)), y2(i)) ; % delta CNR 
              
        daz(i+1:length(y1),i)  = abs(minus(x1(i+1:length(y1)), x2(i))) ; % delta azimut between the compared two CNR values
        daz(find(daz(:,i) > 180),i) = abs(minus(daz(find(daz(:,i) > 180),i),360)) ; % all delta azimuths larger than 180° are interesting for us as well
        
%         trap_base(:,1) = abs(2 * r_0(1,d) * sind(daz(:,i)./2)) ; % the base of the symmetric trapesoid with 50m sides 
%         trap_base(:,2) = abs(2 * r_0(1,d+1) * sind(daz(:,i)./2)) ; % the base of the symmetric trapesoid with 50m sides          
 
        %%% lr is the distance along the circle with radius = R1 or R2 and corresponding to angle "daz"  
%         lr1(:,i) = 2*pi*r_0(1,d)*daz(:,i)*0.001/360; % [km]
%         lr2(:,i) = 2*pi*r_0(1,d+1)*daz(:,i)*0.001/360; % [km]

%         %%% calculate the straight distance between given CNR(R1) and CNR(R2) values, in [meters], which is the diagonal of the trapezoid 
%         ccd(:,i) = sqrt(trap_base(:,1).*trap_base(:,2) + 2500) ; 
%         
%         %%% calculate the angle between the scanning ray R(2) corresponding to CNR(R2) and the line that connects CNR(R1) and CNR(R2) 
%         beta(:,1) = abs(asind((r_0(1,d)*sind(daz(:,i)))./ccd(:,i))) ; 
%         
%         %%% since we know two angles out of three, we can calculate the third
%         zeta(:,1) = 180 - daz(:,i) - beta(:,1) ;
%         
% %         xx(:,i) = ccd(:,i).*sind(beta) - ccd(:,i).*sind(zeta) ; % predictor
% %         xx(:,i) = sind(beta) - sind(zeta) ; % predictor
%         xx(:,i) = 1 - (sind(zeta)./sind(beta)) ;
%         xx(:,i) = abs(minus(lr1,lr2)./daz(:,i));
%         keyboard
    end
    
%     yy(find(daz(:,:) > 170)) = NaN;   % if the angle between two CNR values is close to 180°, do not compare them
%     daz(find(daz(:,:) > 170)) = NaN; 
    
%     clear y1 y2 x1 x2 trap_base zeta beta
    %%% V = [daz,zeta,beta,cd,trap_base(:,1),trap_base(:,2)]; check the values
    %%% r_0(1,d)*(sind(V(:,2))./sind(V(:,3))) ; % this should be equal to r_0(1,d+1)
      
    Y = reshape(yy,[size(yy,1)*size(yy,2),1]); clear y1 y2
    XX(1:length(Y),1) = 1 ; 
    XX(1:length(Y),2) = 1 ;% reshape(xx,[size(yy,1)*size(yy,2),1]) ; 
         
%             Y = yy(find(daz == kl)) ;
%             XX(1:length(Y),1) = 1 ; 
%             XX(1:length(Y),2) = xx(find(daz == kl)) ; 
%             [Y,XX]
%             yu(d) = length(Y);
            
            %%% linear fit: delta CNR vs linear distance between them (delta R is const = 50m)
            if length(find(~isnan(Y))) <= 3
                 alpha(d) = NaN;
                 ERR(d,1:2) = NaN ;
                 FM(d) = NaN ;
                 FM_ERR(d,1:2) = NaN;
            else        
                [B,BINT,R,RINT,STATS]=regress(Y,XX,0.01);
        % % %         %  B = intercept and the coef for the linear regression
        % % %         %  BINT = conf intervals for the coefficients B
        % % %         %  R =  vector of residuals: reality minus the linear model
        % % %         %  RINT = vector of confidence intervals for the residuals
        % % %         %  STATS = r-square, f-stat, p-value   
        % % %         RMSE(d)=sqrt(nansum(R.^2)/(length(find(~isnan(XX(:,2))))-1)); % erros when predicting CNR values with delta(cos(teta)) in [dB] 
                alpha(d) = B(2); % angle of the linear fit
                FM(d) = B(1); % the free coefficient "b" of the linear fit
                ERR(d,:) = BINT(2,:);
                FM_ERR(d,:) = BINT(1,:);

                    %%% plot the linear regression (delta CNR vs
                    %%% dist(d)/delta(cos(teta))) : one subplot for each distance range
%                     if d <= 25   
%                             get(f1);
%                             subplot('Position',loc(d,:)); hold on
%                     elseif d > 25 && d <= 50
%                             if pit == 1
%                                     f2 = f1; 
%                                     clear f1
%                                     f1 = figure(13); hold on;
%                                     my_big_figure ; hold on ; % empty figure with many subplots
%                                     pit = 2;
%                             end
%                             get(f1);
%                             subplot('Position',loc(d-25,:)); hold on
%                     elseif d > 50 && d <= 75
%                             if pit == 2
%                                     f3 = f1; 
%                                     clear f1
%                                     f1 = figure(14); hold on;
%                                     my_big_figure ; hold on ; % empty figure with many subplots
%                                     pit = 3;
%                             end
%                             get(f1);
%                             subplot('Position',loc(d-50,:)); hold on
%                     elseif d > 75 && d <= 100
%                             if pit == 3
%                                     f4 = f1; 
%                                     clear f1
%                                     f1 = figure(15); hold on;
%                                     my_big_figure ; hold on ; % empty figure with many subplots
%                                     pit = 4;
%                             end
%                             get(f1);
%                             subplot('Position',loc(d-75,:)); hold on
%                     end
% 
%                     if d < 100
%                              figure(pt + 1) ;
%                              scatter(XX(:,2),Y); hold on ;
%                              plot(XX(:,2),XX(:,2)*B(2)+B(1)); hold on;
%         %                      
%         % %                     scatter(ST,ALP(1:length(ST),d)); hold on ;
%         % %                     text(nanmean(ST)/15, -1 ,{['d = ' num2str(round(dist(d))) ' meters']});
%         % % % % % %                     ylim([-3 3]);s
%         % % % % %                     
%         % % % % %                     %%% to have common (same) AX and AY axis on all subplots
%         % % % % %         %             pas = (2*epsilon*max(dist)/nanmax(nanmax(CS)))/10;  
%         % % % % %         %             z = 0 : pas : 2*epsilon*max(dist)/nanmax(nanmax(CS)) ;
%         % % % % %         %             xlim([0 2*epsilon*max(dist)/nanmax(nanmax(CS))]);
%         % % % % %         %             ylim([-28 -18]);
%         % % % % % %                     text(nanmean(XX(:,2))/15, -27,{['RMSE for CNR = ' num2str(RMSE(d),'%4.2f') ' [dB]' ]});
%         % % % % % %                     text(nanmean(XX(:,2))/15, -26,{['alpha err : ' num2str(BINT(2,1)*1000,'%4.2f') ' - ' num2str(BINT(2,2)*1000,'%4.2f') ' [km-1]' ]});
%         % % % % % %                     text(nanmean(XX(:,2))/15, -25,{['alpha = ' num2str(B(2)*1000,'%4.2f') ' [km-1]' ]});
%         % % % % % %                     text(nanmean(XX(:,2))/15, -24,{['CNR = ' num2str(B(2)*1000,'%6.4f') '* X + ' num2str(B(1),'%4.2f')]});
%         % % % % % %                     text(nanmean(XX(:,2))/15, -23 ,{['d = ' num2str(round(dist(d))) ' meters']});
%                             ylabel([' delta CNR [dB] '],'color','k');
%         % % % % % %                     xlabel([' (2*eps*d)/cos(teta) '],'color','k');
%                     end
            end  % for more than two CNR values axist at diven "d" distance
end % d

% figure(6)
% plot(r_0(1,1:length(FM)),alpha,'k','linewidth',2); hold on  % initial "typical" CNR profile
% grid on

figure(7)
plot(r_0(1,1:length(FM)),E,'k','linewidth',2); hold on  % initial "typical" CNR profile
% plot(r_0(1,1:length(FM)),exp(FM_ERR),'r','linewidth',2); hold on  % initial "typical" CNR profile
% ylim([-0.001 0.0001]); hold on
% xlim([0 3000]); hold on
grid on
xlabel('scanning distance [meters]','color','k');
% ylabel('exp(offset of the linear regression)','color','k');
ylim([0.4 1.3]);
text(100,1.25-rt,{[num2str(hh(1)) ':' num2str(mn(1))]});
rt=rt+0.05;

% end % kl
%%% reconstruction of F if we known value of F(R) at the peak
% clear pk FT
% pk = find(abs(coeff) == nanmin(abs(coeff))); % where the regression coefficient is the closest to zero
% FT(pk) = I(find(I == max(I))) ; % if the instrumental function = 1 at the first scanning distance R

% for d = 1:size(distance,2)
%      if pk+d < size(distance,2)
%          FT(1,pk+d) =  FT(1,pk+d-1)/FG(1,pk+d-1) ; % Instrum function (on the right side of the peak)
%      end
%      if pk-d > 0
%          FT(1,pk-d) =  FT(1,pk-d+1)*FG(1,pk-d+1) ; % Instrum function (on the left side of the peak)
%      end
% end

% coeff(500:length(coeff)) = NaN
% find(abs(coeff) == nanmin(abs(coeff)))
% distance(1,find(abs(coeff) == nanmin(abs(coeff))))

% clear xla xl i IF 
% xla = round(distance(1,1)):200:round(distance(1,size(distance,2)));
% for i = 1 : length(xla)
%         xl(i,1) = find(distance(1,:) == xla(i));
% end
% 
% figure(3)
% plot(distance(1,1:length(FT)),FT,'k','linewidth',2); hold on  % initial "typical" CNR profile
% plot(r_0(1,:),I,'r-','linewidth',2); hold on  % initial "typical" CNR profile
% grid on
% title({['Function deduced from simulated CNR: using using F(R = peak)'];['initial (red), alpha = 0 (slash-dotted black), 0.4 (plain black), 0.8 (slash black)']},'color','k') ;

% keyboard
% figure(16)
% plot(alpha*1000,'LineWidth',2.5,'Color','k','LineStyle','-.'); hold on
% plot(ERR(:,1)*1000,'LineWidth',2,'Color','k','LineStyle',':'); hold on
% plot(ERR(:,2)*1000,'LineWidth',2,'Color','k','LineStyle',':'); hold on
% am(1:length(alpha))=alphaP*1000; 
% plot(am,'LineWidth',2,'Color','b','LineStyle',':'); hold on
% 
% xlim([1 length(distance(1,:))]); 
% ylim([min(alpha*1000)-0.1 max(alpha*1000)+0.1]); 
% ylim([-3.5 3.5]); 
% ylim([0.05 0.51]); 

% set(gca,'xtick',[xl],'xticklabel',[xla],'FontSize',10,'fontWeight','demi','box','on'); hold on
% grid on
% title({['extinction coefficient at different radius [km-1]']},'color','k') ;
    
% title({['extinction coefficient at different radius [km-1]'];[datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
% ' - ',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
% ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20)];[num2str(length(rng)) ' tirs: ' num2str(min(rng)) ' - ' num2str(max(rng)) ]},'color','k') ;
% ylabel(['   alpha [km-1] '],'color','k');
% xlabel(['   scanning distance (d) in meters'],'color','k');
% 
% keyboard
% 
% figure(17)
% plot(FM,'LineWidth',2.5,'Color','k','LineStyle','-'); hold on
% plot(FM_ERR(:,1),'LineWidth',2,'Color','k','LineStyle',':'); hold on
% plot(FM_ERR(:,2),'LineWidth',2,'Color','k','LineStyle',':'); hold on

% xlim([1 length(dist)]); 
% ylim([min(FM) max(FM)]); 
% ylim([-40 0]); 
% ylim([-0.01 0.01]); 
% set(gca,'xtick',1:8:length(dist),'xticklabel',round(dist(1)):200:round(dist(length(dist))),'FontSize',10,'fontWeight','demi','box','on'); hold on
% grid on
% title({['free element (b) of the linear regression in a form y = ax + b (at each distance "d" ']},'color','k') ;
% title({['free element (b) of the linear regression in a form y = ax + b (at each distance "d" '];[datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
% ' - ',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
% ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20)];[num2str(length(rng)) ' tirs: ' num2str(min(rng)) ' - ' num2str(max(rng)) ]},'color','k') ;
% ylabel(['  free element (b)'],'color','k');
% xlabel(['   scanning distance (d) in meters'],'color','k');

