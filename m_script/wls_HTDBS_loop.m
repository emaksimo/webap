
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
max_vh=10;
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
chemin0='/Users/patrick/2010/WLS100/';
%chemin1='/Users/patrick/2010/WLS100/2013_09_11__15_05_36/';
%chemin1='/Users/patrick/2010/WLS100/test/';
chemin1='/Users/patrick/2010/WLS100/25septembre2013/';
%
chemin2=strcat(chemin1,'fig/');
chemin2bis=strcat(chemin1,'fig_eps/');
[s,mess,messid]=mkdir([chemin2]);
[s,mess,messid]=mkdir([chemin2bis]);

mode='DBS';
location='Dunkerque';

 % %Debut Determination de la liste des dossiers et creation de la liste
list=dir([chemin1,'/*_DBS.rtd']);
  
 k=0 ;
for klist = 1:length(list),
   if ~list(klist).isdir,k=k+1;
       fichier(k) = cellstr(list(klist).name);      
   end;
end



    
    wls_sub_HTDBS2;
    
    
    
    
