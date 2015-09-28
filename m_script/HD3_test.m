%%%
% clear I cnr K M KN Sr y x yy di ccnr KBR F 
% I(1,:) = nanmoving_average(FT(lm,:),3);
% I(1,50:59) = 1;
% % 
% alphaP = 0.0001; % m-1
% Sr = 30 ; 
% betta = alphaP/Sr ; %  [m-1 sr-1]
% K = 10^10.2;

% figure(4); 
% plot(I,'-k','linewidth',2); hold on 
% ylabel(['simulated Instrum function [dB] '],'color','k');
% xlabel(['scanning distance R [meters]'],'color','k');

for i = 1 : 360
        cnr(i,:) = 10*log10((K*betta*I.*exp(-2*alphaP*r_0(1,:)))./r_0(1,:).^2);
end
% 
% get(figure(7));
% scatter(100:50:3000,cnr(1,:),'Marker','o','MarkerFaceColor',[RGB(1),RGB(2),RGB(3)],'MarkerEdgeColor','none'); hold on ;
% % scatter(100:50:3000,exp(-2*alphaP*r_0(1,:)),'Marker','o','MarkerFaceColor',[RGB(1),RGB(2),RGB(3)],'MarkerEdgeColor','none'); hold on ;

% scatter(100:50:3000,10*log10(I),'Marker','o','MarkerFaceColor',[RGB(1),RGB(2),RGB(3)],'MarkerEdgeColor','none'); hold on ;
% grid on ; box on
% xlabel(' scanning distance R [meters]','color','k');
% ylabel('Normalised Instrumental Function F(R)','color','k');


% clf (figure(19)) ;
% f19 =  figure(19) ;
% pcolor(d1,z1,cnr); shading flat; 
% axis equal;
% caxis([-27 -10]);
% xlabel(['     Range West / East ', '(m)']);
% ylabel(['     Range South / North ', '(m)']);
% xlim([-max_range1 max_range1]);
% ylim([-max_range1 max_range1]);
% box on ; grid on ; colorbar ;    
                                    
% save(['/./media/Transcend/Leosphere/nov2014/simulation.mat'],'r_0','I','d1','z1','alphaP','cnr','K');

clear all
close all

figure(1); hold on
ylabel('CNR = 10log_{10}(P_{rec}/P_{transm})','color','k');
xlabel('scanning distance','color','k'); % set(h12,'Position',[650 1 560 420]);
title({['simulated CNR for alpha = 0.1 : 0.1 : 1 km^{-1} (blue = small alpha)'];[' F(R) is the same and const after 1.5 km, LR = 30 sr']});

figure(2); hold on
ylabel('CNR(n)/epsilon + 2*ln(R)','color','k');
xlabel('scanning distance','color','k'); % set(h12,'Position',[650 1 560 420]);
title({['CNR(n)/epsilon + 2*ln(R) = ln(K) + ln(F(R)) + ln(beta) - 2*alpha(n)*R'];['in color : CNR for different alpha = 0.1 : 0.1 : 1 km^{-1} (blue = small alpha)'];[' F(R) is the same and const after 1.5 km, LR = 30 sr']});

figure(3); hold on
ylabel('CNR(n)/epsilon - ln(F(R))','color','k');
xlabel('scanning distance','color','k'); % set(h12,'Position',[650 1 560 420]);
title({['CNR(n)/epsilon - ln(F(R)) = ln(K) - 2*ln(R) + ln(beta) - 2*alpha(n)*R'];['in color : CNR for different alpha = 0.1 : 0.1 : 1 km^{-1} (blue = small alpha)'];[' F(R) is the same and const after 1.5 km, LR = 30 sr']});


colormap(jet) ;
JET= get(gcf,'colormap');
epsilon = 10/log(10) ;

load(['/./media/Transcend/Leosphere/nov2014/simulation.mat']); % ,'r_0','d1','z1','alphaP','cnr', I = istrum function const after 1.5 km

alphaP = 0.0001; % m-1
Sr = 30 ; 
betta = alphaP/Sr ; %  [m-1 sr-1]
K = 10^10.2;

cpt = 1;
for i = 1 : 10
        cnr(i,:) = 10*log10((K*betta*I.*exp(-2*alphaP*r_0(1,:)))./r_0(1,:).^2);
        alphaP = alphaP + 0.0001;
        figure(1); 
        RGB=JET(i*6,:);
        
        plot(r_0(1,6:59),cnr(i,6:59),'color',[RGB(1),RGB(2),RGB(3)]); hold on
        grid on; box on;
        
        figure(2)
        plot(r_0(1,6:59),plus((cnr(i,6:59)/epsilon),2*log(r_0(1,6:59))),'color',[RGB(1),RGB(2),RGB(3)]); hold on;
        grid on; box on;
        
        figure(3)
        plot(r_0(1,6:59),minus((cnr(i,6:59)/epsilon),log(I(6:59))),'color',[RGB(1),RGB(2),RGB(3)]); hold on;
        grid on; box on;
end

figure(4)
plot(r_0(1,6:59),I(6:59)); hold on
ylim([0 1.02]) ; grid on; box on;


keyboard

load(['/./media/Transcend/Leosphere/nov2014/s.mat']); %'TT'= istrum function const after 2 km
 
% clear cnr R1 nr cnp
K = 10^10.2;


alphaP = 0.000025 : 0.000005 : 0.00045 ; % m-1
Sr = rand([1 length(alphaP)])*70 ; 
betta = alphaP./Sr ; 

for i = 1 : size(r_0,1) % azimuth counter
    for p = 1 : length(alphaP) % PPI counter
        cnr(i,:,p) = 10*log10((K*betta(p)*TT.*exp(-2*alphaP(p)*r_0(1,:)))./r_0(1,:).^2);
    end
end
 
for p = 1 : length(alphaP) % PPI counter
    clear R1
    R1 = minus(rand([size(cnr(:,:,p),1),size(cnr,2)]),rand([size(cnr,1),size(cnr,2)]))/10;
    SIG(:,:,p) = plus((plus(cnr(:,:,p),R1))/epsilon,2*log(r_0));
end

%%% apply alpha estimation to all profiles within one PPI
%%% consider individual groups of 30 profiles, instead of treating 360 profiles
ct = 1; % profile counter
l = 300 ; % how many azimuths in a sector

r = r_0(1:30,:);

for gru = 1 : floor(360/l)
    clear MN M KN BR F KBR
    
    for p = 1 : length(alphaP) % which cnr 
        clear pv Y XX BB INT R RINT STATS S
        S = SIG(ct:ct+l-1,:,p);  
        MN(p,:) = nanmean(S,1); % average CNR profile
        M(p,:) = minus(MN(p,1:58),MN(p,2:59)); % best estimate of CNR(R) = mean CNR(R)                 
        KN(p,:)  = exp(M(p,:));  

        pv = nanmax(KN(p,:)) ;
        pj(gru,p) = min(find(KN(p,:) == pv)) ; % distance where this maximum occurs
          
                                                   
        Y(:,1) = MN(p,pj(gru,p):59) ;
        XX(:,2) = r(1,pj(gru,p):59) ;
        XX(:,1) = 1;        

        [B,BINT,R,RINT,STATS] = regress(Y,XX,0.01); % delta CNR(R) for each given azimuth
        regi(gru,p) = B(2)/(-2); % angle of the linear fit
    %     offsi = B(1); % the free coefficient "b" of the linear fit
    %     reg_erri = BINT(2,:)/(-2);
    %     offs_erri = BINT(1,:);

        F(p,:) = plus(MN(p,:),2*regi(gru,p)*r_0(1,:)) ; % best estimate of CNR`(R(i)) plus 2*alpha*R(i) = ln (F(R(i))*K*beta)
        KBR(p) =  nanmean(exp(F(p,pj(gru,p) : 59))) ; % average F(R(i))*K*beta within the peak of exp(delta(CNR*))
        FI(gru,:,p) = exp(F(p,:))/KBR(p) ; %  F(R(i),n)
%         G(gru,p) = nanmean(minus(F(p,:),log(FI(gru,:,p)))) ;
        G(gru,p) = nanmean(minus(F(p,:),log(TT))) ;
%         clf (figure(2)); 
%         get(figure(2));  
%         plot(r_0(1,:),G(gru,:,p),'linewidth',1.5,'color','k');  hold on ; grid on ;
%         keyboard
    end  
   

%     get(figure(2));  
%     plot(r_0(1,:),K(gru,:),'linewidth',1.5,'color',[RGB(1),RGB(2),RGB(3)]);  hold on ; grid on ;
%     grid on ; box on
%     xlabel(' scanning distance R [meters]','color','k');
%     ylabel('Instrumental constant K','color','k');
    
    ct = ct + l;
    
%     keyboard
end

% fu = 1 ; % color definition
% clf (figure(1))
% for p = 1 : length(alphaP)
%     RGB=JET(fu,:);
%     get(figure(1));   
%     plot(r_0(1,:),FI(1,:,p),'linewidth',1.5,'color',[RGB(1),RGB(2),RGB(3)]);  hold on ; grid on ;
%     plot(r_0(1,:),TT,'linewidth',2,'color','k');  hold on ; grid on ;
%     grid on ; box on
%     xlabel(' scanning distance R [meters]','color','k');
%     ylabel('Normalised Instrumental Function F(R)','color','k');
%     ylim([0 1.25]);
%     fu = fu + 1 ;    
% end

%%% calculate K
clear pv Y XX BB INT R RINT STATS S a
Y(:,1) = reshape(G,[gru*p 1]);
XX(:,2) = log(reshape(regi,[gru*p 1]));
XX(:,1) = 1; 
[B,BINT,R,RINT,STATS] = regress(Y,XX,0.01); 
a = B(2); % angle of the linear fit
lnK = B(1) % the free coefficient "b" of the linear fit
log(K)

    %     reg_erri = BINT(2,:)/(-2);
offs_erri = BINT(1,:) % standard error of the free coefficient "b" of the linear fit

% LR = XX(:,2).^(1-a); % lidar ratio for each PPI
clf (figure(12))  ;
h12 = figure(12);
yy = plus(a*XX(:,2), lnK) ;
scatter(XX(:,2),Y,'Marker','o','MarkerFaceColor','r','MarkerEdgeColor','none'); hold on ;
plot(XX(:,2),yy,'color','k'); grid on ; box on
% xlim([r_0(1,di(1)) r_0(1,di(2))]);
xlabel('ln(alpha(n))','color','k');
ylabel('CNR(R,n)/espi + 2lnR + 2*alpha(n)*R - lnF(R)','color','k'); % set(h12,'Position',[650 1 560 420]);
title({['linear regression for a group of simulated PPI'];...
    ['CNR(R,n)/espi + 2lnR + 2*alpha(n)*R - lnF(R) against ln(alpha(n))'];['the offset of linear regression = ln K']});

keyboard
% figure(3); plot(FI)

% FR(cpt,:) = exp(plus(MN,2*reg*r_0(1,1:sdi))) ;
 
%%%  plot the map of random noise
% figure(5)
% surf(d1,z1,R1,'EdgeLighting','phong','LineStyle','none'); 
% view(0,90);
% axis equal;
% xlabel(['     Range West / East ', '(m)'],'color','k');
% ylabel(['     Range South / North ', '(m)'],'color','k');
% xlim([-3000 3000]);
% ylim([-3000 3000]);
% hold on;
% box on;
% grid off;
% caxis([-1 1]);
% h=colorbar;
% set(get(h,'Ylabel'),'color','k');
% set(gca,'Xcolor','k','Ycolor','k');
% title({'Random noise applied to simulated CNR'},'color','k') ;

for i = 1 : size(cnr,1)
    clear B BINT RI RINT STATS ccnr M KN pv di y x offs offs_err F KBR FT


    ccnr = plus(nanmoving_average(nr(i,:),3)/epsilon,2*log(r_0(1,:)));
% 
%     get(figure(4)) ;  
%     plot(r_0(1,:),nr(i,:),'linewidth',1,'color','k');  hold on ; grid on ;
%     xlabel(' scanning distance R [meters]','color','k'); % set(h12,'Position',[650 1 560 420]);
%     ylabel('CNR(R) ','color','k');
%     title({'simulated CNR(R) with const alpha, same F(R) and random noise'});
    
    %%% calculate alpha
    M = nanmoving_average(minus(ccnr(1,1:58),ccnr(1,2:59)),1); % delta CNR`(R) = CNR`(R1) - CNR`(R2) 
    KN  = exp(M);
    KN(57:58) = NaN;
    pv = nanmax(KN) ;
    pi(i) = min(find(KN == pv)); % distance where this maximum occurs

%     get(figure(5)) ;  
%     plot(r_0(1,1:58),KN,'linewidth',1,'color','k');  hold on ; grid on ;

    % di(1) =  min(find(KN >= pv )) ;
    % di(2) =  max(find(KN >= pv )) ;
    
    di(1) =  pi(i) ;
    di(2) =  57 ;
    % r_0(1,di)
    % 
    % mean(exp(r_0(1,di(1):di(2))))

    y(:,1) = ccnr(di(1) : di(2)) ; % cnr corrected by epsilon and 2lnR 
    x(:,2) = r_0(1,di(1) : di(2)) ; % R
    x(:,1) = 1;

    [B,BINT,RI,RINT,STATS] = regress(y,x,0.01); 

    reg1(i) = B(2)/(-2) ; % angle of the linear fit
    offs = B(1); % the free coefficient "b" of the linear fit
    reg_err(i,1:2) = BINT(2,:)/(-2);
    offs_err = BINT(1,:);

% clf (figure(12))  ;
% h12 = figure(12);
% yy = plus(-2*reg1*r_0(1,:), offs) ;
% scatter(x(:,2),y,'Marker','o','MarkerFaceColor','r','MarkerEdgeColor','none'); hold on ;
% plot(r_0(1,:),yy,'color','k'); grid on ; box on
% xlim([r_0(1,di(1)) r_0(1,di(2))]);
% ylabel('CNR(R)/epsilon + 2*lnR','color','k');
% xlabel(' scanning distance R [meters]','color','k'); % set(h12,'Position',[650 1 560 420]);

%%% evaluate the instrumental function
F = exp(plus(ccnr,2*reg1(i)*r_0(1,:))) ; % best estimate of CNR`(R(i)) plus 2*alpha*R(i) = ln (F(R(i))*K*beta)
KBR =  nanmean(F(di(1) : di(2))) ; % average ln(F(R(i))*K*beta) within the peak of exp(delta(CNR*))
FT = F/KBR ;

get(figure(1));
% scatter(r_0(1,:),TT,'Marker','o','MarkerFaceColor','g','MarkerEdgeColor','none'); hold on ;
% scatter(r_0(1,:),FT,'Marker','o','MarkerFaceColor','r','MarkerEdgeColor','none'); hold on ;
plot(r_0(1,:),FT,'linewidth',1,'color','k');  hold on ; grid on ;

%%% what happens with F(R) when varying the value of alpha ?
% figure(17)
% clear FT FN xp U1 U2 x reg FU
% fu = 1 ;
% fp = 1.43;
% cpt = 1;
% for reg = 0 : 0.05*10^(-3) : 0.35*10^(-3)
% 
%         clear F KBR
%         F = exp(plus(ccnr,2*reg*r_0(1,:))) ; % best estimate of CNR`(R(i)) plus 2*alpha*R(i) = ln (F(R(i))*K*beta)
%         KBR =  nanmean(F(di(1) : di(2)))  % average ln(F(R(i))*K*beta) within the peak of exp(delta(CNR*))
%         FT(cpt,:) = F/KBR ;
%         RGB=JET(fu,:);
%         scatter(r_0(1,:),FT(cpt,:),'Marker','o','MarkerFaceColor',[RGB(1),RGB(2),RGB(3)],'MarkerEdgeColor','none'); hold on ;
%         text(100,fp, [ num2str(reg*1000) ' km^{-1} '], 'color',[RGB(1),RGB(2),RGB(3)]);
%                               
%         fu = fu+8 ;
%         fp = fp - 0.15;
%         cpt = cpt + 1;
% end
% 
% FN = abs(minus(FT(1,:), FT(size(FT,1),:))) 
% FN(1:20) = NaN;
% xp = find(FN == min(FN)) 
% r_0(1,xp)
% 
% U1 = mean(ccnr(di(1)+2:di(2))) ;
% U2 = 2*mean(r_0(1,di(1)+2:di(2))) ;
% 
% x = minus(U1 , ccnr(xp)) / minus(2 * r_0(1,xp) , U2 ) % alpha corrected at the distance of convergence XP
% 
% clear F KBR
% get(figure(1))
% F = exp(plus(ccnr,2*x*r_0(1,:))) ; % best estimate of CNR`(R(i)) plus 2*alpha*R(i) = ln (F(R(i))*K*beta)
% KBR =  nanmean(F(di(1) : di(2))) ;
% FU = F/KBR ;
% scatter(r_0(1,:),FU,'Marker','o','MarkerFaceColor','k','MarkerEdgeColor','none'); hold on ;
% grid on ; box on
% xlabel(' scanning distance R [meters]','color','k');
% ylabel('Normalised Instrumental Function F(R)','color','k');
% ylim([0 1.1]);

% keyboard
end

get(figure(1));
% scatter(r_0(1,:),TT,'Marker','o','MarkerFaceColor','r','MarkerEdgeColor','none'); hold on ;
% scatter(r_0(1,:),FI,'Marker','o','MarkerFaceColor','g','MarkerEdgeColor','none'); hold on ;
plot(r_0(1,:),TT,'linewidth',1,'color','r');  hold on ; grid on ;
plot(r_0(1,:),FI,'linewidth',1,'color','g');  hold on ; grid on ;
grid on ; box on
xlabel(' scanning distance R [meters]','color','k');
ylabel('Normalised Instrumental Function F(R)','color','k');
ylim([0 1.25]);


clf (figure(6))
f6 = figure(6);
scatter(1:length(reg1),reg1*1000,'Marker','o','MarkerFaceColor','k','MarkerEdgeColor','none'); 
grid on; box on ; hold on; 
% set(f6,'Position',[1250 1 560 420]); 
xlabel(' azimuth from N [deg]','color','k');
ylabel('extinction coefficient [km^{-1}]','color','k');
xlim([0 360]);
ylim([0 nanmax(reg1)*1000-0.001]);
                               

clf (figure(7))
f6 = figure(7);
scatter(1:length(pi),r_0(1,pi),'Marker','o','MarkerFaceColor','k','MarkerEdgeColor','none'); 
grid on; box on ; hold on; 
% set(f6,'Position',[1250 1 560 420]); 
xlabel(' azimuth from N [deg]','color','k');
ylabel('extinction coefficient [km^{-1}]','color','k');
xlim([0 360]);
% ylim([0 nanmax(reg1)*1000-0.001]);


%%% evaluate K within the range where ln (F(R)) = 0 (where F(R) = 1)
%%% suppose that we don't know LR   
% figure(8);
% fu = 1 ;
% cpt = 1;
% for l = 10 : 5 :35
%     K(cpt,1:59) = exp(minus(plus(ccnr,2*reg*r_0(1,:)),plus(log(reg/l), log(FT)))) ;
%     RGB=JET(fu,:);    
%     scatter(r_0(1,:),K(cpt,:),'Marker','o','MarkerFaceColor',[RGB(1),RGB(2),RGB(3)],'MarkerEdgeColor','none'); hold on ;
%     fu = fu+5 ;
%     cpt = cpt+1;
% end


                                                
                                                
                                                