% extract 1D 3h analysis meteorological data at Pianattoli Radar location
% arome-wmed data

clear all
close all
startup

data_description = {['aromewmed analysis every 3h (forecast step = 0h)'];...
    ['at the model grid location (latv,lonv) closest to the Radar (rla,rlo)'];...
    ['IWV = Integrated Water vapor (kg m**-2) '];...
%     ['SWD = Cumulative downward solar flux at surface (J m-2) '];...
%     ['LWD = Cumulative downward IR at surface (J m-2)'];...
    ['BLH = Boundary layer height (m)'];...
%     ['GH  = Geometrical height of the land surface above the sea level (m)'];...
    ['CAPE = Convective Available Potential Energy (m**2 s**-2) '];...
    ['script:   read_aromewmed_surface.m '];...
    ['output_data_structure:  time of analysis (within a day) x day of month'];...
    ['upper left corner = 00 GMT (of the day 1) / day 1'];...
    ['lower right corner = 21 GMT (of the day 1) / day 30/31']}; 

%%%% collocalise the Radar and model data
rla = 41.4722 ; % decimal degrees [N]
rlo = 9.0656 ; % decimal degrees [E]

%%%% combine all txt files for one day into one file .mat 
core_dir = '/media/elena/SAMSUNG/AROME-WMED-REANALYSIS/';
listing = dir(fullfile(core_dir,'txtdata/')) ; % list of files within the folder
dout = fullfile(core_dir,'matfile/'); % where we store the output files

ht   = 0:3:21 ; % hours of analysis within a day
% alti = sort([20,50,100, 250, 500,750,1000,1250,1500,2000,2500,3000],'descend') ;% corresponding altitudes (within the GRIB file)
%%% "alti" regroups all the altitudes you need

loni = dlmread(fullfile(core_dir,'txtdata/lon.txt'), '\t');
lati = dlmread(fullfile(core_dir,'txtdata/lat.txt'), '\t'); % decimal degrees 

%%% what is the grid location the closest to the Radar position?
dlo = min(min(abs(minus(loni,rlo))));
dla = min(min(abs(minus(lati,rla))));
pos = find(abs(minus(loni,rlo)) == dlo & abs(minus(lati,rla)) == dla);
latv = lati(pos); 
lonv = loni(pos);
fcs = 0; % forecast step 0h for all surface variables 

for i = 3 : length(listing)-4
    if length(listing(i).name) > 7
            T(i,1)= str2num(listing(i).name(5:6)); % month
            T(i,2) = str2num(listing(i).name(7:8)); % day
            if listing(i).name(20:22) == 'IWV'
                T(i,3) = 1 ;
            elseif listing(i).name(20:22) == 'BLH'
                T(i,3) = 2 ;   
%             elseif listing(i).name(20:23) == 'CAPE'
%                 T(i,3) = 4 ;
%             elseif listing(i).name(20:21) == 'SWD'
%                 T(i,3) = 5 ;
%             elseif listing(i).name(20:22) == 'LWD' 
%                 T(i,3) = 6 ;
            end
    end
end

data = dlmread(fullfile(core_dir,'txtdata/20120912_0900_0000_GH.txt'), '\t');
GH = data(pos); % geographic height of the surface above the sea level (at given grid point, closest to Radar position)

for mon = 9 : 11
    clear IWV BLH  mmon
    IWV = nan([length(ht) eomday(2012,mon)]);
    BLH = IWV; 
    
    if mon < 10
        mmon = [num2str(0),num2str(mon)];
    else
        mmon = num2str(mon);
    end
    
    for param = 1:2
        clear flpath        
        for day = 1 : eomday(2012,mon)
                %%% get all file names for given day 
                clear lst                
                lst = find(T(:,1) == mon & T(:,2) == day & T(:,3) == param);
               
                if ~isempty(lst)
                        for j = 1:length(lst)
                                clear l m data a                                
                                if str2num(listing(lst(j)).name(15:16)) == fcs  ; % here we impose the step of the forecast (+ XX h)
                                        listing(lst(j)).name                           
                                        a(1) = str2num(listing(lst(j)).name(10:11))  ; % time of analysis
                                        a(2) = str2num(listing(lst(j)).name(15:16))  ;  % time of the forecast                                                                               
                                        m = find(ht == sum(a(1:2)))  ; % hour of the day of the forecast in columns                                 
                                        data = dlmread(fullfile(core_dir,'txtdata/',listing(lst(j)).name), '\t');

                                        if param == 1
                                                IWV(m,day) = data(pos);
                                        elseif param == 2
                                                BLH(m,day) = data(pos);
                                        end
                                end
                        end
                end % data exists for this day
        end % day
        
        if param == 1   
%              IWV
             flpath = fullfile(dout, ['aromewmed_analys_step3h_2012' , mmon, '_IWV_', num2str(latv), 'N', '_', num2str(lonv), 'E.mat']);
             save([flpath],'IWV','latv','lonv','rla','rlo','ht','data_description');  
        elseif param == 2   
%              BLH
             flpath = fullfile(dout, ['aromewmed_analys_step3h_2012' , mmon, '_BLH_', num2str(latv), 'N', '_', num2str(lonv), 'E.mat']);
             save([flpath],'BLH','latv','lonv','rla','rlo','ht','data_description');   
        end        
    end   % param
end    % mon




