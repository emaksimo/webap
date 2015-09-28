clear cnr vr cf

lambda=1543;
lambda_mic=1.543;
lambdaN=1543;
res=50;
max_range=3000;
max_range2=4000;
ad_range=50;
max_range1=max_range+ad_range;
max_cnr=-10;
max_vr=10;
max_dvr=3;
fuseau=0;
temps='UTC';
niveau='AGL';
gl=0;
nb_par=8; %nb parametre par niveau
seuil_cnr=-27;
ad_seuil=1;
mode='PPI';
location='Dunkerque';

entete=42;
root=importdata([chemin1,char(fichier)],'\t',entete); % fichier(L) when working with some specific day
dte0=root.textdata(:,1);
nline0=size(dte0,1);
dte(:,1)=dte0(entete+1:nline0,1);
sdte=char(dte);
aa=str2num(sdte(:,1:4));
mm=str2num(sdte(:,6:7));
jj=str2num(sdte(:,9:10));
hh=str2num(sdte(:,12:14));
mn=str2num(sdte(:,16:17));
ss=str2num(sdte(:,19:20));
xdate=datenum(aa',mm',jj',hh',mn',ss');

nb_porte=(max_range-50)/res;
nbline=size(aa,1);

cc=root.data(1:nbline,:);

% gps=cc(:,1);
% int_temp=cc(:,2);
% ext_temp=cc(:,3);
% press=cc(:,4);
% hum=cc(:,5);
azcol=cc(:,6);
elcol=cc(:,7);


%%%%%%%%%%%%% CNR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_col=10;
compteur=1;
for i = num_col : nb_par : size(cc,2)
     cnr(:,compteur)=cc(:,i);
     if compteur == 59
         break
     end
     compteur = compteur + 1;    
end
ncol=compteur;

cnr(cnr<seuil_cnr)=seuil_cnr;
cnr(cnr<seuil_cnr-ad_seuil)=seuil_cnr;

for k=1:nbline
        r_0(k,:)=100:50:max_range;
end

 for k=1:nbline  
       for j=1:ncol
        el(k,j)=elcol(k); 
        az(k,j)=azcol(k);
        d1(k,j)=r_0(k,j).*sin(az(k)*pi/180);
        z1(k,j)=r_0(k,j).*cos(az(k)*pi/180);
       end;
 end;
 
  
   % %$$$$$$$$$$$$$$$$$$$$$$$$$$ SCAN CNR $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
if loopme ~= 0
    clf (figure(9));
    cf =  figure(9) ;
%     set(cf,'Position',[1 1 560 420]); 
    set(cf,'Position',[60 10 560 420]);     
    surfc(d1,z1,cnr, 'LineStyle','none','EdgeLighting','phong');
    shading(gca,'flat');
    view(0,90);
%     title([mode, ' of CNR [dB] at ',location,' (',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
%         ' -',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
%         ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20),') ']);
    caxis([seuil_cnr max_cnr]);
    axis equal;
    xlabel(['     Range West / East ', '(m)']);
    ylabel(['     Range South / North ', '(m)']);
    xlim([-max_range1 max_range1]);%complet
    ylim([-max_range1 max_range1]);%complet
    hold on;
    box on; 
    grid on;
    colorbar;
    axe_PPI;
    title(['PPI, elevation angle ',num2str(round(el(1))),'^o, ',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),31),'-',datestr(datenum(aa(nbline),...
    mm(nbline),jj(nbline),hh(nbline),mn(nbline),ss(nbline)),13)]);   
% % end

% if loopme ~= 0
    %%%%%%%%%%%%%Radial wind speed%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%     num_col=8;
%     compteur=1;
%     for i = num_col : nb_par : size(cc,2)
%          vr(:,compteur)=cc(:,i);
%          compteur=compteur+1;
%     end;
%     vr(cnr<=seuil_cnr)=NaN;
% %     % %$$$$$$$$$$$$$$$$$$$$$$$$$$ SCAN Vr $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
% % 
%     clf (figure(1))
%     un = figure(1)
%     set(un,'Position',[1150 1 400 350]);
%     subplot('Position',[0.07 0.07 0.85 0.95]);
%     surf(d1,z1,vr,'EdgeLighting','phong','LineStyle','none'); 
% %     title(['Radial wind speed [m/s]',' ',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
% %         ' -',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
% %         ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20)]);
%     view(0,90);
%     axis equal;
%     xlabel(['     Range West / East ', '(m)']);
%     ylabel(['     Range South / North ', '(m)']);
%     xlim([-max_range1 max_range1]);%complet
%     ylim([-max_range1 max_range1]);%complet
%     caxis([-max_vr max_vr]);
%     hold on;
%     box on;
%     grid on;
%     colorbar;
    
    
%     axe_PPI;
%      titre1=['PPI_',num2str(round(el(1))),'_',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),31),'-',datestr(datenum(aa(nbline),...
%         mm(nbline),jj(nbline),hh(nbline),mn(nbline),ss(nbline)),13)];   
    %  imageok=[chemin2,'VR_',titre1,'.png'];
    %  imageokbis=[chemin2bis,'VR_',titre1,'.eps'];
    %  
    %  set(gcf,'InvertHardcopy','off')
%     %  print (figure(2),'-dpng','-r400',imageok);
%     %print (figure(2),'-depsc2',imageokbis);
% 
%     %%%%%%%%%%%%%Radial wind speed DISPERSION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     num_col=9;
%     compteur=1;
%     for i=num_col:nb_par:size(cc,2)
%      dvr(:,compteur)=cc(:,i);
%      compteur=compteur+1;
%     end;
%     dvr(cnr<=seuil_cnr)=NaN;
%     % %$$$$$$$$$$$$$$$$$$$$$$$$$$ SCAN DVR $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%     clf (figure(3)) 
%     figure(3)
%      surf(d1,z1,dvr,'EdgeLighting','phong','LineStyle','none'); 
%     title([mode, ' of radial wind speed dispersion [m/s] at ',location,' (',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
%         ' -',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
%         ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20),') ']);
%      %shading interp
%     view(0,90);
%     axis equal;
%     xlabel(['     Range West / East ', '(m)']);
%     ylabel(['     Range South / North ', '(m)']);
%     xlim([-max_range1 max_range1]);%complet
%     ylim([-max_range1 max_range1]);%complet
%     caxis([0 max_dvr]);
%     hold on;
%     box on;
%     grid off;
%     colorbar;
%     axe_PPI;
%      titre1=['PPI_',num2str(round(el(1))),'_',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),31),'-',datestr(datenum(aa(nbline),...
%         mm(nbline),jj(nbline),hh(nbline),mn(nbline),ss(nbline)),13)];   
%     %  imageok=[chemin2,'DVR_',titre1,'.png'];
%     %  imageokbis=[chemin2bis,'DVR_',titre1,'.eps'];
%     %  set(gcf,'InvertHardcopy','off')
%     %  print (figure(3),'-dpng','-r500',imageok);
%     %print (figure(3),'-depsc2',imageokbis);
end

clear elcol dte0 root nline0 dte sdte max_range2 max_vr location loc
clear xdate nb_porte cc gps int_temp ext_temp press hum nb_par nb_sect mode niveau nbline ncol el azcol lambda_mic lambdaN lambda
clear vr dvr titre1 imageok imageokbis alti xaxe yaxe u un theta_axe theta_r temps rzaxe rxaxe ryaxe  st rr rj res r_axe
% clear d1 z1 cnr r_0 azaa  mm jj hh mn ss seuil_cnr max_cnr max_range1  max_range 
 
 