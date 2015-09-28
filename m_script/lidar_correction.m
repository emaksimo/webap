%%% evaluate the Instrumental function for the best PPI
%%% PPI file loop done with : wls_PPI_loop_1.m
%%% statistics were calculated with : instrum_function.m
%%% to retrieve the instrumental function, see "result_instr_func.m"

clear all
close all

load('alpha_homogeneous_cases.mat'); % list of 235 PPI and corresponding scanning distances where alpha was determined
%%%  SM(cpt+1,:) = [ij L reg_err(2) reg reg_err(1) offs offs_err ah];  
%%%  FR(cpt+1,:) = exp(plus(MN,2*reg*r_0(1,:))) ;
 
% listing_2lnR % list of scanning distances where alpha should be determined (CNR = CNR/epsilon - 2lnR)
instrumental_correction ; % data: instrumental function (without 2lnR inside) and K * beta(ref), calculated with result_instr_func.m

loopme = 1 ;
R = 100:50:3000 ;
cpt = 0;
colormap(jet) ;
JET= get(gcf,'colormap');
rep=dir(['/./media/Transcend/Leosphere/WLS100/']);

% CFA = NaN([18 1272 59]); CTA = CFA; SKA = CFA; RANA = CFA; RANGA = CFA; LIKA = CFA; KTA = CFA; JBA = CFA; KRA = CFA;
% %%% spatial resolution was changed for ij = 21 and after
% 
% for ij = 3 : 20 % directory counter
%         clear CF CT SK RAN RANG LIK KT JB U V KR peak_alpha
%         if exist(['/media/Transcend/Elena_ULCO/my_matlab_data/CNR_stats_std_range_maxliklihood_ktest_allPPI_' num2str(ij-2) '.mat']) == 2
%                 load(['/media/Transcend/Elena_ULCO/my_matlab_data/CNR_stats_std_range_maxliklihood_ktest_allPPI_' num2str(ij-2) '.mat']);  
% %                 CFA(ij-2,1:size(CF,1),1:size(CF,2)) = CF ; % std before remoing <5% and > 95%  
%                 LIKA(ij-2,1:size(CF,1),1:size(CF,2)) = LIK ; % most expected CNR = test estimate at each R, each PPI
% %                 MEA(ij-2,1:size(CF,1),1:size(CF,2)) = ME ; % mean of all CNR(R)
% %                 CTA(ij-2,1:size(CF,1),1:size(CF,2)) = CT ; % std after remoing <5% and > 95%    
% %                 RANA(ij-2,1:size(CF,1),1:size(CF,2)) = RAN ; % range = max - min of all CNR values at given R 
%                 RANGA(ij-2,1:size(CF,1),1:size(CF,2)) = RANG ; % interquartile range
%                 SKA(ij-2,1:size(CF,1),1:size(CF,2)) = SK ; % skewness  if the distribution is inclinated
% %                 KRA(ij-2,1:size(CF,1),1:size(CF,2)) = KR ; % kurtosis
% %                 KTA(ij-2,1:size(CF,1),1:size(CF,2)) = KT ; % kstest : when normal distrib = 0
% %                 JBA(ij-2,1:size(CF,1),1:size(CF,2)) = JB ; % jbtest : when normal distrib = 0        
%                 clear CF CT SK RAN RANG LIK KT JB U V KR ME
%         else
%                 continue
%         end
% end

% RANGA(find(RANGA == 0 )) = NaN; % range can't be zero!
% LIKA(find(RANGA == 0 )) = NaN;
% KRA(find(RANGA == 0 )) = NaN;

% for d = 1 : size(CFA,3) % at each scanning distance R
% %         U(1,d) = nanmean(reshape(KRA(:,:,d),[size(RANA,1)*size(RANA,2) 1])); % typical kurtosis        
%         V(1,d) = nanmean(reshape(RANGA(:,:,d),[size(RANA,1)*size(RANA,2) 1])); % typical range
% %         MI(1,d) = nanmin(reshape(RANA(:,:,d),[size(RANA,1)*size(RANA,2) 1]));
% %         MA(1,d) = nanmax(reshape(RANA(:,:,d),[size(RANA,1)*size(RANA,2) 1]));
% end

% clear figure(8)
% figure(8)
% plot(R,U,'r'); hold on
% plot(R,MI,'k'); hold on
% plot(R,MA,'k'); hold on
% xlabel([' scanning distance R [meters]'],'color','k');
% ylabel([' 25% - 75% range of all CNR(R), units [dB]'],'color','k');
% title({['The shape of PDF using 360 CNR(same R) values of each PPI is examined'];['25% quartile (min) vs 75% (max) reflect the thickness of PDF distirution at each distance R'];['small range (25% vs 75%) = homogeneous atmosphere']});

% ylabel([' total spread of PDF(all 360 CNR(R))'],'color','k');
% title({['The shape of PDF using 360 CNR(same R) values of each PPI is examined'];['MIN vs MAX reflect the thickness of PDF distirution at each distance R'];['small range = likely homogeneous atmosphere']});

%  ij = input('ij ?  ') 
%  L = input('L ? ') 
for ij = 3 : 20    

% for op = 1 : length(re)
%         ij = re(op,1) ;
        clear chemin1 list
        chemin1=(['/./media/Transcend/Leosphere/WLS100/' rep(ij).name '/']);
        list=dir([chemin1,'/*_PPI.rtd']);
        
        for L = 1 : size(list,1)   
%         L = re(op,2) ;
            clear N e1 e2 fichier lli list1 af fichier_rhi RF M MN st RGB cnr hv hk hh ah            
%             tu = [35 49] ; % 1800 - 2500m distances under examination
%             RF(1,:) = RANGA(ij-2,L,:); % width of PDF (between 25% - 75%) at given distance R
%             e1 = find(RF(tu(1) : tu(2)) <= V(tu(1) : tu(2))); % more narrow PDF at given distance R than the typical width   
            
%             clear RF
%             RF(1,:) = KRA(ij-2,L,:); % height of PDF(CNR(R)) at given distance R
%             e2 = find(RF(tu(1) : tu(2)) > U(tu(1) : tu(2))); clear RF U V
            
            fichier = cellstr(list(L).name) ; % PPI file  
%             if length(e1) >= length(tu(1):tu(2))-5 & nanmax(abs(reshape(SKA(ij-2,L,tu(1) : tu(2)),[length(tu(1):tu(2)) 1]))) < 0.6 % skewness is weak  & length(e2) >5 
            if length(e1) == length(tu(1):tu(2)) & nanmax(abs(reshape(SKA(ij-2,L,tu(1):tu(2)),[length(tu) 1]))) < 0.6 % skewness is weak  & length(e2) >5    
                
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
%                                 for ei = 5 : 15 : 85 % azimuthal angle in vertical (RHI) plane, in [deg]
%                                         clear crh C1 C2 C
%                                         crh = min(find(z1(ei,:) > 300)); % critical height == up to 300m, where we should check the symmetry
%                                         C1 = nanmean(cnr(ei-1:ei+1,1:crh),1); % compare only those RHI CNR measurements below 300m
%                                         C2 = nanmean(cnr(size(el,1)-ei-1 : size(el,1)-ei+1, 1:crh),1);
%                                         C = abs(minus(C2,C1)) ; 
%                                         %%% if more than 3 CNR values at the same altitude, same angle, same scanning distance differ so much !
%                                         if length(find(C > 2)) > 3 
%                                                 clear C1 C2 crh af ans el
%                                                 break  % ei loop                             
%                                         end                                
%                                 end                              
                                break % fg
                        end                         
                 end
                 
%                  if exist('C') ~= 1 | length(find(C > 2)) > 3 % if not symmetric vertically within the lowest 300m
%                      clear C ei          
%                      continue % L loop
%                  end
                
                 RGB=JET(ceil((cpt+1)*0.85),:) ; 
               
                 wls_sub_PPI_1 ; % upload and plot original PPI CNR data     
                 if size(cnr,1) ~= 360 | size(cnr,2) ~= 59
                     continue % L loop
                 end

                 clear ccnr MN 
                 ccnr = cnr; % PPI
                 ccnr(find(ccnr>=0))=NaN; % do not consider the areas with zero CNR 
                 ccnr(find(ccnr<=-27))=NaN; % do not consider the areas with too low signal
                                
                 epsilon = 10/log(10) ;
                 
                 for d = 1 : size(r_0,2); 
                     clear PRCV
                     PRCV = prctile(ccnr(:,d) ,[5 99]) ;  % lower 2.5% and upper 99% percentiles of the distribution  of CNR, not corrected by anything   
                     ccnr(find(ccnr(:,d) < PRCV(1) | ccnr(:,d) > PRCV(2)),d) = NaN ;     
                     dad(:,d) = plus(ccnr(:,d)./epsilon ,  2*log(r_0(1,d)));
%                      MN(1,d) = nanmean(dad(:,d)); % best estimate of CNR(R)

                 end
                 
%                  hh = nanmean(ccnr(:,1:5)); % PPI
%                  hk = minus(hh,hv); % hv is the layer-average CNR of the first 5 distances in vertical direction
                 
%                  if max(abs(hk) > 2)                     
%                      display(['skipping ij = ' num2str(ij) ', L = ' num2str(L) ' vertically nonuniform below 300m'])
%                      continue % L loop
%                  end
                                     
                 %%% delta (mean(CNR)) = mean CNR(R1) minus mean CNR(R2)
                 clear M N K KN rad
                 M(:,1) = minus(MN(1:58),MN(2:59)); % best estimate of CNR(R) = mean CNR(R)
                 
%                  if length(find(M(49:58) < 0)) > 5  % if CNR increases systematically after R > 2500m , it means that alpha and beta increase with height (off the lidar), and so this PPI should be skipped 
%                        display(['skipping ij = ' num2str(ij) ', L = ' num2str(L) ' alpha increases vertically'])
%                        continue % L loop
%                  else
%                        M(find(M(49:58) < 0)+48) = NaN;
%                  end
                   
                 KN  = exp(nanmoving_average(M,3)); % plus minus 3 CNR values on eigther side

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
                         
                         clf (figure(5)) 
                         h1 = figure(5)  ;               
                         plot(r_0(1,2:59),KN,'color','k'); %[RGB(1),RGB(2),RGB(3)]); %
                         hold on
                         ylim([0.9 1.1]);
                         set(h1,'Position',[1 54 560 420]); 
                         grid on             
%                          title('exp^{(delta(mean(CNR(R))))} = F(R1)/F(R2) * exp(-2*alpha*50m)');
%                          ylabel([' exp^{(delta(mean(CNR(R))))}'],'color','k');
%                          xlabel([' scanning distance R [meters]'],'color','k');
                         
                         instrum_function_result  ;               

                         %%% apply multi-angle approach
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
                            

                   %%%% keep cnr data only within those distances where (delta cnr) is const, where the 5-point derivative of exp(delta CNR) is close to zero
                    ah = re(op,3:4); 
                    
%%%%%%%%%%% automatic analysis of delta CNR                  
                   clear e GZ
                   for e = 3 : 56
                        GZ(1,e) = plus(minus(KN(e-2),8*KN(e-1)),minus(8*KN(e+1),KN(e+2)) )/(12*50); % 50 meter distance between two neighbouring CNR values   
                   end
                   GZ(1,1) = (minus(KN(1),KN(2)))/50;
                   GZ(1,2) = (minus(KN(1),KN(3)))/100;
                   GZ(1,57) = (minus(KN(56),KN(58)))/100;
                   GZ(1,58) = (minus(KN(57),KN(58)))/50;

                   if nanstd(GZ) > 0.00045
                        display(['skipping ij = ' num2str(ij) ', L = ' num2str(L) ' large variations in exp(delta CNR)'])
                       continue % L loop
                   end    
                   
%                    dad(:,find(abs(GZ) > 0.00002)) = NaN; % do not use CNR data at those individual distances where exp(delta CNR is large)
                   GZ(find(abs(GZ) > 0.00002)) = NaN; 
                   
%                    if r_0(1,min(find(~isnan(GZ)))-2) >= 1800 % tuning
%                         ah(1) = r_0(1,min(find(~isnan(GZ)))-2);
%                    else
%                        ah(1) = 1800;
%                    end
%                    
%                    if max(find(~isnan(GZ)))+2 < 59                        
%                         ah(2) = r_0(1,max(find(~isnan(GZ)))+2);
%                    else 
%                         ah(2) = 3000;
%                    end
                   
%                    re(cpt+1,:) = [ij, L, ah(1), ah(2)];
  
%%%%%%%%%%% visual analysis of delta CNR
%                    {['ij ', num2str(ij),' L ', num2str(L)]}
%                    if ~isempty(find(re(:,1) == ij & re(:,2) == L))
%                        ah = re(find(re(:,1) == ij & re(:,2) == L),3:4) ;  % see listing.m
%                    else
%                        ah(1) = input('lower distance range ?') 
%                        ah(2) = input('upper distance range ?') 
%                        re(size(re,1)+1,:) = [ij, L, ah(1), ah(2)];
%                    end
%%%%%%%%%%%%%%%%%%%%                   

%                    BI(find(distance < ah(1) | distance > ah(2))) = NaN; % cnr data (corrected by epsilon and 2lnR)
                    
%                    loopme = 1; % plott scatter plots for each distance "d"
%                    multi_angle_method_Pabs_vs_CosTeta
                  
                   %%%%%%% slope method
                   clear y x y1 x1 xx yy Y XX B BINT R RINT STATS reg offs reg_err offs_err alpha ERR FM FM_ERR HT N XN YN a z zz
                   clear ad_range ad_seuil af ans compteur crh ct d h1
                   %%%% clear CFA CTA GA JBA KN KRA KTA LIKA
                   
                   y = dad ; % CNR record (corrected by 2ln(R), epsilon, lower 5% & upper 1% tails), see line 145
                   x = r_0 ;
                   
                   y(find(r_0 < ah(1) | r_0 > ah(2))) = NaN; % cnr corrected by 2lnR and filtered out by 5% and 1% tails
                   x(find(r_0 < ah(1) | r_0 > ah(2))) = NaN; % R
                   ft = 1 ;
                   for i = 1 : 57
                        clear M N
                        M = minus(y(:,1:59-i),y(:,1+i:59)); % delta (mean CNR(R)) over the same (important!) scanning ray !    
                        N = minus(x(:,1:59-i),x(:,1+i:59)); % corresponding delta R
                        Y(ft : ft + length(find(~isnan(M)))-1,1) = M(find(~isnan(M)));
                        XX(ft : ft + length(find(~isnan(M)))-1,2) = N(find(~isnan(M)));
                        ft = ft + length(find(~isnan(M))) ;
                        if length(find(~isnan(M))) == 0
                            break
                        end
                   end
                   XX(:,1) = 1;
                   
                   [B,BINT,R,RINT,STATS]=regress(Y,XX,0.01);
                   reg = B(2)/(-2); % angle of the linear fit
                   offs = B(1); % the free coefficient "b" of the linear fit
                   reg_err = BINT(2,:)/(-2);
                   offs_err = BINT(1,:);
%                    
% U
                   clf (figure(4));
                   h1 = figure(4)
                   set(h1,'Position',[561 54 560 420]); 
                   grid on             
                   scatter(XX(:,2),Y); hold on ;
% U

%                    plot(XX(:,2),XX(:,2)*B(2)+B(1),'r'); hold on;
%                    title({['slope method, dist : ' num2str(ah(1)) ' - '  num2str(ah(2)) ' m']});
%                    ylabel([' delta CNR(R) along the same scanning ray'],'color','k');
%                    xlabel([' scanning distance R [meters]'],'color','k');
                   
                   SM(cpt+1,:) = [ij L reg_err(2) reg reg_err(1) offs offs_err ah];
                   
                   if reg < 0     
                         ah
                         clf (figure(5)) 
                         h1 = figure(5)  ;               
                         plot(r_0(1,2:59),KN,'color',[RGB(1),RGB(2),RGB(3)]); % 'k'); 
                         hold on
                         ylim([0.9 1.1]);
                         set(h1,'Position',[1 54 560 420]); 
                         grid on             
                         title('exp^{(delta(mean(CNR(R))))} = F(R1)/F(R2) * exp(-2*alpha*50m)');
                         ylabel([' exp^{(delta(mean(CNR(R))))}'],'color','k');
                         xlabel([' scanning distance R [meters]'],'color','k');                        
                   end
                   
                   %%%% smoothen neighbouring "tirs"
%                    clear K
%                    for d = 1 : size(dad,2)
%                         K(:,d) = nanmoving_average(dad(:,d),1);
%                    end                   
%                    K(1:2,:) = NaN;
%                    K(359:360,:) = NaN;
                   
%                    clf (figure(7));
%                    figure(7)
%                    surf(d1,z1,K,'EdgeLighting','phong','LineStyle','none'); 
%                    colorbar
%                    view(0,90);
%                    caxis([7 11.5]);      

                   %%% instrumental function shape
                   
                   clear un
                   un = figure(25) ;
                   set(un,'Position',[570 1 560 420]);
                   FR(cpt+1,:) = exp(plus(MN,2*reg*r_0(1,:))) ;
                   plot(r_0(1,:),FR(cpt+1,:),'color',[RGB(1),RGB(2),RGB(3)]);  
                   hold on
                   grid on
                   ylabel([' K*F(R)*beta(n)'],'color','k');
                   xlabel([' scanning distance R [meters]'],'color','k');
                   title({['Instrumental Function F(R) x K x unknown beta (indiv for each PPI)'];['K = instrumental constant']});
                          
                   [ah, cpt, reg*1000]
                   keyboard
                   cpt = cpt + 1;
%                    clf (figure(4)); clf (figure(8)); clf (figure(21));
            end  % criterias KRA, SKA              
%         end % L
end % ij

break

% clear P
%%% n is the counter when varying the reference PPI (using different z)
%%% n is used in result_instr_func.m
% n = 1; 


%%
clf (figure(24)) ; clf (figure(23));
figure(24)
clear u v z LR T
R = 100:50:3000; 

z = 41 ; % reference PPI = 18
for i = 1 : size(FR,1)
    RGB=JET(ceil(i*0.85),:) ; 
    T(i,:) = FR(i,:)./FR(z,:) ; % this ratio is the ratio of beta(i) vs beta(reference = z)
    plot(R,T(i,:),'color',[RGB(1),RGB(2),RGB(3)]); 
    hold on
    ylabel('K*F(R)*beta(n) / K*F(R)*beta(ref)');
    xlabel(' scanning distance R [meters]','color','k');
    LR(i,1:2) = [nanmean(FR(i,find(R == re(i,3)) : find(R == re(i,4)) )) / nanmean(FR(z,find(R == re(z,3)) : find(R == re(z,4)) )), SM(i,4)/SM(z,4)] ;
    grid on
end
% ylim([0.75 5.5]); 

figure(23)
plot(1:length(LR),LR(:,1),'r'); hold on ;
plot(1:length(LR),LR(:,2),'k'); hold on ;
ylabel('ratio : alpha(n)/alpha(ref) in black, beta(n)/beta(ref) in red');
xlabel({['PPI(n = 1 : ' num2str(length(re)) ')']});
xlim([0 76]);
grid on
%%

% result_instr_func ; % calculate instrum function
break

clear KA

for li = 1 : size(GA,1)
    KA(li,1:5) = NaN;
    KA(li,55:58) = NaN;
    clear M
    M(1,:) = nanmoving_average(GA(li,:),1) ;    
    
    for d = 6 : size(GA,2)-4        
        if  GA(li,d) > M(1,d-2) + 0.01 | GA(li,d) < M(1,d+2) - 0.01
            KA(li,d) = NaN ;
        else
            KA(li,d) = M(1,d);
        end
    end
end

[(R(1:58)/100)',GA(1,:)',KA(1,:)']

