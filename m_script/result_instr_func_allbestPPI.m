%%% evaluate instrumental function for all the best PPI and weekly
%%% within the scanning distances where beta(n)/beta(ref) ratio is const
%%% we can evaluate F(R)
%%% with the use of a linear regression
%%% previous script : result.m

clear all 
close all

colormap(jet) ;
JET= get(gcf,'colormap');

rep=dir(['/./media/elena/Transcend/Leosphere/WLS100/']);
loopme = 0;
epsilon = 10/log(10) ;

%%% upload the list of the best 32/61 PPI, variable 're'
% listing_2lnR ; % list of scanning distances where alpha should be determined (CNR = CNR/epsilon - 2lnR)

%%% upload the list of the best 235 PPI  (script : result.m), year 2013
% load('/media/Transcend/Elena_ULCO/my_matlab_data/alpha_homogeneous_cases.mat'); % list of PPI and corresponding scanning distances where alpha was determined
 
%%% year 2014
% load('/media/Transcend/Elena_ULCO/my_matlab_data/alpha_homogeneous_cases_2.mat'); % list of PPI and corresponding scanning distances where alpha was determined

%%% all
load('/media/elena/Transcend/Elena_ULCO/my_matlab_data/alpha_homogeneous_cases_3.mat'); % list of PPI and corresponding scanning distances where alpha was determined

sdi = 59; % consider only the first 3000m (because different files can go up to 5-6 km)
stats_all_PPI ; %% read and regroup the overall statistics for all PPI files we dispose

R = 100:50:3000; 
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
                chemin1=(['/./media/elena/Transcend/Leosphere/WLS100/' rep(ij).name '/']);
                list=dir([chemin1,'/*_PPI.rtd']);
                L = SP(find(SP(:,1) == ij),2) ; % file number within the directory
                idx = find(SP(:,1) == ij) ; % line number  within SM file
                ii = ij ;

                for n = 1 : length(idx)
                    fich(idx(n),:) = cellstr(list(L(n)).name) ; % PPI file  
                    date(idx(n)) = mjuliandate(str2num(list(L(n)).name(11:14)),  str2num(list(L(n)).name(16:17)) , str2num(list(L(n)).name(19:20))) ; % PPI file 
                    dat(idx(n),:) = [str2num(list(L(n)).name(11:14)),  str2num(list(L(n)).name(16:17)) , str2num(list(L(n)).name(19:20)) ] ;
                end

                SP(find(SP(:,1) == ij),:) = NaN ;
            end
        end 
end 
save('/media/elena/Transcend/Elena_ULCO/my_matlab_data/alpha_homogeneous_cases_3_filenames_filetime.mat','fich','dat','date'); 

%%
load('/media/elena/Transcend/Elena_ULCO/my_matlab_data/alpha_homogeneous_cases_3_filenames_filetime.mat'); %,'fich','dat','date'

clear date1 dat1 SM1 FR1 h5 h12 chemin1 
clf (figure(5)) ; clf (figure(12)) ;
date1 = date ;
dat1 = dat;
SM1 = SM ; % = [ij L reg_err(2) reg reg_err(1) offs offs_err ah reg_err1(2) reg1 reg_err1(1)];  
FR1 = FR ; % = exp(plus(MN,2*reg*r_0(1,1:sdi))) = best estimate of CNR plus 2*alpha*R
nt = 1;

chemin2=(['/./media/elena/Transcend/Elena_ULCO/illustrations/FI/']);      
 
for gru = 1 : 40 % group counter (every 10 days)
    
        if isempty(find(date <= nanmin(date) + 10)) % if no data
            continue % gru loop
        end
                
        clear idx ll FFR RP X Y nna nni lli ssi z ij uz se h3 h12 h5 file_list
        clf (figure(1)) ;  clf (figure(5))
        
        P(1,1 : length(R)) = NaN;
        PMI(1:59,gru) = NaN;
        PMA(1:59,gru) = NaN;
              
        ref(gru,1:3) = dat1(min(find(date1 == nanmin(date1))),:) ; % store the reference date for the group
        idx = find(date1 <= nanmin(date1) + 10) ; % which lines 
        ref(gru,4) = length(idx) ; % nb of PPI within the group
        
        ll = SM(idx,:);
        FFR = FR(idx,:);
        file_list = fich(idx,:);        
        
        date1(idx) = NaN ; 
        SM1(idx,:) = NaN ; % hide all the data that was already used
        FR1(idx,:)= NaN ; % hide all the data that was already used
               
        %%%% define the reference PPI  = PPI(z) for given group of PPI files 
        loopme = 0 ; % plot figures for the best PPI
        ref_ppi ; % 
        
        %%%%
        RP = nanmoving_average(FFR(z,:),2); % define the reference F(R)*K*beta(n)
        alpha(gru) = ll(z,4); % alpha of the reference PPI
        RGB=JET(nt,:);   
        
%         h5 = figure(5) ;               
%         plot(R,RP,'linewidth',2,'color',[RGB(1),RGB(2),RGB(3)]);  hold on ; grid on ;
%         set(h5,'Position',[6 10 560 420]); 
%         xlabel(' scanning distance R [meters]','color','k');
%         ylabel('F(R) * K * beta(n)','color','k')
%         title('The reference F(R)*K*beta for each 10d group of PPI');     

        for i = 1 : size(ll,1) % PPI counter within the group
                clear GR GZ rat h12 h15 h16
                clf (figure(12)); clf (figure(15))
                GR = nanmoving_average(FFR(i,:),2)./RP; % ratio : beta(n,i)/beta(ref)
                
                h15 = figure(15);
                plot(R,GR,'color','k') ;   hold on                 
                set(h1,'Position',[600 10 560 420]); 
                  
                for e = 3 : 56
                    GZ(1,e) = plus(minus(GR(e-2),8*GR(e-1)),minus(8*GR(e+1),GR(e+2)) )/(12*50) ; % 50 meter distance between two neighbouring CNR values   
                end
                GZ(1,1) = (minus(GR(1),GR(2)))/50;
                GZ(1,2) = (minus(GR(1),GR(3)))/100;
                GZ(1,57) = (minus(GR(56),GR(58)))/100;
                GZ(1,58:59) = (minus(GR(57),GR(58)))/50;
                 
%                 h2 = figure(2) ;               
%                 plot(R,GZ,'linewidth',2,'color','k');  hold on ; grid on ;
%                 get(h2); ylim([-0.0001 0.0001]);
%                 set(h2,'Position',[650 600 560 420]); 
%                 get(h2); plot(R,GZ,'linewidth',2,'color','r');  hold on ; grid on ;
                  
                GZ(find(abs(GZ) > 0.0005)) = NaN;        
                GR(find(isnan(GZ))) = NaN; 
                
                get(figure(15)); 
                plot(R,GR,'color','r') ; grid on  ; hold on ;
                ylabel('beta(n) / beta(ref)');
                xlabel(' scanning distance R [meters]','color','k');
                ylim([0 4]);
                title('The beta ratio as a function of distance R and PPI');
                                    
                %%% what is the reference PPI (ij and L) for this group ?    
                LR(gru,i,:) = [ll(z,1:2), nanmean(GR), ll(i,4)/ll(z,4), ll(i,9)/50, length(find(~isnan(GR(1:ll(i,9)/50))))] ; % important : how many values of beta_ratio are used for given PPI !?
                rat = nanmean(GR); % average ratio  beta(n)/beta(ref) through all distances between 100 and 3000m

                if ~isempty(find(~isnan(GR))) & minus(nanmax(GR(find(~isnan(GR)))),nanmin(GR(find(~isnan(GR))))) < 0.12
                        %%% all possible values of F(R)*K*beta(ref)/R^2, depending on alpha(PPI(n))                       
                        Y(cp:cp+length(find(~isnan(GR)))-1,1)  = FFR(i,find(~isnan(GR)))./rat;      
                        X(cp:cp+length(find(~isnan(GR)))-1,1) = R(find(~isnan(GR))) ; % predictor

                        if length(X) < length(Y) | length(X) > length(Y)
                                keyboard
                        end
                        cp = cp + length(find(~isnan(GR)));
                end % if beta ratio is const somewhere
        end

        h12= figure(12);
        scatter(X,Y(:,1),'Marker','o','MarkerFaceColor','k','MarkerEdgeColor','none'); hold on ;
        grid on ; box on ;
        xlabel(' scanning distance R [meters]','color','k');
        ylabel('F(R)*K*beta(ref)','color','k')
        xlim([0 3000]); 
        set(h12,'Position',[1150 10 560 420]); 
        
        for d = 1 : length(R)
                len(d,gru) = length(find(X == R(1,d))); % how much F(R)*K*beta(ref) values are available at given distance 
                if length(find(X == R(1,d))) > 0 
                    PMI(d,gru) = min(Y(find(X == R(1,d))));
                    PMA(d,gru) = max(Y(find(X == R(1,d))));
                end
                
                if length(find(X == R(1,d))) > 2                     
                    P(1,d) = mean(Y(find(X == R(1,d)))); % the average value of F(R)*K*beta(ref) at distance R(d) 
                end
        end
        
        KB(gru) = nanmean(P(1,40:59)); % = K*beta(ref) ; to note: with F(R) is within 0-1
        IF(:,gru) = P(1,:)/KB(gru); % Instrumental function for each group
        
        PMI(:,gru) = PMI(:,gru)/KB(gru);
        PMA(:,gru) = PMA(:,gru)/KB(gru);
        
                    
        get(figure(12))
        scatter(R,P(1,:),'Marker','o','MarkerFaceColor','r','MarkerEdgeColor','none'); hold on ;        
        imageok=[chemin2, 'p' num2str(gru) '_F(R)Kbeta(ref).eps'];
        print (figure(12),'-depsc','-r400',imageok);
        
        h13 = figure(13)
        set(h13,'Position',[650 600 560 420]); 
        scatter(R,P(1,:),'Marker','o','MarkerFaceColor','r','MarkerEdgeColor','none'); hold on ;
        scatter(R,IF(:,gru),'Marker','o','MarkerFaceColor',[RGB(1),RGB(2),RGB(3)],'MarkerEdgeColor','none'); hold on ; 
        grid on
        box on
        xlabel(' scanning distance R [meters]','color','k');
        ylabel('Instrumental Function F(R)','color','k')
        ylim([0 1.2]);  
        xlim([0 3000]); 
        title({['F(R) for each 10d group of PPI'];['normalised by its own mean(F(R)*K*beta(ref)) within 2-3km']}) ;
        nt = nt + 6 ;
             
        if gru == 10 | gru == 20 | gru == 30     
            get(figure(13))
            ylim([0 1.2]); 
%             scatter(R,nanmin(PMI(:,gru-9:gru)'),'Marker','+','MarkerEdgeColor','k'); hold on ;
%             scatter(R,nanmax(PMA(:,gru-9:gru)'),'Marker','+','MarkerEdgeColor','k'); hold on ;
            PMI(find(PMI == 0)) = NaN;
            PMA(find(PMA == 0)) = NaN;
            scatter(R,nanmin(PMI(:,31:34)'),'Marker','+','MarkerEdgeColor','k'); hold on ;
            scatter(R,nanmax(PMA(:,31:34)'),'Marker','+','MarkerEdgeColor','k'); hold on ;
            nt = 1;
%             imageok=[chemin2, 'p' num2str(gru-9) '-p' num2str(gru) '_FI_by_group.eps'];
            imageok=[chemin2, 'p' num2str(31) '-p' num2str(34) '_FI_by_group.eps'];
            print (figure(13),'-depsc','-r400',imageok);
%             keyboard
            clf (figure(13))
        end
 
%         clf (figure(2));  
%         figure(2)
%         plot(1:length(ll),LR(gru,:,3),'r'); hold on ;
%         plot(1:length(ll),LR(gru,:,4),'k'); hold on ;
%         ylabel('ratio : alpha(n)/alpha(ref) in black, beta(n)/beta(ref) in red');
%         xlabel({['PPI(n = 1 : ' num2str(length(SM)) ')']});
%         xlim([0 length(ll)+1]);
%         grid on
        
      
%         h14 = figure(14)
%         scatter(B,C,'Marker','o','MarkerFaceColor','k','MarkerEdgeColor','none'); hold on ;
%         grid on
%         box on
%         xlabel(' scanning distance R [meters]','color','k');
%         ylabel('number of PPI');  
%         xlim([0 3000]); 
%         title({['Total amount of F(R)*K*beta(ref) values'];['used to deduce F(R) at each scanning distance']}) ;
end % group counter

% save('/media/Transcend/Elena_ULCO/my_matlab_data/FKBref_235PPI.mat','IF','KB','LR','alpha');  

clf (figure(1));
h1 = figure(1)
set(h1,'Position',[650 600 560 420]); 
scatter(R,sum(len,2),'Marker','o','MarkerFaceColor','k','MarkerEdgeColor','none'); hold on ;
grid on
box on
xlabel(' scanning distance R [meters]','color','k');
ylabel('number of PPI');  
xlim([0 3000]); 
title({['Total amount of F(R)*K*beta(ref) values'];['used to deduce F(R) at each scanning distance']}) ;
imageok=[chemin2, 'F(R)_uncertainty_by_R.eps'];
print (figure(1),'-depsc','-r400',imageok);

break

%%
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

    




