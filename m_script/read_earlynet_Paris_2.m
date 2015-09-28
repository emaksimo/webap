%%% see script read_aerlynet_Paris_2.m for more details on how to read the
%%% original Aeronet data

clear all
close all

a = importdata('/./media/Transcend/Leosphere/aeronet/input.dat');
% save(input.dat A -ascii)
%%%%

[num,txt] = xlsread(['/./media/Transcend/Leosphere/aeronet/Paris/140901_140930_Paris_SizeDistrib.xlsm'],1) ;

p = 1; % counter for the wavelength

line = 4 ; % header line within the original xls file (our starting point)
rf = floor(num(line+1,3)) ; % reference Julian day
d = 1 ; % counter for the day of month 
%%% first guess about the data matrice size
%%% dimentions : time of the day  x  22 particle size bins x  day of month
dat1 = nan([10 22 30]);  
time = nan([10 1 30]); 


for col = 4 : 25 % 22 particle size bins 
    sz(col-3,1) = num(line,col) ; 
end


day(:,1) = floor(num(:,3));
day(1:line,1) = NaN;

d=1;
for count = min(day) : max(day)
    clear n
    n = find(day == count);

    if ~isempty(n)
        dat1(1:length(n),:,d) = num(n,4:25) ;  
        time(1:length(n),1,d) = num(n,3);       
    end
    d = d+1;
end

colormap(jet) ;
JET= get(gcf,'colormap');

for d = 1 : size(dat1,3); 
    st = 0.01;
    clear u
    d
    u = length(find(~isnan(dat1(:,1,d))))
    if u > 0; % if some data are available on given day
        %%%%%%%%%%%%%%%%%%%%%%%%
        h1 = figure(1);
        set(h1,'Position',[600 100 560 420]);  
        for t = 1 : u
            clear hh mm RGB
            RGB=JET(t*floor(64/u),:);
            plot(sz,reshape(dat1(t,:,d),[22 1]),'Color',[RGB(1),RGB(2),RGB(3)]);  hold on ; 
            hh = floor(24*(time(t,1,d) - floor(time(t,1,d))));
            mm = floor(60*minus(24*(time(t,1,d) - floor(time(t,1,d))),hh)) ;
            text(1300, nanmax(nanmax(dat1(:,:,d))) + 0.01 - st*t, [num2str(hh) ':' num2str(mm)],'Color',[RGB(1),RGB(2),RGB(3)]);         
        end
        ylim([0 nanmax(nanmax(dat1(:,:,d)))]) ; 
%         'yticklabel',0:0.01:nanmax(nanmax(dat1(:,:,d))) 
        grid on; box on;
        ylabel([' dV(r)/dln(r) [microns*m^{3}/microns*m^{2}']);
        title({['Size Distribution (total), ' num2str(d) ' September 2014, Paris']}) ;
        xlabel('radius (r) [microns]');
        set(gca,'XScale','log','Xtick',[0.01 0.1 1 10 100],'XMinorGrid','off'); 
    
        %%%%%%%%%%%%%%%%%%%%%%%
      
        keyboard
        clf (figure(1)) 
        
    end
end




