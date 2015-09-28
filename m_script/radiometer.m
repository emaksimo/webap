%%% read files
%%% passive MW radiometer data at Corte (fall 2012) SOP1, 9.16W 42.3 N
%%% HYMEX data base, author Kalthoff Nordert
%%% radiometer model RPG-HATPRO
%%% vertically within 10 km (43 levels results in about 230m vertical resolution)

clear all 
close all

% startup ; 
main = (['/./media/Transcend/Hymex/MWProfiler/data/']);

rep=dir(main);

for ii = 3 : length(rep)  
    
   NC = ncinfo([main rep(ii).name ])  
   time = ncread([main rep(ii).name ],'time',1,inf); % hours since 9 Sept 2012 00:00 UTC
   height = ncread([main rep(ii).name ],'height',1,inf); % 43 altitudes
   freq = ncread([main rep(ii).name ],'freq',1,inf); % within 22 - 58 GHz Frequencies of MW Brightness Temperatures, size (14)
   qprof = ncread([main rep(ii).name ],'qprof',[1 1],[inf inf]);  % absolute humidity content [kg /m3], within 8-12 below 1000m
   tprof = ncread([main rep(ii).name ],'tprof',[1 1],[inf inf]); % [deg K]
   
   
   temperature_profile = ncread([main rep(ii).name ],'temperature_profile');  % [K] temperature profile with boundary-layer scan, size 43 x 92
   timetemperature_profile = ncread([main rep(ii).name ],'timetemperature_profile');  % [K] 92 x 1
   
   
   brightness_temperature = ncread([main rep(ii).name ],'brightness_temperature',[1 1],[inf inf]);  % [K] 
   atmosphere_water_vapor_content = ncread([main rep(ii).name ],'atmosphere_water_vapor_content',1,inf); % [kg m2]
   atmosphere_liquid_water_content = ncread([main rep(ii).name ],'atmosphere_liquid_water_content',1,inf);  % [g m2]
   azimuth = ncread([main rep(ii).name ],'azimuth',1,inf); % 0 0 0 0 0 .... 5:5:355 ....  0 0 0 0 0
   elevation = ncread([main rep(ii).name ],'elevation',1,inf); % 90 90 .... 19.80 19.80

   flagiwvlwp = ncread([main rep(ii).name ],'flagiwvlwp',1,inf);
   flagtprofqprof = ncread([main rep(ii).name ],'flagtprofqprof'); 
   
   freq(find(freq == -99)) = NaN;
   qprof(find(qprof <= 0)) = NaN;
   tprof(find(tprof == -99)) = NaN;
   
%    figure(1); plot(tprof(1000,:),height)
%    figure(2); plot(qprof(1000,:),height)
%    

   save(['/./media/Transcend/Hymex/MWProfiler/mdata/' rep(ii).name(1:length(rep(ii).name)-2) 'mat']);

end



% elevation = ncread('c:\Tmp\20120911_mwr.nc','elevation')
% azimuth = ncread('c:\Tmp\20120911_mwr.nc','azimuth')