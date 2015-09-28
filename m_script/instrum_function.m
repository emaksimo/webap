%%% evaluate statistics of 360 CNR values at each distance R
%%% CF(L,1:59)  = std at each distance R and each PPI file
%%% RAN(L,1:59) = min-max range after removing 5% of data on eigther side 
%%% LIK(L,1:59) = max likelyhood value of the distribution after removing 5% of data on eigther side 
%%% KT(L,1:59)  = normal distribution test after removing 5% of data on eigther side 
%%% JB(L,1:59)  = normal distribution test after removing 5% of data on eigther side
%%% the main script : wls_PPI_loop_1.m

clear ccnr z1 list1 hh d1

ccnr = cnr(:,1:sdi);
ccnr(find(ccnr>=0))=NaN; % do not consider the areas with zero CNR 
ccnr(find(ccnr<=-27))=NaN; % do not consider the areas with too low signal

epsilon = 10/log(10) ;

% if loopme == 1
%     clf (figure(12)) ; clf (figure(13)) ; 
%     f1 = figure(12);
%     my_big_figure ; % empty figure with many subplots
%     pit = 1;
% end

for d = 1 : sdi;  % distance off the lidar, see wls_PPI_loop_1.m
    clear Y HT PRC nx bx cnr
    
    PRC = prctile(ccnr(:,d),[5 99]) ; % lower 5% and upper 97.5% percentiles of the distribution
    ccnr(find(ccnr(:,d) < PRC(1) | ccnr(:,d) > PRC(2)),d) = NaN ; % the "extreme" values ( = profiles) are removed 
    Y = plus(ccnr(:,d)./epsilon ,  2*log(r_0(1,d)));   % all CNR values at the first radius   
    CF(L,d)  = nanstd(Y) ; % std before removing 5% on eigther side of the PDF distribution  
    HT = Y(find(~isnan(Y))); clear Y PRC
    CT(L,d)   = std(HT) ;
    ME(L,d)  = nanmean(HT);
     
    if length(HT) > 200      
        [nx,bx]= hist(HT,min(HT)-1 : 0.25 : max(HT) + 0.5) ;          
        
        if length(find(nx == max(nx))) > 1
            clear nx bx
            [nx,bx]= hist(HT,min(HT)-1 : 0.2 : max(HT) + 0.5) ; 
            if length(find(nx == max(nx))) > 1
                 clear nx bx
                 [nx,bx]= hist(HT,min(HT)-1 : 0.15 : max(HT) + 0.5) ; 
                 if length(find(nx == max(nx))) > 1
                        clear nx bx
                        [nx,bx]= hist(HT,min(HT)-1 : 0.1 : max(HT) + 0.5) ;  
                        if length(find(nx == max(nx))) > 1 & (mean(bx(find(nx == max(nx)))) < ME(L,d)-CT(L,d) | mean(bx(find(nx == max(nx)))) > ME(L,d)+CT(L,d))
                            continue % d
                        elseif length(find(nx == max(nx))) > 1 & (min(bx(find(nx == max(nx)))) < ME(L,d)-CT(L,d) | max(bx(find(nx == max(nx)))) > ME(L,d)+CT(L,d))
                            continue % d
                        end
                 end
            end  
        end
        
        LIK(L,d)  =  max(bx(find(nx == max(nx)))) ;   % position of the peak of the distribution (assumption that distribution is normal)             
        %%% max is used in case if there are a choice of several position values
        
        PRC = prctile(HT,[25 75]) ; % 25% and 75% percentiles of the distribution
        if PRC(2) >= 0 
                RANG(L,d)  = minus(PRC(2),PRC(1)); 
        else % PRC(2) < 0
             RANG(L,d)  = abs(plus(abs(PRC(2)),PRC(1)));
        end
             
        RAN(L,d) = range(HT) ;    % min - max range
        SK(L,d)   = skewness(HT) ; % if the distribution is inclinated
        KR(L,d)   = kurtosis(HT) ; 
        KT(L,d)   = kstest(HT) ; % normal distrib = 0
        JB(L,d)   = jbtest(HT) ;   % normal distrib = 0   
                
    end 
     
%      if loopme == 1 & d <= 25   
%             get(f1);
%             subplot('Position',loc(d,:)); hold on ;
%      elseif loopme == 1 & d > 25 && d <= 50
%             if pit == 1
%                     f2 = f1; 
%                     clear f1
%                     f1 = figure(13); hold on;
%                     my_big_figure ; hold on ; % empty figure with many subplots
%                     pit = 2;
%             end
%             get(f1);
%             subplot('Position',loc(d-25,:)); hold on
%      elseif loopme == 1 & d > 50
%             if pit == 2
%                     f3 = f1; 
%                     clear f1
%                     f1 = figure(14); hold on;
%                     my_big_figure ; hold on ; % empty figure with many subplots
%                     pit = 3;
%             end
%             get(f1);
%             subplot('Position',loc(d-50,:)); hold on
%      end
%      if loopme == 1 & d <= 50
%              hist(HT,min(HT)-1 : 0.01 : max(HT) + 0.5 ) ; hold on ;
%              grid on
%              hist(exp(XX),-3:0.05:3) ; hold on ;
%              hist(ZZ1,-4:0.05:3) ; hold on ;
%              hist(ZZ2,-4:0.05:3) ; hold on ;
%              set(h1,'FaceColor','r','EdgeColor','w')
%              xlim([-1 2]);
%              ylim([0 10000]);
%              if ~isnan(ST(1,d)); text(-0.7,8000,{[' std delta CNR = ' num2str(round(ST(1,d)*100)/100) ]}); end 
%              text(min(HT)-0.7,8,{[' R = ' num2str(r_0(1,d)) ]});  
%      end
end % d

clear Y ccnr PRC nx bx HT 

% figure(21)
% for i= 1 : size(r_0,2)-1
%     
%     ck(1,i) = log(r_0(1,i)); %/r_0(1,i+1));
% end
% plot(ck)
% clear y1 y2
                            %%% to have common (same) AX and AY axis on all subplots
                %             pas = (2*epsilon*max(dist)/nanmax(nanmax(CS)))/10;  
                %             z = 0 : pas : 2*epsilon*max(dist)/nanmax(nanmax(CS)) ;
                %             xlim([0 2*epsilon*max(dist)/nanmax(nanmax(CS))]);
                %             ylim([-28 -18]);
        %                     text(nanmean(XX(:,2))/15, -27,{['RMSE for CNR = ' num2str(RMSE(d),'%4.2f') ' [dB]' ]});
        %                     text(nanmean(XX(:,2))/15, -26,{['alpha err : ' num2str(BINT(2,1)*1000,'%4.2f') ' - ' num2str(BINT(2,2)*1000,'%4.2f') ' [km-1]' ]});
        %                     text(nanmean(XX(:,2))/15, -25,{['alpha = ' num2str(B(2)*1000,'%4.2f') ' [km-1]' ]});
        %                     text(nanmean(XX(:,2))/15, -24,{['CNR = ' num2str(B(2)*1000,'%6.4f') '* X + ' num2str(B(1),'%4.2f')]});
        %                     text(nanmean(XX(:,2))/15, -23 ,{['d = ' num2str(round(dist(d))) ' meters']});
%                             ylabel([' delta CNR [dB] '],'color','k');
        %                     xlabel([' (2*eps*d)/cos(teta) '],'color','k');

% figure(6)
% plot(r_0(1,1:length(FM)),alpha,'k','linewidth',2); hold on  % initial "typical" CNR profile
% grid on
% 
% keyboard
% 
% clear FFM E
% FFM = exp(FM);
% E = nanmoving_average(FFM,2) ;
% E(find(r_0(1,1:length(E)) == 2000):length(E)) = NaN ;
% E(find(E == nanmax(E)))
% 
% clf (figure(7))
% figure(7)
% plot(r_0(1,1:length(FM)),exp(FM),'r','linewidth',2); hold on
% plot(r_0(1,1:length(FM)),E,'linewidth',2,'color','b'); %JET(round(rt*100+6),:)); hold on  
% plot(r_0(1,1:length(FM)),exp(FM_ERR),'r','linewidth',2); hold on  % initial "typical" CNR profile
% ylim([-0.001 0.0001]); hold on
% xlim([0 3000]); hold on
% grid on
% xlabel('scanning distance [meters]','color','k');
% ylabel('exp(offset of the linear regression)','color','k');
% ylim([0.4 1.3]);
% text(100,1.25-rt,{[num2str(hh(1)) ':' num2str(mn(1)) ' ' num2str(L)]},'color',JET(round(rt*100+6),:));
% rt=rt+0.05;
% 
% 
% %% reconstruct F(R) since we know alpha at the peak of F(R) 
% %% and we suppose Sr = 50
% alpha = abs(FM(25)/100);
% clear  al FM ERR FM_ERR 
% Sr = 50; 
% for d = 1 : size(r_0,2)-1;  % distance off the lidar
%             clear Y XX B BINT R RINT STATS
% 
%             %% abs CNR are compared against -2d/cos(teta) to retrieve alpha
%             Y = minus(plus(ccnr(:,d)./epsilon,  2*log(r_0(1,d))), minus(log(alpha/Sr),-2*alpha*r_0(1,d)))  ;  % all CNR values at the first radius   
%             XX(1:length(Y),1:2) = 1 ; % predictor = Ln(F(R)*K)
%          
%             %% linear fit: delta CNR vs linear distance between them (delta R is const = 50m)
%             if length(find(~isnan(Y))) <= 3
%                  al(d) = NaN;
%                  ERR(d,1:2) = NaN ;
%                  FM(d) = NaN ;
%                  FM_ERR(d,1:2) = NaN;
%             else        
%                 [B,BINT,R,RINT,STATS]=regress(Y,XX,0.01);
%                 al(d) = B(2); % angle of the linear fit
%                 FM(d) = B(1); % the free coefficient "b" of the linear fit
%                 ERR(d,:) = BINT(2,:);
%                 FM_ERR(d,:) = BINT(1,:);
%             end
% end
% 
% clf (figure(8))
% plot(r_0(1,1:length(FM)),FM,'k','linewidth',2); hold on 
% plot(r_0(1,1:length(FM)),FM_ERR(:,1),'r','linewidth',2); hold on 
% plot(r_0(1,1:length(FM)),FM_ERR(:,2),'r','linewidth',2); hold on
% text(1500,22,{'ln(F(R)*K)'});
% text(1500,21.7,{'err bars in red'});
% text(1500,21.3,{'err bars in red'});
% text(1500,21,{'alpha at 1300m = 0.0745 10^{-3} m^-^1'});
% grid on
% xlabel('scanning distance [meters]','color','k');
% 
% FM(find(r_0(1,1:length(FM)) == 2000):length(FM)) = NaN ;
% r_0(1,find(FM == nanmax(FM)))
%    
% clf (figure(9))
% figure(9)
% plot(r_0(1,1:length(FM)),exp(FM),'k','linewidth',2); hold on   
% plot(r_0(1,1:length(FM)),exp(FM_ERR(:,1)),'r','linewidth',2); hold on 
% plot(r_0(1,1:length(FM)),exp(FM_ERR(:,2)),'r','linewidth',2); hold on
% grid on
% text(1000,4.5*10^9,{'F(R)*K'});
% text(1000,4*10^9,{'err bars in red'});
% text(1000,3.5*10^9,{'alpha at  1300m = 0.0745 10^{-3} m^-^1'});
% grid on
% xlabel('scanning distance [meters]','color','k');

% figure(11)
% clear LG
% % LA = log(0.6/Sr) - 2*0.0006*r_0(1,:) ; 
% % plot(r_0(1,:), LA,'k'); hold on ;
% % LA = log(0.2/Sr) - 2*0.0002*r_0(1,:) ;
% % plot(r_0(1,:), LA,'r')
% 
% LG(1,:) = sind(az(1:3:180,1))*15; LLG = LG(1:size(r_0,2));
% plot(r_0(1,:), LLG + 1,'b'); hold on; clear LG
% LLG(find(LLG == nanmax(LLG)));
% text(1000,0,{['CNR max at ' num2str(r_0(1,find(LLG == nanmax(LLG)))) ' m, alpha 0 km^-^1']},'color','b');
% 
% LA = log(0.2/Sr) - 2*0.0002*r_0(1,:) ;
% LG =  plus(LLG,LA) ;
% plot(r_0(1,:),LG,'r'); hold on; 
% text(1000,-2,{['CNR max at ' num2str(r_0(1,find(LG == nanmax(LG)))) ' m, alpha 0.2 km^-^1']},'color','r');
% clear LA LG;
% 
% LA = log(0.6/Sr) - 2*0.0006*r_0(1,:) ; 
% LG =  plus(LLG,LA) ;
% plot(r_0(1,:), LG,'k'); hold on;
% text(1000,-4,{['CNR max at ' num2str(r_0(1,find(LG == nanmax(LG)))) ' m, alpha 0.6 km^-^1']},'color','k');
% clear LA LG
% text(1000,-6,{['Sr = 50']},'color','k');
% text(1000,2,{['CNR = F(R) + ln(beta) - 2*alpha*R']},'color','k'); hold on
% grid on
% xlabel('scanning distance [meters]','color','k');
% 
% text(1500,-4.8,{'ln(beta) - 2*alpha*R'},'color','k');
% text(1500,-5,{'alpha 0.6 km^-^1'},'color','k');
% text(1500,-5.2,{'alpha 0.2 km^-^1'},'color','r');
% text(1500,-5.4,{'Sr = 50'},'color','k')

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

