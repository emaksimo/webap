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

rep=dir(['/./media/Transcend/Leosphere/WLS100/']);
%%% ij = 3 : length(rep) %% directory counter where the PPI files are stored
 
loopme = 0 ;
sdi = 59; % consider only the first 3000m

bn = 2000; % arbitrary length of each ij file
cpt = 1;
colormap(jet) ;
JET= get(gcf,'colormap');
clf (figure(1)) ;

list = dir(['/media/Transcend/Elena_ULCO/my_matlab_data/CNR_stats*']);  

CFA = NaN([length(rep)-2 max(bn) sdi]); CTA = CFA; SKA = CFA; RANA = CFA; RANGA = CFA; LIKA = CFA; KTA = CFA; JBA = CFA; KRA = CFA;
%%% spatial resolution was changed for ij = 21 and afterwards

for ij = 3 : length(rep) % file counter, where each file corresponds to some directory containing many PPI files
        clear CF CT SK RAN RANG LIK KT JB S U V KR peak_alpha a1 a2       
        a1 = exist(['/media/Transcend/Elena_ULCO/my_matlab_data/CNR_stats_std_range_maxliklihood_ktest_allPPI_' num2str(ij-2) '.mat']) == 2;
        a2 = exist(['/media/Transcend/Elena_ULCO/my_matlab_data/CNR_stats_std_range_maxliklihood_ktest_allPPI_0' num2str(ij-2) '.mat']) == 2;
        
        if a1 == 0 & a2 == 0
                continue
        elseif a1 == 1
                load(['/media/Transcend/Elena_ULCO/my_matlab_data/CNR_stats_std_range_maxliklihood_ktest_allPPI_' num2str(ij-2) '.mat']);  
        elseif a2 == 1
                load(['/media/Transcend/Elena_ULCO/my_matlab_data/CNR_stats_std_range_maxliklihood_ktest_allPPI_0' num2str(ij-2) '.mat']);      
        end
                
%         CFA(ij,1:size(CF,1),1:size(CF,2)) = CF ; % std before remoing <5% and > 95%  
%         LIKA(ij,1:size(CF,1),1:size(CF,2)) = LIK ; % most expected CNR = test estimate at each R, each PPI
%         MEA(ij,1:size(CF,1),1:size(CF,2)) = ME ; % mean of all CNR(R)
%         CTA(ij,1:size(CF,1),1:size(CF,2)) = CT ; % std after remoing <5% and > 95%    
%         RANA(ij,1:size(CF,1),1:size(CF,2)) = RAN ; % range = max - min of all CNR values at given R 
        RANGA(ij-2,1:size(CF,1),1:size(CF,2)) = RANG ; % interquartile range
        SKA(ij-2,1:size(CF,1),1:size(CF,2)) = SK ; % skewness  if the distribution is inclinated
%         KRA(ij,1:size(CF,1),1:size(CF,2)) = KR ; % kurtosis
%         KTA(ij,1:size(CF,1),1:size(CF,2)) = KT ; % kstest : when normal distrib = 0
%         JBA(ij,1:size(CF,1),1:size(CF,2)) = JB ; % jbtest : when normal distrib = 0     
end

RANGA(find(RANGA == 0 )) = NaN; % range can't be zero!
SKA(find(RANGA == 0 )) = NaN;

for d = 1 : sdi % at each scanning distance R
%         U(1,d) = nanmean(reshape(KRA(:,:,d),[size(RANA,1)*size(RANA,2) 1])); % typical kurtosis    
        S(1,d) = nanmean(reshape(SKA(:,:,d),[size(RANA,1)*size(RANA,2) 1])); % typical skewness 
        S(2,d) = S(1,d) + nanstd(reshape(SKA(:,:,d),[size(RANA,1)*size(RANA,2) 1])); % typical skewness 
        S(3,d) = S(1,d) - nanstd(reshape(SKA(:,:,d),[size(RANA,1)*size(RANA,2) 1])); % typical skewness 
        
        V(1,d) = nanmean(reshape(RANGA(:,:,d),[size(RANA,1)*size(RANA,2) 1])); % typical inter-quartile range
%         MI(1,d) = nanmin(reshape(RANA(:,:,d),[size(RANA,1)*size(RANA,2) 1]));
%         MA(1,d) = nanmax(reshape(RANA(:,:,d),[size(RANA,1)*size(RANA,2) 1]));
end

clear CF CT SK RAN RANG LIK KT JB U KR ME


% plot(R,MI,'k'); hold on
% plot(R,MA,'k'); hold on
% xlabel([' scanning distance R [meters]'],'color','k');
% ylabel([' 25% - 75% range of all CNR(R), units [dB]'],'color','k');
% title({['The shape of PDF using 360 CNR(same R) values of each PPI is examined'];['25% quartile (min) vs 75% (max) reflect the thickness of PDF distirution at each distance R'];['small range (25% vs 75%) = homogeneous atmosphere']});

% ylabel([' total spread of PDF(all 360 CNR(R))'],'color','k');
% title({['The shape of PDF using 360 CNR(same R) values of each PPI is examined'];['MIN vs MAX reflect the thickness of PDF distirution at each distance R'];['small range = likely homogeneous atmosphere']});


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% upload the rough data again and apply the filters (based on overall statistics) to this data
%%%%% calculate alpha for each good PPI
% tu = [35 49] ; % 1800 - 2500m distances under examination
tu = [19 59] ; % 1000m because when you plot V, there is a steep increase in V up to 1000m, and quite stable afterwards
epsilon = 10/log(10) ;

for ij = 3 : length(rep) % directories with PPI files
% for ij = (length(rep) - 2) : length(rep) 
%         ij = 30  ;
    
        clear chemin1 list
        chemin1=(['/./media/Transcend/Leosphere/WLS100/' rep(ij).name '/']);
        list=dir([chemin1,'/*_PPI.rtd']);
            
        for L = 1 : size(list,1)   
            clear R N e1 e2 fichier lli list1 af fichier_rhi RF GT SK M MN st RGB cnr hv hk hh ah   
            R = 100:50:3000 ;
            RF(1,:) = RANGA(ij-2,L,:); % width of PDF (between 25% - 75%) at given distance R
            SK(1,:) = SKA(ij-2,L,:);
            
            if length(find(~isnan(RF))) < 1
                continue
            end
            
            GT(1,1:sdi) = 1;   
            
%             clf (figure(5)); clf (figure(8)) ;
%             f5 = figure(5)
%             plot(R,RF); hold on     % 25% - 75% range of all CNR(R),  for given PPI
%             plot(R,V,'r'); hold on  % "typical" 25% - 75% range of all CNR(R), units [dB] when comparing ALL PPI
%             set(f5,'Position',[50 500 560 420]);  
% 
%             h8 = figure(8);
%             plot(R,S(1,:),'r'); hold on
%             plot(R,S(2,:),'k'); hold on
%             plot(R,S(3,:),'k'); hold on          
%             plot(R,SK,'b'); hold on
%             set(h8,'Position',[600 500 560 420]);  
         
            GT(find(RF >= V)) = NaN; % more narrow PDF at given distance R than the typical width   
            GT(find(SK >= S(2,:))) = NaN;
            GT(find(SK <= S(3,:))) = NaN; % scanning distances with skewness within the corresponding typical range
            GT(find(isnan(RF) & isnan(SK))) = NaN;
             
%             figure(8);
%             SSK = SK; SSK(find(isnan(GT))) = NaN;
%             plot(R,SSK,'b','linewidth',2); hold on                 
            
            fichier = cellstr(list(L).name) ; % PPI file           
            
            if length(find(~isnan(GT(tu(1) : tu(2))))) > 10 
%             if length(e1) == length(tu(1):tu(2)) & nanmax(abs(reshape(SKA(ij-2,L,e1+tu(1)),[length(e1) 1]))) < 0.6 % skewness is weak     
                
                 lli = length(list(L).name)-13 ;
                 list1=dir([chemin1, list(L).name(1:lli),'*_RHI.rtd']); 
                 
                 for it = 1 : length(list1) % the time (minute of the hour) when the observation started
                        st(it) = str2num(list1(it).name(length(list1(it).name)-12 : length(list1(it).name)-11)) ;
                 end
                 
                 for fg = 1 : 40 % several RHI files exist within given hour (we take the one that is the closest in time)
                        %%% fg is the number of minutes between the CNR record and RHI record
%                         [str2num(list(L).name(length(list(L).name)-12:length(list(L).name)-11)) + fg, str2num(list(L).name(length(list(L).name)-12:length(list(L).name)-11)) - fg ]
                        af = find(st <= str2num(list(L).name(length(list(L).name)-12:length(list(L).name)-11)) + fg & st >= str2num(list(L).name(length(list(L).name)-12:length(list(L).name)-11)) - fg ) ;                    
                        if length(af) == 1 % as soon as corresponding wind file is found, stop the search loop                                
                                fichier_rhi = cellstr(list1(af).name) ;
                                wls_sub_RHI_1 ;  %%% check the vertical symmetry within the lowest 300m  
                                hv = nanmean(cnr(89:91,1:5));
                                for ei = 5 : 15 : 85 % azimuthal angle in vertical (RHI) plane, in [deg]
                                        clear crh C1 C2 C
                                        crh = min(find(z1(ei,:) > 300)); % critical height == up to 300m, where we should check the symmetry
                                        C1 = nanmean(cnr(ei-1:ei+1,1:crh),1); % compare only those RHI CNR measurements below 300m
                                        C2 = nanmean(cnr(size(el,1)-ei-1 : size(el,1)-ei+1, 1:crh),1);
                                        C = abs(minus(C2,C1)) ; 
                                        %%% if more than 3 CNR values at the same altitude, same angle, same scanning distance differ so much !
                                        if length(find(C > 2)) > 3 
%                                                 disp('RHI check failed') 
                                                clear C1 C2 crh af ans el
                                                break  % ei loop                             
                                        end                                
                                end                              
                                break % fg
                        end                         
                 end
                 
                 if exist('C') ~= 1 | length(find(C > 2)) > 3 % if not symmetric vertically within the lowest 300m
                        clear C ei          
                        continue % L loop
                 end
                
%                  if cpt <= 64
%                       RGB=JET(cpt,:) ; 
%                  elseif  cpt > 64 & cpt <= 128
%                       RGB=JET(cpt-64,:) ;
%                  elseif cpt > 128 & cpt <= 192
%                       RGB=JET(cpt-128,:) ;
%                  elseif cpt > 192 & cpt <= 257
%                       RGB=JET(cpt-192,:) ;
%                  else cpt > 257
%                       RGB=JET(cpt-257,:) ;
%                  end
                 
                 wls_sub_PPI_1 ; % upload and plot original PPI CNR data     
                 if size(cnr,1) ~= 360 | size(r_0,1) ~= 360
                     continue % L loop
                 end
                     
                 clear ccnr MN dad
                 ccnr = cnr(:, 1 : sdi); % PPI
                 ccnr(find(ccnr >= 0)) = NaN; % do not consider the areas with zero CNR 
                 ccnr(find(ccnr <= -27)) = NaN; % do not consider the areas with too low signal
                        
                 %%%% remove those distances where the statistics are out of the typical vales
                 ccnr(:,find(isnan(GT))) = NaN ;                  
                 
                 for d = 1 : sdi; 
                     clear PRCV
                     PRCV = prctile(ccnr(:,d) ,[5 99]) ;  % lower 2.5% and upper 99% percentiles of the distribution  of CNR, not corrected by anything   
                     ccnr(find(ccnr(:,d) < PRCV(1) | ccnr(:,d) > PRCV(2)),d) = NaN ;     
                     dad(:,d) = plus(ccnr(:,d)./epsilon ,  2*log(r_0(1,d)));
                     MN(1,d) = nanmean(dad(:,d)); % best estimate of CNR(R)
                 end               

                 hh = nanmean(ccnr(:,1:5)); % PPI
                 hk = minus(hh,hv); % hv is the layer-average CNR of the first 5 distances in vertical direction
                 
                 if max(abs(hk)) > 2                     
%                      display(['skipping ij = ' num2str(ij) ', L = ' num2str(L) ' vertically nonuniform below 300m'])
%                       fichier 
                     continue % L loop
                 end                       

%                %%%% smoothen neighbouring "tirs"
%                clear K
%                for d = 1 : size(dad,2)
%                     K(:,d) = nanmoving_average(dad(:,d),1);
%                end                   
%                K(1:2,:) = NaN;
%                K(359:360,:) = NaN;
% 
%                clf (figure(7));
%                figure(7)
%                surf(d1,z1,K,'EdgeLighting','phong','LineStyle','none'); 
%                colorbar
%                view(0,90);
%                caxis([7 11.5]);   

                 %%% delta (mean(CNR)) = mean CNR(R1) minus mean CNR(R2)
                 clear M N K KN rad
                 M(:,1) = minus(MN(1:58),MN(2:59)); % best estimate of CNR(R) = mean CNR(R)                 
                 KN(1,:)  = exp(nanmoving_average(M,3)); % plus minus 3 CNR values on eigther side

%                          clf (figure(9)) ;
%                          h9 = figure(9) ;             
%                          set(h9,'Position',[570 554 560 230]);
%                          subplot('Position',[0.1 0.15 0.89 0.84]);
%                          plot(100:50:3000,reshape(LIKA(ij-2,L,:),[59 1]),'color','k','linewidth',2); hold on
%                          ylim([7 11.5]);
%                          xlim([100 3000]);
%                          grid on
%                          ylabel([' peak value of 360 CNR(R)'],'color','k');
%                          xlabel([' scanning distance R [meters]'],'color','k');  

                  %%% automatic analysis of the shape of exp(delta CNR)                     
                  %%% calculate the first derivative using a 5 point method
                  clear e GZ GGZ ae; 
                  for e = 3 : 56
                            GZ(1,e) = plus(minus(KN(e-2),8*KN(e-1)),minus(8*KN(e+1),KN(e+2)) )/(12*50); % 50 meter distance between two neighbouring CNR values   
                  end
                  
                  GZ(1,1) = (minus(KN(2),KN(1)))/50;
                  GZ(1,2) = (minus(KN(3),KN(1)))/100;
                  GZ(1,57) = (minus(KN(58),KN(56)))/100;
                  GZ(1,58) = (minus(KN(58),KN(57)))/50;
                  
                  %%% keep cnr data only within those distances where (delta cnr) is const, where the 5-point derivative of exp(delta CNR) is close to zero
                  KN(find(abs(GZ) > 0.0001)) = NaN; % remove those scaning distances where the derivative is large    
                  GZ(find(abs(GZ) > 0.0001)) = NaN;                   
                   
%                   figure(3)  ;               
%                   plot(r_0(1,2:59),GZ,'color','k'); %[RGB(1),RGB(2),RGB(3)]); %
%                   set(h2,'Position',[1200 54 560 420]);   
                  
                  if length(find(~isnan(GZ))) < 3
                        continue % L loop
                  end                 
                  
                  ae = find(KN == nanmax(KN(1:55))) ; % at which scanning distance we have the peak of delta CNR
                  al = nanmean(KN(ae-3 : ae+3)); % allow a range of distances around the peak of delta CNR

                  GZ(find(KN < al)) = NaN ; % remove all those distances with weaker KN
                  
%                   h2 = figure(3)  ;               
%                   plot(r_0(1,2:59),GZ,'color','g'); hold on
                   
                  if isempty(min(find(~isnan(GZ)))) |  isempty(max(find(~isnan(GZ)))) | r_0(1,min(find(~isnan(GZ)))) ==  r_0(1,max(find(~isnan(GZ)))) | length(find(~isnan(GZ))) < 3
                      continue % L loop
                  end
                 
                  if r_0(1,min(find(~isnan(GZ)))) >= 1000 
                        ah(1) = r_0(1,min(find(~isnan(GZ))));
                  else
                      continue % L loop
                  end
                   
                  if max(find(~isnan(GZ))) < 57                        
                        ah(2) = r_0(1,max(find(~isnan(GZ)))+1);
                  else 
                        ah(2) = 2900;
                  end
                   
%                   re(cpt,:) = [ij, L, ah(1), ah(2), min(find(~isnan(GZ))),max(find(~isnan(GZ)))+1]
                  
                  %%%%%% apply multi-angle approach
 %                    clear BI distance dist fi CS Y1 AZI d2 z2 ah
 %                    BI = nan([size(dad,1) length(100:5:3000)]) ;
 %                    distance = BI ;
 %                    AZI = BI ;
 %                    CS = BI ;
 %                    fi = BI ;
                   
%                    for i = 1 : size(dad,1) ;
%                         BI(i,:) = interp1(r_0(1,:),dad(i,:),100:5:3000); % cnr without lower 5 and upper 1% tails 
%                         distance(i,:) = interp1(r_0(1,:),r_0(1,:),100:5:3000); % scanning distance
%                         AZI(i,1:size(BI,2)) = az(i,1); % azimut of new values is the same of the original CNR profile!
%                         CS(i,1:size(BI,2)) = cosd(az(i,1));                        
%                         
%                         d2(i,:)=distance(i,:).*sind(az(i,1)) ; % projection of R on OX
%                         z2(i,:)=distance(i,:).*cosd(az(i,1)) ; % projection of R on OY  
%                    end
%                    fi = z2 ;
%                    CS = abs(CS) ; % so we have two times more data at distance = dist(d)    
%                    fi = abs(fi) ;
%                    dist =  min(min(fi)) : 10 :  max(max(fi)) ;  

%                    clf (figure(6));
%                    figure(6)
%                    surf(d2,z2,BI,'EdgeLighting','phong','LineStyle','none'); 
%                    colorbar
%                    view(0,90);
%                    caxis([7 11.5]);           
                            
%                    BI(find(distance < ah(1) | distance > ah(2))) = NaN; % cnr data (corrected by epsilon and 2lnR)
                    
%                    loopme = 1; % plott scatter plots for each distance "d"
%                    multi_angle_method_Pabs_vs_CosTeta
               
                   %%%%%%% slope method (alternative the the multi-angle approach)
                   clear y x y1 x1 xx yy Y XX B BINT R RINT STATS reg offs reg_err offs_err alpha ERR FM FM_ERR HT N XN YN a z zz
                   clear ad_range ad_seuil af ans compteur crh ct d h1 YM XM YMY XMX
                   %%%% clear CFA CTA GA JBA KN KRA KTA LIKA
                   
                   y = dad ; % CNR record (corrected by 2ln(R), epsilon, lower 5% & upper 1% tails), see line 145
                   x = r_0(:,1:sdi) ;
                   YMY = NaN; XMX = NaN;
                   
                   y(find(r_0(:,1:sdi) < ah(1) | r_0(:,1:sdi) > ah(2))) = NaN; % cnr corrected by epsilon and 2lnR and filtered out by 5% and 1% tails
                   x(find(r_0(:,1:sdi) < ah(1) | r_0(:,1:sdi) > ah(2))) = NaN; % R
                   ft = 1 ;
                   
                   for i = 1 : sdi - 2
                        clear M N
                        M = minus(y(:,1:sdi-i),y(:,1+i:sdi)); % delta CNR(R) over the same (important!) scanning ray !    
                        if length(find(~isnan(M))) == 0 % to reduce the calculation time                            
                                break % i loop
                        end 
                        
                        N = minus(x(:,1:sdi-i),x(:,1+i:sdi)); % corresponding delta R
                        Y(ft : ft + length(find(~isnan(M)))-1,1) = M(find(~isnan(M))); % delta CNR(R) 
                        XX(ft : ft + length(find(~isnan(M)))-1,2) = N(find(~isnan(M))); % delta R
                        ft = ft + length(find(~isnan(M))) ;
                        
                        YMY((length(YMY)+1) : (length(YMY) + sdi-i),1) = minus(MN(1,1:sdi-i),MN(1,1+i:sdi)); % delta (mean CNR(R))
                        XMX((length(YMY)+1) : (length(YMY) + sdi-i),1) = minus(r_0(1,1:sdi-i),r_0(1,1+i:sdi)); % delta R
                   end
                   
                   XX(:,1) = 1;
                   
                   YM(:,1) = YMY(find(~isnan(YMY))) ;
                   XM(:,2) = XMX(find(~isnan(YMY))) ;
                   XM(:,1) = 1;
                   
                   [B,BINT,R,RINT,STATS] = regress(Y,XX,0.01); % delta CNR(R) for each given azimuth
                   reg = B(2)/(-2); % angle of the linear fit
                   offs = B(1); % the free coefficient "b" of the linear fit
                   reg_err = BINT(2,:)/(-2);
                   offs_err = BINT(1,:);

                   clear B BINT R RINT STATS reg1 offs1 reg_err1 offs_err1
                   [B,BINT,R,RINT,STATS] = regress(YM,XM,0.01); % delta (mean CNR(R, all azim))
                   reg1 = B(2)/(-2); % angle of the linear fit
                   offs1 = B(1); % the free coefficient "b" of the linear fit
                   reg_err1 = BINT(2,:)/(-2);
                   offs_err1 = BINT(1,:);
                   
%                    clf (figure(4));
%                    h1 = figure(4) ;
%                    set(h1,'Position',[561 54 560 420]); 
%                    grid on             
%                    scatter(XX(:,2),Y); hold on ;

%                    plot(XX(:,2),XX(:,2)*B(2)+B(1),'r'); hold on;
%                    title({['slope method, dist : ' num2str(ah(1)) ' - '  num2str(ah(2)) ' m']});
%                    ylabel([' delta CNR(R) along the same scanning ray'],'color','k');
%                    xlabel([' scanning distance R [meters]'],'color','k');

                   if reg > 0
                       
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
                           SM(cpt,:) = [ij L reg_err(2) reg reg_err(1) offs offs_err ah reg_err1(2) reg1 reg_err1(1)];  
                           
                           [ij L]
                           %%% illustrate the shape of the instrumental function

%                            h3 = figure(7) ;
%                            plot(100:50:3000,MN,'color',[RGB(1),RGB(2),RGB(3)]); hold on
%                            set(h3,'Position',[10 54 560 420]); 
%                            
%                            
%                            un = figure(25) ;
%                            set(un,'Position',[1200 600 560 420]);
                           
                           FR(cpt,1:sdi) = NaN ;
%                            FR(cpt,re(cpt,5) : re(cpt,6)) = exp(plus(MN(re(cpt,5) : re(cpt,6)),2*reg*r_0(1,(re(cpt,5) : re(cpt,6))))) ; % best estimate of CNR plus 2*alpha*R
                           FR(cpt,:) = exp(plus(MN,2*reg*r_0(1,1:sdi))) ; % best estimate of CNR plus 2*alpha*R
                           FR(cpt,find(isnan(GT))) = NaN;
%                            
%                            plot(r_0(1,1:sdi),FR(cpt,:),'color',[RGB(1),RGB(2),RGB(3)]);  
%                            hold on
%                            grid on
%                            ylabel([' K*F(R)*beta(n)'],'color','k');
%                            xlabel([' scanning distance R [meters]'],'color','k');
%                            title({['Instrumental Function F(R) x K x unknown beta (indiv for each PPI)'];['K = instrumental constant']});

                           cpt = cpt + 1;
        %                    clf (figure(4)); clf (figure(8)); clf (figure(21));

%                  else  % if alpha < 0 !!!
%                          ah
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
                   end % if alpha > = < 0 !!! ??
            end  % criterias KRA, SKA, inter-quartile range              
        end % L
end % ij

if exist('SM','var') == 1
%%% year 2013
% save('/media/Transcend/Elena_ULCO/my_matlab_data/alpha_homogeneous_cases.mat','SM','FR'); 

%%% year 2014
% save('/media/Transcend/Elena_ULCO/my_matlab_data/alpha_homogeneous_cases_2.mat','SM','FR'); 

%%% all
save('/media/Transcend/Elena_ULCO/my_matlab_data/alpha_homogeneous_cases_3.mat','SM','FR'); 

end

%%% the upcoming scripts : 
% result_instr_func_allbestPPI.m % to calculate instrumental function and K*beta

%%% to apply F(R), the smallest K*beta(ref) and alpha(n) to all PPI
% wls_PPI_loop_2


% clear un
% un = figure(25) ;
% set(un,'Position',[1200 600 560 420]);
% 
% for cpt = 1:2
%     plot(r_0(1,1:sdi),FR(cpt,:),'color','k');  hold on
% end
% hold on
% grid on
% ylabel([' K*F(R)*beta(n)'],'color','k');
% xlabel([' scanning distance R [meters]'],'color','k');
% title({['Instrumental Function F(R) x K x unknown beta (indiv for each PPI)'];['K = instrumental constant']});
% 


%%% list of the best PPI in 2014
% for k = 1 : size(SM,1)   
%     clear chemin1 list ij L fichier
%     ij = SM(k,1) ;    
%     chemin1=(['/./media/Transcend/Leosphere/WLS100/' rep(ij).name '/']);
%     list=dir([chemin1,'/*_PPI.rtd']);
%     L =  SM(k,1) ;
%     a(k,:) = cellstr(list(L).name) ;     
% end

% dlmwrite('best_PPI_list.mat','a') ;
% X = dlmread('best_PPI_list.mat') ;
% Y = X(find(X(:,8) <= 2),:) ;

  
