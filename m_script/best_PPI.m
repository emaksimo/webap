%%%% in order retrieve alpha we first need to define the part of PPI where
%%%% the CNR signal is the least variable between neightbouring
%%%% observations
%%%% we DO NOT interpolate between the original profiles ANYMORE, as in
%%%% "best_profile.m"
%%%% we don't use the projection on the reference axis anymore, but we use the spherical coordinates instead 

%%% plot any CNR profile (along the scanning direction)
% CNR_profile.m

clear cmean cstd cmax ccnr CK CN

if loopme ~= 0 
    colordef white % default figure window
    JET=get(gcf,'colormap');  % fliplr(get(gcf,'colormap'));
    clear ccnr CN
    % chemin3 = '/media/Transcend/LNA/illustrations/';
end

ccnr = cnr;
ccnr(find(ccnr>=0))=NaN; % do not consider the areas with zero CNR 
ccnr(find(ccnr<=-27))=NaN; % do not consider the areas with too low signal
ccnr(find(nanmean(ccnr,2)==nanmin(ccnr,[],2)),:)=NaN; 

% positive values (of 10-15 dB) are found, remove them, and everything that follow
% these values (along the same scan)
for i = 1:size(ccnr,1)
   if ~isempty(find(ccnr(i,:)>0))    
        ccnr(i,min(find(ccnr(i,:)>0)):size(ccnr,2))=NaN;        
   end
   
   %%% remove local peaks in CNR not related to atmospheric composition
%    rh = nanmoving_average(ccnr(i,:),1); % running mean of each profile, plus minus 1 value around the central value
%    rh(1) = NaN;
%    ra = minus(ccnr(i,:),rh); 
%    ccnr(i,find(abs(ra) > 1)) = NaN ;    
end

%%% std(CNR) of all 360 vales at given radius "j"
for j=1:size(ccnr,2) % treat each radius individually
        CK(1,j) = nanmean(ccnr(:,j))  ;
        CN(1,j) = nanstd(ccnr(:,j))   ;          
end

cmean = nanmean(CN); % average CNR at each scanning distance out of all "good" profiles
cstd  = nanstd(CN); 
cmax  = nanmax(CN); 

% CF(ij-2,L,1:59) = CN(1,:)./CK(1,:); 

if loopme ~= 0
    clf (figure(3))
    cf =  figure(3)
     surf(d1,z1,cnr,'EdgeLighting','phong','LineStyle','none'); 
    view(0,90);
    caxis([seuil_cnr max_cnr]);
    axis equal;
    xlabel(['     Range West / East ', '(m)']);
    ylabel(['     Range South / North ', '(m)']);
    xlim([-max_range1 max_range1]);%complet
    ylim([-max_range1 max_range1]);%complet
    hold on;
    box on;
    grid off;
    colorbar;
    axe_PPI;
    title(['PPI corrected']);
end

% figure(18)
% clear cpt cl; cpt = 1;
% for ij = 1 : 1: size(CF,1)
%     for L = 1 : 1: size(CF,2)
%             clear A
%             A = reshape(CF(ij-2,L,1:59),[1 59]) ;  % = CN(1,:)./CK(1,:); 
%             if length(find(~isnan(A))) > 0 & length(find(A < 0)) > 0 & nanmin(A(13:52)) > -0.05 % & nanmin(A) > 0.1
%                     plot(100:50:3000,A); hold on ;
%                     cl(cpt,:) = [ij+2,L] ; % plot PPI and RHI, wind map and spatial distribution histograms for these PPI
%                     cpt = cpt + 1;
%             end
%     end
% end
% ylabel(['std(CNR(R)) / ave(CNR(R))']);
% xlabel(['scanning distance (meters)']);
% 

