%%%% in order retrieve alpha we first need to define the part of PPI where
%%%% the CNR signal is the least variable between neightbouring
%%%% observations

%%% plot any CNR profile (along the scanning direction)
% CNR_profile.m

colordef white % default figure window
clear R df i dP dPz alpha epsilon ccnr ddi
% chemin3 = '/media/Transcend/LNA/illustrations/';

ccnr=cnr;
ccnr(find(ccnr==0))=NaN; % do not consider the areas with zero CNR 
ccnr(find(ccnr==-27))=NaN; % do not consider the areas with too low signal
ccnr(find(nanmean(ccnr,2)==nanmin(ccnr,[],2)),:)=NaN; 

PP = nan([size(cnr,1) size(cnr,2)]);
dP = nan([size(cnr,1) size(cnr,2) 2]);

% positive values (of 10-15 dB) are found, remove them, an everything that follow
% these values (along the same scan)
for i=1:size(ccnr,1)
   if ~isempty( ccnr(i,find(ccnr(i,:)>0)) )    
        ccnr(i,min(find(ccnr(i,:)>0)):size(ccnr,2))=NaN;
   end
end


%%% homogenuous area detection
clear dPz sm thresh BT figure(6) index ri rh
thresh = 1.2 ; % threshold using areal std [dB]
sm = 80 ; % search area [meters], radius of the "box"

dPz = nan([size(ccnr,1) size(ccnr,2)]);
BT = dPz ; % all CNR values for those 2*sm boxes, that meet the threshold criteria (thresh)

for i = 1 : size(ccnr,1)
    for j = 1 : size(ccnr,2)
            clear a b in
            in = find(z1 >= (z1(i,j)-sm) & z1 <= (z1(i,j)+sm) & d1 >= (d1(i,j)-sm) & d1 <= (d1(i,j)+sm)); 

            a = nanmax(ccnr(in));
            b = nanmin(ccnr(in));
            
            if abs(minus (abs(a),abs(b) )) < thresh & ~isnan(abs(minus (abs(a),abs(b) )));  
                dPz(i,j) =  abs(minus (abs(a),abs(b) )) ;
                
                if length(in)>3 % there should be at least three values within 80m distance
                     BT(in)=ccnr(in);
                end                
            end
    end
end

% figure(6)
% surf(d1,z1,dPz,'EdgeLighting','phong','LineStyle','none'); 
% view(0,90);
% axis equal;
% xlabel(['     Range West / East ', '(m)'],'color','k');
% ylabel(['     Range South / North ', '(m)'],'color','k');
% xlim([-max_range1 max_range1]);
% ylim([-max_range1 max_range1]);
% caxis([0 thresh]);
% hold on;
% box on;
% grid off;
% h=colorbar;
% set(get(h,'Ylabel'),'color','k');
% set(gca,'Xcolor','k','Ycolor','k')
% title({[' max CNR - min CNR [dB] within a 100 m box,'],...
% % title({['standard deviation of CNR values [dB] within a 80 m box,'],...
%     [datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
% ' - ',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
% ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20)]},'color','k');
% % titre1 = ['CNR_std_box100m'];


for j = 1 : size(ccnr,2)
    ri(:,j) = nanmean(BT(:,j)); % average CNR at each scanning distance out of all "good" profiles
end

rh = nanmoving_average(ri,2); % running mean of all potentially "good" profiles
%%% running mean is the average profile (all azimuts)

%%% plot the deviations from the running mean cnr 
% for j = 1 : size(r_0,2)
%     R3(:,j) = minus(ccnr(:,j),rh(1,j)); 
% end
% figure(4)
% surf(d1,z1,R3,'EdgeLighting','phong','LineStyle','none'); 
% view(0,90);
% axis equal;
% xlabel(['     Range West / East ', '(m)'],'color','k');
% ylabel(['     Range South / North ', '(m)'],'color','k');
% xlim([-max_range1 max_range1]);
% ylim([-max_range1 max_range1]);
% hold on;
% box on;
% grid off;
% h=colorbar;
% caxis([-1 1]);
% set(get(h,'Ylabel'),'color','k');
% set(gca,'Xcolor','k','Ycolor','k');
% title({['deviations in measured CNR relative to the smothened CNR, [dB],'],...
%     [datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
% ' - ',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
% ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20)]},'color','k');


%%% if at least one value within given CNR profile exceeds the "typical" cnr signal at given distance, then remove the entire profile
for i = 1 : size(ccnr,1)
    if nanmax(abs(minus(rh,BT(i,:))))>1 
%         [rh',BT(i,:)',minus(rh,BT(i,:))']
          BT(i,:) = NaN;
    end    
end

% clear figure(7) 
% figure(7)
% surf(d1,z1,BT,'EdgeLighting','phong','LineStyle','none'); 
% view(0,90);
% axis equal;
% xlabel(['     Range West / East ', '(m)'],'color','k');
% ylabel(['     Range South / North ', '(m)'],'color','k');
% xlim([-max_range1 max_range1]);
% ylim([-max_range1 max_range1]);
% caxis([seuil_cnr max_cnr]);
% hold on;
% box on;
% grid off;
% h=colorbar;
% set(get(h,'Ylabel'),'color','k');
% set(gca,'Xcolor','k','Ycolor','k')
% title({['CNR data used to retrieve alpha [dB],'],...
%     [datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
% ' - ',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
% ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20)]},'color','k');
% titre1 = ['CNR_homogen_domain'];
% imageok=[chemin3,titre1,'.dpf'];
% print (figure(),'-dpdf','-r500',imageok);

%%% after correction of BT, reconstruct new and more proper "typical" CNR profile
for j = 1 : size(ccnr,2)
    ri(:,j) = nanmean(BT(:,j)); % average CNR at each scanning distance out of all "good" profiles
end
clear rh ct CU
rh = nanmoving_average(ri,2); % running mean of all potentially "good" profiles

%%% running mean is the average profile (all azimuts)
% clear figure(8) ct c ri
% figure(8)
% plot(r_0(i,:),rh,'--k','linewidth',2); hold on  % initial "typical" CNR profile

n=0 ;
for i=1:size(ccnr,1)
    CU(i,1) = length(find(~isnan(BT(i,:))));
    if CU(i,1) > 20
%         plot(r_0(i,:),BT(i,:),'-r'); hold on        
        n = n + 1 ;
        ct(1, n) = i ;
%     else
%         BT(i,:) = NaN;
    end
end
% xlabel([' scanning radius , (meters)'],'color','k');
% ylabel([' CNR [dB] '],'color','k');
% plot(r_0(i,:),rh,'-k','linewidth',2); hold on
% text(120,-26.5,{'data: observations only'});
% text(120,-26,{[num2str(n) ' profiles (red) with over 20 values each']});
% text(120,-25.5,{'black curve = average CNR profile'});
% text(120,-25,{'filter : min(CNR) - max(CNR) < 1.2 dB '});
% text(120,-24.5,{'160 meter box '});
% title({['CNR profiles used to retrieve alpha'],...
%     [datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
% ' - ',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
% ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20)]},'color','k');


clear D BEST BBT MAT zaxe xaxe yaxe raxe chemin2bis figure(8) figure(9) XI YI ZI C range D Y Z DI YI XI listing gc gr CU
 
%%% use "ct" variable to get the list of "best" and longest CNR profiles
%%% define the potentially homogenuous sector with at least 5 CNR profiles
if exist('ct') == 0;
        display(['no homogenuous zone within PPI = ' num2str(L) ])
        break
end

gc = 1; % group count
cpt = 1; % le tir a l'enterieur d'un groupe
beg = 1;
for i=1:length(ct)-2
    if ct(i+1) <= ct(i)+3
        gr(cpt) = ct(i);
        cpt = cpt + 1;
    else
        if cpt > 5 % if at least 5 good rays
            listing(1,gc) = min(gr);
            listing(2,gc) = ct(i);   
            
            if loopme == 0
                  MMAT(nk,:) = [ij-2,L,gc,cpt-1] ;
                  nk = nk + 1;
            end
            gc = gc + 1; % now we work with another group of 'tirs"
        end        
        clear gr
        cpt = 1 ;
    end
end

if exist('listing') == 0;
        display(['no homogenuous zone within PPI = ' num2str(L) ])
        break
end

if loopme == 1
%%%% interpolate between the original profiles
rng = listing(1,zone) : listing(2,zone) ; % define the profiles to interpolate (using "cn" vecor of good profiles)

%%% keep only those CNR profiles within the study zone
% BBT = BT; % when using the real FILTERED  CNR data
% BBT = ccnr ; % when using the real UNFILTERED CNR data
HD2_test  ; % when using the simulated CNR !!!!
% elena_test

% BBT(find(isnan(BT))) = NaN; % apply the mask like if the filtering was used (like in real CNR data)
BBT(1:rng(1)-1,:) = NaN;
BBT(rng(length(rng))+1:size(BBT,1),:) = NaN;

%%% remove artificially some simulated cnr profiles
% zr = [rng(1)+3 rng(1)+4 rng(1)+8 rng(1)+15 rng(1)+3 rng(1)+4 rng(1)+8 rng(1)+15 ] ; 
% BBT(zr,:) = NaN;

Z = z1(find(~isnan(BBT))); % projection of R on Y-axis (North-pointing = azimut)
D = d1(find(~isnan(BBT))); % projection of R on X-axis (North-pointing = azimut)
B = BBT(find(~isnan(BBT))); 

%%% plot all the data used for interpolation
clear id dat col JET figure(10) 
dat = abs(B);
JET=fliplr(get(gcf,'colormap'));
tt = minus(ceil(max(dat)),floor(min(dat)));

for i = 1 : length(dat) ; % corresponding color vector
        clear cc
        cc = round(64*minus(dat(i),floor(min(dat)))/tt); 
        if cc >0 & cc <= 64
            col(i,:) = JET(cc,:); % corresponding color vector FF(whi,di)
        elseif cc == 0
             col(i,:) = JET(1,:);
        elseif cc > 64
             col(i,:) = JET(64,:);
        end
end

figure(10)
scatter(D,Z,50,col,'o','fill'); % corrected!
view(0,90);
axis equal;
xlabel(['     Range West / East ', '(m)'],'color','k');
ylabel(['     Range South / North ', '(m)'],'color','k');
hold on;
box on;
grid off;
hcb=colorbar;
caxis([1 64]);
set(hcb,'ytick',1:9:64);
set(hcb,'yticklabel',-ceil(max(dat)):tt/9:-floor(min(dat)),'fontsize',10,'FontWeight','demi');  
title({['remaining "good" CNR [in dB] data over a presumingly homogeneous area'],
    [datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),' - ',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
    ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20)]},'color','k');

%%%%%%%%%%%%%%%%%%%
% figure(9)
% surf(d1,z1,BBT,'EdgeLighting','phong','LineStyle','none'); hold on
% view(0,90);
% axis equal;
% caxis([min(min(BBT)) max(max(BBT))]);
% h = colorbar;
% if max(rng)<= 90 & min(rng)>=0 
%     xlim([0 3000]);
%     ylim([0 3000]);
% elseif max(rng)<= 180 & min(rng)>=90 
%     xlim([0 3000]);
%     ylim([-3000 0]);
% elseif max(rng)<= 270 & min(rng)>=180 
%     xlim([-3000 0]);
%     ylim([-3000 0]);
% elseif max(rng)<= 360 & min(rng)>=270 
%     xlim([-3000 0]);
%     ylim([-3000 0]);
end

%%%%%%%%%%%%%%%%%%%%%
clear DI ZI BI XI figure(8) ; 
[DI,ZI] = meshgrid(-3000:10:3000,3000:-10:-3000); %% we keep this range of distances, because the "swaths" can be on either side
BI = griddata(D,Z,B,DI,ZI); % D and DI are OX projections, Z and ZI are OY projections

XI = atand(DI./ZI) ; % azimut of each new CNR value [degrees from the North]
% XI(find(DI >= 0 & ZI >= 0 )) = (90 + abs(atand(DI(find(DI >= 0 & ZI <= 0 ))./ZI(find(DI >= 0 & ZI <= 0 ))))) ;
XI(find(DI <= 0 & ZI >= 0 )) = (360 - abs(atand(DI(find(DI <= 0 & ZI >= 0 ))./ZI(find(DI <= 0 & ZI >= 0 ))))) ; % correct the zenit angles within the NW quarter
XI(find(DI <= 0 & ZI < 0 )) = (180 + atand(DI(find(DI <= 0 & ZI < 0 ))./ZI(find(DI <= 0 & ZI < 0 )))) ; % correct the zenit angles within the SW quarter
XI(find(DI >= 0 & ZI <= 0 )) = (180 - abs(atand(DI(find(DI >= 0 & ZI <= 0 ))./ZI(find(DI >= 0 & ZI <= 0 ))))) ; % correct the zenit angles within the SE quarter

% figure(9)
% surf(DI,ZI,SIN,'EdgeLighting','phong','LineStyle','none'); hold on
% view(0,90);
% axis equal;
% xlabel(['Range West / East ', '(m)'],'color','k');
% ylabel(['Range South / North ', '(m)'],'color','k');
% if max(rng)<= 90 & min(rng)>=0 
%     xlim([0 3000]);
%     ylim([0 3000]);
% elseif max(rng)<= 180 & min(rng)>=90 
%     xlim([0 3000]);
%     ylim([-3000 0]);
% elseif max(rng)<= 270 & min(rng)>=180 
%     xlim([-3000 0]);
%     ylim([-3000 0]);
% elseif max(rng)<= 360 & min(rng)>=270 
%     xlim([-3000 0]);
%     ylim([-3000 0]);
% end
% caxis([min(min(BBT)) max(max(BBT))]);
% h = colorbar;
% set(get(h,'Ylabel'),'string','fine-gridded CNR [db]','color','k'); 
% set(h,'YColor','k');
% grid off;
% box on
% set(gca,'Xcolor','k','Ycolor','k'); hold on
% title({['regridded (interpolated) CNR [in dB] over a presumingly homogeneous area'],
%     [datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),' - ',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
%     ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20)]},'color','k');
% end

%%%%%  for alpha definition
clear SS CS azim ref fi SIN
CS = nan([size(ZI,1) size(ZI,2)]); 
SIN = nan([size(ZI,1) size(ZI,2)]); 
fi = CS ;
SS = CS ; 
azim = nanmin(XI(find(~isnan(BI)))) : nanmax(XI(find(~isnan(BI)))) ;
ref = round(plus(listing(1,zone),minus(listing(2,zone),listing(1,zone))/2)) + 0.00001; % the new axis is located in the middle of the first "tir"

% ref = floor(nanmin(XI(find(~isnan(ZI))))) - 1 ; % the nex axis is located on the left side of the first "tir"

% ZI(find(XI <= 11.5)) = NaN ; 
% ZI(find(XI <= 26.5 & XI >= 24.5)) = NaN ;
% ZI(find(XI <= 45.5 & XI >= 44.5)) = NaN ;
% ZI(find(XI <= 55.5 & XI >= 53.5)) = NaN ;
%%% 

CS(find(~isnan(BI))) = cosd(minus(XI(find(~isnan(BI))),ref)); % cos of the angle in new coordinates (original scanning angle relative to the new reference axis "ref"
SIN(find(~isnan(BI))) = sind(minus(XI(find(~isnan(BI))),ref)); 
fi = (ZI./cosd(XI)).*CS; % ZI./cosd(XI) = scanning distance R (in 10m resolution)
%%% fi = projection of each new (interpolated) CNR value on the new reference (central) axis (=ref)
dist = min(fi(find(~isnan(fi)))) : 25 : max(fi(find(~isnan(fi)))) ; % distance off the lidar
SS(find(~isnan(BI))) = fi(find(~isnan(BI))).*tand(minus(XI(find(~isnan(BI))),ref)); % perpendicular distance of given CNR value relative to the new reference axis [meters]

% figure(9)
% surf(DI,ZI,SIN,'EdgeLighting','phong','LineStyle','none'); hold on
% view(0,90);
% axis equal;


