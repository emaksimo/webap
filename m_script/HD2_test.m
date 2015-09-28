%%% create the false cnr ppi R1 R2

clear alphaP Sr cnr betta epsilon figure(6)  BBT K  figure(8) I RC

alphaP = 0.0004; % m-1
Sr = 50 ; 
betta = alphaP/Sr ; % = 0.8 * 10^-5 [m-1 sr-1]
epsilon = 10/log(10) ;
% K = pi * ((0.055)^2) * 3 * (10^7); % pi*r2 [rad/*m2] * 300.000 [m/s] = Ar * c
K=1;

%%% add a function
for j = 1 : size(r_0,2)
    I(1,j) = (20/(0.5+((minus(2*r_0(1,17),2*r_0(1,j)))/3000)^2));
%     I(1,j) = 1 ;
%     I(i,j) = 1.4*81/(pi*100*(.05)^2)
end
% I(find(I == max(I)):length(I)) =  max(I);
figure(4); 
plot(I,'-k','linewidth',2); hold on 
ylabel(['simulated Instrum function [dB] '],'color','k');
xlabel(['scanning distance R [meters]'],'color','k');

for i = 1 : size(r_0,1)
    for j = 1 : size(r_0,2)
        cnr(i,j) = 10*log10((K*I(1,j)*betta*exp(-2*alphaP*r_0(1,j)))/r_0(1,j)^2  )  ; 
%         cnr(1,j) = 10*log10(exp(-2*alphaP*r_0(1,j))/(r_0(1,j)^2))
    end
end

figure(3)
plot(r_0(1,:),cnr(1,:),'-b','linewidth',2); hold on  % initial "typical" CNR profile
ylabel(['simulated CNR [dB] '],'color','k');
xlabel(['scanning distance R [meters]'],'color','k');

% figure(3)
% plot(r_0(1,:),cnr(1,:),'--k','linewidth',2); hold on  % initial "typical" CNR profile
% plot(r_0(1,:),minus(I,10),'--b','linewidth',2); hold on  % initial "typical" CNR profile
% ylabel(['simulated CNR [dB] '],'color','k');
% xlabel(['scanning distance R [meters]'],'color','k');
% title({'Simulated CNR = f(R,alpha,Lidar Ratio) without any noise (with and without a function)'},'color','k') ;

%%% add random noise within [-1 : 1] dB
% R1 = rand([size(cnr,1),size(cnr,2)]);   
% R2 = minus(rand([size(cnr,1),size(cnr,2)]),rand([size(cnr,1),size(cnr,2)]));
% BBT = plus(cnr,R2);

% BBT = cnr ;
% title({'Simulated CNR = f(R,alpha,Lidar Ratio) with 1dB noise (with and without a function)'},'color','k') ;

BBT = cnr; 

%%% add random noise

%%%%
% figure(6)
% surf(d1,z1,BBT,'EdgeLighting','phong','LineStyle','none'); 
% view(0,90);
% axis equal;
% xlabel(['     Range West / East ', '(m)'],'color','k');
% ylabel(['     Range South / North ', '(m)'],'color','k');
% xlim([-max_range1 max_range1]);
% ylim([-max_range1 max_range1]);
% hold on;
% box on;
% grid off;
% h=colorbar;
% set(get(h,'Ylabel'),'color','k');
% set(gca,'Xcolor','k','Ycolor','k')

%%%  plot the map of random noise
% figure(5)
% surf(d1,z1,R2,'EdgeLighting','phong','LineStyle','none'); 
% view(0,90);
% axis equal;
% xlabel(['     Range West / East ', '(m)'],'color','k');
% ylabel(['     Range South / North ', '(m)'],'color','k');
% xlim([-max_range1 max_range1]);
% ylim([-max_range1 max_range1]);
% hold on;
% box on;
% grid off;
% h=colorbar;
% set(get(h,'Ylabel'),'color','k');
% set(gca,'Xcolor','k','Ycolor','k');
% title({'Random noise (within 1dB) applied to simulated CNR'},'color','k') ;
% 
