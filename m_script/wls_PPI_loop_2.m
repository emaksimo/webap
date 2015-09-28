%%% previous script : result_instr_func_allbestPPI.m
%%% apply alpha, F(R) and the smallest K*beta(ref) to all best 235 PPI

% clear all 
% close all

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

% load('FKBref_235PPI.mat'); 
% IF = instrum function for each 10-day period,
% last column of 'IF' is the overall IF if considering all best PPI together
% 'KB' is K*beta(ref) for each group. the last value of KB is the overall KB if considering all best PPI together

C = min(KB); % the smallest K*beta(ref) out of 10 PPI groups is used here
epsilon = 10/log(10) ;

%%% upload the list of the best 235 PPI (script : result.m)
% list of PPI and corresponding scanning distances where alpha was determined
load('alpha_homogeneous_cases.mat');   % year 2013
load('alpha_homogeneous_cases_2.mat'); % year 2014

%%%  SM(cpt+1,:) = [ij L reg_err(2) reg reg_err(1) offs offs_err ah];  
%%%  FR(cpt+1,:) = exp(plus(MN,2*reg*r_0(1,:))) ;

% load(['/media/Transcend/Elena_ULCO/my_matlab_data/FKBref_2355PPI.mat']); see % result_instr_func_allbestPPI.m
% %'KB','IF'  


rep=dir(['/./media/Transcend/Leosphere/WLS100/']);
loopme = 1 ; 

for g = 1 : size(SM,1)    
     clear list chemin0 chemin1 ij L fichier cnr
     ij = SM(g,1) ; % directtory counter
     L  = SM(g,2) ; % PPI file within the directory
     
     chemin0=(['/./media/Transcend/Leosphere/WLS100/' rep(ij).name '/']);
     chemin1=(['/./media/Transcend/Leosphere/WLS100/' rep(ij).name '/']);        
     list = dir([chemin1,'/*_PPI.rtd']);  % all PPI files within one directory
     fichier = cellstr(list(L).name) ;  % PPI file name
%      wls_sub_PPI_2 ; % upload CNR data 

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


     num_col=10;
     compteur=1;
     
     for i = num_col : nb_par : size(cc,2)
         cnr(:,compteur)=cc(:,i);
         compteur = compteur + 1;
     end
     
     ncol=compteur-1;

     cnr(cnr<seuil_cnr)=seuil_cnr;
     cnr(cnr<seuil_cnr-ad_seuil)=seuil_cnr;
    
     for k=1:nbline
        for j=1:ncol
            r_0(k,j)=50*j+50;
        end
     end
    
     cnr = cnr./epsilon ;
     
     for azim = 1 : size(cnr,1)
        cnr(azim,:) = minus(plus(cnr(azim,:),2*log(r_0(1,:))),plus(log(IF(:,size(IF,2)).*C)',2*SM(g,4)*r_0(1,:)));
     end
     
     for k=1:nbline  
           for j=1:ncol
            el(k,j)=elcol(k); 
            az(k,j)=azcol(k);
            d1(k,j)=r_0(k,j).*sin(az(k)*pi/180);
            z1(k,j)=r_0(k,j).*cos(az(k)*pi/180);
           end
     end

    clf (figure(9))
    cf =  figure(9) ;
    set(cf,'Position',[1 554 560 420]); 
    surf(d1,z1,cnr,'EdgeLighting','phong','LineStyle','none'); 
    view(0,90);
%     caxis([seuil_cnr max_cnr]);
    caxis([-2 2]);
    axis equal;
    xlabel(['     Range West / East ', '(m)']);
    ylabel(['     Range South / North ', '(m)']);
    xlim([-max_range1 max_range1]);%complet
    ylim([-max_range1 max_range1]);%complet
    hold on;
    box on;
    grid off;
    colorbar;
%     axe_PPI;     
     
    clf (figure(3))
    figure(3)
    for a = 1:size(cnr,1)
        plot(r_0(1,:),exp(cnr(a,:))); hold on    % plot beta ratio for each azimuthal angle, one plot = one PPI
        ylim([-2 10]);
    end

    keyboard
end % g 



