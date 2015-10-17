%%% read CNR file
%%% the original script : PPI_list_stats.m

function [ccnr,xdate,r_0,az] = read_PPI(chemin0,fichier,loopme)

    wls_setup % get the instrumental parameters
    
    root=importdata([chemin0,char(fichier)],'\t',entete); % read data file
    
    if isempty(root) | exist('root') ~= 1
        return
    end
    
    dte0=root.textdata(:,1);
    nline0=size(dte0,1);    
    sdte=char(dte0(entete+1:nline0,1));
    nbline=size(sdte,1); % it should be always 360!
    aa=str2num(sdte(nbline,1:4)); 
    mm=str2num(sdte(nbline,6:7));
    jj=str2num(sdte(nbline,9:10));
    hh=str2num(sdte(nbline,12:14));
    mn=str2num(sdte(nbline,16:17));
    ss=str2num(sdte(nbline,19:20));
    xdate=datenum(aa',mm',jj',hh',mn',ss'); % date&time corresponding to the end of PPI (which takes 6min)
        
    nb_porte=(max_range-res)/res;
    cc=root.data(1:nbline,:);
    azcol=cc(:,6); % clockwise relative to the North 
    elcol=round(nanmean(cc(:,7))); % inclination relative to the horisontal plane [degrees]
    
    %%%%%%%%%%%%% CNR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    num_col=10;
    ncol=1;
    for i = num_col : nb_par : size(cc,2)
         cnr(:,ncol) = cc(:,i);
         if ncol == 59
             break
         end
         ncol = ncol + 1;    
    end

    cnr(cnr<seuil_cnr) = seuil_cnr;
%     cnr(cnr<seuil_cnr-ad_seuil) = seuil_cnr;

    ccnr = cnr(:,1:sdi); % take the first 3km range, even if the data can span 5km in total
    ccnr(find(ccnr>=seuil_cnr_ma))=NaN; % do not consider the areas with zero CNR 
    ccnr(find(ccnr<=seuil_cnr))=NaN; % do not consider the areas with too low signal
    
    for d = 1 : sdi  % scanning range off the lidar, see wls_PPI_loop_1.m
        clear PRC
        PRC = prctile(ccnr(:,d),[5 99]) ; % lower 5% and upper 99% percentiles of the distribution
        ccnr(find(ccnr(:,d) < PRC(1) | ccnr(:,d) > PRC(2)),d) = NaN ;
    end

    for k = 1 : nbline
        r_0(k,:) = min_range : res : max_range;
    end
    
    el(1:nbline,1:ncol) = elcol; 
  
    for j=1:ncol
        az(:,j)=azcol;
    end
  
    d1 = r_0.*sin(az.*pi/180); % projection of the radial distance on WE (X) axis in horizontal plane
    z1 = r_0.*cos(az.*pi/180); % projection of the radial distance on NS (Y) axis in horizontal plane

    %%%        SCAN CNR      %%%
    if loopme ~= 0
        clf (figure(1));
        cf =  figure(1) ;
        colormap(jet) ;
        JET= get(gcf,'colormap');
        set(cf,'Position',[60 10 560 420]);     
        surfc(d1,z1,cnr, 'LineStyle','none','EdgeLighting','phong');
        shading(gca,'flat');
        view(0,90);
        caxis([seuil_cnr max_cnr]);
        axis equal; box on; grid on;
        xlabel(['     Range West / East ', '(m)']);
        ylabel(['     Range South / North ', '(m)']);
        xlim([-max_range1 max_range1]);
        ylim([-max_range1 max_range1]);
        hold on;        
        colorbar
        title(['PPI, elevation angle ',num2str(round(el(1))), 'deg, ' strvcat(datestr(xdate))]);   
    end
end
 