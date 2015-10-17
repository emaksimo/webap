%%% define the Lidar parameters, which are individual for given instrument 
%%% and the measurement set up

lambda=1543;
lambda_mic=1.543;  % wave length [microns]
lambdaN=1543; % wave length [nm]
res=50; % radial resolution along the line of sight [meters]
sdi = 59  ; % we take the first 59 scanning distances (spanning between 100m and 3000m)
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
% mode='PPI'; % always the same azimuthal elevation = 3deg 
entete=42;


%%%%%%%%%%%% personal parameters %%%%%%%%%%%%%%%%%%%%%%%%%
epsilon = 10/log(10);

%%%%%%%%%%%% personal filter settings and filters %%%%%%%%%%%%%%%%%%%%%%%%%

%%% 1000m is a first-guess starting scanning distance where alpha and F(R) might be accessed;
%%% another reason for 1000m first guess is that the interquartile range spread (25% - 75%) 
%%% of 360 available CNR values, when comparing all available PPI, :
%%% this interquartile range spread increases from 100m up to 1000m horizontal range, and then stays quite
%%% stable within a 1-3km range off the Lidar
tu = [19 sdi] ;

CH = 300 ; % [meters] critical height where we check the symmetry of RHI

%%% for figures
loopme = 0; % if == 0 than we don't plot any figure
