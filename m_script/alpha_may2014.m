 %%% evaluate alpha for the range of distances 
 %%% this range of distances Ri is individual for each PPI
 %%% alpha is individual for each PPI
 %%% data: mean CNR(R) at each scanning distance R, each PPI individually
 
clear yy xx Y X B BINT RA RINT STATS xr1 xr2 XR h3
yy = nan([length(MN) length(MN)]); % delta CNR correcled by epsilon and 2lnR
xx = yy ; % delta R
xr1 = yy ; xr2 = yy;
R = 100:50:3000 ;


% keyboard
MN(find(R < ah(cpt+1,1))) = NaN;
MN(find(R > ah(cpt+1,2))) = NaN;
        
 for i = 1:length(R)-1    % scanning distance
        yy(i+1:length(MN),i)   = minus(MN(i+1:length(MN)), MN(i)) ; % delta CNR 
        xx(i+1:length(MN),i)   = minus(R(i+1:length(MN)), R(i)) ;   % delta R, our predictor
        xr1(i+1:length(MN),i)  = R(i+1:length(MN)) ;
        xr2(i+1:length(MN),i)  = R(i) ;
 end 
%   xx(30:length(MN),30:length(MN))
if length(yy(find(yy > 0))) > 0 % if there are positive delta CNR, then alpha increases with height, and then this PPI should be skiped 
    return % L loop
end

Y = yy(find(~isnan(yy)));    % delta CNR 
X(1:length(Y),2) = -2*xx(find(~isnan(yy)));  % delta R
X(1:length(Y),1) = 1 ; 

XR(:,1) = xr1(find(~isnan(yy))); 
XR(:,2) = xr2(find(~isnan(yy))); 
clear xr1 xr2 xx

[B,BINT,RA,RINT,STATS]=regress(Y,X,0.01);
alpha(cpt+1) = B(2)*1000; % angle of the linear fit
FM(cpt+1) = B(1); % the free coefficient "b" of the linear fit
ERR(cpt+1,1:2) = BINT(2,:);
FM_ERR(cpt+1,1:2) = BINT(1,:);

clf (figure(4)) ;
h3 = figure(4) ;
if cpt == 0;                     
       set(h3,'Position',[1130 54 560 232]);
       subplot('Position',[0.1 0.15 0.89 0.82]);
       grid on
end     
scatter(X(:,2),Y,'MarkerFaceColor',[RGB(1),RGB(2),RGB(3)],'MarkerEdgeColor','none'); hold on ;
plot(X(:,2),X(:,2)*B(2)+B(1),'linewidth',2,'color',[RGB(1),RGB(2),RGB(3)]); hold on;
xlabel([' -2 * delta R [meters]'],'color','k')
ylabel([' delta(CNR(R))'],'color','k');
title('extinction coeff')


