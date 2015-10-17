%%% see : "main.m" and "PPI_list_stats.m" for more details
%%% calculate alpha for the best PPI
%%% evaluate the Instrumental function using the best PPI
%%% PPI file loop done with : PPI_list_stats.m
%%% statistics were calculated with : instrum_function.m
%%% see Aa_my_WLS100_inversion_procedure.m to understand the order of the
%%% procedure in matlab 
%%% media/Transcend/Elena_ULCO/MultiAngleApproach/Maksimovich_resume.tex
%%% describes the equations and the logic of my procedure 
%%% to retrieve the instrumental function, see "result_instr_func.m"

wls_setup % get the instrumental parameters, and my filter criterias

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load([output 'CNR_stats_selectedPPI.mat']); %,'SK','RANG','XD','data_description','r_0','az','FolFil'

RANG(find(RANG == 0 )) = NaN; % range can't be zero!
SK(find(RANG == 0 )) = NaN;

S(1,:) = nanmean(SK); % average skewness at each scanning distance R
S(2,:) = S(1,:) + nanstd(SK); % upper value of the typical skewness 
S(3,:) = S(1,:) - nanstd(SK); % lower value of the typical skewness 
V(1,:) = nanmean(RANG); % typical inter-quartile range when taking all PPI

if loopme ~= 0
    clf (figure(1));  clf (figure(2));
    figure(1)
    plot(r_0(1,:),S(1,:),'r'); hold on
    plot(r_0(1,:),S(2,:),'k'); hold on
    plot(r_0(1,:),S(3,:),'k'); hold on
    xlabel([' scanning distance R [meters]'],'color','k');
    ylabel([' ave skewness of all CNR(R), units [dB]'],'color','k');
    grid on
    
    figure(2)
    plot(r_0(1,:),V(1,:),'k'); hold on
    xlabel([' scanning distance R [meters]'],'color','k');
    ylabel([' 25% - 75% range of all CNR(R), units [dB]'],'color','k');
    grid on
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% upload the rough data and apply the filters (based on overall statistics) to this data
%%%%% calculate alpha for each good PPI
ij = FolFil(1,1);
chemin0=([core_dir rep(ij).name '/']); % first not empty sub-folder name (fox ex, regrouping the files in one month)
list = dir([chemin0,Ftype_PPI]); % PPI file list within the first folder
list_RHI = dir([chemin0,Ftype_RHI]); % RHI file list
X = struct2cell(list_RHI);
Y = cellstr(X(1,:)');  

cpt = 1; % counetr within the selection of best PPI for which the "alpha" and "F(R)" are calculated

for ccc = 1 : length(FolFil) % preselected PPI files
    clear L GT LR cnr MN dad
    im = FolFil(ccc,1); % sub-folder containing PPI and RHI files
    L = FolFil(ccc,2);  % PPI file within this sub-folder
    LR = FolFil(ccc,3);  % RHI file within this sub-folder
    
    if im > ij % if new folder
        clear chemin0 list list_RHI X Y
        ij = im; 
        chemin0=([core_dir rep(im).name '/']); % sub-folder name (fox ex, regrouping the files in one month)
        list = dir([chemin0,Ftype_PPI]); % PPI file list 
        list_RHI = dir([chemin0,Ftype_RHI]); % RHI file list
        X = struct2cell(list_RHI);
        Y = cellstr(X(1,:)');   
    end

    GT(1,1:sdi) = 1;        
    GT(find(RANG(ccc,:) >= V)) = NaN; % more narrow PDF at given distance R than the typical width   
    GT(find(SK(ccc,:) >= S(2,:))) = NaN;
    GT(find(SK(ccc,:) <= S(3,:))) = NaN; % scanning distances with skewness within the corresponding typical range
    GT(find(isnan(RANG(ccc,:)) & isnan(SK(ccc,:)))) = NaN;

    fichier = cellstr(list(L).name);  % PPI file name           
    fichier_RHI = cellstr(list_RHI(LR).name);  % RHI file name

    %%% if the CNR(R) statistics at each given distance R are good
    if length(find(~isnan(GT(tu(1) : tu(2))))) > 10 
        %%% get the appropriate RHI file (closest in time)
        %%% check the vertical symmetry within the lowest 300m  
        
        [cnr,el,z1] = read_RHI(chemin0,fichier_RHI,loopme); % from :  wls_sub_RHI_1 ;         
        hv = nanmean(cnr(89:91,1:5)); % near-vertical angles
        for ei = 5 : 15 : 85 % azimuthal angle in vertical (RHI) plane, in [deg] relative to the horizontal plane
            clear crh C1 C2 C
            crh = min(find(z1(ei,:) > CH));
            C1 = nanmean(cnr(ei-1:ei+1,1:crh),1); % compare only those RHI CNR measurements below 300m
            C2 = nanmean(cnr(size(el,1)-ei-1 : size(el,1)-ei+1, 1:crh),1);
            C = abs(minus(C2,C1)) ; 
            %%% if more than 3 CNR values at the same altitude, same angle, same scanning distance differ so much !
            if length(find(C > 2)) > 3 
                disp('RHI check failed, see "result.m" ') 
                clear C1 C2 crh af ans el
                break  % ei loop                             
            end                                
        end
                 
        if exist('C') ~= 1 | length(find(C > 2)) > 3 % if not symmetric vertically within the lowest 300m
            clear C ei          
            continue % ccc loop
        end
        
        %%% upload PPI CNR data file    
        clear r_0 az xdate ccnr cnr
        [ccnr,xdate,r_0,az] = read_PPI(chemin0,fichier,loopme);

        if size(ccnr,1) ~= 360 | size(r_0,1) ~= 360
            continue % ccc loop
        end

        %%%% remove those distances where the statistics (!) are out of the typical vales
        ccnr(:,find(isnan(GT))) = NaN ;                     
                
        %%% within the first 5 scannng distances (100:300m) 
        %%% the average CNR at each range is similar between PPI and RHI 
        hh = nanmean(ccnr(:,1:5)); % PPI
        hk = minus(hh,hv); 

        if max(abs(hk)) > 2                     
            continue % cc loop
        end                       

        clear DA ah
        %%%% the overall average (representative) CNR profile of the PPI
        for d = 1 : sdi   
            dad(:,d) = plus(ccnr(:,d)./epsilon ,  2*log(r_0(1,d)));
            MN(1,d) = nanmean(dad(:,d)); % best estimate of CNR(R)
        end
    
        [DA,ah] = alphaFR(MN,dad,sdi,r_0); % PPI data        
        
        if ~isempty(find(~isnan(DA))) & exist('DA') == 1 
            XB(cpt,1) = XD(ccc);             
            SM(cpt,:) = [ij L LR ah DA];  
            
            %%% Instrumental function is proportional to F(R)*K*beta
            FR1(cpt,1:sdi) = NaN ; % corresponding to alpha estimated with METHOD1
            FR2(cpt,1:sdi) = NaN ; % corresponding to alpha estimated with METHOD2
            
            FR1(cpt,:) = exp(plus(MN,2*DA(2)*r_0(1,1:sdi))) ; % best estimate of CNR plus 2*alpha*R
            FR1(cpt,find(isnan(GT))) = NaN;
            
            FR2(cpt,:) = exp(plus(MN,2*DA(8)*r_0(1,1:sdi))) ; % best estimate of CNR plus 2*alpha*R
            FR2(cpt,find(isnan(GT))) = NaN;
            cpt = cpt + 1;
        end 
    end  % criterias KRA, SKA, inter-quartile range              
end % ccc
       
%%% in original version :
% % save('/media/Transcend/Elena_ULCO/my_matlab_data/alpha_homogeneous_cases_3.mat','SM','FR'); 
clear R data_description
R = r_0(1,:);

data_description = {['see scripts: main.m, result.m and alphaFR.m for more details'];...
     ['SM(:,1) sub-folder number containing the PPI and RHI files, see main.m,'];...
     ['SM(:,2) corresponding PPI file number within this folder'];...     
     ['where the PPI file number corresponds to the count number within the overall PPI file list of the folder,'];...
     ['SM(:,3) corresponding RHI file number within this folder,'];... 
     ['SM(:,4:5) scanning distances off the instrument (within given PPI) where alpha is calculated (with two methods),'];... 
     ['METHOD 1 , see SM(:,6:11): "alpha" is calculated for a group of all possible combinations of delta(CNR)'];... 
     ['which are always tacken on the same scanning ray, at the neigbouring as well as distant ranges'];... 
     ['METHOD 2 , see SM(:,12:17): "alpha" is calculated from the overall average CNR profile of the entire PPI'];...      
     ['SM(:,6) smallest alpha estimate = angle of the linear fit (99% signif test)'];... 
     ['SM(:,7) ext coef = alpha = angle of the best linear fit, units [m^{-1}]'];... 
     ['SM(:,8) upper alpha estimate = angle of the linear fit (99% signif test)'];...
     ['SM(:,9) lowest free coefficient (offset) estimate of the linear fit'];...
     ['SM(:,10) "ave" free coefficient (offset) estimate of the linear fit'];...
     ['SM(:,11) upper free coefficient (offset) estimate of the linear fit'];...
     ['datevec(datestr(XB(n))) contains the date/time corresponding to the end of PPI (which takes 6min)'];...
     ['time range: aug 2013 - aug 2014'];...
     ['R = scanning range [meters] off the instrument = radial distance'];...    
     ['FR1(n,100:50:3000m) = F(R)*K*beta(n) value at each scanning distance, where beta is individual (unknown) for given n-th PPI '];...
     ['FR1 and FR2 correspond to "alpha" calculated with Method1 and Method2'];...
     ['F(R)*K*beta(n) should be normalized to get F(R) shape'];...
     ['according to this study, the typical values of ext coeff at 1.54 micron = 0.05-0.3 km-1 covering the clear and very polluted air'];... 
     ['by Maksimovich Elena / October 2015']};

save([output 'result_alpha_FR_all_best_PPI.mat'],'SM','FR1','FR2','XB','data_description','R');



