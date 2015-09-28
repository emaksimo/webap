%%%% in order retrieve alpha we first need to define the part of PPI where
%%%% the CNR signal is the least variable between neightbouring
%%%% observations
%%%% we DO NOT interpolate between the original profiles ANYMORE, as in
%%%% "best_profile.m"
%%%% we don't use the projection on the reference axis anymore, but we use the spherical coordinates instead 

%%% plot any CNR profile (along the scanning direction)
% CNR_profile.m

colordef white % default figure window
JET=get(gcf,'colormap');  % fliplr(get(gcf,'colormap'));
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

for j = 1 : size(ccnr,2)
    ri(:,j) = nanmean(BT(:,j)); % average CNR at each scanning distance out of all "good" profiles
end

rh = nanmoving_average(ri,2); % running mean of all potentially "good" profiles
%%% running mean is the average profile (all azimuts)

%%% if at least one value within given CNR profile exceeds the "typical" cnr signal at given distance, then remove the entire profile
% for i = 1 : size(ccnr,1)
%     if nanmax(abs(minus(rh,BT(i,:))))>1 
% %         [rh',BT(i,:)',minus(rh,BT(i,:))']
%           BT(i,:) = NaN;
%     end    
% end

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
% title({['original CNR data used to retrieve alpha [dB],'],...
%     [datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
% ' - ',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
% ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20)]},'color','k');
% titre1 = ['CNR_homogen_domain'];
% imageok=[chemin3,titre1,'.dpf'];
% print (figure(),'-dpdf','-r500',imageok);

%%% after correction of BT, reconstruct new and more proper "typical" CNR profile
% for j = 1 : size(ccnr,2)
%     ri(:,j) = nanmean(BT(:,j)); % average CNR at each scanning distance out of all "good" profiles
% end

clear rh CU ct
% rh = nanmoving_average(ri,2); % running mean of all potentially "good" profiles

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


clear D BEST BBT MAT zaxe xaxe yaxe raxe chemin2bis figure(9) XI YI ZI C range D Y Z DI YI XI listing gc gr CU
 
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

if loopme == 1 ;
    
rng = listing(1,zone) : listing(2,zone) ; % define the profiles to interpolate (using "cn" vecor of good profiles)

clear BBT D Z Y DI YI ZI azim distance figure(11) figure(12) col dat tt
%%% keep only those CNR profiles within the study zone
% BBT = ccnr;  % not filetred measured CNR
% BBT = BT;    %  filetred measured CNR

figure(3)
plot(r_0(1,:),ccnr(rng(2),:),'-r','linewidth',2); hold on  % initial "typical" CNR profile

HD2_test  ; % when using the simulated CNR !!!!

figure(2)
plot(ccnr(10,:)); hold on
plot(BBT(1,:))

keyboard
BBT(1:rng(1)-1,:) = NaN;
BBT(rng(length(rng))+1:size(BBT,1),:) = NaN;

% Z = z1(find(~isnan(BBT))); % projection of R on Y-axis (North-pointing = azimut)
% D = d1(find(~isnan(BBT))); % projection of R on X-axis (North-pointing = azimut)
% B = BBT(find(~isnan(BBT))); 
% 
% 
% BBT = BT;
% BBT(1:rng(1)-1,:) = NaN;
% BBT(rng(length(rng))+1:size(BBT,1),:) = NaN;
% Z = BBT(find(~isnan(BBT)));
% D = d1(find(~isnan(BBT)));
% Y = z1(find(~isnan(BBT)));

%%% plot all the data used for interpolation
% dat = abs(B) ;
% JET=fliplr(get(gcf,'colormap'));
% tt = minus(ceil(max(dat)),floor(min(dat)));
% 
% for i = 1 : length(dat) ; % corresponding color vector 
%         if round(dat(i,1)) > 0 & round(dat(i,1)) <= 64
%             col(i,:) = JET( round(64*minus(dat(i),floor(min(dat)))/tt),:); % corresponding color vector FF(whi,di)
%         elseif round(dat(i,1)) == 0 
%              col(i,:) = JET(1,:);
%         elseif round(dat(i,1)) > 64 ;
%              col(i,:) = JET(64,:);
%         end
% end
% 
% figure(11)
% scatter(Z,D,50,col,'o','fill'); 
% hcb=colorbar;
% caxis([1 64]);
% set(hcb,'ytick',1:9:64);
% set(hcb,'yticklabel',-ceil(max(dat)):tt/9:-floor(min(dat)),'fontsize',10,'FontWeight','demi');  
% 
% view(0,90);
% axis equal;
% xlabel(['     Range West / East ', '(m)'],'color','k');
% ylabel(['     Range South / North ', '(m)'],'color','k');
% hold on;
% box on;
% grid off;
% title({['measured CNR [in dB] along presumingly homogeneous profiles'],
%     [datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),' - ',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
%     ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20)]},'color','k');

%%%% interpolate each CNR profile individually (only along the scanning direction)
clear BI i distance
cpt = 1 ;
for i = 1 : size(BBT,1) ;
    if length(find(~isnan(BBT(i,:))))>20
        BI(cpt,:) = interp1(r_0(1,:),BBT(i,:),100:5:3000); 
        distance(cpt,:) = interp1(r_0(1,:),r_0(1,:),100:5:3000);         
        XI(cpt,1:size(BI,2)) = az(i); % azimut of new values is the same of the original CNR profile!
        cpt = cpt +1 ;
    end
end

DI=distance.*sin(XI*pi/180); % as "d1"
ZI=distance.*cos(XI*pi/180); % as "z1"

figure(11)
surf(DI,ZI,BI,'EdgeLighting','phong','LineStyle','none'); 
view(0,90);
axis equal;
xlabel(['     Range West / East ', '(m)'],'color','k');
ylabel(['     Range South / North ', '(m)'],'color','k');
xlim([-max_range1 max_range1]);
ylim([-max_range1 max_range1]);
caxis([nanmin(nanmin(BI)) nanmax(nanmax(BI))]);
hold on;
box on;
grid off;
h=colorbar;
set(get(h,'Ylabel'),'color','k');
set(gca,'Xcolor','k','Ycolor','k')

title({['1D interpolated CNR']},'color','k');
end  % if loopme = 1
