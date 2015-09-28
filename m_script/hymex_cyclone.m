%%% when working with the daily data comment all "Pc" lines
%%% when working with 6-hourly data, then comment "Dc" lines
%%% the result "G" regroups all cyclone positions, their central pressure and the outermost
%%% closed isobar 

clear all
close all
load(['/./media/Transcend/Hymex/ASCII/msl_6hdaily_y2012_SeptOct.mat']); % 'msl' (6-hourly) , 'RRT' (daily mean SLP), 'LO','LA','time'
% load(['/./media/Transcend/Hymex/ASCII/H700_6hdaily_y2012_SeptOct.mat']); 
% [ min(min(min(Hd))), mean(mean(mean(Hd))), max(max(max(Hd)))]

%%% cyclone center detection : see cyclone_diameter.m
cc = 1 ; % cyclone center count (these are not necessarily independent cyclones!)
rt = 1; % counter for the moment of the day
                               % Pc
cn = 1; % counter for "K" (cyclone domain/location)
    
% d = 4; % use ERAI_SLP data on given day  % Pc
% for p = 1 : size(msl,3)  % Pc
for d = 1 : length(time)/4   % Dc
    clear P LAC LOC PP lwa lwo lim h a gd ; close all ;
%     P = Hd(:,:,d);  % Dc
    P = RRT(:,:,d);
%     P = msl(:,:,p);                           % Pc           
%     if rt == 5                                % Pc
%         rt = 1;                               % Pc
%         d = d+1;                              % Pc
%     end                                       % Pc
    
%     P(:,45:56,:) = NaN; P(25:29,:,:) = NaN; % we don't need any cyclone centers on the southern and eastern border of the frame
    figure(1);
    set(gcf,'PaperType','A4','PaperUnits','centimeters','Units','centimeters','PaperSize',[25 15],'Position',[40 25 25 15]); hold on
    positionvector = [-0.14 -0.095 1.16 1.22];
    subplot('position',positionvector); hold on;
    axesm('MapProjection','lambert','MapLatLimit',[30 50],'MapLonLimit',[-10 30],'PlineLocation',5,'MlineLocation',5); hold on   
    h = contourm(LA,LO, P,970:2:1040,'showtext','off','fill','off','linewidth',1); hold on
    caxis([1005 1025]);
%     caxis([220 380]);
%     h = contourm(LA,LO, P,220:2:380,'showtext','off','fill','off','linewidth',1); hold on
%     caxis([1005 1025]);
    
    geoshow('landareas.shp','Facecolor','none'); hold on    
    setm(gca,'GLineWidth',1.5,'fontsize',10,'meridianlabel','on','parallellabel','on'); box off ; gridm on; framem('on');
%     textm(53,5,['day ' num2str(d) ' ' num2str(time(p,4)) ':00 GMT'],'FontSize',14);   % Pc
    textm(53,5,['day ' num2str(d) ],'FontSize',14);       % Dc
%     d
%   keyboard
%     continue
    
    %%%% firt find the most pronounced cyclone center within the region
    % idx = find(RRT(:,:,d) == min(min(RRT(:,:,d))));
    LAC = LA(find(P == min(min(P)))); 
    lwa = find(LA(:,1) == LAC);
    LOC = LO(find(P == min(min(P)))); 
    lwo = find(LO(1,:) == LOC);
    PP = P(find(P == min(min(P))));

    %%%% create the data base of all cyclone centers within the domain
    G(cc,1) = d;   % day out of 61 days (1 Sept - 31 Oct 2012)
%     G(cc,2) = time(p,4);  % h;     % Pc
    G(cc,2) = 24;                   % Dc
    G(cc,3) = PP;  % minimum cyclone pressure 
    G(cc,4) = LAC; % cyclone position (deg N)
    G(cc,5) = lwa; % cyclone position [line number within the matrix]
    G(cc,6) = LOC; % cyclone position (deg E = +)
    G(cc,7) = lwo; % cyclone position [column number within the matrix]
    cc = cc+1; % cyclone count
    
    %%% outermost closed isobar
    for li = (PP + 1) : 10 : PP+100 % first guess for the outermost closed isobar      
        li
            clear MASK STATS
            a = 0; % counter for the low pressure cores within one cyclone
            MASK = false([size(P,1) size(P,2)]); % mask of cyclone(s) area(s)
            MASK(find(P < li)) = true; % P(find(PP < lim));
            STATS = regionprops(MASK,'PixelList','PixelIdxList');
            %%% since we increase the cyclone radius, the new cyclones may
            %%% detected within the study domain
          
            if size(STATS,1) > 1 % if more than one cyclone exist within the domain (with given outermost P)                  
                for st = 1 : size(STATS,1)
                    if ~ismember([lwo,lwa],STATS(st).PixelList) & length(STATS(st).PixelList) <= 120 
                        %%% if the main cyclone core is not a part of given cyclone (st), then consider this (st) cyclone as a new one                        
                        clear idx idl g3 g4 g5 g6 g7 
                        g2 = 24;   %  time(p,4)               % Dc / Pc
                        g3 = min(P(STATS(st).PixelIdxList)); % minimum cyclone pressure of the secondary cyclone (less deep)
                        idx = find(P(STATS(st).PixelIdxList) ==  min(P(STATS(st).PixelIdxList))); % coordinate of this cyclone position
                        idl = LA(STATS(st).PixelIdxList);  % corresponding lat coordinates                        
                        g4 = idl(idx); clear idl; % cyclone position (deg N)                        
                        g5 = find(LA(:,1) == g4); % cyclone position [line number within the matrix]
                        
                        idl = LO(STATS(st).PixelIdxList);
                        g6 = idl(idx); % cyclone position (deg E)
                        g7 =  find(LO(1,:) == g6); % cyclone position [column number within the matrix]
                       
                        if isempty(find(G(:,1) == d & G(:,2) == g2 & G(:,3) == g3 & G(:,4) == g4 & G(:,5) == g5 & G(:,6) == g6 & G(:,7) == g7)) 
                            %%% if after increasing the outermost P limit
                            %%% this low pressure core is not yet recorded on the same day, then include this new core into the list "G"
                            G(cc,1) =  d;
                            G(cc,2) = 24; 
                            G(cc,3) = g3;
                            G(cc,4) = g4;
                            G(cc,5) = g5;
                            G(cc,6) = g6;
                            G(cc,7) = g7;    
                            cc = cc+1; % cyclone count
                        end
                        clear idx idl g3 g4 g5 g6 g7 
                        
%                     elseif length(STATS(st).PixelList) > 80 
                        %%% if given cyclone is very large, then skip this cyclone, but keep checking the other cyclones searching the outermost isobar
%                         continue % st loop
                    end
                end % st loop
 
            elseif size(STATS,1) == 1 & ismember([lwo,lwa],STATS.PixelList) & length(STATS.PixelList) > 120 % ommit if too big primary cyclone
                G(find(G(:,1) == d),8) = li - 0.5; 
%                 keyboard
                a == 2; 
                break % "li" loop       
            end
                        
            %%% while the outemost contour is enlarged more and more, several cyclone centers can be split together
            %%% check the size of the cyclone and whether the detected cyclone centers are split together (if using given outemost isobar)?
            gd = G(find(G(:,1) == d),:); % all cyclone centers on this day
            
            if size(gd,1) >= 1 % if at least one cyclone center is detected on this day
                for st = 1 : size(STATS,1)  % for each cyclone domain
                    for ct = 1 : size(gd,1) % check all cyclone centers                       
                        if ismember([gd(ct,7),gd(ct,5)],STATS(st).PixelList) & length(STATS(st).PixelList) <= 120 
                            a = a + 1; % a = 1 = one cyclone core 
                             if a > 1 % there is more than one cyclone center within given cyclone domain
                                    %%% we found the outermost isobar = lim - 1
                                    G(find(G(:,1) == d),8) = li - 0.5 ; 
%                                     G(find(G(:,1) == d & G(:,2) == time(p,4)),8) = li - 0.5 ; 
                                    break % ct loop
                             end
                        end                         
                    end 
                    
                    if a > 1 ;  
                        break % st loop
                    end
                end %  for st
            end
            
            if a > 1 ;  
                break % li loop
            end            
    end % "li" outermost closed isobar
    
    %%% show the cylone domain   
    
%     clear MASK STATS gd 
%     gd = G(find(G(:,1) == d),:); 
%     MASK = false([size(P,1) size(P,2)]); % mask of cyclone(s) area(s)
%     MASK(find(RRT(:,:,d) <= li-0.5)) = true; % Dc
%     STATS = regionprops(MASK,'PixelList','PixelIdxList');
%  
%     for ct = 1 : size(gd,1) % plot all cyclone centers
%             set(0,'currentfigure',1); hold on
%             plotm(gd(ct,4),gd(ct,6),'marker','o','markerfacecolor','r'); hold on
%             h  = contourm(LA,LO,RRT(:,:,d),970:2:1040,'showtext','off','fill','off','linewidth',1); hold on  %  Dc  
%         if size(STATS,1) >= ct
%             if length(STATS(ct).PixelList) <= 120
% %                 T = zeros([size(P,1) size(P,2)]); 
% %                 T(STATS(ct).PixelIdxList) = 1;                 
% %                 h1 = contourm(LA,LO,T,-2:3:5,'showtext','off','fill','off','linewidth',2); hold on; %  Pc             
%             end
%         end
%     end
    
    for ct = 1 : size(gd,1) % plot all cyclone centers
            set(0,'currentfigure',1); hold on
            plotm(gd(ct,4),gd(ct,6),'marker','o','markerfacecolor','r'); hold on
%             h2 = contourm(LA,LO,P,gd(1,8)-50 : 50 : gd(1,8)+51,'color','k','showtext','off','fill','off','linewidth',2); hold on  %  Dc
    end
    
%     print(['/media/Transcend/Hymex/figures/daily/slp_' num2str(d) 'd.png'],'-dpng'); % -r200 -painters )
     pause(3)
%     rt = rt + 1; % moment of the day  %  Pc

end % p = 6houly moment out of 244 moments   OR d = day out of 62 days

save(['/./media/Transcend/Hymex/ASCII/cyclone_position_daily_y2012_SeptOct.mat'],'G')
%%

G(find(G(:,4) < 35),:) = NaN;
G(find(G(:,4) > 47),:) = NaN;
G(find(G(:,6) > 25),:) = NaN;

minus(G(:,8),G(:,3))



