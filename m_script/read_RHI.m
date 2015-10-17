
function [cnr,el,z1] = read_RHI(chemin0,fichier_RHI,loopme) % from :  wls_sub_RHI_1 ;  

    wls_setup

    root=importdata([chemin0,char(fichier_RHI)],'\t',entete); % read data file  
    
    if isempty(root) | exist('root') ~= 1
        return
    end
    
    dte0=root.textdata(:,1);
    nline0=size(dte0,1);
    dte(:,1)=dte0(entete+1:nline0,1);
    sdte=char(dte);
    aa=str2num(sdte(:,1:4));
    nb_porte=(max_range-50)/res;
    nbline=size(aa,1);
    cc=root.data(1:nbline,:); %cc(ligne, colonne)
    elcol=cc(:,7);
    num_col=10;
    compteur=1;
    for i=num_col:nb_par:size(cc,2)
        cnr(:,compteur)=cc(:,i);
        compteur=compteur+1;
    end
    ncol=compteur-1;
    cnr(cnr<seuil_cnr)=NaN;

    for k = 1 : nbline
        r_0(k,1:sdi) = min_range : res : max_range;
        el(k,1:sdi) = elcol(k); % azimuthal angle relative to the horizontal surface : from 2 deg to 179 deg
    end
      
    z1=r_0.*sin(el.*pi/180)+gl; % altitude above ground level
    d1=r_0.*cos(el.*pi/180);    % projection of R on the horizontal surface
       
    if loopme ~= 0
        clf (figure(4))
        cf = figure(4) ;
        set(cf,'Position',[1150 754 560 232]);
        subplot('Position',[0.1 0.028 0.83 0.99]);        
        surf(d1,z1,cnr,'EdgeLighting','phong','LineStyle','none'); hold on
        view(0,90);
        caxis([seuil_cnr max_cnr]);
        axis equal;
        xlabel('horiz distance off the lidar [m] in South (left) - North (right) direction');
        ylabel('altitude [meters]');
        xlim([-max_range1 max_range1]);
        ylim([0 2200]);
        hold on;   box on;
        hcb=colorbar;
        u=get(hcb,'position');
    end
end 

