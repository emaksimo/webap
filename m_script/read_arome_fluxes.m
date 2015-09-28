
clear all 
close all

mo = 9;
day = 5;
year = 2012;

if mo < 10 
      mmon = [num2str(0), num2str(mo)];
else
      mmon = num2str(mo);
end  
    
if day < 10 
      dday = [num2str(0), num2str(day)];
else
      dday = num2str(day);
end

%%% AROME-WMED coordinates closest to Pianotoli radar
ala = 41.48;  % alai = 242; % find(lati(:,1) == ala)
alo = 9.08;   % aloi = 704; % find(loni(1,:) == alo)
slcm = 54 ; % altitude of model land surface above the sea level [meters]

%%% Levant (arome coordinates)
% ala = 43.03 ; % decimal degrees [N]
% alo = 6.45 ; % decimal degrees [E]
% slcm = 12; 

%%% Candillargues (arome coordinates)
% ala = 43.6 ; % decimal degrees [N]
% alo = 4.08 ; % decimal degrees [E]
% slcm = 1 ; 

fpath = ['/media/elena/Transcend/Hymex/AROME_WMED/netcdf/2012_' mmon '_' dday  ];
cpt = 1;

for hst = 1:24 % forecast time
    clear fname Z
    fname = ['AROMEWMED_2012' mmon dday '00_P+0' num2str(hst) '.nc'] ;  % 090500_P+01

    % NC = ncinfo(fullfile(fpath,fname)) 

    % for i = 1:20
    %     Ivariable = i
    %     NC.Variables(i).Attributes.Value
    %     NC.Variables(i).Attributes.Name 
    % end

    %%% we need:
    % NC.Variables(1) = g0_lon_1 = longitude
    % NC.Variables(2) = g0_lat_0 = latitude
    % NC.Variables(3) = TH_GDS0_SFC = 1-hour accumulated downward IR flux at surface  [J m**-2]
    % NC.Variables(15) = RR_GDS0_SFC = 1-hour accumulated-rainfall
    % NC.Variables(16) = SO_GDS0_SFC = 1-hour accumulated downward solar flux at surface [Jm**-2]  

    lo = ncread(fullfile(fpath,fname),'g0_lon_1',1,inf); % degrees_east
    la = ncread(fullfile(fpath,fname),'g0_lat_0',1,inf);  

    % (1) extract the meteo data at three Radar positions

    %%% what is the grid location closest to Radar position?
    dlo = min(min(abs(minus(lo,alo))));
    dla = min(min(abs(minus(la,ala))));
    lonv = find(abs(minus(lo,alo)) == dlo);
    latv = find(abs(minus(la,ala)) == dla);

    % (2) regroup into the vector = function of time (for Anton)
    Z = ncread(fullfile(fpath,fname),'TH_GDS0_SFC',[1 1],[inf inf]);  % 948 lons x 628 lats
    LWD(cpt,1) = Z(lonv,latv); clear Z;
    Z = ncread(fullfile(fpath,fname),'SO_GDS0_SFC',[1 1],[inf inf]);
    SWD(cpt,1) = Z(lonv,latv); clear Z;

    inDatesNum(cpt,:) = datenum([year,mo,day,hst,0,0]); % time starting from 1Sept 2012 00 GMT
    cpt = cpt + 1;
end % hour of the day


data_description = {['aromewmed analysis every 1h'];...
    ['1-hour accumulated downward IR flux at surface  [J m**-2]'];...
    ['1-hour accumulated downward solar flux at surface [Jm**-2]'];...
    ['at the model grid location (latv,lonv) closest to the Radar (rla,rlo)'];...  
    ['"ala" and "alo" are the radar position coordinates'];...
    ['the values at 1 GMT correspond to 00-1 GMT period'];...  
    ['script:   read_arome_fluxes.mat']}; 

% flpath = fullfile(core_dir, ['aromewmed_analys_step3h_2012SeptOctNov_uu_', num2str(la(latv)), 'N', '_', num2str(lo(lonv)), 'E_vector.mat']); 
% % save([flpath],'','inDatesNum','inZ','latv','lonv','ala','alo','data_description');






