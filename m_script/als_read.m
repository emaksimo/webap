%%% read and plot ASL data
%%% we need only ch0 - Corrected Data (4th column)
%%% data : PR2

clear all
close all
% aa = {'2014'};
% mm = {'07'};
% day = 18;
entete=165; % read the file starting from this line

rep=dir(['/./media/Transcend/ALS/2014-07-18']);

for i= 100 : length(rep)
    disp(rep(i).name);
    
 	rep2 = dir(['/./media/Transcend/ALS/2014-07-18/' rep(i).name '/'])
    for j = 3 : length(rep2)  
        clear dt
        if length(rep2(j).name) == 23
              fichier = (['/./media/Transcend/ALS/2014-07-18/' rep(i).name '/' rep2(j).name '']);
              aa = rep2(j).name(:,1:4);
              mm = rep2(j).name(:,6:7);
              jj = rep2(j).name(:,9:10);
              hh = rep2(j).name(:,12:13);
              mn = rep2(j).name(:,15:16);
              
              root=importdata(fichier,'\t',entete);
              dt=root.data(:,3);
              z = max(find(dt > 0))
              plot(1:z,dt(1:z))
              title([aa,'-',mm,'-',jj,' ',hh,':', mn]);
              
        end
        keyboard
    end

end