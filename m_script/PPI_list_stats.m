%%% if at least 200 scans are available at given range   
%%% remove lower 5% and upper 97.5% percentiles of the CNR distribution at
%%% each scanning distance individually;
%%% SK(time,range) = skewness, after removing 5% of data on eigther side;
%%% RANG(time,range) = interquartile range spread (25% - 75%);

ccc = 1 ; % counter for the good PPI selection

%%% ij loop starts from "3" because the first line of "rep" = ".", second = '..' and
%%% third is the "real data sub-folder"

for ij = 3 : length(rep)  % folder counter (fox ex, for one year)
     clear list list_RHI chemin0 X Y
     chemin0=([core_dir rep(ij).name '/']); % sub-folder name (fox ex, regrouping the files in one month)

     %%% Determination of PPI file list 
     list = dir([chemin0,Ftype_PPI]);
     list_RHI = dir([chemin0,Ftype_RHI]);
     X = struct2cell(list_RHI);
     Y = cellstr(X(1,:)');                
     
     if size(list,1) > 0  % if there is some PPI data within the folder          
        for L = 1 : length(list)  % PPI file within given folder
           clear fichier ccnr root ct fglow fgup A B LR
           if ~list(L).isdir      
                fichier = cellstr(list(L).name) ;  % PPI file name
                clear list1 it st fichier_rhi fg ccnr                         
                %%% find the most appropriate RHI file (closest in time)
                list1 = dir([chemin0,list(L).name(1:minutes(1)-2),'*RHI.rtd']); % list of all RHI within the same hour
                A = struct2cell(list1);
                B = cellstr(A(1,:)');                
                
                 if length(list1) == 0 % no RHI file corresponding to given CNR file, than consider anothe PPI file
                     continue % L loop 
                 end

                 for it = 1 : length(list1) % the time (minute of the hour) when RHI observation finished
                        st(it) = str2num(list1(it).name([minutes])) ;
                 end
                 
                 ct(1:40) = str2num(list(L).name([minutes])); % corresponding reference time
                 fglow  = minus(ct, [1 : 40]);
                 fgup = plus(ct, [1 : 40]);
                 
                 for fg = 1 : 40 % several RHI files exist within given hour (we take the one that is the closest in time)
                 %%% fg is the number of minutes between the CNR record and RHI record
                    clear af 
                    af = find(st <= fgup(fg) & st >= fglow(fg)); % RHI file number within "B" list             
                    if length(af) >= 1 % as soon as corresponding RHI file is found, stop the search loop
                        LR = find(strcmp(Y,B(af(1),:)) == 1);
                    
                         %%% upload PPI CNR data file    
                         [ccnr,xdate,r_0,az] = read_PPI(chemin0,fichier,loopme);
  
                         if exist('ccnr') == 1 & ~isempty(find(~isnan(ccnr)))% if PPI file is not empty 
                            [B,A] = cnr_stats(ccnr,r_0);   % evaluate CNR statistics at each scanning distance R                                                               
                            SK(ccc,:) = B;
                            RANG(ccc,:) = A;       
                            XD(ccc)=xdate; % date&time corresponding to the end of PPI (which takes 6min), datevec(datestr(XD(ccc)))  
                            FolFil(ccc,1:3) = [ij, L, LR];  % folder and the corresponding PPI and RHI file numbers within this folder
                            ccc = ccc + 1; 
                            clear A B
                             [ij, L]   
                         end                                            

                         break % as soon as corresponding wind file is found, stop the search "fg loop" 
                     end  % length(af)
                 end  % fg                     
           end  % ~list(L).isdir  
        end  % L loop          
     else  % no data within dossier
         disp([ 'no good PPI within dir ' num2str(ij)]); 
         continue % ij
     end
end % ij dossier

% result
%%% see script result.m  that treats the resulting statistics, calculates alpha(n) and F(R)*K*beta(n) for each n(th) best PPI

data_description = {['see scripts: wls_PPI_loop_1.m and my_data.m'];...
    ['if at least 200 scans are available at given range (off the instrument)'];...
    ['remove lower 5% and upper 97.5% percentiles of the CNR distribution at each scanning distance individually;'];...
    ['time: aug 2013 - aug 2014'];...
    ['r_0 = range [meters] = radial distance'];...
    ['az = azimuthal angle = clockwise relative to the North'];...
    ['SK(time,range) = skewness of CNR values at given range, after removing 5% of data on eigther side;'];...
    ['RANG(time,range) = interquartile range spread (25% - 75%) of CNR values'];...
    ['datevec(datestr(XD(time))) contains the date/time corresponding to the end of PPI (which takes 6min)'];...
    ['FolFil(ccc,1:3) = [ij, L, LR] =  folder and the corresponding PPI and RHI file numbers within this folder'];...
    ['where the PPI file number corresponds to the count number within the overall PPI file list of the folder ']};

save([output 'CNR_stats_selectedPPI.mat'],'SK','RANG','XD','data_description','r_0','az','FolFil');
break


% save best_PPI_list.mat Y

 
%%% evaluate ln(F(R1)/F(R2)) for each pair of R1 and R2
%%% delta R = const = 50m 
%%% use linear regression for each pair of R1 and R2 (with all possible
%%% combinations of CNR(R1) and CNR(R2)
%%% apply ln(F(R1)/F(R2)) to extract alpha (a) using all CNR data within one PPI all at once,
%%% and (b) using all CNR data at R1 and R2, thus resulting in alpha(R) 
% instrum_function1
%     wls_sub_PPI;
%     best_profile; %detection of potentially homogenuous zone
%     multi_angle_method_Pabs_vs_CosTeta
%     % instrum_function2
%     test  % recalculate CNR using alpha(d) and b(d)

%     multi_angle_method
%     backscatter     
%     instrum_function1
%     backscatter1
%     alpha_new
%     alpha_recover
