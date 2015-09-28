%%% see script read_aerlynet_Paris_2.m for more details on how to read the
%%% original Aeronet data

clear all
close all

[num,txt] = xlsread(['/./media/Transcend/Leosphere/aeronet/Paris/140901_140930_Paris_RefrIndex.xlsm'],1) ;

p = 1; % counter for the wavelength

line = 4 ; % header line within the original xls file (our starting point)
rf = floor(num(line+1,3)) ; % reference Julian day
d = 1 ; % counter for the day of month 
%%% first guess about the data matrice size
%%% dimentions : time of the day  x  wavelength (355 ... 1540) x  day of month
dat1 = nan([10 6 30]);  % real part of the refractive index   
dat2 = dat1;  % imaginary part of the refractive index   
time = nan([10 6 30]); 


for col = 4 : 7 % real part of the refr index
    clear b
    b = char(txt(4,col)) ;      

    if col ~= 7 
            freq(1,col-3) = str2num(b(length(b)-3:length(b)-1)) ; % wavelength
    else  
            freq(1,col-3) = str2num(b(length(b)-4:length(b)-1)) ;
    end
end

day(:,1) = floor(num(:,3));
day(1:line,1) = NaN;

d=1;
for count = min(day) : max(day)
    count
    clear n
    n = find(day == count)
    num(n,4:7)
    
%     keyboard
    if ~isempty(n)
        %%% dimentions time of the day  x  wavelength  x  day of month
        dat1(1:length(n),2:5,d) = num(n,4:7) ; % real part of the refractive index   
        dat2(1:length(n),2:5,d) = num(n,8:11); % imaginary part of the refractive index
        for wl = 1:6
            time(1:length(n),wl,d) = num(n,3);       
        end
    end
    d = d+1;
end

%%% extrapolate linearly
for d = 1 : size(dat1,3)
    for t = 1 : size(dat1,1)
        if ~isempty(find(~isnan(dat1(t,:,d)))); % if some data are available on given moment of the day
            clear XX Y B BINT R RINT STATS
            Y(:,1) = dat1(t,2:5,d);
            XX(:,2) = freq;
            XX(:,1) = 1;

            [B,BINT,R,RINT,STATS] = regress(Y,XX,0.01);
            dat1(t,6,d) = 1540*B(2) + B(1);
            dat1(t,1,d) = 355*B(2) + B(1);

            clear XX Y B BINT R RINT STATS
            Y(:,1) = dat2(t,2:5,d) ;
            XX(:,2) = freq;
            XX(:,1) = 1;

            [B,BINT,R,RINT,STATS] = regress(Y,XX,0.01);
            dat2(t,6,d) = 1540*B(2) + B(1);
            dat2(t,1,d) = 355*B(2) + B(1);
        end
    end
end

colormap(jet) ;
JET= get(gcf,'colormap');


% save(['/./media/Transcend/Leosphere/aeronet/mfile/time_avePF.mat'],'time','pf');

%%%%% if you can't read .xlsm files, then get the ready matlab data
% load(['/./media/PETIT/140718_PhaseFunction.mat']) ; % 'scat_angle','freq','dat','rf'
% load(['/./media/PETIT/140723_PhaseFunction.mat']) ; % 'scat_angle','freq','dat','rf'




for d = 1 : size(dat1,3); % wavelength
    st = 0.01;
    clear u
    u = length(find(~isnan(dat1(:,1,d))));
    if ~isempty(u); % if some data are available on given day
        %%%%%%%%%%%%%%%%%%%%%%%%
        h1 = figure(1);
        set(h1,'Position',[600 100 560 420]);  
        for t = 1 : u
            clear hh mm RGB
            RGB=JET(t*floor(64/u),:);
    %         scatter([355,freq,1540],reshape(dat1(t,:,d),[6 1]),'markerfacecolor',[RGB(1),RGB(2),RGB(3)],'markeredgecolor','none');  hold on ; 
            plot([355,freq,1540],reshape(dat1(t,:,d),[6 1]),'Color',[RGB(1),RGB(2),RGB(3)]);  hold on ; 
            hh = floor(24*(time(t,1,d) - floor(time(t,1,d))));
            mm = floor(60*minus(24*(time(t,1,d) - floor(time(t,1,d))),hh)) ;
            text(1300, nanmax(nanmax(dat1(:,:,d))) + 0.01 - st*t, [num2str(hh) ':' num2str(mm)],'Color',[RGB(1),RGB(2),RGB(3)]);         
        end
        grid on; box on;
        ylabel([' Real part of the refractive index ']);
        title({['Real part of the refractive index, ' num2str(d) ' September 2014, Paris']}) ;
        xlabel('wavelength [nm]');
        
        %%%%%%%%%%%%%%%%%%%%%%%
        h2 = figure(2);
        set(h2,'Position',[1300 100 560 420]); 
        for t = 1 : u
            clear hh mm RGB
            RGB=JET(t*floor(64/u),:);
    %         scatter([355,freq,1540],reshape(dat1(t,:,d),[6 1]),'markerfacecolor',[RGB(1),RGB(2),RGB(3)],'markeredgecolor','none');  hold on ; 
            plot([355,freq,1540],reshape(dat2(t,:,d),[6 1]),'Color',[RGB(1),RGB(2),RGB(3)]);  hold on ; 
            hh = floor(24*(time(t,1,d) - floor(time(t,1,d))));
            mm = floor(60*minus(24*(time(t,1,d) - floor(time(t,1,d))),hh)) ;
            text(1300, nanmax(nanmax(dat1(:,:,d))) + 0.01 - st*t, [num2str(hh) ':' num2str(mm)],'Color',[RGB(1),RGB(2),RGB(3)]);         
        end
        grid on; box on;
        ylabel([' Imaginary part of the refractive index ']);
        % set(gca,'xlim', [0 31],'xtick',0:1:30);

        title({['Imaginery part of the refractive index, ' num2str(d) ' September 2014, Paris']}) ;
        xlabel('wavelength [nm]');
        
        keyboard
        clf (figure(1)) ; clf (figure(2)) ;
        
    end
end




