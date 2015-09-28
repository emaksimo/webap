%%% previous scripts : 
%%% result.m , result_instrum_func.m (to calculate F(R) for each 10d group of PPI

clear all 
close all

rep=dir(['/./media/Transcend/Leosphere/WLS100/']);
loopme = 0;
epsilon = 10/log(10) ;
R = 100:50:3000; 

%%% upload the list of the best PPI (presumingly homogeneously mixed air) over the entire WLS observation period
load('/media/Transcend/Elena_ULCO/my_matlab_data/alpha_homogeneous_cases_3.mat'); % list of PPI and corresponding scanning distances where alpha was determined

sdi = 59; % consider only the first 3000m (because different files can go up to 5-6 km)
stats_all_PPI ; %% read and regroup the overall statistics for all PPI files we dispose

cp = 1;

ii = 1 ; % group counter
SP = SM(:,1:2);

% get the information relative to each PPI file
for k = 1 : size(SP,1)    
        clear ij n 
        if ~isnan(SP(k,1))            
            ij = SP(k,1) 
            if ij ~= ii 
                clear list chemin1 L idx
                chemin1=(['/./media/Transcend/Leosphere/WLS100/' rep(ij).name '/']);
                list=dir([chemin1,'/*_PPI.rtd']);
                L = SP(find(SP(:,1) == ij),2) ; % file number within the directory
                idx = find(SP(:,1) == ij) ; % line number  within SM file
                ii = ij ;

                for n = 1 : length(idx)
                    fich(idx(n),:) = cellstr(list(L(n)).name) ; % PPI file  
                    date(idx(n)) = mjuliandate(str2num(list(L(n)).name(11:14)),  str2num(list(L(n)).name(16:17)) , str2num(list(L(n)).name(19:20))) ; % PPI file 
                    dat(idx(n),:) = [str2num(list(L(n)).name(11:14)),  str2num(list(L(n)).name(16:17)) , str2num(list(L(n)).name(19:20)) , ...
                                    str2num(list(L(n)).name(23:24)) , str2num(list(L(n)).name(26:27)) ] ;
                end

                SP(find(SP(:,1) == ij),:) = NaN ;
            end
        end 
end 


%%
clear date1 dat1 SM1 FR1 h5 h12 chemin1 ref
close all
clf (figure(5)) ; clf (figure(12)) ;
date1 = date ;
dat1 = dat;
SM1 = SM ; % = [ij L reg_err(2) reg reg_err(1) offs offs_err ah reg_err1(2) reg1 reg_err1(1)];  
FR1 = FR ; % = exp(plus(MN,2*reg*r_0(1,1:sdi))) = best estimate of CNR plus 2*alpha*R
nt = 1;

chemin2=(['/./media/Transcend/Elena_ULCO/illustrations/FI/']);      
 

for gru = 1 : 40 % group counter (every 10 days)
    
        if isempty(find(date <= nanmin(date) + 10)) % if no data
            continue % gru loop
        end
                
        clear idx mom ll FFR RP X Y nna nni lli ssi z ij uz se h3 h12 h5 file_list reg reg_err K TC ZN BR
        clf (figure(1)) ;  clf (figure(5))
        
%         P(1,1 : length(R)) = NaN;
%         PMI(1:59,gru) = NaN;
%         PMA(1:59,gru) = NaN;
              
        ref(gru,1:5) = dat1(min(find(date1 == nanmin(date1))),:)  % store the reference date for the group
        idx = find(date1 <= nanmin(date1) + 10) ; % line numbers corresponding to some day within a 10d period
        ref(gru,6) = length(idx) ; % nb of PPI within the group
        
        mom = dat1(idx,:);
        ll = SM(idx,:);
        FFR = FR(idx,:);
        file_list = fich(idx,:);        
          
        
        %%%% define the reference PPI  = PPI(z) for given group of PPI files 
        loopme = 1 ; % plot figures for the best PPI
        ref_ppi ; % result : MN, KN, z, zz, zi
        
%         keyboard
        %%% ah(lm,1:2) = scanning distances where exp(delta cnr* is at its
        %%% maximum, where F(R1) = F(R2)
        %%% reg(lm) = alpha for the best selection of PPI, 
        %%% FT(lm, : ) = F(R) for each of these best PPI
        %%% FU(lm,:) = %  minus(plus(MN(lm,:),2*reg(lm)*r_0(1,1:sdi)), ln(FT(lm,:))); % = ln(K) + ln(beta(R)) is it const over R?
        
        date1(idx) = NaN ; 
        SM1(idx,:) = NaN ; % hide all the data that was already used
        FR1(idx,:)= NaN ; % hide all the data that was already used
           
%         BR = KBR' * (KBR.^-1);  % beta ratio for the best selection of PPI
%         for lm = 1 : length(KBR)
%             TC(1:length(KBR),lm) = nanmean(MN(lm,find(r_0(1,1:sdi) == ah(lm,1)) : find(r_0(1,1:sdi) == ah(lm,2)))) ; % CNR` (nominator within beta ratio)
%             ZN(lm,1:length(KBR)) = nanmean(MN(lm,find(r_0(1,1:sdi) == ah(lm,1)) : find(r_0(1,1:sdi) == ah(lm,2)))) ; % CNR` (denominator within beta ratio)
%         end
%         
%         K = sqrt(exp(minus(plus(TC,ZN),log(BR)))) ;
        
        keyboard
    
                
%                 h15 = figure(15);
%                 plot(R,GR,'color','k') ;   hold on                 
%                 set(h1,'Position',[600 10 560 420]); 
%                   
%                 for e = 3 : 56
%                     GZ(1,e) = plus(minus(GR(e-2),8*GR(e-1)),minus(8*GR(e+1),GR(e+2)) )/(12*50) ; % 50 meter distance between two neighbouring CNR values   
%                 end
%                 GZ(1,1) = (minus(GR(1),GR(2)))/50;
%                 GZ(1,2) = (minus(GR(1),GR(3)))/100;
%                 GZ(1,57) = (minus(GR(56),GR(58)))/100;
%                 GZ(1,58:59) = (minus(GR(57),GR(58)))/50;
                 
%                 h2 = figure(2) ;               
%                 plot(R,GZ,'linewidth',2,'color','k');  hold on ; grid on ;
%                 get(h2); ylim([-0.0001 0.0001]);
%                 set(h2,'Position',[650 600 560 420]); 
%                 get(h2); plot(R,GZ,'linewidth',2,'color','r');  hold on ; grid on ;
                  
%                 GZ(find(abs(GZ) > 0.001)) = NaN;        
%                 GR(find(isnan(GZ))) = NaN; 
%                 
%                 get(figure(15)); 
%                 plot(R,GR,'color','r') ; grid on  ; hold on ;
%                 ylabel('beta(n) / beta(ref)');
%                 xlabel(' scanning distance R [meters]','color','k');
%                 ylim([0 4]);
%                 title('The beta ratio as a function of distance R and PPI');
                                    
                %%% what is the reference PPI (ij and L) for this group ?    
%                 LR(gru,i,:) = [ll(z,1:2), nanmean(GR), ll(i,4)/ll(z,4), ll(i,9)/50, length(find(~isnan(GR(1:ll(i,9)/50))))] ; % important : how many values of beta_ratio are used for given PPI !?
        
end % group counter

%%