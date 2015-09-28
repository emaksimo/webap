% read erai U, V and Geopotential (mb)
% at H925 and H900 level
% aug 2013


clear all 
close all

startup ; 
% NC = ncinfo('/home/elena/Downloads/erai_aug2013_daily4t_925hPa_900hPa_UVH.nc')
% keyboard

Z = ncread('/home/elena/Downloads/erai_aug2013_daily4t_925hPa_900hPa_UVH.nc','z',[1 1 1 1],[inf inf inf inf])/10;  % Geopotential 
%%% Z(:,:,2,:) = heigh of 925 mb level (about 800m)

U = ncread('/home/elena/Downloads/erai_aug2013_daily4t_925hPa_900hPa_UVH.nc','u',[1 1 1 1],[inf inf inf inf]);
V = ncread('/home/elena/Downloads/erai_aug2013_daily4t_925hPa_900hPa_UVH.nc','v',[1 1 1 1],[inf inf inf inf]);

lar = 43.7; % N
lor = 5.5 ; % E

lon = double(ncread('/home/elena/Downloads/erai_aug2013_daily4t_925hPa_900hPa_UVH.nc','longitude',1,inf));   
lat = double(ncread('/home/elena/Downloads/erai_aug2013_daily4t_925hPa_900hPa_UVH.nc','latitude',1,inf));   
L = ncread('/home/elena/Downloads/erai_aug2013_daily4t_925hPa_900hPa_UVH.nc','level',1,inf);

TI  = ncread('/home/elena/Downloads/erai_aug2013_daily4t_925hPa_900hPa_UVH.nc','time',1,inf);
time=datevec(double(TI)/24+datenum(1900,1,1)); 
tp = plus(time(:,3),time(:,4)./24);

clo = find(lon <= lor+0.25 & lon >= lor-0.25) ; % 43.5
cla = find(lat <= lar+0.25 & lat >= lar-0.25) ; % 5.25

% loi = find(lon <= lor+0.1 & lon >= lor-0.1 & lat <= lar+0.1 & lar >= lar-0.1);

 for j = 1 : size(Z,2)
    LO(:,j) = lon;  
end

for i = 1 : size(Z,1)
    LA(i,:) = lat;
end

%%
colormap(jet(64))
jet=get(gcf,'colormap');

clear un1 vn1 du dv vn2 un2
Zup  = reshape(Z(clo,cla,1,:),[size(tp) 1]); % vector of altitudes for 900 mb level
Zlow = reshape(Z(clo,cla,2,:),[size(tp) 1]); % vector of altitudes for 925 mb level 

du = reshape(U(clo,cla,1,:),[size(tp) 1]);
dv = reshape(V(clo,cla,1,:),[size(tp) 1]);
un1 = du./sqrt(du.^2+dv.^2);
vn1 = dv./sqrt(du.^2+dv.^2);
c1 = jet(round(sqrt(du.^2 + dv.^2)*4));

clear du dv
du = reshape(U(clo,cla,2,:),[size(tp) 1]);
dv = reshape(V(clo,cla,2,:),[size(tp) 1]);
un2 = du./sqrt(du.^2+dv.^2);
vn2 = dv./sqrt(du.^2+dv.^2);
c2 = jet(round(sqrt(du.^2 + dv.^2)*4));

positionvector = [0.06 0.78 0.9 0.2 ; 0.06 0.54 0.9 0.2 ; 0.06 0.3 0.9 0.2 ; 0.06 0.06 0.9 0.2]; 

%%
clf(figure(1));
figure(1);
set(gcf,'PaperType','A4','PaperUnits','centimeters','Units','centimeters','PaperSize',[27 27],'Position',[2 -1 27 27]);  


cp = 1 ;
pp = 31 ;
for i = 1 : 4
    clear a1
    subplot('position',positionvector(i,:)); hold on;
    
    ws1 = scatter(tp(cp:cp+pp-1),Zup(cp:cp+pp-1)/100,60,c1(cp:cp+pp-1),'filled','s','MarkerEdgeColor','none'); 
    ws2 = scatter(tp(cp:cp+pp-1),Zlow(cp:cp+pp-1)/100,60,c2(cp:cp+pp-1),'filled','s','MarkerEdgeColor','none');
    
    a1 = quiver(tp(cp:cp+pp-1),Zup(cp:cp+pp-1)/100,un1(cp:cp+pp-1),vn1(cp:cp+pp-1),0.4,'color','k'); hold on % 900mb
    a2 = quiver(tp(cp:cp+pp-1),Zlow(cp:cp+pp-1)/100,un2(cp:cp+pp-1),vn2(cp:cp+pp-1),0.4,'color','r'); hold on % 925 mb level (about 800m)
    
    if i == 1
        set(gca,'xlim',[0.5 tp(cp+pp+1)],'xtick',0.5:1:tp(cp+pp+1),'ylim',[6 11.5],'ytick',6:0.5:11.5);        
    elseif i > 1 & cp+pp+1 < length(tp)
        set(gca,'xlim',[tp(cp-1) tp(cp+pp+1)],'xtick',tp(cp-1):1:tp(cp+pp+1),'ylim',[6 11.5],'ytick',6:0.5:11.5);    
    else
        set(gca,'xlim',[tp(cp-1) max(tp)+0.5],'xtick',tp(cp-1):1:max(tp)+0.5,'ylim',[6 11.5],'ytick',6:0.5:11.5);    
                
        hcb=colorbar('horiz');
        u=get(hcb,'position') ;
        set(hcb,'position',[u(1)+0.66  u(2)  u(3)/4 u(4)/1.1]);
        set(hcb,'xtick',[1/64,16/64,32/64,48/64,64/64],'xticklabel',0:4:16); xlabel(hcb,'wind speed [m/s]');
    end
    
    ylabel('altitude [meters * 100]');
    xlabel('day of month'); 
    box on; grid on ;
    cp = cp + pp;
end


%%
             
%        dlmwrite(filename,M,delimiter)     '