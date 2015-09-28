%%% read ERAI data
%%% 6-hourly daily, resolution (0.75 deg lat x 0.75 deg lon)
%%%%%

clear all 
close all

startup ; 
main = (['/./media/elena/Transcend/Hymex/ERAI/']);

%%%% define study sector
latmi = 30;  % southern limit of the study area [deg N]
latma = 50; % northern limit of the study area [deg N]
lonmi = -10;  % western limit of the study area [deg W]
lonma = 30; % eastern limit of the study area [deg E]
cp = 1;
%%%%%%%%%%%
var = {'H500','H700','H850','H950'};

rep=dir(main);

for ii = 4 : length(rep)  
     rep2 = dir([main rep(ii).name ]);    
%    NC = ncinfo([main rep(ii).name ])
%    keyboard
  
     clear D
     %%% variables ii = 3 msl ; ii = 4 z, pv ; ii = 5 : t (temp), q (specif humidity)
     D = (ncread([main rep(ii).name ],'z',[1 1 1 1],[inf inf inf inf]))/100;   %,-1,-1,1,-1,2,0,1,[1 1]); [1 1],[inf inf]
     
     for lev  = 1 : 4  
            clear DD  H Hd P
            DD  = reshape(D(:,:,lev,:),[size(D,1) size(D,2) size(D,4)]); 
            lon = double(ncread([main rep(ii).name ],'longitude',1,inf));   %,-1,-1,1,-1,2,0,1,[1 1]); [1 1],[inf inf]
            lat = double(ncread([main rep(ii).name ],'latitude',1,inf));   %,-1,-1,1,-1,2,0,1,[1 1]); [1 1],[inf inf]
            TI  = ncread([main rep(ii).name ],'time',1,inf);
            time=datevec(double(TI)/24+datenum(1900,1,1)); 

            lon(find(lon > 180)) = lon(find(lon > 180)) - 360; % western hemisphere = negative longitude
            lo = [max(lon(find(lon < lonmi))) min(lon(find(lon > lonma)))];
            loi = [find(lon == lo(1)) find(lon == lo(2))];

            la = [max(lat(find(lat < latmi))) min(lat(find(lat > latma))) ] ;
            lai = [find(lat == la(1)) find(lat == la(2))];
            P = cat(1,DD(loi(1):length(lon),lai(2):lai(1),:), DD(1:loi(2),lai(2):lai(1),:));

            for j = 1 : size(P,2)
                LO(j,:) = [lon(loi(1):length(lon));lon(1:loi(2))];
            end

            for i = 1 : size(P,1)
                LA(:,i) = lat(lai(2):lai(1));
            end
            clear lon lat lo loi DD
       
        for i = 1 : size(P,1)
            for j = 1 : size(P,2)
                H(j,i,:) = P(i,j,:);
            end
        end
        
        rt = 1;
        for d = 1 : 61
            Hd(:,:,d) = mean(H(:,:,rt:rt+3),3); %%% daily mean slp
            rt = rt+4;
        end
                
        save(['/./media/elena/Transcend/Hymex/ASCII/' strvcat(var(lev)) '_6hdaily_y2012_SeptOct.mat'], 'H', 'Hd','LO','LA','time')
        ['/./media/elena/Transcend/Hymex/ASCII/' strvcat(var(lev)) '_6hdaily_y2012_SeptOct.mat']
        [ min(min(min(Hd))), mean(mean(mean(Hd))), max(max(max(Hd)))]
        keyboard
     end 
     break
end

%%
clear all 
close all

%%% coordinates of Pianatoli
pla = 41.25 ; % deg N
plo = 9; % deg est

main = (['/./media/Transcend/Hymex/netcdf-atls04-20140903144920-46036-7916.nc']);
% NC = ncinfo(main)
v = (ncread(main,'v',[1 1 1 1],[inf inf inf inf]));   %,-1,-1,1,-1,2,0,1,[1 1]); [1 1],[inf inf]

TI  = ncread(main,'time',1,inf);
time=datevec(double(TI)/24+datenum(1900,1,1)); 

lon = double(ncread(main,'longitude',1,inf));   %,-1,-1,1,-1,2,0,1,[1 1]); [1 1],[inf inf]
lat = double(ncread(main,'latitude',1,inf)); 
level = double(ncread(main,'level',1,inf));  

V = reshape(v(find(lon == plo),find(lat == pla),:,:),[length(level), length(time)]); clear main v TI

main = (['/./media/Transcend/Hymex/netcdf-atls05-20140903145948-48560-8259.nc']);
w = (ncread(main,'w',[1 1 1 1],[inf inf inf inf]));
W = reshape(w(find(lon == plo),find(lat == pla),:,:),[length(level), length(time)]); clear main w 

main = (['/./media/Transcend/Hymex/netcdf-atls03-20140903151133-49862-8553.nc']);
u = (ncread(main,'u',[1 1 1 1],[inf inf inf inf]));
U = reshape(u(find(lon == plo),find(lat == pla),:,:),[length(level), length(time)]); clear main u

main = (['/./media/Transcend/Hymex/netcdf-atls03-20140903155708-49883-8233.nc']);
% NC = ncinfo(main)
z = (ncread(main,'z',[1 1 1 1],[inf inf inf inf]))/10;
Z = reshape(z(find(lon == plo),find(lat == pla),:,:),[length(level), length(time)]); clear main z

main = (['/./media/Transcend/Hymex/netcdf-atls04-20140904080259-45998-8167.nc']);
q = (ncread(main,'q',[1 1 1 1],[inf inf inf inf]));
Q = reshape(q(find(lon == plo),find(lat == pla),:,:),[length(level), length(time)]); clear main q

main = (['/./media/Transcend/Hymex/netcdf-atls05-20140904082517-48533-8124.nc']);
t = (ncread(main,'t',[1 1 1 1],[inf inf inf inf]));
T = reshape(t(find(lon == plo),find(lat == pla),:,:),[length(level), length(time)]); clear main t

lat = lat(find(lat == pla));
lon = lon(find(lon == plo));
save(['/./media/Transcend/Hymex/ASCII/Pianatoli_ERAI_UVWZTQ_verticle.mat'],'U','V','W','Z','T','Q','level','lat','lon','time');
%%
 
 



