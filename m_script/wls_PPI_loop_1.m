
clear all ;
close all;

sdi = 59  ; % which scanning distances we take (only within the first 3000km)

loopme = 0; % if ==0 than we don't plot any maps
track = 0 ; % to plot CNR for the interesting cases
rep=dir(['/./media/Transcend/Leosphere/WLS100/']);
nk = 1;
ccc = 1 ; % counter for the good PPI selection
ka = 0; % counter of PPI files that could not be considered eigther because (a) it has no corresponding DBS record  (b) no corresponding RHI record, (c) night time observations
rt = 0; % counter for the figure, see instrum_function1.m

for ij = 266 : length(rep) %% directory counter
% for ij = (length(rep) - 2) : length(rep)       
     clear list chemin0 chemin1 CF CT SK RAN RANG LIK KT JB KR ME
     chemin0=(['/./media/Transcend/Leosphere/WLS100/' rep(ij).name '/']);
     chemin1=(['/./media/Transcend/Leosphere/WLS100/' rep(ij).name '/']);        

     %%% Determination de la liste des dossiers et creation de la liste
     list = dir([chemin1,'/*_PPI.rtd']);  % all PPI files within one directory
     if size(list,1) > 0  % if there is some PPI data within the directory            
        for L = 1 : length(list)  % PPI file within given dossier
           clear list1 fichier cnr lli fichier_wind st it mmi mma fg ddi fichier_rhi 
           if ~list(L).isdir      
                 CF(L,1:sdi)  = NaN; % std at each distance R and each PPI file
                 CT(L,1:sdi)  = NaN; % std at each distance R and each PPI file after removing 5% of data on eigther side 
                 SK(L,1:sdi)  = NaN; % skewness, after removing 5% of data on eigther side 
                 KR(L,1:sdi)  = NaN; % kurtosis, after removing 5% of data on eigther side 
                 RAN(L,1:sdi) = NaN; % min-max range after removing 5% of data on eigther side 
                 RANG(L,1:sdi)= NaN; % range containing 25% - 75% of data 
                 ME(L,1:sdi)  = NaN; % average CNR(R)
                 LIK(L,1:sdi) = NaN; % position of the peak of the distribution after removing 5% of data on eigther side 
                 KT(L,1:sdi)  = NaN; % normal distribution test after removing 5% of data on eigther side 
                 JB(L,1:sdi)  = NaN; % normal distribution test after removing 5% of data on eigther side                  
                 
                 fichier = cellstr(list(L).name) ;  % PPI file name
%                  lli = length(list(L).name)-13 ;
%                  list1=dir([chemin1, list(L).name(1:lli),'*_DBS.rtd']) ;  % find the most appropriate DBS file (closest in time)               
                 
%                  if length(list1) == 0 % if NO DBS file corresponding to given CNR file, than consider anothe CNR file
%                      ka = ka + 1 ;
%                      continue % L loop
%                  end
%                      
%                  for it = 1 : length(list1) % the time (minute of the hour) when the observation started
%                         st(it) = str2num(list1(it).name(length(list1(it).name)-12 : length(list1(it).name)-11)) ;
%                  end
                 
%                  for fg = 1 : 40 % several DBS files exist within given hour (we take the one that is the closest in time)
%                  %%% fg is the number of minutes between the CNR record and DBS record
%                     af = find(st <= str2num(list(L).name(length(list(L).name)-12:length(list(L).name)-11)) + fg ... 
%                         & st >= str2num(list(L).name(length(list(L).name)-12:length(list(L).name)-11)) - fg ) ;
%                     if length(af) == 1 % as soon as corresponding wind file is found, stop the search loop
%                         fichier_wind = cellstr(list1(af).name) ;
%                         break % fg loop
%                     end
%                  end                 
             
%                  wls_sub_DBS_1 ; % we need here: hh(1) nbline direction  zdirection
%                  if nbline > size(direction,1) | size(direction,2) < 59 | size(cc,2) > 99
%                      continue % L loop
%                  end
%                  
%                  ddi = direction(nbline,1:sdi);
%                  mmi = ddi(find(ddi == nanmin(ddi)))  ;
%                  mma = ddi(find(ddi == nanmax(ddi)))  ; 
%                  if mmi <= 90 & mma >=270
%                      da = plus(mmi,minus(360,mma)) ;
%                  else  % mmi >= 90 & mma <=270
%                      da = minus(mma,mmi)
%                      if da > 180
%                          da = minus(360,180) ;
%                      end
%                  end
%     
%                  if da < 60 
                         clear lli list1 it st fichier_rhi fg z1 d1 cnr
                         lli = length(list(L).name)-13 ;
                         list1=dir([chemin1, list(L).name(1:lli),'*_RHI.rtd']); % find the most appropriate RHI file (closest in time)

                         if length(list1) == 0 % no RHI file corresponding to given CNR file, than consider anothe PPI file
%                              ka = ka + 1 ;
%                              UK(ka,1:2) = [ij,L]; 
                             continue % L loop 
                         end

                         for it = 1 : length(list1) % the time (minute of the hour) when the observation started
                                st(it) = str2num(list1(it).name(length(list1(it).name)-12 : length(list1(it).name)-11)) ;
                         end

                         for fg = 1 : 40 % several RHI files exist within given hour (we take the one that is the closest in time)
                         %%% fg is the number of minutes between the CNR record and RHI record
                            clear af 
                            af = find(st <= str2num(list(L).name(length(list(L).name)-12:length(list(L).name)-11)) + fg & st >= str2num(list(L).name(length(list(L).name)-12:length(list(L).name)-11)) - fg ) ;                    
                            if length(af) == 1 % as soon as corresponding RHI file is found, stop the search loop
                                     wls_sub_PPI_1 ; % upload CNR data 
%                                      keyboard
                                     instrum_function  ;   % evaluate CNR statistics at each scanning distance R  
                                      [ij, L]
                                     break % as soon as corresponding wind file is found, stop the search "fg loop"
                            end  % length(af)
                         end  % fg                     
%                  end % wind direction
           end  % ~list(L).isdir  
        end  % L loop   
        
%         bn(ij-2,1) = size(SK,1); % for result.m
        
%         if (ij-2) < 12
%             save(['/media/Transcend/Elena_ULCO/my_matlab_data/CNR_stats_std_range_maxliklihood_ktest_allPPI_0' num2str(ij-2) '.mat'],'SK','CF','CT','RAN','RANG','LIK','KT','JB','KR','ME') ;
%         else
%             save(['/media/Transcend/Elena_ULCO/my_matlab_data/CNR_stats_std_range_maxliklihood_ktest_allPPI_' num2str(ij-2) '.mat'],'SK','CF','CT','RAN','RANG','LIK','KT','JB','KR','ME') ; 
%         end
        
     else  % no data within dossier
         disp([ 'no good PPI within dir ' num2str(ij)]); 
         continue % ij
     end
end % ij dossier

% result
%%% see script result.m  that treats the resulting statistics, calculates
%%% alpha(n) and F(R)*K*beta(n) for each n(th) best PPI



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
