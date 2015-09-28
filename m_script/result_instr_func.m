%%% evaluate instrumental function for all the best PPI and weekly
%%% within the scanning distances where beta(n)/beta(ref) ratio is const
%%% we can evaluate F(R)
%%% with the use of a linear regression
%%% previous script : result.m
%%% the more advanced version of thios script, see see % result_instr_func_allbestPPI.m

clear all 
close all

colormap(jet) ;
JET= get(gcf,'colormap');

rep=dir(['/./media/Transcend/Leosphere/WLS100/']);
loopme = 0;
epsilon = 10/log(10) ;

%%% upload the list of the best 32/61 PPI
%%% variable 're'
% listing_2lnR ; % list of scanning distances where alpha should be determined (CNR = CNR/epsilon - 2lnR)

%%% upload the list of the best 235 PPI
load('alpha_homogeneous_cases.mat'); % list of PPI and corresponding scanning distances where alpha was determined
%%%  SM(cpt+1,:) = [ij L reg_err(2) reg reg_err(1) offs offs_err ah];  
%%%  FR(cpt+1,:) = exp(plus(MN,2*reg*r_0(1,:))) ;
 
R = 100:50:3000; 
z = find(SM(:,1) == 18 & SM(:,2) == 94) ; % reference PPI = 1
% RP = FR(z,:);  % reference F(R)*K*beta(n)

z = [3 3 3 9 7 5 47 19 19]; % from visual choice of homogeneous cases

cpt = 1;
cp = 1;
cd = 1;
n = 1;

LR(1,1:2) = NaN;

for ij = [ 3 5 6 9 10 16 17 18 19] ; 
%     ij = 19
        clear ll FFR X Y
        clf (figure(1)) ;   clf (figure(5)) ;  clf (figure(12)) ;  
        
        ll = SM(find(SM(:,1) == ij),:); % statistics (alpha and others) for a group of PPI
        FFR = FR(find(SM(:,1) == ij),:); 
        
        if ij == 3 % regroup PPI files from dir N3 with dir N4
            ll(size(ll,1)+1 : size(ll,1) + size(SM(find(SM(:,1) == 4)),1),:) = SM(find(SM(:,1) == 4),:) ;
            FFR(size(FFR,1)+1 : size(FFR,1) + size(SM(find(SM(:,1) == 4)),1),:) = FR(find(SM(:,1) == 4),:) ;
        elseif ij == 6 % regroup PPI files from dir N6 with dir N7
            ll(size(ll,1)+1 : size(ll,1) + size(SM(find(SM(:,1) == 7)),1),:) = SM(find(SM(:,1) == 7),:) ;
            FFR(size(FFR,1)+1 : size(FFR,1) + size(SM(find(SM(:,1) == 7)),1),:) = FR(find(SM(:,1) == 7),:) ;
        elseif ij == 10
            ll(size(ll,1)+1 : size(ll,1) + size(SM(find(SM(:,1) == 11)),1),:) = SM(find(SM(:,1) == 11),:) ;
            FFR(size(FFR,1)+1 : size(FFR,1) + size(SM(find(SM(:,1) == 11)),1),:) = FR(find(SM(:,1) == 11),:) ;
%         elseif ....
%             for op = 12 : 15
%                 ll(size(ll,1)+1 : size(ll,1) + size(SM(find(SM(:,1) == op)),1),:) = SM(find(SM(:,1) == op),:) ;
%                 FFR(size(FFR,1)+1 : size(FFR,1) + size(SM(find(SM(:,1) == op)),1),:) = FR(find(SM(:,1) == op),:) ;
%             end
        end
           
        %%% the reference PPI is chosen subjectively (visually) 
%         RP = FFR(z(cpt),:); % define the reference F(R)*K*beta(n)        
%         alpha(cpt) = ll(z(cpt),4); % alpha of the reference PPI (reference for a group)
        
        %%% each PPI within the group serves as a reference PPI
        for z = 1 : size(ll,1)
            clear RP
            RP = FFR(z,:); % define the reference PPI (and corresponding F(R)*K*beta(n)  )
            alpha(n) = ll(z,4); % alpha of the reference PPI (reference for a group)
            n = n + 1 ;
            
        for i = 1 : size(ll,1) % for each PPI within the group
                clear GR GZ
%                 RGB=JET(ceil(64/size(ll,1)*i),:) ; 
                
%                 figure(5)  ;               
%                 plot(R,FFR(i,:),'color',[RGB(1),RGB(2),RGB(3)]); % 'k'); 
%                 if FFR(i,:) == RP
%                     plot(R,RP,'linewidth',2,'color',[RGB(1),RGB(2),RGB(3)]);
%                 end
% %                 ylim([0.8 1.1]);         
%                 grid on  
               
                GR = FFR(i,:)./RP; % ratio : beta(n,i)/beta(ref)
%                 figure(1);
%                 plot(R,GR,'color','k') ;  hold on                 
                 
                for e = 3 : 56
                    GZ(1,e) = plus(minus(GR(e-2),8*GR(e-1)),minus(8*GR(e+1),GR(e+2)) )/(12*50); % 50 meter distance between two neighbouring CNR values   
                end
                GZ(1,1) = (minus(GR(1),GR(2)))/50;
                GZ(1,2) = (minus(GR(1),GR(3)))/100;
                GZ(1,57) = (minus(GR(56),GR(58)))/100;
                GZ(1,58) = (minus(GR(57),GR(58)))/50;
                GR(find(abs(GZ) > 0.0001)) = NaN;        
    
%                 figure(1);
%                 plot(R,GR,'color','r') ; % [RGB(1),RGB(2),RGB(3)]); 
%                 grid on ; hold on
%                 ylabel('beta(n) / beta(ref)');
%                 xlabel(' scanning distance R [meters]','color','k');
                
%                 LR(length(LR)+1,1:2) = [nanmean(FFR(i,find(~isnan(GR))))/nanmean(RP), ll(i,4)/ll(z(cpt),4)] ;

                rat(i) = nanmean(GR); % average ratio  beta(n)/beta(ref) for given PPI

                if ~isempty(find(~isnan(GR))) & minus(nanmax(GR(find(~isnan(GR)))),nanmin(GR(find(~isnan(GR))))) < 0.12
                        %%% all possible values of F(R)*K*beta(ref)/R^2, depending on alpha(PPI)
                        %%% here MN(d) is the best estimate out of all plus(ccnr(:,d)./epsilon)
                        %%% at those scanning distance where ratio ~isnan
                        
                        Y(cp:cp+length(find(~isnan(GR)))-1,1)  = FFR(i,find(~isnan(GR)))./rat(i); % predictable variable         
                        X(cp:cp+length(find(~isnan(GR)))-1,1) = R(find(~isnan(GR))) ; % predictor

                        if length(X) < length(Y) | length(X) > length(Y)
                                keyboard
                        end
                        
                        cp = cp+length(find(~isnan(GR)));
                end % if beta ratio is const somewhere
        end  % i
        end  % z  : when each PPI serves as a reference PPI
        
%          for iu = 1 : length(re) % each best PPI   
%                     clear chemin1 list ij L cnr ccnr dad x M N Y XX B BINT R RINT STATS KN
%                     ij = ll(iu,1);       
%                     L  = ll(iu,2);
%                     chemin1=(['/./media/Transcend/Leosphere/WLS100/' rep(ij).name '/']);
%                     list=dir([chemin1,'/*_PPI.rtd']);
% 
%                     fichier = cellstr(list(L).name) ; % PPI file 
%                     RGB=JET(iu,:) ;
% 
%                   copyfile([chemin1,list(L).name],['/./media/Transcend/Leosphere/lpca_15jul2014/']) ;
%                     wls_sub_PPI_1 ;
%          end    % iu = PPI counter   

%         break
%         figure(12);
%         scatter(X,Y(:,1),'Marker','o','MarkerFaceColor','k','MarkerEdgeColor','none'); hold on ;
%         grid on
%         box on
%         xlabel(' scanning distance R [meters]','color','k');
%         % ylabel('F(R)*K*beta(ref)/R^2','color','k')
%         ylabel('F(R)*K*beta(ref)','color','k')
        
        P(1,1 : length(R)) = NaN;
        for d = 1 : length(R)
                P(1,d) = nanmean(Y(find(X == R(1,d)))); % the average value of F(R)*K*beta(n) at distance R(d)
        end
        
        KB(cpt) = nanmean(P(40:52)); % where P seems to be const
        IF(:,cpt) = P;
        
%         figure(12)
%         scatter(R,P,'Marker','o','MarkerFaceColor','r','MarkerEdgeColor','none'); hold on ;
        % ylim([0 0.08]);

        figure(4)
        RGB=JET(6*cpt,:);
        % scatter(R,P./nanmax(IF),'Marker','o','MarkerFaceColor','k','MarkerEdgeColor','none'); hold on ;
        scatter(R,P/KB(cpt),'Marker','o','MarkerFaceColor',[RGB(1),RGB(2),RGB(3)],'MarkerEdgeColor','none'); hold on ;

        % scatter(R,P./nanmean(P(49:59)),'Marker','o','MarkerFaceColor','k','MarkerEdgeColor','none'); hold on ; %[RGB(1),RGB(2),RGB(3)]
%         grid on
        box on
        xlabel(' scanning distance R [meters]','color','k');
        ylabel('Instrumental Function F(R)','color','k')
        ylim([0 1.1]); %hold on        
        
        cpt = cpt + 1;
%         pause(5)
%         keyboard
end % group counter
 
figure(4)
PI = nanmean(IF,2);
scatter(R,PI/nanmean(PI(40:52)),'Marker','o','MarkerFaceColor','k','MarkerEdgeColor','none'); hold on ;


keyboard

clf (figure(3));  
figure(3)
plot(1:length(alpha),alpha,'r'); hold on ;
plot(1:length(alpha),KB/100000,'k'); hold on ;


% clf (figure(2));  
% figure(2)
% plot(1:length(LR),LR(:,1),'r'); hold on ;
% plot(1:length(LR),LR(:,2),'k'); hold on ;
% ylabel('ratio : alpha(n)/alpha(ref) in black, beta(n)/beta(ref) in red');
% xlabel({['PPI(n = 1 : ' num2str(length(SM)) ')']});
% xlim([0 length(SM)+1]);
% grid on




    




