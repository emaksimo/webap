%%% plot any CNR profile (along the scanning direction)

%%% the part of PPI where the CNR signal is the least variable was defined
%%% in "best_profile.m"


cla
clear figure(2)
figure(2)

% data = cnr ;
data = ZI ; 
YI(1,find(YI(1,:)<0)) = abs(YI(1,find(YI(1,:)<0)));
% range=find(r_0(1,:)==1300):find(r_0(1,:)==2000)
range = 1:size(data,2);

for ni=1:size(data,1)
%    rn(ni,:)=runmean(data(ni,:),2); % running mean along the scanning direction (singe azimut)
%    diff(ni,:)=minus(rn(ni,range),data(ni,range));
   if ~isnan(nansum(data(ni,range)));
%      diff_std(ni,:)=NaN;
%    else
%       diff_std(ni,:)=nanstd(diff(ni,:));
%       plot(r_0(nk(ni),:),(rn(nk(ni),:)),'-r');
%       plot(YI(ni,:),data(ni,:),'-r', ); hold on
%       find(~isnan(data(ni,:)))
      plot(YI(1,:),data(ni,:),'LineStyle','none','Marker','o','MarkerFaceColor','y','MarkerEdgeColor','none','MarkerSize',2.5); 
      hold on
   end
end
ylim([-27 -17]);
xlim([0 2500]);

ylabel([' CNR (function of di and azimuth [dB]'],'color','k');
xlabel([' di = Y-axis projection of R ', '(m)'],'color','k');
set(gca,'Xcolor','k','Ycolor','k','Zcolor','k'); hold on
title({['regridded (interpolated) CNR signal over the homogeneous area [dB],'],...
    [datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),'-',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20)]},'color','k');

titre1 = ['CNR_interpolated_di_vs_azimut_scatter'];
imageok=[chemin3,titre1,'.png'];
print (figure(2),'-dpng','-r500',imageok);

% nk=find(diff_std==nanmin(diff_std) & diff_std)))
% 
% for ni=1:length(nk)
%     figure(3)
%     plot(r_0(nk(ni),:),(rn(nk(ni),:)),'-r');
%     hold on
%     plot(r_0(nk(ni),:),(data(nk(ni),:)),'-g');
%     pause(2)
%     clf
% end 
