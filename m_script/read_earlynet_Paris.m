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

% Paris Sept 2014
% [num,txt] = xlsread(['/./media/Transcend/Leosphere/aeronet/Paris/140901_140930_Paris_pfn.xlsm'],1) ;
% [num,txt] = xlsread(['/./media/Transcend/Leosphere/aeronet/Paris/140901_140930_Paris_pfn_fine.xlsm'],1) ;
[num,txt] = xlsread(['/./media/Transcend/Leosphere/aeronet/Paris/140901_140930_Paris_pfn_coarse.xlsm'],1) ;

p = 1; % counter for the wavelength
cpt = 1; % counter for the scattering angle 

line = 4 ; % header line within the original xls file (our starting point)
rf = floor(num(line+1,3)) ; % reference Julian day
d = 1 ; % counter for the day of month 
dat = nan([4 83 10 30]); % first guess about the data matrice size
time = nan([10 30]); 

for count = 1 : size(txt,1)
    for col = 4 : size(txt,2) % data values start from the 4th column within the xls file
        clear b
        b = char(txt(4,col)) ;
        
        if count == 1 & ~isempty(str2num(b(1:6)))
            scat_angle(p,cpt) = str2num(b(1:6)); % scattering angle

            if p < 4       
                freq(p,cpt) = str2num(b(length(b)-5:length(b)-3)) ; % corresponding wave length
            else  
                freq(p,cpt) = str2num(b(length(b)-6:length(b)-3)) ;
            end
        end
        
        t = 1;          
        for n = line : size(txt,1)  % moment of the day
            if floor(num(n,3)) == rf 
                dat(p,cpt,t,d) = num(n,col) ; % data corresponding to given time, scattering angle and wavelength
                time(t,d) = num(n,3);
                t = t + 1;
            end
        end
               
        cpt = cpt +1 ; 

        if str2num(b(1:6)) == 180 
            p = p+1 ; % wave length change
            cpt = 1; % renew the counter for the scattering angle
        end
        
        %%% switch to a new day 
        if str2num(b(1:6)) == 180 & str2num(b(length(b)-6:length(b)-3)) == 1020 &  length(find(~isnan(time(:,d)))) == length(find(floor(num(:,3)) == rf ))       
            for ll = 1 : 10 % find next day of measurements even if missing observational days are present
                rf = rf + 1;
                if ~isempty(find(floor(num(:,3)) == rf ))
                    line =  min(find(floor(num(:,3)) == rf ))  ; 
                    d = d+1;
                    p = 1;
                    cpt = 1;                    
                    break % "ll" loop
                end   
            end  
            break % "col" loop for this day and restart a new for the next day
        end
    end
end

colormap(jet) ;
JET= get(gcf,'colormap');

for u = 1 : size(dat,1); % wavelength
    for d = 1 : size(dat,4);
        for t = 1 : size(dat,3); % moment of the day
            pf(u,t,d) = nanmean(dat(u,find(scat_angle(u,:) > 120 & scat_angle(u,:) <= 160),t,d)); % ave phase function
        end
    end
end

% figure(1)
% for u = 1 : size(freq,1); % wavelength
%     clear a b RGB
%     RGB=JET(u*16,:);
%     a = minus(reshape(time,[size(time,1)*size(time,2) 1]),nanmin(nanmin(time))-1);
%     b = reshape(pf(u,:,:),[size(time,1)*size(time,2) 1]);
%     scatter(a(find(~isnan(a))),b(find(~isnan(a))),'markerfacecolor',[RGB(1),RGB(2),RGB(3)],'markeredgecolor','none');  hold on ;  
% end
% grid on; box on;
% xlabel([' day of month ']);
% set(gca,'xlim', [0 31],'xtick',0:1:30);
% title({['Time evolution of the coarse mode Phase Function (ave for 120^o - 160^o scatt angle), in Paris, September 2014'];['at 440 nm (blue), 675 nm (green), 870 nm (orange), 1020 nm (brown)']}) ;
% ylabel('Phase Function (coarse mode)');

% save(['/./media/Transcend/Leosphere/aeronet/mfile/time_avePF.mat'],'time','pf');

%%%%% if you can't read .xlsm files, then get the ready matlab data
% load(['/./media/PETIT/140718_PhaseFunction.mat']) ; % 'scat_angle','freq','dat','rf'
% load(['/./media/PETIT/140723_PhaseFunction.mat']) ; % 'scat_angle','freq','dat','rf'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  single scattering albedo 

clear dat time freq num txt ssa LR
[num,txt] = xlsread(['/./media/Transcend/Leosphere/aeronet/Paris/140901_140930_Paris_ssa.xlsm'],1) ;

p = 1; % counter for the wavelength
line = 4 ; % header line within the original xls file (our starting point)
rf = floor(num(line+1,3)) ; % reference Julian day
d = 1 ; % counter for the day of month 
dat = nan([4 10 30]); % first guess about the data matrice size
time = nan([10 30]); 
cn = 1;

for col = 4 : 7 % data values start from the 4th column within the xls file
    clear b
    b = char(txt(4,col)) 
    if cn == 1 & ~isempty(length(b)-4:length(b)-2) % if the column does not contain any info about the scattering angle 
        if p < 4       
            freq(p) = str2num(b(length(b)-4:length(b)-2))  % corresponding wavelength
        elseif p == 4
            freq(p) = str2num(b(length(b)-5:length(b)-2)) 
        end
        p = p+1; 
    end
end

t = 1;  % counter for the moment of the day        
line = 5; % where the data starts

for count = 1 : size(txt,1)
    for n = line : size(txt,1)  % moment of the day
        if floor(num(n,3)) == rf %| ~isnan(num(n,3))
            dat(:,t,d) = num(n,4:7) ; % data corresponding to given wavelength (dim 1), time of the day (dim 2) and day (dim 3)
            time(t,d) = num(n,3) ;
            num(n,3:7) = NaN ;
            t = t + 1;
        else    % switch to a new day 
            rf = nanmin(floor(num(line+1 : size(txt,1),3)));
            line = min(find(floor(num(:,3)) == rf)); 
            d = d + 1;
            t = 1;
            break % n loop
        end
    end
    if d > 30
        break
    end
end        


for d = 1 : size(dat,3)
    for t = 1 : size(dat,2) 
        clear XX Y B BINT R RINT STATS
        Y(:,1) = dat(:,t,d) ;
        XX(:,2) = freq;
        XX(:,1) = 1;

        [B,BINT,R,RINT,STATS] = regress(Y,XX,0.01);
        ssa(6,t,d) = 1540*B(2) + B(1);
        ssa(1,t,d) = 355*B(2) + B(1);
        ssa(2:5,t,d) = dat(:,t,d);
               
        pff(1,t,d) = pf(1,t,d) ;
        pff(6,t,d) = pf(4,t,d) ;
        pff(2:5,t,d) = pf(:,t,d) ;
        for u = 1:6
            LR(u,t,d)  = (4*pi)/(ssa(u,t,d)*pff(u,t,d));
        end
    end
end
% 
% figure(2)
% for u = 1 : 6  % wavelength
%     clear a b RGB
%     RGB=JET(u*10,:);
%     a = minus(reshape(time,[size(time,1)*size(time,2) 1]),nanmin(nanmin(time))-1);
%     b = reshape(ssa(u,:,:),[size(time,1)*size(time,2) 1]);
%     scatter(a(find(~isnan(a))),b(find(~isnan(a))),'markerfacecolor',[RGB(1),RGB(2),RGB(3)],'markeredgecolor','none');  hold on ;   
% end
% grid on; box on;
% xlabel([' day of month ']);
% set(gca,'xlim', [0 31],'xtick',0:1:30);
% title({['Time evolution of the SSA, in Paris, September 2014 (linearly extrapolated for 355 nm and 1540 nm) '];['at 355 nm (dark blue), 440 nm (blue), 675 nm (green), 870 nm (yellow), 1020 nm (orange), 1540 nm (brown)']}) ;
% ylabel('ssa');


% figure(3)
% for u = 1 : 6; % wavelength
%     clear a b RGB
%     RGB=JET(u*10,:);
%     a = minus(reshape(time,[size(time,1)*size(time,2) 1]),nanmin(nanmin(time))-1);
%     b = reshape(LR(u,:,:),[size(time,1)*size(time,2) 1]);
%     scatter(a(find(~isnan(a))),b(find(~isnan(a))),'markerfacecolor',[RGB(1),RGB(2),RGB(3)],'markeredgecolor','none');  hold on ; 
% end
% grid on; box on;
% xlabel([' day of month ']);
% set(gca,'xlim', [0 31],'xtick',0:1:30);
% title({['Time evolution of the LR, in Paris, September 2014 (for the coarse mode Phase Function, ave 120-160^o)'];['at 355 (dark blue), 440 nm (blue), 675 nm (green), 870 nm (yellow), 1020 nm (orange), 1540 nm (brown)']}) ;
% ylabel('LR');

save(['/./media/Transcend/Leosphere/aeronet/mfile/LR_coarsePF.mat'],'time','LR');

break

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clear all
close all
load('/./media/Transcend/Leosphere/aeronet/mfile/LR_totPF.mat') ;
LRT = LR ; clear LR ;
load('/./media/Transcend/Leosphere/aeronet/mfile/LR_finePF.mat') ;
LRF = LR ; clear LR ;
load('/./media/Transcend/Leosphere/aeronet/mfile/LR_coarsePF.mat') ;
LRC = LR ; clear LR ;

figure(1)
% u = 1 ; % 355 nm
u = 6 ; % 1540 nm
a = minus(reshape(time,[size(time,1)*size(time,2) 1]),nanmin(nanmin(time))-1);
b = reshape(LRT(u,:,:),[size(time,1)*size(time,2) 1]);
c = reshape(LRF(u,:,:),[size(time,1)*size(time,2) 1]);
d = reshape(LRC(u,:,:),[size(time,1)*size(time,2) 1]);

scatter(a(find(~isnan(a))),b(find(~isnan(a))),'markerfacecolor','r','markeredgecolor','none');  hold on ; 
scatter(a(find(~isnan(a))),c(find(~isnan(a))),'markerfacecolor','k','markeredgecolor','none');  hold on ; 
scatter(a(find(~isnan(a))),d(find(~isnan(a))),'markerfacecolor','g','markeredgecolor','none');  hold on ; 

grid on; box on;
xlabel([' day of month ']);
set(gca,'xlim', [0 31],'xtick',0:1:30);
title({['Time evolution of the LR at 1540 nm, in Paris, September 2014, Phase Function is ave 120-160^o at 1020 nm'];['overall Phase Function (red), fine mode Phase Function (black), coarse mode Phase Function (green)']}) ;
ylabel('LR');

%%


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


