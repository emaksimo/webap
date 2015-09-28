%%% BTEX campaign data set

clear all
close all

%%% chemical and meteo variable (121 in total) at different measurement sites, every ??? min        
% load('/media/elena/Transcend/BTEX/ClassificationDesBreezes/DATA_BTEX_20130405_.mat');

% variables :
% inData_BTEXpp           16033x121                
% inDates_BTEXpp_NUM      16033x1      time (min) since ???             
% inNames_BTEXpp              1x121   

% useful variables ;
% 'T1_MREI2' , 'VV_MREI2 (m/s)', 'DV_MREI2 (deg)' ,'PR_MREI2 (HPa)' 
% 'DV_PE deg'  
% 'VV_DKE m/s', 'DV_DKE degre ',
% 'VV_MG (m/s)', 'DV_MG (deg)', 'zTcov_MG (mK/s)','ustar_MG (m/s)','Tstar_MG (K)'


%%% back trajectories every 30 min 
% load('/media/elena/Transcend/BTEX/ClassificationDesBreezes/AllTrajPlusMeteo_SPPEGSER_12h_Mod2_20141217.mat');
% 3 model coordinates (x,y,z) x 24 time steps (every 30 min) x 1069 (trajectores for each 30-min arrival) 
% coordinate (1,:,:) , (2,:,:) , (3,:,:) = ? = lat, lon z ??? in what order ?

% bt_GrSynthe     3 x 24 x 1069                   
% bt_PortEst      3 x 24 x 1069                         
% bt_StPol        3 x 24 x 1069  
% 
% DATES_NUM_bt 1 x 1069 (mins since ???) 
% DATES_STR_bt 1069 x 20 (every 30 min)
% lat and lon for each grid box   ?

%%% coordinates of each centroid
% load('/media/elena/Transcend/BTEX/ClassificationDesBreezes/Centroids/6ClustersAndCentroidsPE.mat');

% what should I use? :
% outCent          3 x 24 x 6 claster              
% outCentTotal     3 x 24 x 6   

% DATES_NUM_bt     1x1069                        
% DATES_STR_bt     1069x20  
% outBtType        1x1069   % vector of corresponding claster number  

%%% ??? what is this?
load('/media/elena/Transcend/BTEX/ClassificationDesBreezes/Centroids/Mod2Altitude.mat');
% variable :
% inALT__      62x62x70 