%%% plot the model surface height in the vicinity of given radar position

clear all 
close all

startup

if S == 1 % Pianatolli
    %%% radar position
    rla = 41.4722 ; % decimal degrees [N]
    rlo = 9.0656 ; % decimal degrees [E]
    
    %%% AROME-WMED coordinates closest to radar
    ala = 41.48;  % alai = 242; % find(lati(:,1) == ala)
    alo = 9.08;   % aloi = 704; % find(loni(1,:) == alo)
%     slcm = 54 ; % altitude of model land surface above the sea level [meters]

elseif S == 2 % Levant
    %%% radar position
    rla = 43.02 ; % decimal degrees [N]
    rlo = 6.46 ; % decimal degrees [E]
    ala = 43.03 ; % decimal degrees [N]
    alo = 6.45 ; % decimal degrees [E]
%     slcm = 12; 

elseif S == 3 % Candillargues
    rla = 43.61 ; % decimal degrees [N]
    rlo = 4.07 ; % decimal degrees [E]
    ala = 43.6 ; % decimal degrees [N]
    alo = 4.08 ; % decimal degrees [E]
%     slcm = 1 ; 
end

figure(1)
filename = 'boston_ovr.jpg';
RGB = imread(filename);
R = worldfileread(getworldfilename(filename), 'geographic', size(RGB));

ax = usamap(RGB, R);
setm(ax, ...
    'MLabelLocation',.05, 'PLabelLocation',.05, ...
    'MLabelRound',-2, 'PLabelRound',-2)
geoshow(RGB, R)
title('Boston Overview')

%%%% combine all txt files for one day into one file .mat 
% core_dir = '/media/elena/SAMSUNG/AROME-WMED-REANALYSIS/';
% listing = dir(fullfile(core_dir,'txtdata/')) ; % list of files within the folder
% dout = fullfile(core_dir,'matfile/'); % where we store the output files
% 
% ht   = 0:3:21 ; % hours of analysis within a day
% alti = sort([20,50,100, 250, 500,750,1000,1250,1500,2000,2500,3000],'descend') ;% corresponding altitudes (within the GRIB file)
% %%% "alti" regroups all the altitudes you need
% 
% loni = dlmread(fullfile(core_dir,'txtdata/lon.txt'), '\t');
% lati = dlmread(fullfile(core_dir,'txtdata/lat.txt'), '\t'); % decimal degrees 
% 
% %%% what is the grid location the closest to the Radar position?
% dlo = min(min(abs(minus(loni,rlo))));
% dla = min(min(abs(minus(lati,rla))));
% pos = find(abs(minus(loni,rlo)) == dlo & abs(minus(lati,rla)) == dla);
% latv = lati(pos);
% lonv = loni(pos);
% sh = dlmread(fullfile(core_dir,'txtdata/20120905_0000_0000_GH.txt'), '\t'); % surface height
% 
% 
% xc = loni(find(lati(:,1) == ceil(rla+1)) : find(lati(:,1) == floor(rla-1)),find(loni(1,:) == floor(rlo-1)) : find(loni(1,:) == ceil(rlo+1)));
% yc = lati(find(lati(:,1) == ceil(rla+1)) : find(lati(:,1) == floor(rla-1)),find(loni(1,:) == floor(rlo-1)) : find(loni(1,:) == ceil(rlo+1)));
% hc = sh(find(lati(:,1) == ceil(rla+1)) : find(lati(:,1) == floor(rla-1)),find(loni(1,:) == floor(rlo-1)) : find(loni(1,:) == ceil(rlo+1)));
% 
% figure(1)
% pcolor(xc,yc,hc); shading interp; hold on
% contour(xc,yc,hc,5:500:2000,'color','k'); % ,970:2:1040,'showtext','off','fill','off','linewidth',1); 
% hold on
% text(rlo,rla,'X','color','r'); hold on
% caxis([0 200]); hold on
% ylabel('latitude [^oN]');
% xlabel('longitude [^oE]'); 
% box on; grid on ;
% 
