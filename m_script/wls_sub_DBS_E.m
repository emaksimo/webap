clear root entete dte0 nline0 sdte cc cnr

colordef white
colormap(flipud(jet))
JET= get(gcf,'colormap');
% JET=fliplr(get(gcf,'colormap'));
lambda=1543;
lambda_mic=1.543;
lambdaN=1543;
res=50;
max_range=3000;
max_range2=4000;
ad_range=50;
max_range1=max_range+ad_range;
max_vh=20;
max_vz=1;
max_dvr=2;
fuseau=0;
temps='UTC';
niveau='AGL';
gl=0;
nb_par=8; %nb parametre par niveau
seuil_cnr=-27;
ad_seuil=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Donn�es d'entr�e %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
%  [num2str(L),'/',num2str(length(fichier))]
% fichier(L)
entete=42;
%nline=size(root,2);
root=importdata([chemin1,char(fichier_wind)],'\t',entete);

dte0=root.textdata(:,1);
%tps=root.textdata(:,2);

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

cnr(cnr<seuil_cnr-ad_seuil)=NaN;

for k=1:nbline
    for j=1:ncol
        r_0(k,j)=50*j+50;
    end;
end;
 
 for k=1:nbline  
    for j=1:ncol,
        el(k,j)=elcol(k); 
        az(k,j)=azcol(k);
        z1(k,j)=r_0(k,j).*sin(el(k)*pi/180)+gl;
    end;
end;
     
     
%%%Determination de l'indice max de CNR avant NaN
% [val_CNR,ind_CNR]=cnr(isnan(cnr(nbline,:)));


[max_z1,ind_max]=max(z1(nbline,isnan(cnr(nbline,:))==0));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%  if loopme ~= 0
%          clf (figure(1))
%              figure(1)
%           plot(cnr(nbline,:)',z1(nbline,:)','-ok');
%           hold on;
% 
         alti=['Altitude ',niveau,' (m)'];
%          ylabel(alti);
%          xlabel(' CNR [dB]');
%          xlim([seuil_cnr 10]); 
%          ylim([0 max_z1]);
% 
%          title(['Vertical profil of CNR [dB] at ',location,' (',datestr(datenum(aa(1),mm(1),j(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
%              ' ',temps,', ',datestr(datenum(aa(nbline),mm(nbline),jj(nbline)),20),') ']);
% 
%           titre1=[mode,'_',datestr(datenum(aa(1),mm(1),jj(1),hh(1),mn(1),ss(1)),31),'-',datestr(datenum(aa(nbline),...
%             mm(nbline),jj(nbline),hh(nbline),mn(nbline),ss(nbline)),13)];   
%         % imageok=[chemin2,'CNR_',titre1,'.png'];
%         % imageokbis=[chemin2bis,'CNR_',titre1,'.eps'];
%         %set(gcf,'InvertHardcopy','off')
%         % print (figure(1),'-dpng','-r500',imageok);
%         % print (figure(1),'-depsc2',imageokbis);
%  end
% 
% %%%%%%%%%%%%% VH %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_col=11;
compteur=1;
for i=num_col:nb_par:size(cc,2)
    vh(:,compteur)=cc(:,i);
    compteur=compteur+1;
end;
%vh(isnan(cnr))=NaN;
ncol=compteur-1;


 for k=1:nbline  
    for j=1:ncol,
         zvh(k,j)=r_0(k,j).*sin(el(k)*pi/180)+gl;
    end;
 end;
% 
%  if loopme ~= 0 
%          clf (figure(2))
%          figure(2)
% 
%           plot(vh(nbline,:)',zvh(nbline,:)','-ok');
%           hold on;
% 
%          ylabel(alti);
%         %  xlim([0 max_vh]);%complet
%         %  ylim([0 max_z1]);%complet 
% 
%          xlabel(' Wind speed [m/s]');
%          title(['Vertical profil of horizontal wind speed [m/s] at ',location,' (',datestr(datenum(aa(1),mm(1),j(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
%              ' ',temps,', ',datestr(datenum(aa(nbline),mm(nbline),jj(nbline)),20),') ']);
%         % imageok=[chemin2,'VH_',titre1,'.png'];
%         % imageokbis=[chemin2bis,'VH_',titre1,'.eps'];
%         % print (figure(2),'-dpng','-r500',imageok);
%         % print (figure(2),'-depsc2',imageokbis);
%  end
        
 %%%%%%%%%%%%% DIR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_col=12;
compteur=1;
for i=num_col:nb_par:size(cc,2)
 direction(:,compteur)=cc(:,i);
 compteur=compteur+1;
end;
%vh(isnan(cnr))=NaN;
ncol=compteur-1;

 for k=1:nbline  
       for j=1:ncol,
                zdirection(k,j)=r_0(k,j).*sin(el(k)*pi/180)+gl;
                
       end
 end

 
 if loopme ~= 0;
        clf (figure(5))
        figure(5);         
        for coll = 1 : 1 : size(direction,2)
            if ~isnan(direction(nbline,coll))
                clear RGB
%                 hh = plot(direction(nbline,:)',zdirection(nbline,coll)','-o');  hold on;   % 'sqk');
%                 JT(1,:) = JET(round(zdirection(nbline,j)/5.65),:);
%                 set(hh,'MarkerFaceColor',JT(1,:), 'MarkerSize',10); hold on; 
                if round(vh(nbline,coll)) == 0
                    vh(nbline,coll) = 1 ;
                end
                if round(direction(nbline,coll)/5.65) < 1
                    RGB=JET(1,:);
                else
                    RGB=JET(round(direction(nbline,coll)/5.65),:) ; % first gradation
                end                   
                plot(direction(nbline,coll),zdirection(nbline,coll),'Marker','s','MarkerFaceColor',[RGB(1),RGB(2),RGB(3)],'MarkerEdgeColor','none','markersize',1.5*round(vh(nbline,coll))); hold on;
            end
        end
        
        ylabel('altitude (meters)','fontsize',12,'FontWeight','bold','color','k');
        xlim([0 360]);
        ylim([0 max_z1]);%complet 
        set(gca,'Xtick',[0:90:360]);
        xlabel(' Wind direction [degrees from the North clockwise]','fontsize',12,'FontWeight','bold','color','k');
        title({['Vertical profile of wind direction ',datestr(datenum(aa(1),mm(1),j(1),hh((nbline)),mn((nbline)),ss(nbline)),13) ];[ ]}); % ,...
        
     datestr(datenum(aa(nbline),mm(nbline),jj(nbline)),20)

%         hcb=colorbar('horiz');
%         set(hcb,'position',[0.27    0.0042    0.8    0.1]);  
%         set(get(hcb,'Ylabel'),'string','20yr average MO [Julian day]','fontsize',14,'FontWeight','bold')
%         set(hcb,'ytick',c)
%         set(hcb,'yticklabel',95:10:195,'fontsize',14,'FontWeight','demi')
        
%         title(['Vertical profil of wind direction at ',location,' (',datestr(datenum(aa(1),mm(1),j(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
%      ' ',temps,', ',datestr(datenum(aa(nbline),mm(nbline),jj(nbline)),20),') ']);
%         title(['Vertical profil of wind direction at ',location,' (5 aout 2013) ']);
        %  imageok=[chemin2,'DIR_',titre1,'.png'];
        % imageokbis=[chemin2bis,'DIR_',titre1,'.eps'];
        % print (figure(3),'-dpng','-r500',imageok);
        % print (figure(3),'-depsc2',imageokbis);

%         clf (figure(4))  
%         figure(4)
%         [AX,vithor1,dirvent2]=plotyy(zvh(nbline,1:ind_max)',vh(nbline,1:ind_max)',zdirection(nbline,1:ind_max)',direction(nbline,1:ind_max)');
%         linkaxes(AX,'x');
%         xlabel(alti); 
%         tit1=[datestr(datenum(aa(1),mm(1),j(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
%              ' ',temps,', ',datestr(datenum(aa(nbline),mm(nbline),jj(nbline)),20)];
%          axes(AX(1));
%         %% ylabel('Horizontal Wind Speed (m/s)');
%          ylabel({'Horizontal wind Speed (m/s)',tit1});
%          set(vithor1,'LineStyle','-');
%          set(vithor1,'Marker','o');
%          set(vithor1,'MarkerFaceColor','b');
%          axes(AX(2));
%         %% ylabel({tit1,'Wind Direction (�)'});
%          ylabel('Wind Direction (�)');
%          set(gca,'Ytick',[0:90:360]);
%          set(dirvent2,'LineStyle','sq ');
%         %% set(dirvent2,'Marker','sq');
%          set(dirvent2,'MarkerFaceColor','k');
%          set(gca,'YColor','k');
%          set(dirvent2,'Color','k');
%          ylim([0 360])
%          xlim([0 max_z1]);%complet 
%          %%% print -dpng graphique_vitesse_hor_direction_4juin.png -r500
%          view(90,-90) 
        % imageok=[chemin2,'Dir_VH_',titre1,'.png'];
        % imageokbis=[chemin2bis,'Dir_VH_',titre1,'.eps'];
        % print (figure(4),'-dpng','-r500',imageok);
        % print (figure(4),'-depsc2',imageokbis);
 end

  %%%%%%%%%%%%% VZ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% num_col=15;
% compteur=1;
% for i=num_col:nb_par:size(cc,2)
%  vz(:,compteur)=cc(:,i);
%  compteur=compteur+1;
% end;
% %vh(isnan(cnr))=NaN;
% ncol=compteur-1;
% %vz(isnan(cnr))=NaN;
% 
% 
%  for k=1:nbline  
%        for j=1:ncol,
%          zvz(k,j)=r_0(k,j).*sin(el(k)*pi/180)+gl;
%        end
%  end
     
% if loopme ~= 0
%         clf (figure(5))
%          figure(5)
% 
%           plot(vz(nbline,:)',zvz(nbline,:)','-ok');
%           hold on;
%          ylabel(alti);
%         %  xlim([-max_vz max_vz]);
%         %   ylim([0 max_z1]);%complet 
%           xlabel(' Vertical wind speed [m/s]');
%           title(['Vertical profil of vertical wind speed [m/s] at ',location,' (',datestr(datenum(aa(1),mm(1),j(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
%              ' ',temps,', ',datestr(datenum(aa(nbline),mm(nbline),jj(nbline)),20),') ']);
%         %  imageok=[chemin2,'W_',titre1,'.png'];
%         % imageokbis=[chemin2bis,'W_',titre1,'.eps'];
%         % print (figure(5),'-dpng','-r500',imageok);
%         % print (figure(5),'-depsc2',imageokbis);
% end

  %%%%%%%%%%%%% Radial wind speed DISPERSION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% num_col=9;
% compteur=1;
% for i=num_col:nb_par:size(cc,2)
%  dvr(:,compteur)=cc(:,i);
%  compteur=compteur+1;
% end;
% %vh(isnan(cnr))=NaN;
% ncol=compteur-1;
% dvr(isnan(cnr))=NaN;
% 
%  for k=1:nbline  
%        for j=1:ncol,
%          zdvr(k,j)=r_0(k,j).*sin(el(k)*pi/180)+gl;
%        end
% end
% 
% if loopme ~= 0
%          clf (figure(6))
%          figure(6)
% 
%         plot(dvr(nbline,:)',r_0(nbline,:)','-ok');
%         hold on;
%         alti_range=['Range ',niveau,' (m)'];
%         ylabel(alti_range);
%         xlim([-max_dvr max_dvr]);%c
%          ylim([0 max_z1]);
%           xlabel(' Radial wind speed dispersion [m/s]');
%           title(['Vertical profil of radial wind speed dispersion [m/s] at ',location,' (',datestr(datenum(aa(1),mm(1),j(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
%              ' ',temps,', ',datestr(datenum(aa(nbline),mm(nbline),jj(nbline)),20),') ']);
% 
%         %  imageok=[chemin2,'DVR_',titre1,'.png'];
%         % imageokbis=[chemin2bis,'DVR_',titre1,'.eps'];
%         % print (figure(6),'-dpng','-r500',imageok);
%         % print (figure(6),'-depsc2',imageokbis);
% 
%         % 
%         % im_dir_vh=imread([chemin2,'Dir_VH_',titre1,'.png']);
%         % im_dir_vz=imread([chemin2,'W_',titre1,'.png']);
%         % im_dir_dvr=imread([chemin2,'DVR_',titre1,'.png']);
%         % im_dir_cnr=imread([chemin2,'CNR_',titre1,'.png']);
% 
%         % clf (figure(7))
%         % figure(7)
%         % m=2;%nbligne 
%         % n=2;%nbcolonne
%         % haut1=0.5;
%         % larg1=0.5;
% 
%         % axes('Position', [0, haut1, larg1, haut1]);
%         % image(im_dir_vh);
%         % axis off
%         % axes('Position', [0.5, haut1, larg1, haut1]);
%         % image(im_dir_vz);
%         % axis off
%         % axes('Position', [0, 0, larg1, haut1]);
%         % image(im_dir_dvr);
%         % axis off
%         % axes('Position', [0.5, 0, larg1, haut1]);
%         % image(im_dir_cnr);
%         % axis off
% 
%         %  imageok=[chemin2,'ALL_',titre1,'.png'];
%         %  print (figure(7),'-dpng','-r500',imageok);
%         %  imageokbis=[chemin2bis,'ALL_',titre1,'.eps'];
%         %  print (figure(7),'-depsc2',imageokbis);
% end

clear el elcol az azcol z1 r_0 d1 dte0 root nline0 dte sdte aa  mm mn ss
clear xdate nb_porte cc gps int_temp ext_temp press hum 
clear cnr vr dvr zdvr titre1 imageok imageokbis alti vz zvz z1 vh zvh AX vithor1 dirvent2
clear im_dir_vh im_dir_vz im_dir_dvr im_dir_cnr max_z1 % hh nbline direction  zdirection

