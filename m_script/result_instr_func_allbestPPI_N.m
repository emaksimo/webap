%%% evaluate instrumental function for all the best PPI and weekly
%%% within the scanning distances where beta(n)/beta(ref) ratio is const
%%% we can evaluate F(R)
%%% with the use of a linear regression
%%% previous script : result.m   and also   result_instr_func_allbestPPI.m

clear all 
close all

figure(2)
colormap(jet) ;
JET= get(gcf,'colormap');

rep=dir(['/./media/elena/Transcend/Leosphere/WLS100/']);
loopme = 0;
epsilon = 10/log(10) ;

%%% upload the list of ALL best 235 PPI  (script : result.m), Aug 2013 - Aug 2014
load('/media/elena/Transcend/Elena_ULCO/my_matlab_data/alpha_homogeneous_cases_3.mat'); % list of PPI and corresponding scanning distances where alpha was determined

sdi = 59; % consider only the first 3000m (because different files can go up to 5-6 km)
stats_all_PPI ; %% read and regroup the overall statistics for all PPI files we dispose

R = 100:50:3000; 
load('/media/elena/Transcend/Elena_ULCO/my_matlab_data/alpha_homogeneous_cases_3_filenames_filetime.mat'); %,'fich','dat','date'

%%% after the preliminary treatment of CNR, PPI were selected for the first
%%% 10days (July 2013), and F(R) average was calculated for this (first) group of good
%%% here we remove this ln(F(R)) from CNR to verify if the residual = ln(Kbeta) - 2alphaR is linear
load(['/media/elena/Transcend/Elena_ULCO/my_matlab_data/FRref.mat']); % see thi script below , variables 'wscript','FREF');


clear date1 dat1 SM1 FR1 h5 h12 chemin1 
date1 = date ;
dat1 = dat;
SM1 = SM ; % = [ij L reg_err(2) reg reg_err(1) offs offs_err ah reg_err1(2) reg1 reg_err1(1)];  
FR1 = FR ; % = exp(plus(MN,2*reg*r_0(1,1:sdi))) = best estimate of K*beta(R)*F(R) for each R, each best PPI
nt = 1;
loopme = 0;   
wscript = {'see   result_instr_func_allbestPPI_N.m'};
chemin2=(['/./media/elena/Transcend/Elena_ULCO/illustrations/FI_mar2015/']);      
clear reg offs reg_err offs_err wrong % individual for each group and each PPI              
ccc = 1;

for gru = 1 : 40 % group counter (every 10 days)
    
        if isempty(find(date <= nanmin(date) + 10)) % if no data
            continue % gru loop
        end
                
        clear idx ll FFR RP X Y nna nni lli ssi z ij uz se h3 h12 h5 file_list imageok goodPPI
              
        ref(gru,1:3) = dat1(min(find(date1 == nanmin(date1))),:) ; % store the reference date for the group
        idx = find(date1 <= nanmin(date1) + 10) ; % which lines 
        ref(gru,4) = length(idx) ; % amount of pressumingly good PPI within the group
        
        ll = SM(idx,:);
        FFR = FR(idx,:);
        file_list = fich(idx,:);          
        goodPPI(:,1:3) = dat1(idx,:);  
        goodPPI(:,4:5) = NaN; % hh and min
        
        date1(idx) = NaN ; 
        SM1(idx,:) = NaN ; % hide all the data that was already used
        FR1(idx,:)= NaN ; % hide all the data that was already used

%         if gru < 9
%             continue % gru loop
%         end
        
        clf (figure(15)); clf (figure(20)); 
        h20 = figure(20) ;          
        h15 = figure(15) ;
        
        if gru == 1
            wrong = [5 6 7 8 9 10 12 13 18 21:41 43:45  48:50 52:60 65 70:73 105:106 120:122 125 127 128 132 135];
        else
            wrong = [0];
        end
        
        %%% alpha and offset canculated from CNR that contains F(R), after 2km distance
        reg(1 : 390, gru) = NaN;
        offs(1 : 390, gru) = NaN;
        reg_err(1 : 390, gru,1:2) = NaN;
        offs_err(1 : 390, gru,1:2) = NaN;
        FT(1:59,1 : 390, gru) = NaN;
        
        %%% after removing F(R) for gru =1, the overall alpha(PPI) and offset(PPI) are calculated
        reg_ov(1 : 390,gru) = NaN; % angle of the linear fit
        offs_ov(1 : 390,gru) = NaN; % the free coefficient "b" of the linear fit = ln(KF(R)beta(R)
        reg_err_ov(1 : 390,gru,1:2) = NaN;
        offs_err_ov(1 : 390,gru,1:2) = NaN;        
        
        for it = 1 : size(ll,1) % PPI counter within the group
                           
                if ~isempty(find(wrong == it))
                    file_list(it,1) = {''};
                    goodPPI(it,:) = NaN;
                    continue
                end
                clear GR GGR GZ rat h2 h16 RC list ij fichier L ij thresh chemin1 ima
                %clf (figure(12)); 
%                 clf (figure(9)) ; clf (figure(2)) ;  
%                 GR = nanmoving_average(FFR(i,:),2)./RP; % ratio : beta(n,i)/beta(ref)

%                 h2 = figure(2);
%                 plot(R,FFR(it,:),'color','k'); hold on; %[RC(1),RC(2),RC(3)]
%                 xlim([0 3000]); 
%                 grid on ; box on ;
%                 title('F(R)*K*beta(PPIn,R)');                
%                 set(h2,'Position',[650 10 560 420]); 
                
                ij = ll(it,1) ;
                chemin1=(['/./media/elena/Transcend/Leosphere/WLS100/' rep(ij).name '/']);
%                 list=dir([chemin1,'/*_PPI.rtd']);
%                 L = ll(i,2) ; % file number within the directory
%                 fichier = cellstr(list(L).name) ; % PPI file  
%                 dat = [str2num(list(L).name(11:14)),  str2num(list(L).name(16:17)) , str2num(list(L).name(19:20)) ] ;

                GR = nanmoving_average(FFR(it,:),2);    
                
%                 get(figure(2));
%                 plot(R,GR,'color','r'); hold on;
                
                GZ(2:58) = minus(GR(3:59),GR(1:57));
                GZ([1 59]) = NaN;
                 
%                 h2 = figure(2) ;               
%                 plot(R,GZ,'linewidth',2,'color','k');  hold on ; grid on ;
%                 get(h2); ylim([-0.0001 0.0001]);
%                 set(h2,'Position',[650 600 560 420]); 
%                 get(h2); plot(R,GZ,'linewidth',2,'color','r');  hold on ; grid on ;
                  
                thresh = nanmean(GR(39:59))/100; % acceptable 1% deviation relative to the absolute value of K*beta*F(R) 
                
                GZ(find(abs(GZ) > thresh)) = NaN;        
                GR(find(isnan(GZ))) = NaN; 
                
%                 GGR = GR./nanmean(GR(39:59)) ; % if const ratio beta(n,i)/beta(n,2 - 2.5km) then well mixed air
                ima = max(find(~isnan(GR))); % exclude from analysis the following distances 
                
%                 clf (figure(15)); 
%                 h15 = figure(15);
%                 plot(R,FFR(i,:)./nanmean(GR(39:59)),'color','k') ;   hold on     
%                 plot(R,GGR,'color','r') ;   hold on                 
%                 set(h15,'Position',[1300 10 560 420]); 
%                 grid on ; box on;
%                 ylabel('normalized F(R) where K*beta*F(R) is const over 2-3km range');
%                 xlabel(' scanning distance R [meters]','color','k');
%                 ylim([0 1.1]);
%                 xlim([0 3000]); 
%                 title([strvcat(fichier)]);
                               
                
                fichier = file_list(it,:);                
                wls_sub_PPI_1 ;               
                               
                %%%%%%%%%%%%%
                goodPPI(it,4:5) = [hh(1),mn(1)] ; % hh and min
                
                if goodPPI(it,1) == 2013 & goodPPI(it,2) == 10 & goodPPI(it,3) == 26 & goodPPI(it,4) == 4 & goodPPI(it,5) == 36 
                    loopme = 1; 
                    wls_sub_PPI_1 ;  
                end
                
                
                 %%% clean CNR measurements
                 clear ccnr MN 
                 ccnr = cnr(:, 1 : sdi); % PPI
                 ccnr(find(ccnr >= 0)) = NaN; % do not consider the areas with zero CNR 
                 ccnr(find(ccnr <= -27)) = NaN; % do not consider the areas with too low signal
                 
                 
%                 clf (figure(20)); clear cl
%                 cf =  figure(20) ;
%                 for azi = 1 : 360
%                     if length(find(~isnan(ccnr(azi,1:35)))) > 10
%                         plot(R,nanmoving_average(ccnr(azi,:),2),'color','g'); hold on
%                     end
%                 end
%                box on;  grid on;       
%                set(figure(20),'Position',[1300 450 560 420]); 
                
               ccnr(:,ima:size(ccnr,2)) = NaN; 
                                 
                for d = 1 : sdi; 
                     clear PRCV
                     PRCV = prctile(ccnr(:,d) ,[10 90]) ;  % lower 2.5% and upper 99% percentiles of the distribution  of CNR, not corrected by anything   
                     ccnr(find(ccnr(:,d) < PRCV(1) | ccnr(:,d) > PRCV(2)),d) = NaN ;
%                      dad(:,d) = plus(ccnr(:,d)./epsilon ,  2*log(r_0(1,d)));
%                      MN(1,d) = nanmean(dad(:,d)); % best estimate of CNR(R)
                 end      
                 
%                 clf (figure(19))
%                 cf =  figure(19) ;
%                 set(cf,'Position',[100 450 560 420]); 
%                 surfc(d1,z1,ccnr, 'LineStyle','none','EdgeLighting','phong'); hold on;  
%                 shading(gca,'flat')
%                 view(0,90);
%                 caxis([seuil_cnr max_cnr]);
%                 axis equal;
%                 xlabel(['     Range West / East ', '(m)']);
%                 ylabel(['     Range South / North ', '(m)']);
%                 xlim([-max_range1 max_range1]);%complet
%                 ylim([-max_range1 max_range1]);%complet
%                 box on;  grid on;
%                 colorbar;
%                 title(['PPI without 10% tails,']);
%         
%                 get(figure(20)) ;                        
                for azi = 1 : 360
                    if length(find(~isnan(ccnr(azi,1:35)))) > 30
%                         plot(R,nanmoving_average(ccnr(azi,:),2),'color','k'); hold on
                    else
                        ccnr(azi,:) = NaN;
                    end
                end
                
                clear X Y B BINT RR RINT STATS MN ima
                MN = plus((nanmean(ccnr))./epsilon,2*log(r_0(1,:))); % best estimate of CNR(R)
                if length(find(~isnan(MN(39:59)))) < 5
                    file_list(it,1) = {''};
                    goodPPI(it,:) = NaN;
                    continue % it loop
                end
                
                X(:,2) = R;
                X(:,1) = 1;
                Y(:,1) = MN;
                Y(1:38,1) = NaN;
                [B,BINT,RR,RINT,STATS] = regress(Y,X,0.01); % CNR(R) for each given azimuth
                reg(it,gru) = B(2)/(-2); % angle of the linear fit = alpha within 2-3km range
                offs(it,gru) = B(1); % the free coefficient "b" of the linear fit = ln(KF(R)beta(R))
                reg_err(it,gru,:) = BINT(2,:)/(-2);
                offs_err(it,gru,:) = BINT(1,:);
                
%                 GGR = GR./nanmean(GR(39:59)) ; % if const ratio beta(n,i)/beta(n,2 - 2.5km) then well mixed air
%                 ima = max(find(~isnan(GR))); % exclude from analysis the following distances 
                

%%%%%  check if the residual ln(Kbeta) -2alphaR is a linear function of R, then F(R) and alpha(2 km -) are correct and atm-re is well mixed
                clear CR C YT cf X Y B BINT RR RINT STATS   
                CR = plus(ccnr./epsilon,2*log(r_0));    
                
                if gru > 1                              
                    for azi = 1 : 360
                         %%% F(R) for group 1 recalculated after removing those PPI that are vertically stratified with bad alpha (0-3km) plot  
                         YT(azi,1:59) = log(IF(1:59,1)');                 
                    end 
                    C = minus(CR,YT); % = ln(Kbeta) - 2alphaR
                    
                elseif gru == 1    
                    for azi = 1 : 360
                         YT(azi,1:59) = log(FREF'); % original F(R) for group 1    
                    end
                    C = minus(CR,YT);
                end
                
                X(:,2) = R;
                X(:,1) = 1;
                Y(:,1) = nanmean(C);
                [B,BINT,RR,RINT,STATS] = regress(Y,X,0.01); % mean CNR(R) for each given azimuth

                if STATS(4) > (10/10000) ; % square RMSE  criteria
                    file_list(it,1) = {''};
                    continue % it loop
                else
                    reg_ov(it,gru) = B(2)/(-2); % angle of the linear fit
                    offs_ov(it,gru) = B(1); % the free coefficient "b" of the linear fit = ln(KF(R)beta(R)
                    reg_err_ov(it,gru,:) = BINT(2,:)/(-2);
                    offs_err_ov(it,gru,:) = BINT(1,:);
                    
                    %%% F(R) only for those PPI that are well mixed, with monotonous [ln(Kbeta(R)) - 2alphaR] over 0 - 3km
                    FT(:,it,gru) = exp(plus(MN,R*2*reg_ov(it,gru)))./exp(offs_ov(it,gru)); % F(R) for each PPI
                    
                   %%% fill in the missing data after 2km distance
%                 clear ff
%                 ff = FT(:,it,gru);
%                 ff(it,gru,1:38) = 1;
%                 
%                 if length(FT(39:59,it,gru)) < 10
%                     FT(find(isnan(ff(it,gru,:))),it,gru) = nanmean(FT(39:59,it,gru));
%                 end

                    if loopme == 1 
                        clf (figure(18));
                        cf =  figure(18) ;
                        set(cf,'Position',[60 450 560 420]); 
                        surfc(d1,z1,C, 'LineStyle','none','EdgeLighting','phong'); hold on;  
                        shading(gca,'flat');
                        view(0,90);
                        axis equal;
                        xlabel(['     Range West / East ', '(m)']);
                        ylabel(['     Range South / North ', '(m)']);
                        xlim([-max_range1 max_range1]);
                        ylim([-max_range1 max_range1]);
                        box on;  grid on;
                        colorbar;
                        %title({['CNR cleaned: best rays only, 10&90% filter'];['(CNR/epsilon) + 2lnR - lnF(R,gru1) = ln(Kbeta) - 2alphaR'];['']}); 
                        title([num2str(goodPPI(it,1)) '-' num2str(goodPPI(it,2)) '-' num2str(goodPPI(it,3)) ' ' num2str(goodPPI(it,4)) 'h:' num2str(goodPPI(it,5)) 'min']);
                        keyboard
                    end
                    
                    set(0, 'CurrentFigure', h15);
                    plot(R,FT(:,it,gru),'color','k') ; grid on; box on;  hold on                   
                    ylim([0 1.05]);
                    xlim([0 3000]);
        
                    if gru == 1
                        clear RGB
%                         ccc
                        RGB=JET(ccc,:);
                        set(0, 'CurrentFigure', h15);
                        plot(R,FT(:,it,gru),'color','r') ;   hold on                                                  
                        
                        
                        set(0, 'CurrentFigure', h20);
                        plot(R,nanmean(C),'color',[RGB(1),RGB(2),RGB(3)]); hold on
                        ccc = ccc + round(2.38);
%                         keyboard
                        %%%%%%%%%%%%%
%                         it  
%                         ([reg(it,gru), reg_ov(it,gru)])*1000 % alpha after 2km (guess)  &   overall alpha (after removing F(R))
%                         [offs(it,gru), offs_ov(it,gru)] % ln(K*beta(R)) after 2km (guess)  &   overall ln(K*beta(R)) value (after removing F(R))                    
%                         keyboard
                    else    
                        set(0, 'CurrentFigure', h15);
                        plot(R,FT(:,it,gru),'color','k') ;   hold on  

                        set(0, 'CurrentFigure', h20);
                        plot(R,nanmean(C),'color','k'); grid on; box on; hold on  
                        xlim([0 3000]); 
                    end
                end                
        end % it
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        FT(find(FT(:,:,:) == 0)) = NaN;
        IF(1:59,gru) = nanmean(FT(:,:,gru),2); % Instr func for given group
        for dis = 1:59
            if length(find(~isnan(FT(dis,:,gru)))) < 5
                IF(dis,gru) = NaN;
            end
        end
        
        
%         set(0, 'CurrentFigure', h15);
%         plot(R,FREF,'color','g','linewidth',2); % original F(R) for gr1
%         plot(R,IF(:,gru),'color','r','linewidth',2) ; 
%         %%% IF is the F(R) for given group after removing F(R,gru1) and
%         %%% those PPI with non-monotonuous alpha residual within 0-3km ! 
%         title({['normalized F(R) for each well mixed (alpha check for each PPI)'];...
%             ['firstguess ave F(R) out of 60 presumingly good PPI, per1 (green)'];...
%             ['final ave F(R) for all well mixed (red), period ', num2str(gru)];...
%             ['period ' num2str(gru) ': ' num2str(ref(gru,3)) '/' num2str(ref(gru,2)) '/' num2str(ref(gru,1)) ' +10d' ];['']});
%         xlabel(' scanning distance R [meters]','color','k');
%         ylabel(['normalized F(R), group' num2str(gru)]);
%         imageok=[chemin2, 'gru' num2str(gru) '_FR_new.eps'];
%         print(h15,'-depsc','-r400',imageok);
%         
%         
%         
%         set(0, 'CurrentFigure', h20);
%         xlabel(' scanning distance R [meters]','color','k');
%         title({['[ln(K*beta(R)) - 2*alpha*R] profile out of ave CNR(:,R)'];...
%             [' = (CNR(R)/epsilon) + 2lnR - lnF(R,gru1)'];['for each PPI, well mixed lowest 300m (alpha checked!)'];...
%             ['period ' num2str(gru) ': ' num2str(ref(gru,3)) '/' num2str(ref(gru,2)) '/' num2str(ref(gru,1)) ' +10d' ]});
%         imageok=[chemin2, 'gru' num2str(gru) '_lnKbeta(R)_min_2alphaR_profiles.eps'];
%         print(h20,'-depsc','-r400',imageok);
%         
%         save(['/media/elena/Transcend/Elena_ULCO/my_matlab_data/PPI_file_list_FR_10d_gru'  num2str(gru) '.mat'],'wscript','file_list','goodPPI');
        
% %         FREF = IF(:,1);
% %         save(['/media/elena/Transcend/Elena_ULCO/my_matlab_data/FRref.mat'],'wscript','FREF');
%         keyboard       
                    
%         clf (figure(2));  
%         figure(2)
%         plot(1:length(ll),LR(gru,:,3),'r'); hold on ;
%         plot(1:length(ll),LR(gru,:,4),'k'); hold on ;
%         ylabel('ratio : alpha(n)/alpha(ref) in black, beta(n)/beta(ref) in red');
%         xlabel({['PPI(n = 1 : ' num2str(length(SM)) ')']});
%         xlim([0 length(ll)+1]);
%         grid on      
%         if gru == 1
%             keyboard
%         end
end % group counter

description = {['18 March 2015'];...
    ['FREF is the reference F(R) of group 1 that was deduced from all PPI (gr 1 and other groups as well)'];...
    ['this was done to check whether there is a systematic non-linear evolution of the residual = -2*alpha*R + ln(K*beta(R)) '];...
    ['FT(59R x Ns PPI x gru) is the instrumental fuction for one (good!) PPI'];...
    ['IF(59 x Ngroups) is the instrumental fuction for a 10day group of PPI'];...
    ['CNR(R)/epsilon + 2lnR - lnF(R) = residual'];...
    ['the residual should be linear if (a) F(R) is correct and alpha&beta are const through R'];...
    ['only those PPI with a linear residual are considered for '];...
    ['reg_ov(Ns PPI x gruoups) is the ext coeff for the entire R range (0-3km)'];...
    ['offs_ov(Ns PPI x gruoups) = ln(K*beta(R)) = offset of linear regression for the entire R range (0-3km) '];...
    ['reg_err_ov (Ns PPI x gruoups x 2) upper and lower confidence interval for reg_ov'];...
    ['offs_err_ov (Ns PPI x gruoups x 2) upper and lower confidence interval for offs_ov'];...
    ['reg, offs, reg_err, offs_err  are the extr coeff and offset ln(K*beta(R)) within 2-3 km'];...
    [''];...
    ['see also :/media/elena/Transcend/Elena_ULCO/my_matlab_data/PPI_file_list_FR_10d_gru ?? .mat, variables: file_list and goodPPI'];...
    ['to get the time (year, mon, day, hh, min) and PPI file name for each good PPI']}

save('/media/elena/Transcend/Elena_ULCO/my_matlab_data/FR_alpha_by10dGroup_cleaned.mat',...
'FT','IF','wscript','description','reg_ov','offs_ov','reg_err_ov','offs_err_ov','reg','offs','reg_err','offs_err');  

% clear A B
% A = reg(find(~isnan(reg_ov)))*1000;
% B = reg_ov(find(~isnan(reg_ov)))*1000;
% 
% clf (figure(2));  
% figure(2)
% % scatter(X,Y/KBR,'Marker','o','MarkerFaceColor','k','MarkerEdgeColor','none'); hold on ;
% scatter(B,A,'Marker','o','MarkerFaceColor','r','MarkerEdgeColor','none'); hold on ;
% grid on
% box on
% xlabel('ext coef [km^{-1}] 0-3km after alpha slope filtering'); % B
% ylabel('ext coef [km^{-1}] 2-3km');

%%
clear all
close all
% load('/media/elena/Transcend/Elena_ULCO/my_matlab_data/CapLaGr_atmo_hourly_PM25.mat'); %,'script','atmo_dat','data_descr');   
% gr = [3 21];

load('/media/elena/Transcend/Elena_ULCO/my_matlab_data/StPol_atmo_hourly_PM10.mat');
gr = [6 21 24 33];

% load('/media/elena/Transcend/Elena_ULCO/my_matlab_data/Malo_atmo_hourly_PM25.mat'); %,'script','atmo_dat','data_descr');
% gr = [6 21 24]; % which groups (-30 days) should be plotted all together on one plot

load('/media/elena/Transcend/Elena_ULCO/my_matlab_data/FR_alpha_by10dGroup_cleaned.mat');
%%%  variables: 'FT','IF','wscript','description','reg','offs','reg_err','offs_err','reg_ov','offs_ov','reg_err_ov','offs_err_ov');  

% % compare to earlier results
% load('/media/elena/Transcend/Elena_ULCO/my_matlab_data/FKBref_235PPI.mat');
% 'IF','KB','LR','alpha');  see result_instr_func_allbestPPI.m
% JET= get(gcf,'colormap');

cpt = 1;
a = 1.3883; %1.4125; % color plot
zr = 3 : 3 : 40 ; % combine data within a 30-day period

clf (figure(2));  
figure(2);
JET= get(gcf,'colormap');
   
clear A B C L Z b bint r rint stats
for gru = 1 : 34 
    clear file_list goodPPI 
    load(['/media/elena/Transcend/Elena_ULCO/my_matlab_data/PPI_file_list_FR_10d_gru'  num2str(gru) '.mat']); % 'wscript','file_list','goodPPI');
    if length(find(~isnan(goodPPI))) > 0        
        for it = 1 : length(goodPPI)
            clear time 
            if ~isempty(find(~isnan(goodPPI(it,:)))) & ~isempty(find(atmo_dat(:,1) == goodPPI(it,1) & atmo_dat(:,2) == goodPPI(it,2))) & ~isnan(reg_ov(it,gru))
                time = goodPPI(it,4) + round(goodPPI(it,5)/60)  ;
                if time == 0
                    A(cpt) = atmo_dat(find(atmo_dat(:,1) == goodPPI(it,1) & atmo_dat(:,2) == goodPPI(it,2) & atmo_dat(:,3) == (goodPPI(it,3)-1) & ...
                    atmo_dat(:,4) == 24),5);
                else            
                    A(cpt) = atmo_dat(find(atmo_dat(:,1) == goodPPI(it,1) & atmo_dat(:,2) == goodPPI(it,2) & atmo_dat(:,3) == goodPPI(it,3) & ...
                    atmo_dat(:,4) == time),5);
                end
                B(cpt) = reg_ov(it,gru)*1000;
%                 C(cpt) = reg(it,gru)*1000;
%                 if goodPPI(it,1) == 2013
%                     L(cpt) =  goodPPI(it,2)^a;
%                 elseif goodPPI(it,1) == 2014
%                     L(cpt) =  (goodPPI(it,2)+12)^a;
%                 end                
                cpt = cpt + 1;
            end
        end
    end
    
%     if ~isempty(find(zr == gru)) & exist('B') == 1 & length(B) > 5
    if ~isempty(find(gr == gru))
        
        Z(:,2) = B;
        Z(:,1) = 1;
        [b,bint,r,rint,stats] = regress(A',Z);
%         stats(1)
%         stats(3)
         
        if goodPPI(it,1) == 2013
            RGB =  JET(round(goodPPI(it,2)^a),:);
        elseif goodPPI(it,1) == 2014
             RGB = JET(round((goodPPI(it,2)+12)^a),:);
        end   
       
%         clf (figure(2));  
%         figure(2);
        scatter(B,A,30,RGB,'filled'); hold on ;
        grid on; box on
        xlabel('lidar ext coef [km^{-1}] 0-3km');
%         ylabel('PM2.5 [micro gr per m^{3}]')
        ylabel('PM10 [micro gr per m^{3}]');
        plot(B,B*b(2)+b(1),'color',[RGB(1),RGB(2),RGB(3)],'linewidth',1.8); hold on ;
%         ylim([0 20])        
%         goodPPI(it,:)
%         [RHO,PVAL] = corrcoef(A,B,'alpha',0.01)
%         
%         length(B)
        gru
        keyboard
        clear A B C L Z b bint r rint stats RGB
        cpt = 1;        
    end
end



% title(['Sept 2013, correl 0.4, sign at 99%, 66 cases']); % gru = 6
% title(['March 2014, correl 0.72, sign at 99%, 49 cases']);  % gru 21
% title(['April 2014, correl 0.37, sign at 99%, 45 cases']);  % gru 24

% clf (figure(2));  
% figure(2);
% scatter(B,A,25,L,'filled'); hold on ;
% scatter(C,A,'Marker','o','MarkerFaceColor','k','MarkerEdgeColor','none'); hold on ;
% grid on; box on
% xlabel('lidar ext coef [km^{-1}] 0-3km'); % B
% ylabel('PM2.5 [micro gr per m^{3}]');
% ylabel('PM10 [micro gr per m^{3}]');
%title({['PM2.5 vs Lidar extinction coeff at 1.54 microns'];['411 obs in the period July 2013 - July 2014'];['ATMO measuremets at Cappelle-la-Grande'];['colors reflect different months'];['']});

%  
% [b,bint,r,rint,stats] = regress(A',Z) % returns a 1-by-4 vector stats that contains, in order, the R2 statistic, the F statistic and its p value, and an estimate of the error variance.
% stats(3)
% stats(4)

%%
clear all
close all
for gru = 1 : 34 
    clear file_list goodPPI 
    load(['/media/elena/Transcend/Elena_ULCO/my_matlab_data/PPI_file_list_FR_10d_gru'  num2str(gru) '.mat']); % 'wscript','file_list','goodPPI');
    goodPPI(find(goodPPI(:,1) == 2013 & goodPPI(:,2) == 10 & goodPPI(:,3) == 26 & goodPPI(:,4) == 4 & goodPPI(:,5) == 36 ),:)   
    if length(find(goodPPI(:,1) == 2013 & goodPPI(:,2) == 10 & goodPPI(:,3) == 26) & goodPPI(:,4) == 4 & goodPPI(:,5) == 36 ) > 1 
    break
    end
end
%%

break

%%%%% calculate overall F(R)  %%%%%%%%%%%%%%%%%%%%%%%%%
clear z RP KBR P Y X rat A
% z = find(SM(:,1) == 18 & SM(:,2) == 94) ; % reference PPI = 1

z = 8 ;
RP = FR(z,:);  % reference F(R)*K*beta(n)
cp =1;

for i = 1 : size(SM,1)
    clear GR GZ
    GR = FR(i,:)./RP; % ratio : beta(n,i)/beta(ref)
      
    for e = 3 : 56
        GZ(1,e) = plus(minus(GR(e-2),8*GR(e-1)),minus(8*GR(e+1),GR(e+2)) )/(12*50); % 50 meter distance between two neighbouring CNR values   
    end
    
    GZ(1,1) = (minus(GR(1),GR(2)))/50;
    GZ(1,2) = (minus(GR(1),GR(3)))/100;
    GZ(1,57) = (minus(GR(56),GR(58)))/100;
    GZ(1,58) = (minus(GR(57),GR(58)))/50;
    GR(find(abs(GZ) > 0.0001)) = NaN; 
    
    rat(i) = nanmean(GR); % average ratio  beta(n)/beta(ref)
    
                if ~isempty(find(~isnan(GR))) & minus(nanmax(GR(find(~isnan(GR)))),nanmin(GR(find(~isnan(GR))))) < 0.09
                        %%% all possible values of F(R)*K*beta(ref)/R^2, depending on alpha(PPI)
                        %%% here MN(d) is the best estimate out of all plus(ccnr(:,d)./epsilon)
                        %%% at those scanning distance where ratio ~isnan
                        
                        Y(cp:cp+length(find(~isnan(GR)))-1,1)  = FR(i,find(~isnan(GR)))./rat(i);      
                        X(cp:cp+length(find(~isnan(GR)))-1,1) = R(find(~isnan(GR))) ; % predictor

                        if length(X) < length(Y) | length(X) > length(Y)
                                keyboard
                        end
                        cp = cp+length(find(~isnan(GR)));
                end % if beta ratio is const somewhere   
end % PPI counter
  
P(1,1 : length(R)) = NaN;
for d = 1 : length(R)
        P(1,d) = nanmean(Y(find(X == R(1,d)))); % the average value of F(R)*K*beta(n) at distance R(d)
end

KBR = nanmean(P(40:52)); % = K*beta(ref) ; to note: with F(R) is within 0-1
% KB(length(KB)+1) = KBR ;

A(39:57) = nanmoving_average(P(39:57)/KBR,5);
A(1:38) =  P(1:38)/KBR ;
A(45:59) = mean(A(45:57)) ; 
A(35:50) = nanmoving_average(A(35:50),2);

IF(:,size(IF,2)+1) = A; 

figure(4);
scatter(X,Y/KBR,'Marker','o','MarkerFaceColor','k','MarkerEdgeColor','none'); hold on ;
scatter(R,A,'Marker','o','MarkerFaceColor','r','MarkerEdgeColor','none'); hold on ;
grid on
box on
xlabel(' scanning distance R [meters]','color','k');
ylabel('Instrumental Function F(R)','color','k')
% title('Overall F(R) for 235 PPI in red and corresponding uncertainty in black')
ylim([0 1.2]); %hold on   

[R'/1000,IF(:,size(IF,2))]

FKB = A*KBR; 

% save('/media/Transcend/Elena_ULCO/my_matlab_data/FKBref_235PPI.mat','IF','KB');  

%%    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        

% clf (figure(3));  
% figure(3)
% plot(1:length(alpha),alpha,'r'); hold on ;
% plot(1:length(alpha),KB/100000,'k'); hold on ;


%%% apply F(R), the smallest K*beta(ref) and alpha(n) to all PPI
wls_PPI_loop_2

    




