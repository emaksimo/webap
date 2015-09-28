%%% this script is used by "result_instr_func_allbestPPI.m"
%%%  and/or "retrieve_K.m"

b = 10; % how many F(R)*K*beta(n) values de we need within 2000 - 3000m range ?
clear se zz ft z uz n nni nna ssi lli RF SK KN M MN lm FU KBR di reg
close all

colormap(jet) ;
JET= get(gcf,'colormap');

% clf (figure(3));  clf (figure(20));  clf (figure(27));  clf (figure(28));
% if loopme ==1 ; h3 = figure(3) ;  h18 = figure(18) ;  h20 = figure(20) ; h21 = figure(21) ;  h27 = figure(27) ; h28 = figure(28)  ; end
R = 100:50:3000; 

for lli = 1 : size(FFR,1)
        clear GZ F FT 
        %%% FFR = exp(plus(MN,2*reg*r_0(1,1:sdi))) = best estimate of CNR plus 2*alpha*R
        %%% the derivative of F(R)*K*beta(n) should be near zero, since we know
        %%% already that F(R) is const after at least 2000m!
%         FT = nanmoving_average(FFR(lli,:),3);
        FT = FFR(lli,:);
        
%         if loopme ==1 ;
%                 get(figure(3));
%                 plot(R,FFR(lli,:),'linewidth',1,'color','k','linewidth',0.3);  hold on ; grid on ; box on;    
%                 set(h3,'Position',[1150 600 560 420]);
%         end
        
        for e = 3 : 56
                GZ(1,e) = plus(minus(FT(e-2),8*FT(e-1)),minus(8*FT(e+1),FT(e+2)) )/(12*50) ; % 50 meter distance between two neighbouring CNR values   
        end
        GZ(1,1) = (minus(FT(1),FT(2)))/50;
        GZ(1,2) = (minus(FT(1),FT(3)))/100;
        GZ(1,57) = (minus(FT(56),FT(58)))/100;
        GZ(1,58:59) = (minus(FT(57),FT(58)))/50;       

        ssi(lli) = nanstd(FFR(lli,40:59));
        
        F = FFR(lli,40:59) ;
        F(find(abs(GZ(40:59)) > 4)) = NaN; % last 1000m (= R within 2000 and 3000m)
        FFR(lli,40:59) = F;


        nni(lli) = numel(find(~isnan(FFR(lli,:)))) ; 
        nna(lli) = numel(find(~isnan(FFR(lli,40:59)))) ; % data is needed where alpha should be determined        
 end
        
ssi(find(ssi == 0 )) = NaN;     
     
clear FT
for n = 1 : 20
        if length(find(nni > 45 & ssi < (nanmean(ssi))/n & nna >= b )) > 5
                continue
        elseif n == 1 & length(find(nni > 45 & ssi < (nanmean(ssi))/n & nna >= b )) == 0 % if none of PPI within the group is good
                display(['no reference PPI detected within the 10-day group ' num2str(gru) ', see script "ref_ppi.m" line 42'])
                keyboard
                break % n loop
        else     
                %%% the first PPI with more than 45 CNR measurements and weak variability of F(R)*K*beta within the last 1000m
                se = ssi(find(nni > 45 & ssi < (nanmean(ssi))/(n-1) & nna >= b )) ;
                uz = min(se);                
                z = max(find(nni > 45 & ssi == uz & nna >= b)) ; % index within FFR record
                zi = find(nni > 45 & ssi == uz & nna >= b) ; % index of the best PPI within several best PPI (zz) of the group
                ft = 1;

                
                for zz = [find(nni > 45 & ssi < (nanmean(ssi))/(n-1) & nna >= b )] % loop throught the best choice of PPI within the group
                        clear RF SK ccnr ae y yy x B BINT RI RINT STATS F alpha
                        clear MN M KN reg offs reg_err offs_err f8 f4 f5 f8 ccnr dad FT F KBR
%                         close all
%                         lm = 1; % counter for the best profile within the PPI
                        
                        %%% rough filtering of bad scanning distances where
                        %%% statistics exceed the threshold no ray selection
                        
                        %%% compare stats(PPI = zz) to the overall
                        %%% statistics of CNR distribution at each scanning distance R
                        RF(1,:) = RANGA(ll(zz,1),ll(zz,2),:); % width of PDF (between 25% - 75%) at given distance R
                        SK(1,:) = SKA(ll(zz,1),ll(zz,2),:); % skew of PDF at each R
                        FFR(zz,find(RF >= V)) = NaN; % more narrow PDF at given distance R than the typical width   
                        FFR(zz,find(SK >= S(2,:))) = NaN;
                        FFR(zz,find(SK <= S(3,:))) = NaN; % scanning distances with skewness within the corresponding typical range
                        FFR(zz,find(isnan(RF) & isnan(SK))) = NaN; 

                        %%% impose the ray selection within the best PPI
                        %%% out of the group
                        if loopme == 1                              
                                clf (figure(4)); clf (figure(6)) ; clf (figure(7))
%                                clf (figure(5));  clf (figure(12)); clf (figure(17)); 
                                 f7 = figure(7);
                                 
%                                 RGB=JET(ft,:);
%                                 ft = floor(ft + 64/length(find(nni > 45 & ssi < (nanmean(ssi))/(n-1) & nna >= b ))) ;

                                  
%                                 clf (figure(5))
%                                 f5 = figure(5);
%                                 plot(R,RF); hold on     % 25% - 75% range of all CNR(R),  for given PPI
%                                 plot(R,V,'r'); hold on  % "typical" 25% - 75% range of all CNR(R), units [dB] when comparing ALL PPI
%                                 set(f5,'Position',[50 500 560 420]);  
%                                 xlabel(' scanning distance R [meters]','color','k');
%                                 ylabel(' 25-75% range of PDF: typical (in red) and for a particular PPI','color','k')
%                                 text(1500,0.1,['PPI at ' num2str(mom(zz,4)) ':' num2str(mom(zz,5)) ' GMT ' num2str(mom(zz,3)) '/' num2str(mom(zz,2)) '/' num2str(mom(zz,1))], 'color','b');
%                                 

%                                 clf (figure(8))
%                                 f8 = figure(8);
%                                 plot(R,S(1,:),'r'); hold on
%                                 plot(R,S(2,:),'k'); hold on
%                                 plot(R,S(3,:),'k'); hold on          
%                                 plot(R,SK,'b'); hold on
%                                 set(f8,'Position',[600 500 560 420]);  
%                                 xlabel(' scanning distance R [meters]','color','k');
%                                 ylabel(' typical skew(R) and skew(R) for a particular PPI','color','k')
%                                 text(1500,8,['PPI at ' num2str(mom(zz,4)) ':' num2str(mom(zz,5)) ' GMT ' num2str(mom(zz,3)) '/' num2str(mom(zz,2)) '/' num2str(mom(zz,1))], 'color','b');
%                                 
%                                 get(figure(3)) ;                
%                                 plot(R,FFR(zz,:),'linewidth',2,'color',[RGB(1),RGB(2),RGB(3)],'linewidth',2.5);  hold on ; grid on ;
%                                 title({['F(R)*K*beta(n) for the best PPI of a 10-day group'];['where overall statistics allow']});      
                                
%                                 % imageok=[chemin2, 'p' num2str(gru) '_refPPI.eps'];
%                                 % print (figure(3),'-depsc','-r400',imageok); 

                                %%% plot ppi and rhi of the reference PPI within a 10-day group
                                chemin1=(['/./media/Transcend/Leosphere/WLS100/' rep(ll(zz,1)).name '/']);
                                fichier=file_list(zz,:);

                                wls_sub_PPI_1 ; 
                        
                                ccnr = cnr(:, 1 : sdi); % PPI
                                ccnr(find(ccnr >= 0)) = NaN; % do not consider the areas with zero CNR 
                                ccnr(find(ccnr <= -27)) = NaN; % do not consider the areas with too low signal
                        
                                f4 = figure(4) ;               
                                for ang = 1 : size(ccnr,1)
                                         plot(R,plus(ccnr(ang,:)./epsilon , 2*log(r_0(1,:))),'linewidth',1,'color','r');  hold on ; grid on ;
                                end

                                
                                %%% statistics of CNR at each R
                                for d = 1 : sdi; 
                                         clear PRCV
                                         PRCV = prctile(ccnr(:,d) ,[5 99]) ;  % lower 5% and upper 99% percentiles of the distribution  of CNR  
                                         ccnr(find(ccnr(:,d) < PRCV(1) | ccnr(:,d) > PRCV(2)),d) = NaN ; 
                                         dad(:,d) = plus(ccnr(:,d)./epsilon ,  2*log(r_0(1,d)));    
                                end

                               
                                for ang = 1 : size(ccnr,1)
                                        clear ut T TT
                                        ut(1,:) = abs(minus(dad(ang,1:sdi-1),dad(ang,2:sdi)));
                                        dad(ang,find(ut >= 1)) = NaN ; % filter out all rays that contain large fluctuations in CNR between neighbouring 
                                        dad(ang,(find(ut >= 1))+1) = NaN ;
                                        
                                        %%% remove all and entire profiles where (ln(F*K*beta) - 2*alpha*R(i)) increases with distance after 2000m
                                        T(1,:) = nanmoving_average(dad(ang,:),3);
                                        TT(1,:) = minus(T(1,2:sdi),T(1,1:sdi-1)); 
                                        TT(1,1:40) = NaN; % (ln(F*K*beta) - 2*alpha*R(i)) increases within the first 2km due to F(R)
                                        dad(ang,find(TT > 0)) = NaN ;
                                        dad(ang,sdi-1:sdi) = NaN; % remove last two CNR measurements 
                                        
                                        if length(find(~isnan(dad(ang,1:30)))) < 30 % if the profile is complete before 1.5km !!
                                                dad(ang,:) = NaN;
                                                continue
                                        elseif length(find(~isnan(dad(ang,:)))) <= 50 % if the profile is large enough for alpha and F(R) estimation
                                                dad(ang,:) = NaN;
                                                continue
                                        end
                                end
                                
%                                 ccnr(find(isnan(dad))) = NaN;                                
                                                            
%                                 clf (figure(19)) ;
%                                 cf =  figure(19) ;
%                                 set(cf,'Position',[1 554 560 420]); 
%                                 pcolor(d1,z1,ccnr); shading flat; 
%                                 title([ num2str(kl) ' good profiles within given PPI']);
%                                 axis equal;
%                                 caxis([seuil_cnr max_cnr]);
%                                 xlabel(['     Range West / East ', '(m)']);
%                                 ylabel(['     Range South / North ', '(m)']);
%                                 xlim([-max_range1 max_range1]);
%                                 ylim([-max_range1 max_range1]);
%                                 hold on ; box on ; grid on ; colorbar ;                                                         
%                                                         
                                fu = 1;            
                                for lm = 1 : size(dad,1)
                                        if length(find(~isnan(dad(lm,:)))) >= 50
                                                clear x y B BINT RI RINT STATS M KN di GR t T
%                                                 
                                                dad(lm,:) = nanmoving_average(dad(lm,:),2);
                                                
                                                M = minus(dad(lm,1:58),dad(lm,2:59)); % delta CNR(R) = CNR(R1) - CNR(R2) 
                                                MN(lm,:) = exp(M);
                                                
                                                clf (figure(14));
                                                f14 = figure(14);
                                                plot(r_0(1,1:sdi-1),MN(lm,:),'color','k','linewidth',1); hold on 
                                                grid on  ; box on ;    
                                                ylabel(['exp(deltaCNR(R)) = F(R1)/F(R2) * exp(-2 alpha delta(R))'],'color','k');
                                                xlabel([' scanning distance R [meters]'],'color','k');
                                                set(f14,'Position',[650 1 560 420]);
                                                
                                                %%% calculate alpha for each ray
                                                %%% starting from the first distance
                                                %%% where exp(delta(CNR')) shifts the sign
                                                GR = MN(lm,:);
                                                for t = 1:10
                                                        clear pi pv
                                                        pv = nanmax(GR) ;
                                                        pi = min(find(GR == pv)); % distance where this maximum occurs
                                                        %%% if there is an
                                                        %%% interruption in CNR data before this peak of exp(delta(CNR)
                          
                                                        if length(find(~isnan(MN(lm,1:pi)))) < pi % then find the previous step of the stairs                                                  
                                                            GR(find(GR == pv)) = NaN; % hide this peak
                                                            if nanmax(GR) < pv - 0.01 % if exp(delta(CNR) has a shape of brocken stairs
                                                                dad(lm,find(isnan(GR))) = NaN ; % then cut-off the upper "step of the stairs" 
                                                                %%%% so that it does not perturb further alpha calculations
%                                                                 pi
%                                                                 keyboard
                                                            end
                                                            
                                                        elseif pi < 20 % the peak occurs already within the first 1000m   
                                                            dad(lm,:) = NaN ;
                                                            break % t loop
                                                            
                                                        else
                                                            break % t loop
                                                        end
                                                end
                                                
                                                if length(find(~isnan(dad(lm,:)))) < 50
                                                        MN(lm,1:sdi-1) = NaN ;
                                                        reg(lm) = NaN;
                                                        offs(lm) = NaN;
                                                        reg_err(lm,1:2) = NaN;
                                                        offs_err(lm,1:2) = NaN;
                                                        continue % lm loop 
                                                end
                                                
                                                %%% distance where exp(delta(CNR')) is at its maximum
                                                di(1) =  pi ;
                                                di(2) =  max(find(MN(lm,:) >= pv - 0.02)) ;
                                                
                                                y(:,1) = dad(lm,di(1) : di(2)) ; % cnr corrected by epsilon and 2lnR 
                                                x(:,2) = r_0(1,di(1) : di(2)) ; % R
                                                x(:,1) = 1;

                                                [B,BINT,RI,RINT,STATS] = regress(y,x,0.01); % delta (mean CNR(R, all azim))

                                                if B(2)/(-2) <= 0 | (abs(minus(B(2)/(-2),BINT(2,1)/(-2)))*1000 > 0.2 | abs(minus(B(2)/(-2),BINT(2,2)/(-2)))*1000 > 0.2)  % too large uncertainty in alpha !
                                                        MN(lm,:) = NaN ;
                                                        reg(lm) = NaN;
                                                        offs(lm) = NaN;
                                                        reg_err(lm,:) = NaN;
                                                        offs_err(lm,:) = NaN;
                                                        dad(lm,:) = NaN ;
                                                        display('huge alpha uncertainty or negative alpha')
                                                        continue % lm loop
%                                                 elseif B(2)/(-2) > 0.2/1000 | B(2)/(-2) < 0.05/1000    
%                                                         MN(lm,:) = NaN ;
%                                                         reg(lm) = NaN;
%                                                         offs(lm) = NaN;
%                                                         reg_err(lm,:) = NaN;
%                                                         offs_err(lm,:) = NaN;
%                                                         dad(lm,:) = NaN ;
%                                                         continue % lm loop
                                                else
                                                        reg(lm) = B(2)/(-2); % angle of the linear fit
                                                        offs(lm) = B(1); % the free coefficient "b" of the linear fit
                                                        reg_err(lm,:) = BINT(2,:)/(-2);
                                                        offs_err(lm,:) = BINT(1,:);
                                                                          
%                                                         
%                                                         f13 = figure(13);
%                                                         plot(r_0(1,1:sdi),ccnr(lm,:),'color','r','linewidth',1); hold on
%                                                         plot(r_0(1,1:sdi),dad(lm,:),'color','k','linewidth',1); 
%                                                         grid on  ; box on ;    
%                                                         ylabel(['CNR`(R) in red, CNR`(R) filtered '],'color','k');
%                                                         xlabel([' scanning distance R [meters]'],'color','k');
%                                                         set(f13,'Position',[650 650 560 420]);
                                                        
                                                        get(figure(14)) ;
                                                        plot(r_0(1,1:sdi-1), GR,'color','r','linewidth',1); hold on ; % after filtering 
                                                
%                                                         clf (figure(12))  ;
%                                                         h12 = figure(12);
%                                                         yy = plus(-2*reg(lm)*R(:), offs(lm)) ;
%                                                         scatter(x(:,2),y,'Marker','o','MarkerFaceColor','r','MarkerEdgeColor','none'); hold on ;
%                                                         plot(R,yy,'color','k'); grid on ; box on
% %                                                         title({['Best-ray average CNR` = (CNR/epsilon + 2lnR) '];['within the range where alpha(n) is calculated']...
% %                                                             ;['by a simple linear regression against R'];['here const offset of the linear regression = ln(F(R) * K * beta(n))']...
% %                                                             ;['PPI at ' num2str(mom(zz,4)) ':' num2str(mom(zz,5)) ' GMT ' num2str(mom(zz,3)) '/' num2str(mom(zz,2)) '/' num2str(mom(zz,1))]}, 'color','k');
%                                                         xlim([r_0(1,di(1)) r_0(1,di(2))]);
%                                                         ylim([10.2 10.8]);
%                                                         ylabel('average CNR`','color','k');
%                                                         xlabel(' scanning distance R [meters]','color','k');
%                                                         set(h12,'Position',[650 1 560 420]);
                                                                                                       
%                                                         [lm, min(reg_err(lm,:))*1000 , reg(lm)*1000, max(reg_err(lm,:))*1000 ]
                                                        
                                                        
                                                        F(lm,:) = exp(plus(dad(lm,:),2*reg(lm)*r_0(1,1:sdi))) ; % best estimate of CNR`(R(i)) plus 2*alpha*R(i) = ln (F(R(i))*K*beta)
                                                        KBR(lm) =  nanmean(F(lm,di(1) : di(2))) ; % average ln(F(R(i))*K*beta) within the peak of exp(delta(CNR*))
                                                        FT(lm,:) = F(lm,:)/KBR(lm) ;
                                                        
%                                                         FT(lm,di(1):di(2)) = nanmean(FT(lm,di(1):di(2))) ;                                        
%                                                         FT(lm,find(FT(lm,:) > nanmean(FT(lm,di(1):di(2))))) =  nanmean(FT(lm,di(1):di(2))) ; 
                                
                                                        %%% because there are often some large values of F(R)*K*beta before the peak of exp(delta_CNR)
                                                        
%                                                         T(1,:) = nanmoving_average(FT(lm,:),2);
%                                                         FT(lm,:) = T;
%                                                         FT(lm,:) = FT(lm,:)./nanmax(FT(lm,:)) ; % the top of F(R) is strictly == 1

                                                        RGB=JET(fu,:);
                                                        fu = fu+1 ;
                                                        if fu == 64
                                                            fu = 1
                                                        end
                                                        
                                                       
%                                                         get(figure(7));
%                                                         scatter(100:50:3000,FT(lm,:),'Marker','o','MarkerFaceColor',[RGB(1),RGB(2),RGB(3)],'MarkerEdgeColor','none'); hold on ;
%                                                         grid on ; box on
%                                                         xlabel(' scanning distance R [meters]','color','k');
%                                                         ylabel('Normalised Instrumental Function F(R)','color','k');
%                                                         ylim([0 1.15]); 
%                                                         xlim([0 3000]);  
%                                                         set(f7,'Position',[650 1 560 420]);  
%                                                         text(1400,0.74-lm/10,['PPI at ' num2str(mom(zz,4)) ':' num2str(mom(zz,5)) ' GMT ' num2str(mom(zz,3)) '/' num2str(mom(zz,2)) '/' num2str(mom(zz,1))], 'color',[RGB(1),RGB(2),RGB(3)]);
                                                        
                                                        get(figure(4)) ;  
                                                        plot(R,dad(lm,:),'linewidth',1,'color','k');  hold on ; grid on ;
                                       
                                                        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                                        %%% what happens with F(R) for given profile when varying the value of alpha ?
                                                        clear FG FN U1 U2 x xp D FC KBC T FD rr cpt fp
                                                        clf (figure(17));
                                                        figure(17);
                                                        fut = 1;
                                                        cpt = 1;
                                                        fp = 1.43; % figure annotation
                                                        for rr = 0 : 0.05*10^(-3) : 0.35*10^(-3)
                                                                clear FF KB
                                                                FF = exp(plus(dad(lm,:),2*rr*r_0(1,:))) ; % best estimate of CNR`(R(i)) plus 2*alpha*R(i) = ln (F(R(i))*K*beta)
                                                                KB =  nanmean(FF(di(1) : di(2))) ;  % average ln(F(R(i))*K*beta) within the peak of exp(delta(CNR*))
                                                                FG(cpt,:) = FF./KB ; % normalised F(R) for given alpha value
                                                                RGB=JET(fut,:);
                                                                scatter(r_0(1,:),FG(cpt,:),'Marker','o','MarkerFaceColor',[RGB(1),RGB(2),RGB(3)],'MarkerEdgeColor','none'); hold on ;
                                                                text(100,fp, [ num2str(rr*1000) ' km^{-1} '], 'color',[RGB(1),RGB(2),RGB(3)]);
                                                                text(700,1.43, ['first guess ' num2str(reg(lm)*1000) ' km^{-1} '], 'color','r');
                                                                ylim([0 1.5]);
                                                                grid on; box on;
                                                                fut = fut + 8 ;
                                                                fp = fp - 0.15;
                                                                cpt = cpt + 1;                                                        
                                                        end
                                                        clear FF KB
                                                        plot(r_0(1,:),FT(lm,:),'Color','r','linewidth',2); hold on ;
                                                        
                                                        %%% the convergence point
                                                        FN = abs(minus(FG(1,:), FG(size(FG,1),:))) ; %the difference between the most extreme scenarios of alpha
                                                        
                                                        FN(1:20) = NaN; % there is a small difference in F(R) witin the first part of the scanning range
                                                        xp = find(FN == nanmin(FN)) 
                                                        r_0(1,xp)                                                        

                                                        U1 = nanmean(dad(lm,di(1):di(2))) ;
                                                        U2 = 2*nanmean(r_0(1,di(1):di(2))) ;
                                                        D = dad(lm,:);     
%                                                         D = dad(lm,:);  
                                                        x = (minus(U1 , D(xp)) / minus(2 * r_0(1,xp) , U2 )) ; % alpha corrected at the distance of convergence R = XP
                                                       
                                                        
                                                        [x*1000, reg(lm)*1000, reg_err(lm,:)*1000]
                                                        [r_0(1,xp), r_0(1,di)]
                                                            
                                                        FC = exp(plus(dad(lm,:),2*x*r_0(1,:))) ; %  now lets recalculate F(R) using corrected alpha
                                                        KBC =  nanmean(FC(di(1) : di(2))) ; % reference used for normalization = average ln(F(R(i))*K*beta) 
                                                        
                                                        plot(r_0(1,:),FC./KBC,'Color','k','linewidth',2); hold on ; % normalized
                                                        text(700,1.28, ['corrected ' num2str(x*1000) ' km^{-1} '], 'color','k');
                                                        
                                                        clf (figure(16));
                                                        f16 = figure(16)
                                                        scatter(100:50:3000,FC./KBC,'Marker','o','MarkerFaceColor','k','MarkerEdgeColor','none'); hold on ;
                                                        scatter(100:50:3000,FT(lm,:),'Marker','o','MarkerFaceColor','r','MarkerEdgeColor','none'); hold on ;
                                                        set(f16,'Position',[1250 1 560 420]);  
                                                        grid on ; box on ;
                                                        xlabel(' scanning distance R [meters]','color','k');
                                                        ylabel('Normalised Instrumental Function F(R)','color','k');
                                                        title({['first guess F(R) for alpha ' num2str(reg(lm)*1000) ' km-1 (in red)']...
                                                            ;['corrected F(R) at reference range ' num2str(xp) ' m with corrected alpha ' num2str(x*1000) ' km-1 (in black)']}); 
                                                        ylim([0 1.15]); 
                                                        xlim([0 3000]);

                                                        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                                        
                                                        
                                                        keyboard
                                                end   
                                        else
                                                MN(lm,1:sdi-1) = NaN ;
                                                reg(lm) = NaN;
                                                offs(lm) = NaN;
                                                reg_err(lm,1:2) = NaN;
                                                offs_err(lm,1:2) = NaN;
                                        end  
                                         
                                         
                                end  % lm for each ray
                                
                                FT(find(FT == 0)) = NaN ;
                                
                                ccnr(find(isnan(dad))) = NaN;
                                
                                kl = length(find(nansum(ccnr,2) ~= 0)) ;
                                
%                                 clf (figure(19)) ;
%                                 f19 =  figure(19) ;
%                                 set(f19,'Position',[750 660 560 420]); 
%                                 pcolor(d1,z1,ccnr); shading interp; 
%                                 view(0,90);
% %                                 surfc(d1,z1,ccnr, 'LineStyle','none','EdgeLighting','phong');
% %                                 shading(gca,'flat')
%                                 title([ num2str(kl) ' treated profiles within given PPI']);
%                                 axis equal;
%                                 caxis([seuil_cnr max_cnr]);
%                                 xlabel(['     Range West / East ', '(m)']);
%                                 ylabel(['     Range South / North ', '(m)']);
%                                 xlim([-max_range1 max_range1]);
%                                 ylim([-max_range1 max_range1]);
%                                 box on ; grid on ; colorbar ;    

                                
%                                 get(figure(7));
%                                  title([ num2str(kl) ' treated profiles within given PPI']);
                                 
                                %%
%                                 clf (figure(6))
%                                 f6 = figure(6);
%                                 scatter(1:length(reg),reg*1000,'Marker','o','MarkerFaceColor','k','MarkerEdgeColor','none'); 
%                                 grid on; box on ; hold on; 
%                                 set(f6,'Position',[1250 1 560 420]); 
%                                 xlabel(' azimuth from N [deg]','color','k');
%                                 ylabel('extinction coefficient [km^{-1}]','color','k');
%                                 xlim([0 360]);
%                                 ylim([0 nanmax(reg)*1000-0.001]);
%                                 get(figure(6));
%                                 text(160,0.21,['PPI at ' num2str(mom(zz,4)) ':' num2str(mom(zz,5)) ' GMT ' num2str(mom(zz,3)) '/' num2str(mom(zz,2)) '/' num2str(mom(zz,1))], 'color','k');
                               
                                 
                                clear MOD MI MA ST TT
                                ct = 1;
                                for st = 1 : sdi
                                    MOD(st) = nanmean(FT(:,st)) ;
%                                     MI(st) = nanmin(FT(:,st)) ;
%                                     MA(st) = nanmax(FT(:,st)) ;
%                                     ST(st,1) = minus(MOD(st),nanstd(FT(:,st))) ;
%                                     ST(st,2) = plus(MOD(st),nanstd(FT(:,st))) ;
                                end
                               
                                TT = nanmoving_average(MOD,2);

                                clf (figure(10))
                                figure(10);                                 
                                grid on ; box on ;
                                TT(39:59) = 1 ;
                                scatter(r_0(1,:),TT,'Marker','o','MarkerFaceColor','k','MarkerEdgeColor','none'); hold on ;
                                save(['/./media/Transcend/Leosphere/nov2014/s.mat'],'TT')
%                                 scatter(r_0(1,:),MOD,'Marker','o','MarkerFaceColor','k','MarkerEdgeColor','none'); hold on ;
%                                 scatter(r_0(1,:),ST(:,1),'Marker','o','MarkerFaceColor','r','MarkerEdgeColor','none'); hold on ;
%                                 scatter(r_0(1,:),ST(:,2),'Marker','o','MarkerFaceColor','r','MarkerEdgeColor','none'); hold on ;
%                                 scatter(r_0(1,:),MI,'Marker','o','MarkerFaceColor','g','MarkerEdgeColor','none'); hold on ;
%                                 scatter(r_0(1,:),MA,'Marker','o','MarkerFaceColor','g','MarkerEdgeColor','none'); hold on ;
%                                 hold on
%                                 grid on;
%                                 ylim([0 1.1]);
%                                 grid on ; box on
%                                 xlabel(' scanning distance R [meters]','color','k');
%                                 ylabel('Normalised Instrumental Function F(R)','color','k');
%                                 text(1400,0.38,['PPI at ' num2str(mom(zz,4)) ':' num2str(mom(zz,5)) ' GMT ' num2str(mom(zz,3)) '/' num2str(mom(zz,2)) '/' num2str(mom(zz,1))], 'color','k');
%                                 text(1400,0.3,'mean F(R)','color','k'); 
%                                 text(1400,0.22,'std F(R)','color','r'); 
%                                 text(1400,0.14,'min and max F(R)','color','g'); 
                                %%
                                
                                keyboard
%                                 close(f19)
%                                 close(cf)
%                                  text(1400,nanmax(F)/2,['PPI at ' num2str(mom(zz,4)) ':' num2str(mom(zz,5)) ' GMT ' num2str(mom(zz,3)) '/' num2str(mom(zz,2)) '/' num2str(mom(zz,1))], 'color',[RGB(1),RGB(2),RGB(3)]);
                                
                        end % if loopme == 1      
%                         
                end  % zz  
                break % after treating the best (one or several) PPI of the group, go further
                
        end % ssi and nni filter for the best PPI of the group
end % strengthening criteria (n) for ssi imposed  to the best PPI of the group

if length(nni) == 1 & length(ssi)==1
        z = 1 ;
end

if  n == 1 & length(find(nni > 45 & ssi < (nanmean(ssi))/n & nna >= b)) == 0 
        display(['no reference PPI detected within the 10-day group ' num2str(gru) ', see script "ref_ppi.m" line 42'])
        keyboard
        continue % gru loop
end



