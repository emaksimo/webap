
clear all ;
close all;
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

mdpath = ['/./media/elena/Transcend/Leosphere/WLS100/']; % main directory path
rep=dir(mdpath);
ij=7;     
% chemin0=(['/./media/elena/Transcend/Leosphere/WLS100/' rep(ij).name '/']);
% chemin1=(['/./media/elena/Transcend/Leosphere/WLS100/' rep(ij).name ]);
        

% chemin2=strcat(chemin1,'fig/');
% chemin2bis=strcat(chemin1,'fig_eps/');
% [s,mess,messid]=mkdir([chemin2]);
% [s,mess,messid]=mkdir([chemin2bis]);
% 
% mode='DBS';
% location='Dunkerque';

 % %Debut Determination de la liste des dossiers et creation de la liste
% list=dir([chemin1,'/*_DBS.rtd'])
% list.name 

%%% Determination de la liste des dossiers et creation de la liste
for ij = 250:320
    clear chemin1 
    chemin1=rep(ij).name  ;
    list = dir([mdpath, chemin1,'/*_DBS.rtd']); % all DBS files within one directory    
    if size(list,1) > 0  % if there is some data within the directory   
        chemin1
        for L = 1 : length(list)  % DBS file within given dossier
            fichier = cellstr(list(L).name)   % file name
        end
        keyboard
    end
end

keyboard
 k=0 ;
for klist = 1:length(list),
   if ~list(klist).isdir,k=k+1;
       fichier(k) = cellstr(list(klist).name);      
   end;
end


% for L=1:length(fichier),
    L = 1 ;
    keyboard
    wls_sub_DBS;
    
% end;
%     
    
    
    
