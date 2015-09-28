clear ze CS T azim D DC d a fi figure(10) figure(11) ref f1 alpha
if exist('f1')==1
    clf(f1) ;
elseif exist('f2')==1
    clf(f2) ;
end

azim = rng;
ref = min(rng)-1;

ze = 120;
cpt=1;
for i=azim
        scnr(cpt,:) = nanmoving_average(ccnr(i,:),2);
        cpt=cpt+1;
end

CS = cosd(az(azim,1)-ref);

for i = 1:size(scnr,1) % teta angle
    fi(i,:) = r_0(1,:)*CS(i);
end


% figure(10)
% plot(r_0(1,:),ccnr(ze,:),'o-k')
% hold on
% plot(r_0(1,:),nanmoving_average(ccnr(ze,:),2),'o-r');
% hold on
% plot(r_0(1,:),ccnr(ze-5,:),'o-g'); hold on
% plot(r_0(1,:),nanmoving_average(ccnr(ze-5,:),2),'o-m')
% r_0(1,find(scnr(6,:) == nanmax(scnr(6,:))))
% cos(5*pi/180)*800

figure(10)
cpt = 1;
colormap(jet);
JET=get(gcf,'colormap');
step = floor(64/size(scnr,1)); % color step depends on the number of "tirs" that we have within our study zone 

for i=1:size(scnr,1)
     H1 = plot(r_0(1,:),scnr(i,:),'Color',[JET(cpt,:)]);
     hold on
     cpt = cpt+step;
end

% figure(11)
% cpt = 1;
% for i=1:size(scnr,1)
%      plot(fi(i,:),scnr(i,:),'r');
%      hold on
% end

epsilon = 10/log(10) ;

f1 = figure(12);
my_big_figure % empty figure with many subplots
pit = 1;


for d = 1: size(r_0,2)
%     d = 1; % distance off the lidar
    clear a D DC AL cos_fi A y x T r S mu regF err k XX
    a = ccnr(azim,d) ;  % all CNR values within the good (homeneguous) sector, roughly corresponding to distance "d" 
    
    D = nan([length(a) length(a)]); 
    DC = D;
    AL = D;

    for i = 1:length(azim) % azimut count
       clear n
       D(i+1:length(a),i)  = abs(minus(a(i+1:length(a)), a(i))); % delta CNR (no matter the sign)
       DC(i+1:length(a),i) = abs(minus((CS(i+1:length(a)).^(-1)),(CS(i)^(-1)))) ; % we don't care the relative position of CNR values, but only the "absolute" difference in angles
    end

    AL = D./(DC*2*epsilon*r_0(1,d)) ; % alpha for each combination of CNR values at given distance from the instrument
    A = reshape(AL,[length(a)*length(a) 1]);
    y = reshape(D,[length(a)*length(a) 1]);
    x = reshape(DC,[length(a)*length(a) 1])*2*epsilon*r_0(1,d) ; % predictor
  
    %%% linear fit: delta CNR vs delta cos teta for each combination of observations

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
    
        %%% plot the linear regression (delta CNR vs delta(cos(teta)))
        if d < 26   
                get(f1);
                subplot('Position',loc(d,:)); hold on
        elseif d > 25 && d < 51
                if pit == 1
                        f3 = f1; 
                        clear f1
                        f1 = figure(13); hold on;
                        my_big_figure ; hold on ; % empty figure with many subplots
                        pit = 2;
                end
                get(f1);
                subplot('Position',loc(d-25,:)); hold on
        else
                break % "d" loop, because alpha retriieval is not needed there
        end

        plot(x,x*B(2)+B(1)); hold on;
        scatter(x,y); hold on ;
        % max(reshape(DC,[length(a)*length(a) 1]))

        pas = nanmax(x)/10;
        z = (0:pas:nanmax(x))/(2*epsilon*r_0(1,d)) ;
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
        text(nanmean(x)/5, 1.8 ,{['R = ' num2str(r_0(1,d)) ' meters']});
        ylabel([' delta CNR [dB] '],'color','k');
        xlabel([' delta cos(teta) '],'color','k');

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
xlim([0 59]); 
ylim([0 .004]); 
set(gca,'xtick',1:5:59,'xticklabel',100:250:3000,'FontSize',10,'fontWeight','demi','box','on'); hold on
set(gca,'ytick',0:.0005:.004,'yticklabel',0:.5:4,'FontSize',10,'fontWeight','demi','box','on'); hold on

title(['extinction coeff at different radius [m-1]'],'color','k')
text(30,.0036,{[num2str(length(rng)) ' tirs']});
text(30,.0034,{['tirs : ' num2str(min(rng)) ' - ' num2str(max(rng)) ]});
text(30,.0032,{[datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
' - ',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20)]},'color','k');
ylabel(['   alpha [km-1] '],'color','k');
xlabel(['   scanning distance (R) in meters'],'color','k');
