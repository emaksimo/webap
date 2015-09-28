%%%% see also wls_sub_DBS, wls_BBS_loop ...

clear all ;
close all;

startup
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
%res_a=7.5;
fuseau=0;
temps='UTC';
niveau='AGL';
gl=0;
%gl=15;
nb_par=8; %nb parametre par niveau
seuil_cnr=-27;
ad_seuil=1;
entete=42; % when reading the data file
mode='DBS';
location='Dunkerque';
colordef white
colormap(flipud(jet))
JET= get(gcf,'colormap');

core_dir = '/media/elena/Transcend/Elena_ULCO/my_matlab_data/'; % where we store the data in ".m"

%%% Determination de la liste des dossiers et creation de la liste
% mdpath = ['/./media/elena/Transcend/Leosphere/WLS100/']; % main directory path with DBS files
% rep=dir(mdpath);
% it = 1;
%
% for ij = 250:length(rep)
%     clear chemin1 list
%     chemin1=rep(ij).name  ;
%     list = dir([mdpath, chemin1,'/*_DBS.rtd']); % all DBS files within one directory
%     if size(list,1) > 0  % if there is some data within the directory
%         for L = 1 : length(list)  % DBS file within given dossier
% %             fichier = cellstr(list(L).name);  % file name
%             FL(it,1) = fullfile(mdpath, chemin1, cellstr(list(L).name)); % list of all DBS files (with the full path) within one year of measurements
%             it = it+1;
%         end
%     end
% end
%
% data_description = {['FL contains the list of all files of the wind speed and direction'];...
%     ['see script: /m_script/eole/wls_DBS.m']};
% flpath = fullfile(core_dir, ['DBS_filelist_jul2013_jul2014_Dunkerque.mat']);
% save([flpath],'FL','data_description');

load(fullfile(core_dir,['DBS_filelist_jul2013_jul2014_Dunkerque.mat']));
loopme = 0; % "0" = DON'T plot WS and WD plots

for it = 1:size(FL,1)    % read the DBS file
    clear root dt0 nline0 dte sdte xdate aa mm hh mn ss el az z1
    clear cc azcol elcol i j cnr ncol r_0 vh direction

    VSH(it) = NaN; VSHz(it)= NaN;
    VDSH(it)= NaN;

    root=importdata(char(FL(it)),'\t',entete);
    dte0=root.textdata(:,1);
    nline0=size(dte0,1);
    dte(:,1)=dte0(entete+1:nline0,1);
    sdte=char(dte);

    aa=str2num(sdte(:,1:4));
    mm=str2num(sdte(:,6:7));
    jj=str2num(sdte(:,9:10));
    hh=str2num(sdte(:,12:14));
    mn=str2num(sdte(:,16:17));
    ss=str2num(sdte(:,19:20)); % 2-6sec step ?
    nb_porte=(max_range-50)/res;
    nbline=size(aa,1);
    xdate=datenum(aa',mm',jj',hh',mn',ss');
    XD(it) = xdate(nbline); % inverse : datevec(datestr(XD))
    cc=root.data(1:nbline,:); % cnr
%     gps=cc(:,1);
%     int_temp=cc(:,2);
%     ext_temp=cc(:,3);
%     press=cc(:,4);
%     hum=cc(:,5);
    azcol=cc(:,6);
    elcol=cc(:,7);

    cnr(:,:)=cc(:,10:nb_par:size(cc,2));
%     cnr(cnr<seuil_cnr-ad_seuil)=NaN;
    ncol=size(cnr,2)-1;
    vh(:,:)=cc(:,11:nb_par:size(cc,2)); % horizontal wind speed [m/s]
    vh(isnan(cnr))=NaN;
    direction(:,:)=cc(:,12:nb_par:size(cc,2)); % horizontal wind direction
    direction(isnan(cnr))=NaN;

    for j=1:ncol
        r_0(1:nbline,j)=50*j+50;
    end

     for j=1:ncol,
         el(:,j)=sin(elcol(:)*pi/180);
         az(:,j)=azcol(:);
         z1(:,j)=(r_0(:,j).*el(:,1))+gl;
     end

    %%%Determination de l'indice max de CNR avant NaN
    % [val_CNR,ind_CNR]=cnr(isnan(cnr(nbline,:)));

    [max_z1,ind_max]=max(z1(nbline,isnan(cnr(nbline,1:size(z1,2)))==0));

    %%%%%%%%  vertical profile statistics

    VSH(it) = minus(vh(nbline,2),vh(nbline,1))  ; % vertical wind shear [m/s]
    VSHz(it) = minus(z1(nbline,2),z1(nbline,1)) ; % corresponding altitude difference [meters]

    if abs(minus(direction(nbline,2),direction(nbline,1))) < 180
        VDSH(it) = abs(minus(direction(nbline,2),direction(nbline,1))); % vertical shift of horizontal wind direction, units [deg]
    else
        VDSH(it) = minus(360,abs(minus(direction(nbline,2),direction(nbline,1))));
    end

%     if ~isnan(VDSH(it)) && ~isnan(VSH(it))
%         {[num2str(VSH(it)) ' m/s ,  ' num2str(round(VDSH(it))) ' deg']}
%         clf (figure(1)); clf (figure(2))
%         figure(1)
%          plot(vh(nbline,:)',z1(nbline,:)','-ok'); hold on;
%          alti=['Altitude ',niveau,' (m)'];
%          ylabel(alti);
%          xlim([0 max_vh]);
%          ylim([0 max_z1]);
%          grid on; box on
%          xlabel(' Wind speed [m/s]');
%          title({['Vertical profile of horizontal wind speed [m/s] in ',location];[datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
%              ' ',temps,', ',datestr(datenum(aa(nbline),mm(nbline),jj(nbline)),20)]});
%
%         figure(2);
%         for coll = 1 : 1 : size(direction,2)
%             if ~isnan(direction(nbline,coll))
%                 clear RGB
%                 if round(vh(nbline,coll)) == 0
%                     vh(nbline,coll) = 1 ;
%                 end
%                 if round(direction(nbline,coll)/5.65) < 1
%                     RGB=JET(1,:);
%                 else
%                     RGB=JET(round(direction(nbline,coll)/5.65),:) ; % first gradation
%                 end
%                 plot(direction(nbline,coll),z1(nbline,coll),'Marker','s','MarkerFaceColor',[RGB(1),RGB(2),RGB(3)],'MarkerEdgeColor','none','markersize',1.5*round(vh(nbline,coll))); hold on;
%             end
%         end
%
%         ylabel('altitude (meters)','fontsize',12,'FontWeight','bold','color','k');
%         xlim([0 360]);
%         ylim([0 max_z1]);
%         grid on; box on
%         set(gca,'Xtick',[0:90:360]);
%         xlabel(' Wind direction [degrees from the North clockwise]','fontsize',12,'FontWeight','bold','color','k');
%         title({['Vertical profile of the wind direction in ',location];[datestr(datenum(aa(1),mm(1),jj(1),hh((nbline)),mn((nbline)),ss(nbline)),13),...
%              ' ',temps,', ',datestr(datenum(aa(nbline),mm(nbline),jj(nbline)),20)]});
%         datestr(datenum(aa(nbline),mm(nbline),jj(nbline)),20)
%         keyboard
%      end
end

data_description = {['record of the wind speed shear and the vertical direction shift'];...
 ['when comparing two lowest vertical lidar measurements'];...
 ['see script: /m_script/eole/wls_DBS.m'];...
 ['datevec(datestr(XD)) is the date and time of the measurement'];...
 ['VSH(it) = vertical wind shear [m/s] = upper minus lower'];...
 ['VDSH(it) = vertical shift of horizontal wind direction, units [deg]'];...
 ['VSHz(it) = corresponding altitude difference [meters]']};

flpath = fullfile(core_dir, ['WindShear_record_jul2013_jul2014_Dunkerque.mat']);
save([flpath],'VSH','VDSH','VSHz','XD','data_description');


%%
clear all
close all
colormap(flipud(jet))
JET= get(gcf,'colormap');

core_dir = '/media/elena/Transcend/Elena_ULCO/my_matlab_data/'; % where we store the data in ".m"
load(fullfile(core_dir,['WindShear_record_jul2013_jul2014_Dunkerque.mat']));

% % % check that nanmin(VSHz) == nanmax(VSHz)
R = datevec(datestr(XD));

cpt = 1
f1 = figure(1); f2 = figure(2)
for mon = 1:12 % month
    for hhr = 1:24 % hour of the day
        clear et
        et = find(R(:,2) == mon & R(:,4) >= hhr-1 & R(:,4) < hhr); % lines within the record corresponding to given selection
        AVMe(hhr,mon) = nanmean(VSH(et)) ; % monthly average wind shear for given time of the day
        AVMa(hhr,mon) = nanmax(VSH(et)) ; % ever observed max instant wind shear for given time of the day
        AVDMe(hhr,mon) = nanmean(VDSH(et)); % monthly average wind direction shift for given time of the day
        AVDMe(hhr,mon) = nanmax(VDSH(et));
        SI(hhr,mon) = length(et);
    end

    RGB=JET(cpt,:);
    set(0, 'CurrentFigure',f1);
        clear Y T
        Y(:,1) = runmean([AVMe(:,mon);AVMe(:,mon);AVMe(:,mon)],1) ;
        T(:,1) = [1:1:24,1:1:24,1:1:24];
        plot(T(25:48),Y(25:48,1),'Marker','none','Color',[RGB(1),RGB(2),RGB(3)]);
        text(10+cpt/5,1.9,num2str(mon),'Color',[RGB(1),RGB(2),RGB(3)]);
        hold on
    set(0, 'CurrentFigure',f2);
        plot(1:24,AVMa(:,mon),'Marker','none','Color',[RGB(1),RGB(2),RGB(3)]);
        text(1+cpt/5,17,num2str(mon),'Color',[RGB(1),RGB(2),RGB(3)]);
        hold on
%     set(0, 'CurrentFigure',f3);
%         clear Y T
%         plot(1:24,AVDMe(:,mon),'Marker','none','Color',[RGB(1),RGB(2),RGB(3)]);
%         text(1+cpt/5,25,num2str(mon),'Color',[RGB(1),RGB(2),RGB(3)]);
%         hold on
%
%      set(0, 'CurrentFigure',f4);
%         plot(1:24,AVMa(:,mon)'Marker','none','Color',[RGB(1),RGB(2),RGB(3)]);
%         text(1+cpt/5,25,num2str(mon),'Color',[RGB(1),RGB(2),RGB(3)]);
%         hold on
     cpt = cpt + 5;
end

set(0, 'CurrentFigure',f1);
ylabel('vertical wind shear [m/s]','fontsize',11,'FontWeight','bold','color','k');
title({['diurnal evolution of the vertical wind shear (150m - 100m)'];['individually for each month']},'fontsize',11,'FontWeight','bold','color','k');
grid on; box on;
set(gca,'Xtick',[0:3:24],'XtickLabel',[0:3:24],'fontsize',11);
xlabel(' time of the day [GMT]','FontWeight','bold','color','k','fontsize',11);

set(0, 'CurrentFigure',f2);
ylabel('MAX observed vertical wind shear [m/s]','fontsize',11,'FontWeight','bold','color','k');
title({['The strongest instanteneous vertical wind shear (150m - 100m)'];['individually for each month']},'fontsize',11,'FontWeight','bold','color','k');
grid on; box on;
set(gca,'Xtick',[0:3:24],'XtickLabel',[0:3:24],'fontsize',11);
xlabel(' time of the day [GMT]','FontWeight','bold','color','k','fontsize',11);

% set(0, 'CurrentFigure',f3);
% ylabel('wind direction shift [^o]','fontsize',11,'FontWeight','bold','color','k');
% title({['diurnal evolution of the vertical wind shift (150m - 100m)'];['individually for each month']},'fontsize',11,'FontWeight','bold','color','k');
% grid on; box on;
% set(gca,'Xtick',[0:3:24],'XtickLabel',[0:3:24],'fontsize',11);
% xlabel(' time of the day [GMT]','FontWeight','bold','color','k','fontsize',11);



%%%% Weibull distribution at 96m altitude



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

% clear el elcol az azcol z1 r_0 d1 dte0 root nline0 dte sdte aa  mm mn ss
% clear xdate nb_porte cc gps int_temp ext_temp press hum
% clear cnr vr dvr zdvr titre1 imageok imageokbis alti vz zvz z1 vh zvh AX vithor1 dirvent2
% clear im_dir_vh im_dir_vz im_dir_dvr im_dir_cnr max_z1 % hh nbline direction  zdirection
%
