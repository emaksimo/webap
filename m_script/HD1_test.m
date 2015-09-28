%%% evaluate alpha without any data filtering
%%% use the entire PPI

colordef white % default figure window
clear R df i dP dPz alpha epsilon ccnr ddi
chemin3 = '/media/Transcend/LNA/illustrations/';

ccnr=cnr;
ccnr(find(ccnr==0))=NaN; % do not consider the areas with zero CNR 
ccnr(find(ccnr==-27))=NaN; % do not consider the areas with too low signal
ccnr(find(nanmean(ccnr,2)==nanmin(ccnr,[],2)),:)=NaN; 

% PP = nan([size(cnr,1) size(cnr,2)]);
% dP = nan([size(cnr,1) size(cnr,2) 2]);

% positive values (of 10-15 dB) are found, remove them, an everything that follow
% these values (along the same scan)
for i=1:size(ccnr,1)
   if ~isempty( ccnr(i,find(ccnr(i,:)>0)) )    
        ccnr(i,min(find(ccnr(i,:)>0)):size(ccnr,2))=NaN;
   end
end

Y = z1(find(~isnan(ccnr))); % projection of R on Y-axis (North-pointing = azimut)
D = d1(find(~isnan(ccnr))); % projection of R on X-axis (North-pointing = azimut)
Z = ccnr(find(~isnan(ccnr))); 

[DI,YI] = meshgrid(-2500:25:2500,2500:-25:-2500); %% we keep this range of distances, because the "swaths" can be on either side
ZI = griddata(D,Y,Z,DI,YI); 
%%% dimentions are organized as followed :
%%% YI(i,1) : where each "i" row is a new distance from the center.
%%% YI(i,i) = 2500m from the lidar to the North
%%% XI(101,1) = 2500m from the lidar to the West

XI = atand(DI./YI) ; % azimut of each new CNR value [degrees from the North]
XI(find(YI <= 0 & DI >= 0 )) = (180 + atand(DI(find(YI <= 0 & DI >= 0 ))./YI(find(YI <= 0 & DI >= 0 )))) ; % correct the zenit angles within the SE quarter
XI(find(YI <= 0 & DI <= 0 )) = (180 + abs(atand(DI(find(YI <= 0 & DI <= 0 ))./YI(find(YI <= 0 & DI <= 0 ))))) ; % correct the zenit angles within the SW quarter
XI(find(YI >= 0 & DI <= 0 )) = (360 + atand(DI(find(YI >= 0 & DI <= 0 ))./YI(find(YI >= 0 & DI <= 0 )))) ; % correct the zenit angles within the NW quarter

%%% compare the regridded CNR (in 25m resol) with the original CNR data
%%% (same PPI)
% clear figure(2)
% figure(2)
% surf(DI,YI,ZI,'EdgeLighting','phong','LineStyle','none'); hold on
% %%% text(DI(105,50),YI(105,50),num2str(ZI(105,50)))
% view(0,90);
% axis equal;
% xlabel(['     Range West / East ', '(m)'],'color','k');
% ylabel(['     Range South / North ', '(m)'],'color','k');
% xlim([-max_range1 max_range1]);
% ylim([-max_range1 max_range1]);
% caxis([seuil_cnr max_cnr]); % as all other CNR figures
% h = colorbar;
% set(get(h,'Ylabel'),'string','fine-gridded CNR [db]','color','k'); 
% set(h,'YColor','k');
% grid off;
% box on
% set(gca,'Xcolor','k','Ycolor','k'); hold on


