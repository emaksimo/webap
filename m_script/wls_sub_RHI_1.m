%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Donn�es d'entr�e %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
clear cnr r_0 el az z1 d1 vr dvr CN IL K INV cf u

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
% niveau='ASL';
% gl=15;
niveau='AGL';
gl=0;
nb_par=8; %nb parametre par niveau
seuil_cnr=-27;
ad_seuil=1;

entete=42;
root=importdata([chemin1,char(fichier_rhi)],'\t',entete);
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
% xdate=xdate';

nb_porte=(max_range-50)/res;
nbline=size(aa,1);

cc=root.data(1:nbline,:); %cc(ligne, colonne)

gps=cc(:,1);
int_temp=cc(:,2);
ext_temp=cc(:,3);
press=cc(:,4);
hum=cc(:,5);
azcol=cc(:,6);
elcol=cc(:,7);

%%%%%%%%%%%%% CNR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_col=10;
compteur=1;
for i=num_col:nb_par:size(cc,2)
    cnr(:,compteur)=cc(:,i);
    compteur=compteur+1;
end;
ncol=compteur-1;

%cnr(cnr<seuil_cnr)=seuil_cnr;
cnr(cnr<seuil_cnr-ad_seuil)=NaN;

for k=1:nbline
    for j=1:ncol
        r_0(k,j)=50*j+50;
    end
end

 for k=1:nbline  
       for j=1:ncol,
        el(k,j)=elcol(k);  % azimuth relative to the horizontal surface : from 2 deg to 179 deg
        az(k,j)=azcol(k);  % azimuth (relative to the North! same for the first 90 elevation angles and same for the other 90 anges
        z1(k,j)=r_0(k,j).*sin(el(k)*pi/180)+gl; % altitude
        d1(k,j)=r_0(k,j).*cos(el(k)*pi/180);    % projection of R on the horizontal surface
       end
 end

%%%%$$$$$$$$$$$$$$$$$$$$$$$$$$ SCAN CNR $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
if loopme ~= 0   
%         colordef black
        clf (figure(10))
        cf = figure(10) ;
        set(cf,'Position',[1150 754 560 232]);
        subplot('Position',[0.09 0.028 0.83 0.99]);
        
        surf(d1,z1,cnr,'EdgeLighting','phong','LineStyle','none'); 
        view(0,90);
%         title([mode, ' of CNR [dB] at ',location,' (',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
%             ' -',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
%             ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20),') ']);
        caxis([seuil_cnr max_cnr]);
        axis equal;
        xlabel('horizontal distance off the lidar [meters] in South (left) - North (right) direction');
        ylabel('altitude [meters]');
        xlim([-max_range1 max_range1]);
        ylim([0 2200]);
        hold on;
        box on;

        hcb=colorbar;
        u=get(hcb,'position');

        set(hcb,'position',[u(1)+0.09   u(2)-0.03    u(3)/2    u(4)*1.15]); % 0.8201    0.2859    0.0446    0.4375

        title(['RHI, azimuth relative to North = ', num2str(round(az(1))),', ',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),31),'-',datestr(datenum(aa(nbline),...
         mm(nbline),jj(nbline),hh(nbline),mn(nbline),ss(nbline)),13)]);   
        %  titre1=['RHI_',num2str(round(az(1))),'_',str2num(aa(1)),str2num(mm(1)),jj(1),str2num(hh(1)),str2num(mn(1)),str2num(ss(1)),'-',str2num(aa(nbline)),...
        % str2num(mm(nbline)),str2num(jj(nbline)),str2num(hh(nbline)),str2num(mn(nbline)),ss(nbline)),13)];   

%         imageok=['/media/Transcend/LNA/multi_angle_approach/filter2/RHI' num2str(cpt+1) '.png'];
        % imageokbis=[chemin2bis,'CNR_',titre1,'.eps'];
        % set(gcf,'InvertHardcopy','off')
%         print (figure(10),'-dpng','-r400',imageok);
        %print (figure(1),'-depsc2',imageokbis);


        %%%%%%%%%%%%%Radial wind speed%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        num_col=8;
        compteur=1;
        for i=num_col:nb_par:size(cc,2)
            vr(:,compteur)=cc(:,i);
            compteur=compteur+1;
        end
        vr(isnan(cnr))=NaN;
%         % %$$$$$$$$$$$$$$$$$$$$$$$$$$ SCAN VR $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        clf (figure(2)); clear cf u;
        cf = figure(2);         
        set(cf,'Position',[1150 500 560 170]);
        subplot('Position',[0.07 0.035 0.83 0.95]);
        
        surf(d1,z1,vr,'EdgeLighting','phong','LineStyle','none'); 
%         title([mode, ' of radial wind speed [m/s] at ',location,' (',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
%             ' -',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
%             ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20),') ']);
        
        view(0,90);
        axis equal;
        alti=['Altitude ',niveau,' (m)'];
        ylabel(alti);
        xlim([-max_range1 max_range1]);%complet
        ylim([0 max_range1]);%complet
        caxis([-max_vr max_vr]);
        hold on;
        box on;
        grid on;
        hcb=colorbar;
        u=get(hcb,'position');
        set(hcb,'position',[u(1)+0.09   u(2)-0.03    u(3)/1.2    u(4)]); % u(3)/2
        
%         % xlabel(['     Range ',orientation,' (m)'])%�����
%          axe_RHI;
%          titre1=['RHI_',num2str(round(az(1))),'_',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),31),'-',datestr(datenum(aa(nbline),...
%             mm(nbline),jj(nbline),hh(nbline),mn(nbline),ss(nbline)),13)];   
%         % imageok=[chemin2,'VR_',titre1,'.png'];
%         % imageokbis=[chemin2bis,'VR_',titre1,'.eps'];
%         % 
%         % set(gcf,'InvertHardcopy','off')
%         % print (figure(2),'-dpng','-r400',imageok);
%         %print (figure(2),'-depsc2',imageokbis);
% 
% 
%         %%%%%%%%%%%%%Radial wind speed DISPERSION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         num_col=9;
%         compteur=1;
%         for i=num_col:nb_par:size(cc,2)
%          dvr(:,compteur)=cc(:,i);
%          compteur=compteur+1;
%         end;
%         dvr(isnan(cnr))=NaN;
%         % %$$$$$$$$$$$$$$$$$$$$$$$$$$ SCAN DVR $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%         clf (figure(3)) 
%         figure(3)
%          surf(d1,z1,dvr,'EdgeLighting','phong','LineStyle','none'); 
%         title([mode, ' of radial wind speed dispersion [m/s] at ',location,' (',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),13),...
%             ' -',datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
%             ' ',temps,', ',datestr(datenum(aa(1),mm(1),jj(1)),20),') ']);
%          %shading interp
%         view(0,90);
%         axis equal;
%         alti=['Altitude ',niveau,' (m)'];
%         ylabel(alti);
%         xlim([-max_range1 max_range1]);%complet
%         ylim([0 max_range1]);%complet
%         caxis([0 max_dvr]);
%         hold on;
%         box on;
%         grid off;
%         colorbar;
%         % xlabel(['     Range ',orientation,' (m)'])%�����
%          axe_RHI;
%          titre1=['RHI_',num2str(round(az(1))),'_',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),31),'-',datestr(datenum(aa(nbline),...
%             mm(nbline),jj(nbline),hh(nbline),mn(nbline),ss(nbline)),13)];   
%         % imageok=[chemin2,'DVR_',titre1,'.png'];
%         % imageokbis=[chemin2bis,'DVR_',titre1,'.eps'];
%         % set(gcf,'InvertHardcopy','off')
%         % print (figure(3),'-dpng','-r400',imageok);
%         %print (figure(3),'-depsc2',imageokbis);
end

%%% average cnr at each altitude
% altit = 60 : 10 : nanmax(nanmax(z1));
% 
% for alt = 1 : length(altit)
%         clear K
%         K = cnr(find(z1 <= alt + 5 & z1 >= alt - 5 )) ; 
%         CN(alt,1) = nanmean(K) ; % average cnr
%         INV(alt,1) = 0 ;
%         
%         if alt > 5 & (nanmin(CN(alt-2 : alt)) > nanmean(CN(alt-5 : alt-3)) ) % the last three CNR values are stronger compared to the previous 3
%             INV(alt,1) = 1 ;
%         end
% end
% 
% if length(find(INV == 1)) > 0
%     IL = altit(min(find(INV == 1))); % the height of the boundary mixing layer, where CNR decreases with height
% else
%     IL = 1100 ;  
% end
% 
% if loopme ~= 0
%         figure(4)
%         colordef white % default figure window
%         plot(altit,CN); hold on
%         pp(1:30) = IL;
%         plot(pp,-28:1)
% end

clear compteur ad_range ad_seuil fuseau fg dte0 root nline0 dte sdte aa  mm jj mn ss % el elcol az azcol z1 r_0 d1 cnr
clear xdate nb_porte nbline cc gps int_temp ext_temp press hum  max_dvr  max_cnr gl elcol entete 
clear vr dvr titre1 imageok imageokbis alti max_range max_range1 max_range2 max_vr nb_par ncol niveau res seuil_cnr temps
 

