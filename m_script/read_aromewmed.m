%%% see .../Hymex/read_me.txt   : my documentation on grib-to-txt data
%%% conversion, and other matlab scripts
%%% read also : /GRIB/documentation_AROME_WMED.txt

clear all
close all
startup

%%%% collocalise the Radar and model data

%%% Pianatolli
% rla = 41.4722 ; % decimal degrees [N]
% rlo = 9.0656 ; % decimal degrees [E]

%%% Levant
% rla = 43.02 ; % decimal degrees [N]
% rlo = 6.46 ; % decimal degrees [E]

%%% Candillargues
rla = 43.61 ; % decimal degrees [N]
rlo = 4.07 ; % decimal degrees [E]

%%%% combine all txt files for one day into one file .mat 
core_dir = '/media/elena/SAMSUNG/AROME-WMED-REANALYSIS/';
listing = dir(fullfile(core_dir,'txtdata/')) ; % list of files within the folder
dout = fullfile(core_dir,'matfile/'); % where we store the output files

ht   = 0:3:21 ; % hours of analysis within a day
alti = sort([20,50,100, 250, 500,750,1000,1250,1500,2000,2500,3000],'descend') ;% corresponding altitudes (within the GRIB file)
%%% "alti" regroups all the altitudes you need

loni = dlmread(fullfile(core_dir,'txtdata/lon.txt'), '\t');
lati = dlmread(fullfile(core_dir,'txtdata/lat.txt'), '\t'); % decimal degrees 

%%% what is the grid location the closest to the Radar position?
dlo = min(min(abs(minus(loni,rlo))));
dla = min(min(abs(minus(lati,rla))));
pos = find(abs(minus(loni,rlo)) == dlo & abs(minus(lati,rla)) == dla);
latv = lati(pos);
lonv = loni(pos);
sh = dlmread(fullfile(core_dir,'txtdata/20120905_0000_0000_GH.txt'), '\t'); % surface height

%%% plot the model surface height in the vicinity of given radar position
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

alt = sh(pos);  % is the land surface height above the sea level at given Arome grid location

for i = 3 : length(listing)-4
    if length(listing(i).name) > 7
            T(i,1)= str2num(listing(i).name(5:6)); % month
            T(i,2) = str2num(listing(i).name(7:8)); % day
            if listing(i).name(20) == 'U'
                T(i,3) = 1 ;
            elseif listing(i).name(20) == 'V'
                T(i,3) = 2 ;   
            elseif listing(i).name(20) == 'P' % Pressure (Pa)
                T(i,3) = 3 ;
            elseif listing(i).name(20) == 'R' % relative humidity (%)
                T(i,3) = 4 ;
            elseif listing(i).name(20:21) == 'T_' % Air Temperature (K)
                T(i,3) = 5 ;
            elseif listing(i).name(20:22) == 'TKE' % Turbulent Kinetic Energy (m2/s2)
                T(i,3) = 6 ;
            elseif listing(i).name(20:23) == 'SCWC'
                T(i,3) = 7 ;
            end
    end
end

for mon = 9 : 11
    clear U V P RH TA TKE
    V = nan([length(alti) length(ht) eomday(2012,mon)]);
    U = V; P = V; RH = V; TA = V; TKE = V;
    
    for param = 1:6 
        clear flpath fcs
        
        if param == 6
            fcs = 3 ; % forecast step 0h for all variables except for TKE
        else
            fcs = 0 ;
        end
    
        for day = 1 : eomday(2012,mon)
                %%% get all file names for given day 
                clear lst lst1 lst2            
                lst = find(T(:,1) == mon & T(:,2) == day & T(:,3) == param);
               
                if day == 1 & mon >= 10 param == 6 % TKE
                    lst1 = find(T(:,1) == mon-1 & T(:,2) == eomday(2012,mon-1) & T(:,3) == param);
                    lst2 = lst;
                    lst = [lst1;lst2];
                end
                
                if ~isempty(lst)
                        for j = 1:length(lst)
                                clear l m data a                                  
                                if str2num(listing(lst(j)).name(15:16)) == fcs  ; % here we impose the step of the forecast (+ XX h)
                                        listing(lst(j)).name     

                                        a(1) = str2num(listing(lst(j)).name(10:11))  ; % time of analysis
                                        a(2) = str2num(listing(lst(j)).name(15:16))  ;  % time of the forecast
                                        
                                        if param == 4 ; % RH
                                            a(3) = str2num(listing(lst(j)).name(23:26))  ; % altitude
                                        elseif param == 6 ; % TKE
                                            a(3) = str2num(listing(lst(j)).name(24:27))  ; 
                                        else
                                            a(3) = str2num(listing(lst(j)).name(22:25))  ;
                                        end
                                        
                                        m = find(ht == sum(a(1:2)))  ; % hour of the day of the forecast in columns
                                        l = find(alti == a(3))  ;      % altitude in rows                                        
                                        data = dlmread(fullfile(core_dir,'txtdata/',listing(lst(j)).name), '\t');

                                        %%% get the wind value only at the location the closest to the Radar position
                                       if param == 1
                                            U(l,m,day) = data(pos);
                                       elseif param == 2
                                            V(l,m,day) = data(pos);
                                       elseif param == 3
                                            P(l,m,day) = data(pos);
                                       elseif param == 4
                                            RH(l,m,day) = data(pos);
                                       elseif param == 5
                                            TA(l,m,day) = data(pos);                                        
                                       elseif param == 6
                                           if sum(a(1:2)) < 24
                                               TKE(l,m,day) = data(pos);  
                                           %%% 00:00 GMT on the next day    
                                           elseif sum(a(1:2)) >= 24 & sum(a(1:2)) < 48 & str2num(listing(lst(j)).name(5:6)) == mon  % day of analysis (within the file name)
                                               m = find(ht == (sum(a(1:2))-24)) ;
                                               TKE(l,m,day+1) = data(pos);   
                                           %%% 00:00 GMT on the first day of month  == 3h forecast at  21h on the last day of previous month
                                           elseif sum(a(1:2)) == 24 & str2num(listing(lst(j)).name(5:6)) == mon-1 &  str2num(listing(lst(j)).name(7:8)) == eomday(2012,mon-1) % day of analysis in the file name
                                               m = find(ht == (sum(a(1:2))-24)) ;
                                               TKE(l,m,day) = data(pos);                                               
                                           end
                                       end                                       
                                end % frcts time <= 2h
                        end % file selection (dd, month, var)
                end  
         end % dd of month        

         if mon < 10
             mmon = [num2str(0),num2str(mon)];
         else
             mmon = num2str(mon);
         end
         
         if param == 6
            data_description = {['aromewmed forecast every 3h (forecast step = 3h)'];...
            ['at the model grid location (latv,lonv) closest to the Radar (rla,rlo)'];...
            ['"alt" is the surface height at given Arome grid location above the sea level'];...
            ['script:   read_aromewmed.mat'];...
            ['output_data_structure:  altitude x time of analysis (within a day) x day of month'];...
            ['upper left corner = 3km altitude / 00 GMT (of the day 1) / day 1'];...
            ['lower right corner = 20m altitude / 21 GMT (of the day 1) / day 1'];...
            ['in depth: day of month (:,:,1) = 1st of month, (:,:,XX) = XX day of month'] }; 
         else
            data_description = {['aromewmed analysis every 3h (forecast step = 0h)'];...
            ['at the model grid location (latv,lonv) closest to the Radar (rla,rlo)'];...
            ['"alt" is the surface height at given Arome grid location above the sea level'];...
            ['script:   read_aromewmed.mat'];...
            ['output_data_structure:  altitude x time of analysis (within a day) x day of month'];...
            ['upper left corner = 3km altitude / 00 GMT (of the day 1) / day 1'];...
            ['lower right corner = 20m altitude / 21 GMT (of the day 1) / day 1'];...           
            ['in depth: day of month (:,:,1) = 1st of month, (:,:,XX) = XX day of month'] }; 
        
        
        
         end
         
         if param == 1            
            flpath = fullfile(dout, ['aromewmed_analys_step3h_2012' , mmon, '_U_', num2str(latv), 'N', '_', num2str(lonv), 'E.mat']);  % 26 Sept is good ! filled in
            save([flpath],'U','latv','lonv','alti','rla','rlo','ht','alt','data_description');
         elseif param == 2
            flpath = fullfile(dout, ['aromewmed_analys_step3h_2012' , mmon, '_V_', num2str(latv), 'N', '_', num2str(lonv), 'E.mat']);  % 26 Sept is good ! filled in
            save([flpath],'V','latv','lonv','alti','rla','rlo','ht','alt','data_description');
         elseif param == 3        % Pressure (Pa)
             flpath = fullfile(dout, ['aromewmed_analys_step3h_2012' , mmon, '_P_', num2str(latv), 'N', '_', num2str(lonv), 'E.mat']);
             save([flpath],'P','latv','lonv','alti','rla','rlo','ht','alt','data_description');
         elseif param == 4    %'RH' % relative humidity (%)
             flpath = fullfile(dout, ['aromewmed_analys_step3h_2012' , mmon, '_RH_', num2str(latv), 'N', '_', num2str(lonv), 'E.mat']);
             save([flpath],'RH','latv','lonv','alti','rla','rlo','ht','alt','data_description');
         elseif param == 5    % Air Temperature (K)
             flpath = fullfile(dout, ['aromewmed_analys_step3h_2012' , mmon, '_T_', num2str(latv), 'N', '_', num2str(lonv), 'E.mat']);
             save([flpath],'TA','latv','lonv','alti','rla','rlo','ht','alt','data_description');            
         elseif param == 6    % TKE (m2/s2)
             flpath = fullfile(dout, ['aromewmed_analys_step3h_2012' , mmon, '_TKE_', num2str(latv), 'N', '_', num2str(lonv), 'E.mat']);
             save([flpath],'TKE','latv','lonv','alti','rla','rlo','ht','alt','data_description');   
         end
%          continue % meteo param
    end % meteo param    
end  % month



%%% calculate the specific humidity at each altitude, each day, every 3h
clear all
close all
year = 2012;
% core_dir = '/media/elena/Transcend/Hymex/AROME_WMED/matfile/';  % see   read_aromewmed.m
core_dir = '/media/elena/SAMSUNG/AROME-WMED-REANALYSIS/matfile/';
%%% see vaisala.com conversions documentation
Rv = 461.5  ;    % [J/kg*K] specific gas constant for water vapor 
Rd = 287.05 ;   % [J/kg*K] specific gas constant
A = 6.116441 ; 
m = 7.591386 ; 
Tn = 240.7263; 

for mon = 9:11;
    clear P TA RH Q flpath es e ro_m ro_wv
    if mon < 10
        mmon = [num2str(0),num2str(mon)];
    else
        mmon = num2str(mon);
    end  
    
    %%% Pianatolli
%     if exist(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_T_41.48N_9.08E.mat'])) == 2
%         load(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_T_41.48N_9.08E.mat'])) ; % in [K]
%         load(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_P_41.48N_9.08E.mat'])) ; % in [Pa]
%         load(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_RH_41.48N_9.08E.mat'])) ; % rel hum in [%]
%         % 'latv','lonv','alti','rla','rlo','ht','data_description');
%     end
        
    %%% Levant
%     if exist(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_T_43.03N_6.45E.mat'])) == 2
%         load(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_T_43.03N_6.45E.mat'])) ; % in [K]
%         load(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_P_43.03N_6.45E.mat'])) ; % in [Pa]
%         load(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_RH_43.03N_6.45E.mat'])) ; % rel hum in [%]
%         % 'latv','lonv','alti','rla','rlo','ht','data_description');
%     end    
    
    %%% Candillargues
    if exist(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_T_43.6N_4.08E.mat'])) == 2
        load(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_T_43.6N_4.08E.mat'])) ; % in [K]
        load(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_P_43.6N_4.08E.mat'])) ; % in [Pa]
        load(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_RH_43.6N_4.08E.mat'])) ; % rel hum in [%]
        % 'latv','lonv','alti','rla','rlo','ht','data_description');
    end 
    
    for al = 1 : size(TA,1) % altitude
        for hh = 1 : size(TA,2) % time of the day
            for dd = 1 : eomday(year,mon)
                %%% saturation water vapor pressure
                es(al,hh,dd) = 6.11*exp(17.27*(TA(al,hh,dd)-273.15)/(TA(al,hh,dd)-273.15 +237.3))  ; % Tetens (1930), in [hPa]
                
                %%% actual water vapor pressure
                e(al,hh,dd)  = es(al,hh,dd)  * RH(al,hh,dd)/100 ;  % [hPa]
                
                %%% density of moist air at given atmospheric pressure (at altitude) and air temperature
                ro_m(al,hh,dd) = (P(al,hh,dd)/(Rd*TA(al,hh,dd))) * (1 - ((0.378*e(al,hh,dd) *100)/P(al,hh,dd))); % [kg/m3]      
                
                %%% density of water vapour
                ro_wv(al,hh,dd) = e(al,hh,dd)*100/(Rv * TA(al,hh,dd)) ; % [kg/m3]                
            end
        end
    end
    
    %%% specific humidity of air for given RH, Ta and P
    Q = (ro_wv./ro_m)*1000 ; % unitless, but typically noted as [g/kg]
    flpath = fullfile(core_dir, ['aromewmed_analys_step3h_2012' , mmon, '_Q_', num2str(latv), 'N', '_', num2str(lonv), 'E.mat']);  % 26 Sept is good ! filled in
    save([flpath],'Q','latv','lonv','alti','rla','rlo','ht','data_description');
end


%%  reshape the data files for Anton correlation study

clear all
close all
year = 2012;
core_dir = '/media/elena/Transcend/Hymex/AROME_WMED/matfile/';  % see   read_aromewmed.m
%core_dir = '/media/elena/SAMSUNG/AROME-WMED-REANALYSIS/matfile/';

cm = 0;

for mon = 9:11;
    clear U V Q TKE
    
    if mon < 10
        mmon = [num2str(0),num2str(mon)];
    else
        mmon = num2str(mon);
    end
       
   %%% Pianatoli 
%     if exist(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_U_41.48N_9.08E.mat'])) == 2
%         load(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_U_41.48N_9.08E.mat'])) ; 
%         load(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_V_41.48N_9.08E.mat'])) ; 
%         load(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_Q_41.48N_9.08E.mat'])) ;
%         load(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_TKE_41.48N_9.08E.mat'])) ; 
%         % 'U, 'V','Q','TKE','latv','lonv','alti','rla','rlo','ht','data_description');
%     end

      %%% Levant
%     if exist(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_U_43.03N_6.45E.mat'])) == 2
%         load(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_U_43.03N_6.45E.mat'])) ; 
%         load(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_V_43.03N_6.45E.mat'])) ; 
%         load(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_Q_43.03N_6.45E.mat'])) ; 
%         load(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_TKE_43.03N_6.45E.mat'])) ; 
%         % 'latv','lonv','alti','rla','rlo','ht','data_description');
%     end 
    
     %%% Candillargues
    if exist(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_U_43.6N_4.08E.mat'])) == 2
        load(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_U_43.6N_4.08E.mat'])) ; 
        load(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_V_43.6N_4.08E.mat'])) ; 
        load(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_Q_43.6N_4.08E.mat'])) ; 
        load(fullfile(core_dir,['aromewmed_analys_step3h_2012', strvcat(mmon), '_TKE_43.6N_4.08E.mat'])) ; 
        % 'latv','lonv','alti','rla','rlo','ht','data_description');
    end 
    
    for al = 1 : size(U,1)
        cpt = 1;
        for day = 1 : eomday(year,mon);   
            inU(cm+cpt:cm+cpt+7,al) = U(size(U,1)-al+1,:,day);
            inV(cm+cpt:cm+cpt+7,al) = V(size(U,1)-al+1,:,day);
            inQ(cm+cpt:cm+cpt+7,al) = Q(size(U,1)-al+1,:,day);
            inTKE(cm+cpt:cm+cpt+7,al) = TKE(size(U,1)-al+1,:,day);
            
            TA(cm+cpt:cm+cpt+7,1) = year;
            TA(cm+cpt:cm+cpt+7,2) = mon;
            TA(cm+cpt:cm+cpt+7,3) = day;           
            TA(cm+cpt:cm+cpt+7,4) = ht;  % time starting from 1Sept 2012 00 GMT

            inZ(cm+cpt:cm+cpt+7,al) = alti(size(U,1)-al+1);
         
            cpt = cpt + 8;
        end
    end
    cm = cm + eomday(year,mon)*8; 
end

for l = 1:size(TA,1)
    inDatesNum(l,:) = datenum([TA(l,1),TA(l,2),TA(l,3),TA(l,4),0,0]);
end

data_description = {['aromewmed analysis every 3h'];...
    ['U-wind and V-wind components in [m/s]'];...
    ['Q is the specific humidity [g/kg]'];...
    ['TKE is the Turbulent Kinetic Energy [m2/s2] is a 3h forecast variable'];...
    ['at the model grid location (latv,lonv) closest to the Radar (rla,rlo)'];...  
    ['"rla" and "rlo" are the radar position coordinates'];...
    ['script:   read_aromewmed.mat']}; 

flpath = fullfile(core_dir, ['aromewmed_analys_step3h_2012SeptOctNov_U_V_Q_TKE_', num2str(latv), 'N', '_', num2str(lonv), 'E_vector.mat']); 
save([flpath],'inU','inV','inQ','inTKE','inDatesNum','inZ','latv','lonv','rla','rlo','data_description');



