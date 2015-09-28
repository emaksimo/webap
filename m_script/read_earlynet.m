%%% import aeronet Phase Function text record into excel 
%%% save as .XLSM ! only then ALL the data will be saved, otherwise some
%%% data is lossed while saving

%%% here the example on how to read this .XLS file
%%% ommit first three lines (data description)
%%% line 4 : header
%%% each other line contains measurements for some moment of the day
%%% in .XLSM file : all 4 wavelengths and all scattering angles are regrouped on one line

%%% col 1 = date
%%% col 2 = hh:mm:ss
%%% col 3 = Julian day
%%% col 4 = measurements (at all wavelengths and scattering angles)

%%% here we chose one day of observations within the file that can contain
%%% observations during several days (!) 
%%% create "dat" matrix of measurements, in three dimentions :
%%% [wavelength in lines x scattering angle in col x moment of the day]
%%% "freq" = corresponding wavelength matrix
%%% "scat_angle" = corresponding scattering angle

clear all
close all

% july 2013
% [num,txt] = xlsread(['/./media/Transcend/Leosphere/aeronet/Dunkerque/140718_140723_Dunkerque.xlsm'],3) ; % CONTROL the sheet !!!!!!!! 

%%% phase function : sheet 1 (18/07/2014) and sheet 3 (23/07/2014)
%%% single scattering albedo : sheet 2 (18/07/2014) and sheet 4 (23/07/2014)

% Paris Sept 2014
[num,txt] = xlsread(['/./media/PETIT/Paris/140901_140930_Paris_pfn_v2.xlsm'],1) ;
% [num,txt] = xlsread(['/./media/Transcend/Leosphere/aeronet/Paris/140901_140930_Paris_pfn.xlsm'],1) ;
% [num,txt] = xlsread(['/./media/Transcend/Leosphere/aeronet/Paris/140901_140930_Paris_pfn_fine.xlsm'],1) ;
% [num,txt] = xlsread(['/./media/Transcend/Leosphere/aeronet/Paris/140901_140930_Paris_pfn_coarse.xlsm'],1) ;

p = 1; % counter for the wavelength
cpt = 1; % counter for the scattering angle 

line = 4 ; % header line within the original xls file (our starting point)
rf = floor(str2num(char(num(line+1,3)))) %% reference Julian day


for col = 4 : size(txt,2) % data values start from the 4th column within the xls file
    clear b
    b = char(txt(line,col)) ;
    scat_angle(p,cpt) = str2num(b(1:6)); % scattering angle
    
    if p < 4       
        freq(p,cpt) = str2num(b(length(b)-5:length(b)-3)) ; % corresponding wave length
    else  
        freq(p,cpt) = str2num(b(length(b)-6:length(b)-3)) ;
    end
    
    %%% skip the header (line = line) and take the data on ONE day only
    t=1; % counter for the moment of the day
    for n = line+1 : size(txt,1)  % moment of the day
        if floor(str2num(char(txt(n,3)))) == rf 
            dat(p,cpt,t) = str2num(char(txt(n,col))) ; % data corresponding to given time, scattering angle and wavelength
            time(t) = str2num(char(txt(n,3)));
            t = t + 1;
        end
    end
    
    cpt = cpt +1 ; 
    
    if str2num(b(1:6)) == 180 
        p = p+1 ; % wave length change
        cpt = 1;
    end
    
    if str2num(b(1:6)) == 180 & str2num(b(length(b)-6:length(b)-3)) == 1017
        break % stop reading phase function data
    end
end

%%%%% if you can't read .xlsm files, then get the ready matlab data
% load(['/./media/PETIT/140718_PhaseFunction.mat']) ; % 'scat_angle','freq','dat','rf'
% load(['/./media/PETIT/140723_PhaseFunction.mat']) ; % 'scat_angle','freq','dat','rf'


colormap(jet) ;
JET= get(gcf,'colormap');

for u = 1 : size(freq,1); % wavelength
    figure(u); hold on
    
    for t = 1 : size(dat,3); % moment of the day
        RGB=JET(t*floor(64/size(dat,3)),:);
        plot(scat_angle(u,:),reshape(dat(u,:,t),[size(dat,2) 1]),'color',[RGB(1),RGB(2),RGB(3)]);  hold on ; 
        pf(u,t) = nanmean(dat(u,find(scat_angle(1,:) > 130 & scat_angle(1,:) <= 180),t)); % ave phase function
    end
    grid on; 
    set(gca,'YScale','log','Ytick',[0.1 1 10 100 1000],'YMinorGrid','off'); 
    
    xlabel([' scattering angle ']);
    ylabel([' Normalized Phase Function ( ' num2str(freq(u,1)) ' nm )' ]);
    title({['Phase Function, Julian day ' num2str(rf)];['dark blue (early in the day) - green - orange (later in the day)']});
    box on;
end

save(['/./media/Transcend/Leosphere/aeronet/mfile/time_avePF.mat'],'time','pf');

keyboard

% dat(1,83,:)
% 
% figure(u+1)
% cc = find(scat_angle(1,:) == 180);
% for t = 1 : size(dat,3)
%     RGB=JET(t*floor(64/size(dat,3)),:);
%     plot(freq(:,cc),reshape(dat(:,cc,t),[size(dat,1) 1]),'Color',[RGB(1),RGB(2),RGB(3)]); hold on;
% end
% 
% title({[' Normalized Phase Function at 180 ^o scattering angle'];['dark blue (early in the day) - green - red (later in the day)'];['Julian day ' num2str(rf)]});
% ylabel('Phase Function');
% xlabel(' wavelength [ nm ]');
% grid on; box on;
% u = u+1;
% 
% 
% figure(u+1)
% for t = 1 : size(dat,3) ;
%     clear XX Y    
%     Y(:,1) = reshape(dat(:,cc,t),[size(dat,1) 1]);
%     XX(:,2) = freq(:,cc);
%     XX(:,1) = 1;
% 
%     [B,BINT,R,RINT,STATS] = regress(Y,XX,0.01);
%     y(t) = 1540*B(2) + B(1);
%     g(t) = 355*B(2) + B(1);
%     
%     RGB=JET(t*floor(64/size(dat,3)),:);
%     plot([355;freq(:,cc);1540],[g(t);reshape(dat(:,cc,t),[size(dat,1) 1]);y(t)],'Color',[RGB(1),RGB(2),RGB(3)]); hold on; 
%     box on ; grid on ;
%     F(t,:) = [reshape(dat(:,cc,t),[size(dat,1) 1]);y(t)]';
%     title({['Normalized Phase Function at 180 ^o scattering angle'];['dark blue (early in the day) - green - red (later in the day)'];['Julian day ' num2str(rf)]});
%     ylabel('Phase Function');
%     xlabel(' wavelength [ nm ]');
% end

%  single scattering albedo 
clear all
close all

colormap(jet) ;
JET= get(gcf,'colormap');

load(['/./media/Transcend/Leosphere/LR/23072014_time_avePF.mat']); %  'time','pf'

[num,txt] = xlsread(['/./media/Transcend/Leosphere/LR/140718_140723_Dunkerque.xlsm'],4) ; % CONTROL the sheet !!!!!!!! 
%%% single scattering albedo : sheet 2 (18/07/2014) and sheet 4 (23/07/2014)

p = 1; % counter for the wavelength
cpt = 1; % counter for the scattering angle 

line = 4 ; % header line within the original xls file (our starting point)
rf = floor(str2num(char(txt(line+1,3)))); %% reference Julian day

for col = 4 : 7 % data values start from the 4th column within the xls file
    clear b
    b = char(txt(line,col)) ;

    
    if p < 4       
        freq(p) = str2num(b(length(b)-4:length(b)-2)) ; % corresponding wavelength
    else  
        freq(p) = str2num(b(length(b)-5:length(b)-2)) ;
    end
   
    %%% skip the header (line = line) and take the data on ONE day only
    t=1; % counter for the moment of the day
    for n = line+1 : size(txt,1)  % moment of the day
         floor(str2num(char(txt(n,3)))) 
        if floor(str2num(char(txt(n,3)))) == rf 
            dat(p,t) = str2num(char(txt(n,col))) ; % data corresponding to given time, scattering angle and wavelength
            t = t + 1;
        end
    end
    p = p+1;
end

for t = 1 : size(dat,2) 
    clear XX Y B BINT R RINT STATS
    Y(:,1) = dat(:,t) ;
    XX(:,2) = freq;
    XX(:,1) = 1;

    [B,BINT,R,RINT,STATS] = regress(Y,XX,0.01);
    y(t) = 1540*B(2) + B(1);
    g(t) = 355*B(2) + B(1);
    
    RGB=JET(t*floor(64/size(dat,2)),:);
    plot([355,freq,1540]',[g(t);Y;y(t)],'Color',[RGB(1),RGB(2),RGB(3)]); hold on; % linear fit
    
    LR355(t,1)  = (4*pi)/(g(t)*pf(1,t));
    LR1540(t,1) = (4*pi)/(y(t)*pf(4,t));
    
%     clear XX Y B BINT R RINT STATS  
%     Y(:,1) = log(dat(:,t)) ;
%     XX(:,2) = freq;
%     XX(:,1) = 1;

%     [B,BINT,R,RINT,STATS] = regress(Y,XX,0.01);
%     yy(t) = 1540*B(2) + B(1);
%     gg(t) = 355*B(2) + B(1);
%     plot([355,freq,1540]',[gg(t);Y;yy(t)],'Color',[RGB(1),RGB(2),RGB(3)],'linestyle',':'); hold on; % linear fit
%     
%     LR355(t,2)  = (4*pi)/(gg(t)*pf(1,t));
%     LR1540(t,2) = (4*pi)/(yy(t)*pf(4,t));
    
    box on ; grid on ;
%     F(t,:) = [g(t);Y;y(t)]';
    title({[' Single Scattering Albedo'];['dark blue (early in the day) - green - red (later in the day)'];['Julian day ' num2str(rf)]});
    ylabel('ssa');
    xlabel(' wavelength [ nm ]');
end

LR355

%% interpolate AOD value from 1020 and 1640 to 1540 nm
%%%

clear all
close all

colormap(jet) ;
JET= get(gcf,'colormap');

load(['/./media/Transcend/Leosphere/LR/23072014_time_avePF.mat']); % 'time' and average phase function 'pf' at 1020 nm

% [num,txt] = xlsread(['/./media/Transcend/Leosphere/LR/140718_140718_Dunkerque.lev15.xlsm']) ;
% [num,txt] = xlsread(['/./media/Transcend/Leosphere/LR/140719_140719_Dunkerque.lev15.xlsm']) ;

% [num,txt] = xlsread(['/./media/Transcend/Leosphere/LR/140723_140723_Dunkerque.lev15.xlsm'],1) ;
[num,txt] = xlsread(['/./media/PETIT/140723_140723_Dunkerque.lev15.xlsm'],1) ;
    
p = 1; % counter for the wavelength
cpt = 1; % counter for the scattering angle 

line = 5 ; % header line within the original xls file (our starting point)
rf = floor(num(1,2)); %% reference Julian day

for col = 4 : 6 % data values start from the 4th column within the xls file
    clear b
    b = char(txt(line,col)) 
    
    if p <=2
        freq(p) = str2num(b(length(b)-3:length(b))) ; % corresponding wavelength
    else
        freq(p) = str2num(b(length(b)-2:length(b))) ;
    end
    p = p+1;
end

%%% skip the header (line = line) and take the data on ONE day only
t=1; % counter for the moment of the day
for n = 1 : size(num,1)  % moment of the day
         
    if floor(num(n,2)) == rf 
        if length(find(time < num(n,2) + 0.005 & time > num(n,2) - 0.005)) > 0      % observations of AOT and phase function within 5 minutes  
            dat(:,t) = num(n,3:5) ; % data corresponding to given time and wavelength

            clear XX B BINT R RINT STATS
            XX(:,2) = freq;
            XX(:,1) = 1;
            [B,BINT,R,RINT,STATS] = regress(dat(:,t),XX,0.01);
            aod1540(t) = 1540*B(2) + B(1) ;
            
            in = find(time < num(n,2) + 0.005 & time > num(n,2) - 0.005) ; 
            
            bt(t) = aod1540(t)*pf(in)/(4*pi) ;
            lr(t) = aod1540(t)/bt(t) ;
            
            [n , num(n,2) - 0.005 , time(in) ,  num(n,2) + 0.005 , aod1540(t) , pf(in) , bt(t) , lr(t) ]
            
            keyboard
            t = t + 1;
        end
    end
end


