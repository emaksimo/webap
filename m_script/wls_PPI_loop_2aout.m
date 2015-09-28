
clear all ;
% close all;
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
mode='PPI';
location='Dunkerque';
        
chemin0='/media/Transcend/LNA/02aout2013/';
chemin1='/media/Transcend/LNA/02aout2013/test/'; 

ifile=strcat(chemin0,'listedossier.txt');
        %file=[chemin1,'WLS100S-9_2013_09_11__15_06_34_RHI.rtd'];

        % chemin2=strcat(chemin1,'fig/');
        % chemin2bis=strcat(chemin1,'fig_eps/');
        % [s,mess,messid]=mkdir([chemin2]);
        % [s,mess,messid]=mkdir([chemin2bis]);

         % %Debut Determination de la liste des dossiers et creation de la liste
 list=dir([chemin1,'/*_PPI.rtd']);  % all PPI files within 
        % fid=fopen(ifile,'wt');
        %  fprintf(fid,'%s\n',list1.name);
        % fclose(fid);
        %Fin Determination de la liste des dossiers...


        %lecture de la liste
        %  nbltete=0;
        %  root=importdata(ifile);
        %  nnligne=size(root,1); 
        %  strcat('Nombre de scan:',num2str(nbligne))
        %  dossier=(root)


        %compteur:=0;
        % for p=1:nnligne,
        %    repertoire=strcat(dossier(p),'/Labview Data/');
        %    repertoires=char(repertoire);
        %    adjust=2;
           %repdir= uigetdir([chemin,repertoire,'/'],'dialog_title');
           %repertoires=strcat('2011-06-25_05-00-36','/Labview Data');

           %repdir=uigetdir([chemin,repertoires,'/'],'dialog_title');
           %repdir=([chemin,repertoires,'/']);
           %list =dir([repdir,'/','Data_*.txt']);
        
           L = 11 ; % file within given dossier
           k = 0 ; 
           for klist = 1 : length(list)
               if ~list(klist).isdir
                   k = k+1 ;
                   fichier(k) = cellstr(list(klist).name);
               end
           end
                    
           L = 11 ;
           zone = 1 ;
           loopme = 1; % in this case we see the maps
           wls_sub_PPI ;
%            best_profile; %detection of potentially homogenuous zone ; 2D interpolation
           best_profile1  %detection of potentially homogenuous zone ; 1D interpolation

%            multi_angle_method_Pabs_vs_CosTeta ; % usind "d" projection
           multi_angle_method_Pabs_vs_CosTeta1 ; % usind R,  1D interpolation
%            multi_angle_method_Pabs_vs_CosTeta2 ; % comparing CNR at the same radial distance "R" and same "d" (symmetric study)
%            instrum_function2

% FAT = MMAT(find(MMAT(:,4) >= 30),:);
% save('my_record.mat','FAT')
% 
% for ht = 8: length(FAT); % chose the file 
%     close all
%     ij = FAT(ht,1)+2 ; % dossier that contains houndreds of PPI & RHI files
% 
%     clear list chemin0 chemin1 fichier zone L
%     chemin0=(['/./media/Transcend/LNA/WLS100/' rep(ij).name '/']);
%     chemin1=(['/./media/Transcend/LNA/WLS100/' rep(ij).name '/']);
%     list=dir([chemin1,'/*_PPI.rtd']);
%     L = FAT(ht,2) ; % PPI file name
%     zone = FAT(ht,3) ; % sector with more than 30 profiles withing given PPI
%     fichier = cellstr(list(L).name);
% 
%     loopme = 1; % in this case we see the maps
%     wls_sub_PPI;
%     best_profile; %detection of potentially homogenuous zone
%     multi_angle_method_Pabs_vs_CosTeta
%     % instrum_function2
%     test  % recalculate CNR using alpha(d) and b(d)
%     keyboard
% end

%     size(rng)    
%     ct(find(ct >= listing(1,zone) & ct <= listing(2,zone))) % show which real cnr profiles are used (what are the profiles invented by interpolation)
%     PA ; % alpha calculation
%     multi_angle_method
%     backscatter     
%     instrum_function1
%     backscatter1
%     alpha_new
    
%     alpha_recover
   % sup_im
   
%%% run the unfiltered alpha recover
% wls_PP