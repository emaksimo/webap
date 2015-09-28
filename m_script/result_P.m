%%% calculate alpha for the best PPI
%%% evaluate the Instrumental function using the best PPI
%%% PPI file loop done with : wls_PPI_loop_1.m
%%% statistics were calculated with : instrum_function.m
%%% see Aa_my_WLS100_inversion_procedure.m to understand the order of the
%%% procedure in matlab 
%%% media/Transcend/Elena_ULCO/MultiAngleApproach/Maksimovich_resume.tex
%%% describes the equations and the logic of my procedure 
%%% to retrieve the instrumental function, see "result_instr_func.m"


%%% CONTROL ij  !!! for Aug - Nov 2013  _ OR _ for JULY 2014 ?  
%%% ij :  see line ~ 80

clear all
close all

clear CF CT SK RAN RANG LIK KT JB U KR ME R RF SK GT rep azz 
clf (figure(1)) ;

cpt = 1;
rep=dir(['/./media/Transcend/Leosphere/WLS100/']);
 
tu = [19 59] ; % 1000m because when you plot V, there is a steep increase in V up to 1000m, and quite stable afterwards
epsilon = 10/log(10) ;

fichier =  cellstr({'WLS100S-9_2014_07_18__08_01_35_PPI.rtd'});
a = 0;
st_ij = 310 ; % starting ij when searching for a good ij containing given 'fichier'
fin_ij = length(rep); 

azz = [160 195] ; % choice of a part of PPI (azimutal angles)
% azz = [1 360] ;

loopme = 0 ; % dont plot PPI, RHI & DBS

colormap(jet) ;
JET= get(gcf,'colormap');

sdi = 59; % consider only the first 3000m
stats_all_PPI ; %% read and regroup the overall statistics for all PPI files we dispose

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% upload the rough data again and apply the filters (based on overall statistics) to this data
%%%%% calculate alpha for each good PPI

for ij = st_ij : fin_ij
    clear chemin1 list
    chemin1=(['/./media/Transcend/Leosphere/WLS100/' rep(ij).name '/']);
    list=dir([chemin1,'/*_PPI.rtd']);
    for L = 1 : length(list)
        if strcmp(cellstr(list(L).name) , fichier) == 1
            a = 1;
            break
        end
    end
    if a == 1
        break
    end
end

R = 100:50:3000 ;
RF(1,:) = RANGA(ij,L,:); % width of PDF (between 25% - 75%) at given distance R
SK(1,:) = SKA(ij,L,:);

GT(1,1:sdi) = 1;   
            
clf (figure(5)); clf (figure(8)) ;
f5 = figure(5)
plot(R,RF); hold on     % 25% - 75% range of all CNR(R),  for given PPI
plot(R,V,'r'); hold on  % "typical" 25% - 75% range of all CNR(R), units [dB] when comparing ALL PPI
set(f5,'Position',[50 500 560 420]);  

h8 = figure(8);
plot(R,S(1,:),'r'); hold on
plot(R,S(2,:),'k'); hold on
plot(R,S(3,:),'k'); hold on          
plot(R,SK,'b'); hold on
set(h8,'Position',[600 500 560 420]);  
            
GT(find(RF >= V)) = NaN; % more narrow PDF at given distance R than the typical width   
GT(find(SK >= S(2,:))) = NaN;
GT(find(SK <= S(3,:))) = NaN; % scanning distances with skewness within the corresponding typical range
GT(find(isnan(RF) | isnan(SK))) = NaN;
             
figure(8);
SSK = SK; SSK(find(isnan(GT))) = NaN;
plot(R,SSK,'b','linewidth',2); hold on                 
            
% if length(find(~isnan(GT(tu(1) : tu(2))))) > 10 
% 
%      lli = length(list(L).name)-13 ;
%      list1=dir([chemin1, list(L).name(1:lli),'*_RHI.rtd']); 
% 
%      if cpt <= 64
          RGB=JET(cpt,:) ; 
%      elseif  cpt > 64 & cpt <= 128
%           RGB=JET(cpt-64,:) ;
%      elseif cpt > 128 & cpt <= 192
%           RGB=JET(cpt-128,:) ;
%      elseif cpt > 192 & cpt <= 257
%           RGB=JET(cpt-192,:) ;
%      else cpt > 257
%           RGB=JET(cpt-257,:) ;
%      end
    ij
    L
    clear chemin1 list
    chemin1=(['/./media/Transcend/Leosphere/WLS100/' rep(ij).name '/']);
    list=dir([chemin1,'/*_PPI.rtd']);
    fichier = cellstr(list(L).name);
            
     wls_sub_PPI_1 ; % upload and plot original PPI CNR data     
                     
     clear ccnr MN MMN dad
     ccnr = cnr(:, 1 : sdi); % PPI
     ccnr(find(ccnr >= 0)) = NaN; % do not consider the areas with zero CNR 
     ccnr(find(ccnr <= -27)) = NaN; % do not consider the areas with too low signal

     %%%% remove those distances where the statistics are out of the typical vales
%      ccnr(:,find(isnan(GT))) = NaN ;                  

     for d = 1 : sdi; 
%          clear PRCV
%          PRCV = prctile(ccnr(:,d) ,[5 99]) ;  % lower 2.5% and upper 99% percentiles of the distribution  of CNR, not corrected by anything   
%          ccnr(find(ccnr(:,d) < PRCV(1) | ccnr(:,d) > PRCV(2)),d) = NaN ;     
         dad(:,d) = plus(ccnr(:,d)./epsilon ,  2*log(r_0(1,d)));
         MN(d) = nanmean(dad(azz(1):azz(2),d)); % best estimate of CNR(R)
     end               

     %%% delta (mean(CNR)) = mean CNR(R1) minus mean CNR(R2)
     clear M N K KN rad B BINT R RINT STATS XM 

     M(:,1) = minus(MN(1:58),MN(2:59)); % best estimate of CNR(R) = mean CNR(R)   
     KN(1,:)  = exp(nanmoving_average(M,3)); % plus minus 3 CNR values on eigther side
         
      %%% keep cnr data only within those distances where (delta cnr) is const, where the 5-point derivative of exp(delta CNR) is close to zero

      %%% automatic analysis of the shape of exp(delta CNR)                   
      %%% calculate the derivative using a 5 point method
      clear e GZ GGZ ae; 
      for e = 3 : 56
                GZ(1,e) = plus(minus(KN(e-2),8*KN(e-1)),minus(8*KN(e+1),KN(e+2)) )/(12*50); % 50 meter distance between two neighbouring CNR values   
      end

      GZ(1,1) = (minus(KN(2),KN(1)))/50;
      GZ(1,2) = (minus(KN(3),KN(1)))/100;
      GZ(1,57) = (minus(KN(58),KN(56)))/100;
      GZ(1,58) = (minus(KN(58),KN(57)))/50;
                  
      KN(find(abs(GZ) > 0.0001)) = NaN; % remove those scaning distances where the derivative is large    
      GZ(find(abs(GZ) > 0.0001)) = NaN;                   
                   
      figure(1)  ;   
      for w = 1 : size(dad,1)
          plot(r_0(1,1:sdi),dad(w,:),'color','k'); hold on;
      end
      plot(r_0(1,1:sdi),MN,'color','r','linewidth',2); 
      grid on           
      ylabel(['(10/ln(10) * CNR) + 2lnR'],'color','k');
      xlabel([' scanning distance R [meters]'],'color','k');
%                   set(h2,'Position',[1200 54 560 420]);   
                  
      if length(find(~isnan(GZ))) < 3
            continue % L loop
      end                 

      ae = find(KN == nanmax(KN(1:55))) ; % at which scanning distance we have the peak of delta CNR
      al = nanmean(KN(ae-3 : ae+3)); % allow a range of distances around the peak of delta CNR

      GZ(find(KN < al)) = NaN ; % remove all those distances with weaker KN
                
      if isempty(min(find(~isnan(GZ)))) |  isempty(max(find(~isnan(GZ)))) | r_0(1,min(find(~isnan(GZ)))) ==  r_0(1,max(find(~isnan(GZ)))) | length(find(~isnan(GZ))) < 3
          continue % L loop
      end

      if r_0(1,min(find(~isnan(GZ)))) >= 1000 
            ah(1) = r_0(1,min(find(~isnan(GZ))));
      end

      if max(find(~isnan(GZ))) < 57                        
            ah(2) = r_0(1,max(find(~isnan(GZ)))+1);
      else 
            ah(2) = 2900;
      end

%       re(cpt,:) = [ij, L, ah(1), ah(2), min(find(~isnan(GZ))),max(find(~isnan(GZ)))+1]       
          
       %%%%%%% slope method (alternative the the multi-angle approach)
       clear y x y1 x1 xx yy Y XX B BINT R RINT STATS reg offs reg_err offs_err alpha ERR FM FM_ERR HT N XN YN a z zz
       clear ad_range ad_seuil af ans compteur crh ct d h1 CM RM
       %%%% clear CFA CTA GA JBA KN KRA KTA LIKA

       y = dad(azz(1):azz(2),:) ; % CNR record (corrected by 2ln(R), epsilon, lower 5% & upper 1% tails), see line 145
       x = r_0(azz(1):azz(2),1:sdi) ;
       MMN = MN;
       MN(find(x(1,1:sdi) < ah(1) | x(1,1:sdi) > ah(2))) = NaN;

       y(find(x(:,1:sdi) < ah(1) | x(:,1:sdi) > ah(2))) = NaN; % cnr corrected by epsilon and 2lnR and filtered out by 5% and 1% tails
       x(find(x(:,1:sdi) < ah(1) | x(:,1:sdi) > ah(2))) = NaN; % R
       
       ft = 1 ;
       nt = 1;
       
       for i = 1 : sdi - 2
            clear M N
            M = minus(y(:,1:sdi-i),y(:,1+i:sdi)); % delta (mean CNR(R)) over the same (important!) scanning ray !    
            N = minus(x(:,1:sdi-i),x(:,1+i:sdi)); % corresponding delta R
            Y(ft : ft + length(find(~isnan(M)))-1,1) = M(find(~isnan(M)));
            XX(ft : ft + length(find(~isnan(M)))-1,2) = N(find(~isnan(M)));
            ft = ft + length(find(~isnan(M))) ;
            
            CM(nt:nt+length(1:sdi-i)-1,1) = minus(MN(1,1:sdi-i),MN(1,1+i:sdi)) ;
            RM(nt:nt+length(1:sdi-i)-1,1) = minus(r_0(1,1:sdi-i),r_0(1,1+i:sdi)) ;
            nt = nt + length(1:sdi-i);
            
            if length(find(~isnan(M))) == 0 % to reduce the calculation time                            
                    break % i loop
            end
       end
       
       %%% ave cnr profile 
       YM(:,1) = CM(find(~isnan(CM)));
       XM(:,2) = RM(find(~isnan(CM)));
       XM(:,1) = 1;
       [B,BINT,R,RINT,STATS] = regress(YM,XM,0.01);
       reg1 = B(2)/(-2) % angle of the linear fit
       offs1 = B(1); % the free coefficient "b" of the linear fit
       reg_err1 = BINT(2,:)/(-2);
       offs_err1 = BINT(1,:);
       
       %%% all cnr values
       clear B BINT R RINT STATS
       XX(:,1) = 1;
       [B,BINT,R,RINT,STATS] = regress(Y,XX,0.01);
       reg = B(2)/(-2) % angle of the linear fit
       offs = B(1); % the free coefficient "b" of the linear fit
       reg_err = BINT(2,:)/(-2);
       offs_err = BINT(1,:);

       clf (figure(4));
       h1 = figure(4) ;
       set(h1,'Position',[561 54 560 420]); 
       grid on             
       scatter(XX(:,2),Y); hold on ;
       plot(XX(:,2), -2*XX(:,2)*reg + offs,'r'); hold on;
       
       scatter(XM(:,2),YM,'markerfacecolor','k','linewidth',2); hold on ;
       plot(XM(:,2), -2*XM(:,2)*reg1 + offs1,'g','linewidth',2); hold on;
      % title({['slope method, dist : ' num2str(ah(1)) ' - '  num2str(ah(2)) ' m']});
       ylabel([' delta CNR(R) along the same scanning ray'],'color','k');
       xlabel([' scanning distance R [meters]'],'color','k');
       grid on ; box on    
       
        clf (figure(7)) ;
        h3 = figure(7) ;
        plot(100:50:3000,MN,'color',[RGB(1),RGB(2),RGB(3)]); hold on
        set(h3,'Position',[10 54 560 420]); 

%                           clf (figure(5)) ;
%                           h1 = figure(5)  ;               
%                           plot(r_0(1,2:59),KN,'color','k'); %[RGB(1),RGB(2),RGB(3)]); %
%                           hold on                          
%                           set(h1,'Position',[600 600 560 420]); 
%                           grid on             
%                           title('exp^{(delta(mean(CNR(R))))} = F(R1)/F(R2) * exp(-2*alpha*50m)');
%                           ylabel([' exp^{CNR(R1) - CNR(R2)}'],'color','k');
%                           xlabel([' scanning distance R [meters]'],'color','k');
%                           ylim([0.9 1.1]);
%                        
       SM(1,:) = [ij L reg_err(2) reg reg_err(1) offs offs_err ah];  

       %%% illustrate the shape of the instrumental function

%        clear un
%        un = figure(25) ;
%        set(un,'Position',[1200 600 560 420]);
       clear x y FFR FT MN
       MN = MMN ;
       FR(1,:) = exp(plus(MN,2*reg1*r_0(1,1:sdi))) ; % best estimate of CNR plus 2*alpha*R
%        FR(2,:) = exp(plus(MN,2*reg_err(1)*r_0(1,1:sdi))) ; % best estimate of CNR plus 2*alpha*R     
%        FR(3,:) = exp(plus(MN,2*reg_err(2)*r_0(1,1:sdi))) ; % best estimate of CNR plus 2*alpha*R       
%        FR(:,find(isnan(GT))) = NaN;

       
       y = dad(azz(1):azz(2),:) ; % CNR record (corrected by 2ln(R), epsilon, lower 5% & upper 1% tails), see line 145
       x = r_0(azz(1):azz(2),1:sdi); 
       FFR(:,:,1) = exp(plus(y,2*reg1*x)) ; % best estimate of CNR plus 2*alpha*R
       FFR(:,:,2) = exp(plus(y,2*reg_err1(1)*x)) ; % best estimate of CNR plus 2*alpha*R     
       FFR(:,:,3) = exp(plus(y,2*reg_err1(2)*x)) ; % best estimate of CNR plus 2*alpha*R 

       for d = 1 :sdi
       FT(1,d) = nanmin(nanmin(FFR(:,d,1)));
       FT(2,d) = nanmax(nanmax(FFR(:,d,1)));
       end
       
% load(['/media/Transcend/Elena_ULCO/my_matlab_data/FKBref_2355PPI.mat']); %'KB','IF'
KBR =  nanmean(FR(find(r_0(1,1:sdi) >= ah(1) & r_0(1,1:sdi) <= ah(2))));

%%
clf (figure(9)); clf (figure(7)); clf (figure(10)); clf (figure(11))
clear CNR x al of

get(figure(7));
% scatter(X,Y/KBR,'Marker','o','MarkerFaceColor','k','MarkerEdgeColor','none'); hold on ;
scatter(100:50:3000,FR(1,:)./KBR,'Marker','o','MarkerFaceColor','r','MarkerEdgeColor','none'); hold on ;
scatter(100:50:3000,FT(1,:)./KBR,'Marker','o','MarkerFaceColor','k','MarkerEdgeColor','none'); hold on ;
scatter(100:50:3000,FT(2,:)./KBR,'Marker','o','MarkerFaceColor','k','MarkerEdgeColor','none'); hold on ;
grid on ; box on
xlabel(' scanning distance R [meters]','color','k');
ylabel('Instrumental Function F(R)','color','k')
% title('F(R) for 235 PPI in red and corresponding uncertainty in black')
ylim([0 1.4]); 
xlim([0 3000]); 


%%% chose good scans (within one PPI) out of 360 scans available

F = nanmoving_average(FR./KBR,2);
F(25:59) = nanmean(F(25:45)) ;
get(figure(7));
plot(100:50:3000,F,'g','linewidth',2); hold on
x(:,2) = r_0(1,1:sdi) ;
x(:,1) = 1;

figure(6); hold on

for i = 1 : size(ccnr,1)
    clear B
    CNR(i,:) = minus(plus(ccnr(i,:)./epsilon ,  2*log(r_0(1,1:sdi))), log(F));
    B = regress(CNR(i,:)',x,0.01);
    al(i,1:sdi) = B(2)/(-2) ; % angle of the linear fit
    of(i,1:sdi) = B(1); % offset
    plot(100:50:3000,CNR(i,:),'k','linewidth',1); hold on
    
end
grid on; box on;

al(find(isnan(CNR))) = NaN;
of(find(isnan(CNR))) = NaN;

cf =  figure(9) ;
set(cf,'Position',[1 554 560 420]); 
surf(d1(:,1:sdi),z1(:,1:sdi),CNR,'EdgeLighting','phong','LineStyle','none'); 
view(0,90);
caxis([nanmin(nanmin(CNR))+2 nanmax(nanmax(CNR))-4]);
axis equal;
xlabel(['     Range West / East ', '(m)']);
ylabel(['     Range South / North ', '(m)']);
xlim([-max_range1 max_range1]);%complet
ylim([-max_range1 max_range1]);%complet
hold on; box on; grid off; colorbar;

cf =  figure(10) ;
set(cf,'Position',[1 554 560 420]); 
surf(d1(:,1:sdi),z1(:,1:sdi),al,'EdgeLighting','phong','LineStyle','none'); 
view(0,90);
caxis([0.00014 0.00023]);
axis equal;
xlabel(['     Range West / East ', '(m)']);
ylabel(['     Range South / North ', '(m)']);
xlim([-max_range1 max_range1]);%complet
ylim([-max_range1 max_range1]);%complet
hold on; box on; grid off; colorbar;

cf =  figure(11) ;
set(cf,'Position',[1 554 560 420]); 
surf(d1(:,1:sdi),z1(:,1:sdi),of,'EdgeLighting','phong','LineStyle','none'); 
view(0,90);
caxis([10 11]);
axis equal;
xlabel(['     Range West / East ', '(m)']);
ylabel(['     Range South / North ', '(m)']);
xlim([-max_range1 max_range1]);%complet
ylim([-max_range1 max_range1]);%complet
hold on; box on; grid off; colorbar;

keyboard
%%% find the most probable Lidar Ratio
for sig = 10:5:100
%    clear X B,BINT R RINT STATS
%    X = log(reg1/sig) 
%    [B,BINT,R,RINT,STATS]=regress(y,X,0.05);
%  	%  B = intercept and the coef for the trend
%  	%  BINT = conf intervals for the coefficients B
%  	%  R =  vector of residuals: reality minus thelinear model
%  	%  RINT = vector of confidence intervals for the residuals
%  	%  STATS = r-square, f-stat, p-value
%  	TR(i,1:2)=B;
%  	TR(i,3:4)=BINT(2,:);
%  	TR(i,5:7)=STATS(1,1:3);
%  	TR(i,8)=sqrt(sum(R.^2)/18); % RMSE

end

%%% the upcoming scripts : 
%%% result_instr_func ; % to calculate instrumental function
%%% result_instr_func_allbestPPI.m  % to calculate instrumental function

%%% to apply F(R), the smallest K*beta(ref) and alpha(n) to all PPI
% wls_PPI_loop_2

%                          clf (figure(5)) ;
%                          h1 = figure(5)  ;               
%                          plot(r_0(1,2:59),KN,'color',[RGB(1),RGB(2),RGB(3)]); % 'k'); 
%                          hold on
%                          ylim([0.9 1.1]);
%                          set(h1,'Position',[1 54 560 420]); 
%                          grid on             
%                          title('exp^{(delta(mean(CNR(R))))} = F(R1)/F(R2) * exp(-2*alpha*50m)');
%                          ylabel([' exp^{(delta(mean(CNR(R))))}'],'color','k');
%                          xlabel([' scanning distance R [meters]'],'color','k'); 


