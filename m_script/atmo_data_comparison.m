%%%% intercompare MP2.5 measurements between two sites: Malo vs Cap-La-Gr


clear all
close all
load('/media/elena/Transcend/Elena_ULCO/my_matlab_data/CapLaGr_atmo_hourly_PM25.mat'); %,'script','atmo_dat','data_descr');   
CAP = atmo_dat;
clear atmo_dat
load('/media/elena/Transcend/Elena_ULCO/my_matlab_data/Malo_atmo_hourly_PM25.mat'); 
MAL = atmo_dat;

cpt = 1;
a = 1.3883; % color plot

%%%%%% overall comparison (all events within a month)
% zr = 1 : 720 : length(MAL) ; % combine data by month (30-day period)
% per = {'july2013','aug2013','sept2013','oct2013','nov2013','dec2013','jan2014','feb2014','mar2014','apr2014','may2014','june2014','july2014'};
% 
% JET= get(gcf,'colormap');
%    
% clear A B C L Z b bint r rint stats
% for gru = 2 : length(zr)-1 
%     clear AA BB A B RHO PVA A B1 R P
%     A = CAP(zr(gru-1):zr(gru),5);
%     B = MAL(zr(gru-1):zr(gru),5);
%     AA = A(find(~isnan(B)));
%     BB = B(find(~isnan(B)));
%     A1 = AA(find(~isnan(AA)));
%     B1 = BB(find(~isnan(AA)));
%     
%     RGB =  JET(cpt,:); 
%     clf (figure(2));  
%     figure(2);
%     scatter(B,A,30,RGB,'filled'); hold on ;
%     grid on; box on
%     xlabel('PM2.5 at Malo')
%     ylabel('PM2.5 at Cappelle-la-Grande');
%     xlim([0 100]);
%     ylim([0 100]);
%     title(strvcat(per(gru-1)));    
% %     [zr(gru-1) zr(gru)]
%     [RHO,PVAL] = corrcoef(A,B,'alpha',0.01)    
%     keyboard
%     cpt = cpt + 5 ;
% end
%%%%%% 
load('/media/elena/Transcend/Elena_ULCO/my_matlab_data/FR_alpha_by10dGroup_cleaned.mat');
%%%  variables: 'FT','IF','wscript','description','reg','offs','reg_err','offs_err','reg_ov','offs_ov','reg_err_ov','offs_err_ov');  

gr = 3 : 3 : 40 ; % combine data within a 30-day period

clf (figure(2));  
figure(2);
JET= get(gcf,'colormap');
   
clear A B C L Z b bint r rint stats
for gru = 1 : 34 
    clear file_list goodPPI 
    load(['/media/elena/Transcend/Elena_ULCO/my_matlab_data/PPI_file_list_FR_10d_gru'  num2str(gru) '.mat']); % 'wscript','file_list','goodPPI');
    if length(find(~isnan(goodPPI))) > 0        
        for it = 1 : length(goodPPI)
            clear time 
            if ~isempty(find(~isnan(goodPPI(it,:)))) & ~isempty(find(CAP(:,1) == goodPPI(it,1) & CAP(:,2) == goodPPI(it,2))) & ~isnan(reg_ov(it,gru))
                time = goodPPI(it,4) + round(goodPPI(it,5)/60)  ;
                if time == 0
                    A(cpt) = CAP(find(CAP(:,1) == goodPPI(it,1) & CAP(:,2) == goodPPI(it,2) & CAP(:,3) == (goodPPI(it,3)-1) & ...
                    CAP(:,4) == 24),5);
                
                    B(cpt) = MAL(find(MAL(:,1) == goodPPI(it,1) & MAL(:,2) == goodPPI(it,2) & MAL(:,3) == (goodPPI(it,3)-1) & ...
                    MAL(:,4) == 24),5);
                
                else            
                    A(cpt) = CAP(find(CAP(:,1) == goodPPI(it,1) & CAP(:,2) == goodPPI(it,2) & CAP(:,3) == goodPPI(it,3) & ...
                    CAP(:,4) == time),5);
                
                    B(cpt) = MAL(find(MAL(:,1) == goodPPI(it,1) & MAL(:,2) == goodPPI(it,2) & MAL(:,3) == goodPPI(it,3) & ...
                    MAL(:,4) == time),5);
                end
                
                cpt = cpt + 1;
            end
        end
    end
    
    if ~isempty(find(gr == gru)) & exist('B') == 1 & length(B) > 5
        
        length(B)
        
        Z(:,2) = B;
        Z(:,1) = 1;
        [b,bint,r,rint,stats] = regress(A',Z);
%         stats(1)
%         stats(3)
         
        if goodPPI(it,1) == 2013
            RGB =  JET(gru*2,:);
        elseif goodPPI(it,1) == 2014
             RGB = JET(gru*2,:);
        end   
      
        scatter(B,A,30,RGB,'filled'); hold on ;
        grid on; box on
        xlabel('PM2.5 [micro gr per m^{3}] at Malo');
        ylabel('PM2.5 [micro gr per m^{3}] at Cappelle-la-Grande')
        plot(B,B*b(2)+b(1),'color',[RGB(1),RGB(2),RGB(3)],'linewidth',1.8); hold on ;
        xlim([0 50]);
        ylim([0 50]);
        
        goodPPI(it,:)
%         [RHO,PVAL] = corrcoef(A,B,'alpha',0.01)
%         
%         length(B)
%         gru
         keyboard
        clear A B C L Z b bint r rint stats RGB
        cpt = 1;        
    end
end