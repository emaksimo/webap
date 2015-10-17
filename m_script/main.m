%%% in this Matlab script you should define the parameters of your own data set

%%% for the first test we give you an example of a data set, so that you can understand the code
%%% see README.md 
clear all
close all

%%% the path of your source folder
core_dir = '/media/elena/Transcend/Leosphere/WLS100/';
rep=dir(core_dir); % list of sub-direcrories were PPI and corresponding RHI files are stored

%%% the path of the folder where you save the results
output = '/home/elena/git/data/';

%%% describe the naming convention and type of your PPI and RHI files, 
%%% so that they can be found automatically
Ftype_PPI = '*PPI.rtd'; % in my case I search for file names containing this info
Ftype_RHI = '*RHI.rtd';

%%% define the number of scanning distances off the instrument that you use
minutes = [26 27] ; % time of the observation (minute of the hour) within the PPI file name

%%% modify the file "wls_setup.m" containing the instrumental constants of your instrument! 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% STEP 1: 
% preselect the PPI out of all available
% evaluate the CNR statistics at each scanning distance R for each PPI,
% and each scanning distance R
PPI_list_stats %%% previously : wls_PPI_loop_1

%%% STEP 2:
result
% load([output 'CNR_stats_selectedPPI.mat']) 
% check all PPI files to detect those that correspond the criteria of homogeneity
% impose filtering conditions of PPI's (using statistics for all PPI)
% filter the "extreme" CNR values within each PPI
% calculate the average (representative) CNR profile for each given PPI  
% smothen to get the average CNR profile for given PPI 
% determine automatically the distances where exp(delta CNR) is const
% calculate the extinction coeff (alpha) within these distances (for each n-th PPI individually)
% for comparison "alpha" is calculated here with the slope method, 
% but applied differently (see my method 1 and method2). 
% using CNR(n,R) and alpha(n): evaluate F(n,R)*K*beta(n) for each n-th best
% PPI (with individual beta(n)).
% the shape of the Instrumental function F(n,R) for each PPI can be obtained by
% normalising F(n,R)*K*beta(n) within the distances where alpha(n) was
% calculated, see alphaFR.m
% as a result we get the list of best PPI files, extinction coeff and its
% error estimate (for each PPI, 99% sign test), and the approximate shape
% of F(R) for each PPI





