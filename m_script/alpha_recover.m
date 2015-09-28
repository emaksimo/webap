%%% calculate alpha for each pair of CNR values, that is a
%%% function of cos(azimut) and the projection on Y-axis
%%% the part of PPI where the CNR signal is the least variable was defined
%%% in "best_profile.m"

%%% "CNR_profile.m" was used to plot gerdrided (interpolated/cleaned) CNR 
%%% values over di (projection of R on Y-axis) and over azimuth (degrees from North in clockwise direction) 

%%% alpha = extinction coef
%%% betta = backcatter
%%% Lidar ratio
%%% R = the distance off the instrument
%%% XI is the matrix of azimuts 

clear azi di epsilon
colordef white % default figure window

epsilon = 10/log(10) ;
zn = 2*epsilon ;

%%% r_0 = distance from the instrument [m] corresponding cnr matrix of 
%%% observations (PPI)
clear RT FF DIST DCOS XA f1 f3 % is a matrix of all alpha estimates at each distance (di)
for di = 1:4:size(YI,1) % YI is the projection of given CNR observation (R vs angle) on Y-axis
    
%    di = 45 % size(ZI,YI and XI) = 201 x 201 (25m resolution)
    if isempty(find(~isnan(ZI(di,:)))) % find all cnr values corresponding to given Y-projection distance 
        continue  % di loop
    end
    clear a b aa bb c e cc ee i D DC CC falpha i j
    a = ZI(di,find(~isnan(ZI(di,:)))); % all available CNR values at given distance "di" 
    b = XI(di,find(~isnan(ZI(di,:)))); % corresponding azimut of "good nonNAN" CNR values at given distance "di" [degreeze from the North]
    c = DI(di,find(~isnan(ZI(di,:)))); % corresponding  X-axis projection (in 25m resolution)
    e = YI(di,find(~isnan(ZI(di,:)))); % corresponding  Y-axis projection (in 25m resolution)
     
    %%% create the symmetric matrice of , see
    aa = toeplitz(a); % CNR
    bb = toeplitz(b); % azimut
    cc = toeplitz(c); % X-axis projection 
    ee = toeplitz(e); % Y-axis projection : should be the same at all locations! zero everywhere where making the difference   
    
    D = nan([length(a) length(a)]);
    DC = D; CC = D; 
    
    for i=1:length(a) 
        D(i+1:length(a),i)  = abs(minus(aa(i+1:length(a),1), aa(1,i))); % delta CNR
        %%% if the measurements that we compare are located in the same quarter relative to the azimut (North-South) direction
        %%% then we treat (compare) these values in a simple way
       
        if (bb(1,i)<=180 & length(find(bb(i+1:length(a),1)>180 )) == 0 ) | (bb(1,i)>180 & length(find(bb(i+1:length(a),1)<=180 )) == 0 )  % if none of comparable values is located within the other quarter
             DC(i+1:length(a),i) = abs(minus(((cos(bb(i+1:length(a),1).*pi/180)).^(-1)) , (cos(bb(1,i)*pi/180))^(-1))); % "abs" : we are interested in the absolute angular difference only
             CC(i+1:length(a),i) = abs(minus(cc(i+1:length(a),1), cc(1,i))); % corresponding distance between two CNR values (X-axis)
        else 
        %%% however it is likelly that the measurements that we compare are located on different sides of the azimut (North-South) direction
        %%% so we should treat (compare) these values differently
           
            for j = i+1:length(a) 
                if (bb(1,i)<=180 & bb(j,1)>180 ) || (bb(1,i)>180 & bb(j,1)<=180 ) 
                    DC(j,i) = abs(plus( (cos(bb(j,1)*pi/180))^(-1) , (cos(bb(1,i)*pi/180))^(-1) )); 
                    CC(j,i) = plus(abs(cc(j,1)), abs(cc(1,i))); % corresponding distance between two CNR values (X-axis)
                    
%                     j
%                     [bb(j,1), bb(1,i) , cos(bb(j,1)*pi/180), cos(bb(1,i)*pi/180), DC(j,i) ]
%                     [cc(j,1), cc(1,i),  CC(j,i) ]
%                     
%                     keyboard
                else
                    DC(j,i) = abs(minus( (cos(bb(j,1)*pi/180))^-1 , (cos(bb(1,i)*pi/180))^-1 )); % "abs" : we are interested in the absolute angular difference only
                    CC(j,i) = abs(minus(cc(j,1), cc(1,i) ));
                    
%                     [bb(j,1), bb(1,i) , cos(bb(j,1)*pi/180), cos(bb(1,i)*pi/180), DC(j,i) ]
%                     [cc(j,1), cc(1,i),  CC(j,i) ]
%                     keyboard
                end
            end    
        end
        
        
        % corresponding distance between two CNR values within Y-axis == ZERO !
    end   
    
    falpha = D./(DC*zn*abs(YI(di,1))) ; % for given di !!!!
    FF(1:length(find(~isnan(falpha) & ~isinf(falpha))),di) = falpha(find(~isnan(falpha) & ~isinf(falpha))) ;
    XA(1:length(find(~isnan(falpha) & ~isinf(falpha))),di) = CC(find(~isnan(falpha) & ~isinf(falpha))) ;
    DCOS(1:length(find(~isnan(falpha) & ~isinf(falpha))),di) = DC(find(~isnan(falpha) & ~isinf(falpha))) ; 
    DIST(1:length(find(~isnan(falpha) & ~isinf(falpha))),di) = YI(di,1) ; % what is the reference Y-projection for all these alpha values ? = const 
% end
   
FF(find(FF(:,di)<=0),di)=NaN;
RT = FF(find(~isnan(FF(:,di))),di) ;
   
clear figure(3) f1 f3
f3 = figure(3)
set(f3,'PaperType','A4','PaperUnits','centimeters','Units','centimeters','PaperSize',[17 10],'Position',[18.5 18 17 12]); hold on % 'PaperType','A4','PaperUnits','centimeters','Units','centimeters','PaperSize',[55 30],
set(f3,'PaperPositionMode','auto')
ax = 0:0.0002:0.002; %max(RT);
num2str(di)
[ft,bins] = hist(RT,ax) ; 
hist(RT,ax) ;  hold on
ylim([0 7500]);
xlim([0 0.002]); 
title(['PDF of the extinction coef at dy = ' num2str(YI(di,1)) 'm (all CNR measures considered)'],'color','k')

clear figure(2)
f1=figure(2)
set(f1,'PaperType','A4','PaperUnits','centimeters','Units','centimeters','PaperSize',[17 10],'Position',[36 18 17 12]); hold on % 'PaperType','A4','PaperUnits','centimeters','Units','centimeters','PaperSize',[55 30],
set(f1,'PaperPositionMode','auto')
scatter(XA(find(~isnan(FF(:,di))),di),RT,5,'g','o'); hold on
ylim([0 0.002]);
xlim([0 5000]);
title({['dependence of extinction coef [m-1]'];['on the distance (dx) between two measurements, dy = ' num2str(YI(di,i)) 'm']},'color','k')
ylabel('alpha','color','k');
xlabel(' X-axis projection of the distance between two CNR measures [meter]','color','k');

pause(5)
clf(f1) ; clf(f3)
end
%%%%%

clear figure(4) i di loc f1 a

f1=figure(4);
my_big_figure % empty figure with many subplots 
projection={'lambert'} ;  
    
colormap(jet);
JET=get(gcf,'colormap');

u = 1;
for di = 1 : size(FF,2)
     if isempty(find(~isnan(FF(:,di)))) % | isempty(find(FF(:,di)>0))
        continue  % di loop
     end
   
    clear whi dat col id
    whi = find(FF(:,di)>0) ;
    dat = FF(whi,di)*100000;

    [DCOS(whi,di),XA(whi,di),FF(whi,di)]
    
    for i = 1 : length(dat) ; % corresponding color vector 
        id(i,1) = round(dat(i)) ;
        if round(dat(i,1)) > 0 & round(dat(i,1)) < 64
            col(i,:) = JET( round(dat(i)),:); % corresponding color vector FF(whi,di)
        elseif round(dat(i,1)) == 0 
             col(i,:) = JET(1,:);
        elseif round(dat(i,1)) > 64 ;
             col(i,:) = JET(64,:);
        end
    end
%     scatter3(DCOS(whi,di),XA(whi,di),DIST(whi,di),6,col,'o'); hold on
    
%     get(f)
    subplot('Position',loc(u,:)); hold on
    scatter3(id,DCOS(whi,di),XA(whi,di),80,col,'o'); hold on
    view(80,-40)
    grid on
    text(400,0.1, num2str(DIST(1,di))) ; 
    u = u+1 ;
    ylim([0 0.4]); 
%     ylim([0 600]);
    xlim([0 250]);
end

% view(-60,60)
% % ylim([0 0.0016]);
title('dependence of extinction coef [m-1] on delta(cos(theta)) and the relative distance (X-axis projection)','color','k')
% colorbar

% figure(4)
% [xi,yi] = meshgrid(1:length(aa),1:length(aa));
% surf(xi,yi,DC,'LineStyle','none');  
% view(2); hold on;
% xlim([1 length(aa)]);
% ylim([1 length(aa)]);
% colorbar;
% 
% figure(4)
% surf(xi,yi,D,'LineStyle','none');  
% view(2); hold on;
% xlim([1 length(aa)]);
% ylim([1 length(aa)]);
% colorbar;

% xlabel(['     azimuth ', '(degrees clockwise from the North)'],'color','k');
% ylabel(['     Y-axis projection of R ', '(m)'],'color','k');





