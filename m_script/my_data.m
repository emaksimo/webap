%%% in this Matlab script you should define the parameters of your own data set

%%% for the first test we give you an example of a data set, so that you can understand the code
%%% see README.md 
clear all
close all

%%% the path of your data source 
core_dir = '/media/elena/Transcend/Leosphere/WLS100/';
rep=dir(core_dir); % list of sub-direcrories were PPI and corresponding RHI files are stored

%%% the path where you save your results
output = '/home/elena/git/data/';

%%% describe thenaming convention and type of your PPI and RHI files, 
%%% so that they can be found automatically
Ftype_PPI = '/*_PPI*.rtd'; % in my case I search for file names containing this info
Ftype_RHI = '*_RHI*.rtd';

%%% define the number of scanning distances off the instrument that you use
sdi = 59  ; % we take the first 59 scanning distances (spanning between 100m and 3000m)
lambda=1543;
lambda_mic=1.543;  % wave length [microns]
lambdaN=1543; % wave length [nm]
res=50; % radial resolution along the line of sight [meters]
min_range = 100; % the first scanning range of the instrument (along the line of sight), units [meters]
max_range=3000; % the last scanning range of the instrument (along the line of sight), units [meters]
ad_range=50;
max_range1=max_range+ad_range;
max_cnr=-10;
fuseau=0; % time zone of the record
temps='UTC';
niveau='AGL';
gl=15; % the instrument is mounted at this height above the ground [meters]
nb_par=8; % nb parametre par niveau
seuil_cnr=-27;
% ad_seuil=1;
seuil_cnr_ma = 0;
mode='PPI'; % always the same azimuthal elevation = 3deg 
entete=42;
minutes = [26 27] ; % time of the observation (minute of the hour) within the file name

%%% for figures
loopme = 0; % if == 0 than we don't plot any figure
colormap(jet) ;
JET= get(gcf,'colormap');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% STEP 1: run "wls_PPI_loop_1.m'
%%% preselect the PPI
%%% evaluate the CNR statistics at each scanning distance R for each PPI,
%%% and each scanning distance R
wls_PPI_loop_1

%%% STEP 2:
% load([output 'CNR_stats_selectedPPI.mat']);% 'SK','RANG','XD','data_description','r_0','az'




