
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


rep=dir(['/./media/Transcend/LNA/WLS100/']);
chemin0=(['/./media/Transcend/LNA/WLS100/' rep(4).name ]);
chemin1=(['/./media/Transcend/LNA/WLS100/' rep(4).name ]);
        
% chemin0='/Users/Elena/LNA/02aout2013/';
% chemin1='/Users/Elena/LNA/02aout2013/test/';

ifile=strcat(chemin0,'/listedossier.txt');
%file=[chemin1,'WLS100S-9_2013_09_11__15_06_34_RHI.rtd'];

chemin2=strcat(chemin1,'fig/');
chemin2bis=strcat(chemin1,'fig_eps/');
[s,mess,messid]=mkdir([chemin2]);
[s,mess,messid]=mkdir([chemin2bis]);

mode='PPI';
location='Dunkerque';

 % %Debut Determination de la liste des dossiers et creation de la liste
list=dir([chemin1,'/*_PPI.rtd']);
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
 k=0 ;
for klist = 1:length(list),
   if ~list(klist).isdir,k=k+1;
       fichier(k) = cellstr(list(klist).name);      
   end
end


% for L=1:length(fichier),
    L=1;
    wls_sub_PPI;
    
% end;
    
%     best_profile;
   % sup_im
    
