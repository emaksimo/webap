clear ze CS T azim D DC d a fi figure(10) figure(11) ref f1 alpha
if exist('f1')==1
    clf(f1) ;
elseif exist('f2')==1
    clf(f2) ;
elseif exist('f3')==1
    clf(f3) ; 
end

% CS = cosd(az(azim,1)-ref);
CS = nan([size(ZI,1) size(ZI,2)]); 
azim = nanmin(XI(find(~isnan(ZI)))) : nanmax(XI(find(~isnan(ZI)))) ;
ref = floor(nanmin(XI(find(~isnan(ZI))))) - 1 ; % the nex axis is located on the left side of the first "tir"

CS(find(~isnan(ZI))) = cosd(minus(XI(find(~isnan(ZI))),ref));
%  nanmin(nanmin(CS))
%  nanmax(nanmax(CS))
 
fi = (YI./cosd(XI)).*CS; % projection of each CNR value (that is alreadu interpolated into 25m grid) on the new axis
% fi(find(~isnan(fi)))

epsilon = 10/log(10) ;

f1 = figure(12);
my_big_figure % empty figure with many subplots
pit = 1;

dist = min(fi(find(~isnan(fi)))) : 25 : max(fi(find(~isnan(fi)))) ;
for d = 1:length(dist);
%     d = 1 ; % distance off the lidar
    clear a b c D DC AL A y x XX
    a = ZI(find(fi <= dist(d)+12.5 & fi >= dist(d)-12.5)) ; % all CNR values within the good (homeneguous) sector, roughly corresponding to distance "d" 
    b = CS(find(fi <= dist(d)+12.5 & fi >= dist(d)-12.5)) ; % corresponding cos(teta) relative to the new axis "ref"
    c = fi(find(fi <= dist(d)+12.5 & fi >= dist(d)-12.5)) ; % corresponding projection of each interpolated CNR value on the new axis "ref"
    
    D = nan([length(a) length(a)]); 
    DC = D;
    AL = D;

    for i = 1:length(a) % azimut count
       D(i+1:length(a),i)  = abs(minus(a(i+1:length(a)), a(i))); % delta CNR (no matter the sign)
       DC(i+1:length(a),i) = abs(minus(c(i+1:length(a))./b(i+1:length(a)), c(i)/b(i) )) ; % we don't care the relative position of CNR values, but only the "absolute" difference in angles
    end

    AL = D./(DC*2*epsilon) ; % alpha for each combination of CNR values at given distance from the instrument
    A = reshape(AL,[length(a)*length(a) 1]);
    y = reshape(D,[length(a)*length(a) 1]);
    x = reshape(DC,[length(a)*length(a) 1])*2*epsilon; % predictor = d/cos(teta)
  
    %%% linear fit: delta CNR vs delta cos teta for each combination of observations

    if length(find(~isnan(AL))) == 0
         alpha(d) = NaN;
         ERR(d,1:2) = NaN ;
    elseif length(find(~isnan(AL))) <= 3 & length(find(~isnan(AL)))>0;
        alpha(d) = nanmean(AL(find(~isnan(AL)))) ;
        ERR(d,:) = [nanmin(AL(find(~isnan(AL)))) , nanmax(AL(find(~isnan(AL))))]  ;
    else
        XX(1:length(y),1)=1;
        XX(1:length(y),2)=x;
        [B,BINT,R,RINT,STATS]=regress(y,XX,0.01);
        %  B = intercept and the coef for the trend
        %  BINT = conf intervals for the coefficients B
        %  R =  vector of residuals: reality minus the linear model
        %  RINT = vector of confidence intervals for the residuals
        %  STATS = r-square, f-stat, p-value   
        RMSE(d)=sqrt(nansum(R.^2)/(length(find(~isnan(x)))-1)); % erros when predicting CNR values with delta(cos(teta)) in [dB] 
        alpha(d) = B(2);
        ERR(d,:) = BINT(2,:);

            %%% plot the linear regression (delta CNR vs
            %%% dist(d)/delta(cos(teta))) : one subplot for each distance
            %%% range
            if d <= 25   
                    get(f1);
                    subplot('Position',loc(d,:)); hold on
            elseif d > 25 && d < 51
                    if pit == 1
                            f2 = f1; 
                            clear f1
                            f1 = figure(13); hold on;
                            my_big_figure ; hold on ; % empty figure with many subplots
                            pit = 2;
                    end
                    get(f1);
                    subplot('Position',loc(d-25,:)); hold on
            elseif d >= 51 && d < 75
                    if pit == 2
                            f3 = f1; 
                            clear f1
                            f1 = figure(14); hold on;
                            my_big_figure ; hold on ; % empty figure with many subplots
                            pit = 3;
                    end
                    get(f1);
                    subplot('Position',loc(d-50,:)); hold on
            else
                    break % "d" loop, because alpha retriieval is not needed there
            end

            plot(x,x*B(2)+B(1)); hold on;
            scatter(x,y); hold on ;
            % max(reshape(DC,[length(a)*length(a) 1]))

            pas = nanmax(x)/10;
            z = (0:pas:nanmax(x))/(2*epsilon*dist(d)) ;
            xlim([0 nanmax(x)]);
            ylim([0 2]);
            set(gca,'xtick', 0:pas:nanmax(x),'xticklabel',round(z*1000)/1000,'FontSize',10,'fontWeight','demi','box','on'); hold on
            % title({[datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
            % ' - ',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
            % ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20)]},'color','k')
            text(nanmean(x)/5, 1.2,{['RMSE for delta(CNR) = ' num2str(RMSE(d),'%4.2f') ' [dB]' ]});
            text(nanmean(x)/5, 1.35,{['alpha err : ' num2str(BINT(2,1)*1000,'%4.2f') ' - ' num2str(BINT(2,2)*1000,'%4.2f') ' [km-1]' ]});
            text(nanmean(x)/5, 1.5,{['alpha = ' num2str(B(2)*1000,'%4.2f') ' [km-1]' ]});
            text(nanmean(x)/5, 1.65,{['delta CNR = ' num2str(B(2),'%6.4f') ' x delta(1/cos(teta)) + ' num2str(B(1),'%4.2f')]});
            text(nanmean(x)/5, 1.8 ,{['R = ' num2str(dist(d)) ' meters']});
            ylabel([' delta CNR [dB] '],'color','k');
            xlabel([' delta cos(teta) '],'color','k');
            
    end  % for than two CNR values axist at diven "d" distance
    
        % h14 = figure(14);
        % ax = 0:0.04:1.6; %max(RT);
        % [ft,bins] = hist(A,ax) ; 
        % hist(A,ax) ;  hold on
        % xlim([0 1.5]); 
        % set(gca,'xtick', 0:0.1:1.6);

        % clf(14)
end % d

figure(15)
plot(abs(alpha),'LineWidth',2.5,'Color','b','LineStyle','-'); hold on
xlim([1 length(dist)]); 
ylim([0 .004]); 
set(gca,'xtick',1:8:length(dist),'xticklabel',round(dist(1)):200:round(dist(length(dist))),'FontSize',10,'fontWeight','demi','box','on'); hold on
set(gca,'ytick',0:.0005:.004,'yticklabel',0:.5:4,'FontSize',10,'fontWeight','demi','box','on'); hold on

title(['extinction coeff at different radius [m-1]'],'color','k')
text(30,.0036,{[num2str(length(rng)) ' tirs']});
text(30,.0034,{['tirs : ' num2str(min(rng)) ' - ' num2str(max(rng)) ]});
text(30,.0032,{[datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
' - ',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20)]},'color','k');
ylabel(['   alpha [km-1] '],'color','k');
xlabel(['   scanning distance (R) in meters'],'color','k');
