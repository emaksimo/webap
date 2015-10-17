%%% see scripts: main.m and result.m

function [DA,ah] = alphaFR(MN,dad,sdi,r_0)  

    DA = NaN; ah = NaN;
    
    %%% delta (mean(CNR)) = mean CNR(R1) minus mean CNR(R2)
    M(:,1) = minus(MN(1:58),MN(2:59)); % best estimate of CNR(R) = mean CNR(R)                 
    KN(1,:)  = exp(nanmoving_average(M,3)); % plus minus 3 values on eigther side

    %%% automatic analysis of the shape of exp(delta CNR)                     
    %%% calculate the first derivative using a 5 point method
    for e = 3 : 56
        GZ(1,e) = plus(minus(KN(e-2),8*KN(e-1)),minus(8*KN(e+1),KN(e+2)) )/(12*50); % 50 meter distance between two neighbouring CNR values   
    end

    GZ(1,[1,2,57,58]) = NaN; 

    %%% keep cnr data only within those distances where (delta cnr) is const, where the 5-point derivative of exp(delta CNR) is close to zero
    KN(find(abs(GZ) > 0.0001)) = NaN; % remove those scaning distances where the derivative is large    
    GZ(find(abs(GZ) > 0.0001)) = NaN;                   

    if length(find(~isnan(GZ))) < 3
        return % continue ccc loop
    end                 

    ae = find(KN == nanmax(KN(1:55))) ; % at which scanning distance we have the peak of delta CNR
    al = nanmean(KN(ae-3 : ae+3)); % allow a range of distances around the peak of delta CNR

    GZ(find(KN < al)) = NaN ; % remove all those distances with weaker KN

    if isempty(min(find(~isnan(GZ)))) |  isempty(max(find(~isnan(GZ)))) | r_0(1,min(find(~isnan(GZ)))) ==  r_0(1,max(find(~isnan(GZ)))) | length(find(~isnan(GZ))) < 3
        return % continue ccc loop
    end

    if r_0(1,min(find(~isnan(GZ)))) >= 1000 
        ah(1) = r_0(1,min(find(~isnan(GZ))));
    else
        return % continue ccc loop
    end

    if max(find(~isnan(GZ))) < 57                        
        ah(2) = r_0(1,max(find(~isnan(GZ)))+1);
    else 
        ah(2) = 2900;
    end

    %%%%%%% slope method 
    y = dad ; % CNR record (corrected by 2ln(R), epsilon, lower 5% & upper 1% tails), see line 145
    x = r_0 ;
    YMY = NaN; XMX = NaN;

    y(find(r_0 < ah(1) | r_0 > ah(2))) = NaN; % cnr corrected by epsilon and 2lnR and filtered out by 5% and 1% tails
    x(find(r_0 < ah(1) | r_0 > ah(2))) = NaN; % R
    ft = 1 ;

    for i = 1 : sdi - 2
        clear M N
        M = minus(y(:,1:sdi-i),y(:,1+i:sdi)); % delta CNR(R) over the same (important!) scanning ray !    
        
        if length(find(~isnan(M))) == 0 % to reduce the calculation time                            
            break % i loop
        end 

        N = minus(x(:,1:sdi-i),x(:,1+i:sdi)); % corresponding delta R
        Y(ft : ft + length(find(~isnan(M)))-1,1) = M(find(~isnan(M))); % delta CNR(R) 
        XX(ft : ft + length(find(~isnan(M)))-1,2) = N(find(~isnan(M))); % delta R
        ft = ft + length(find(~isnan(M))) ;

        YMY((length(YMY)+1) : (length(YMY) + sdi-i),1) = minus(MN(1,1:sdi-i),MN(1,1+i:sdi)); % delta (mean CNR(R))
        XMX((length(YMY)+1) : (length(YMY) + sdi-i),1) = minus(r_0(1,1:sdi-i),r_0(1,1+i:sdi)); % delta R
    end

    XX(:,1) = 1;
    YM(:,1) = YMY(find(~isnan(YMY))) ;
    XM(:,2) = XMX(find(~isnan(YMY))) ;
    XM(:,1) = 1;

    %%% METHOD 1
    %%% here "alpha" is calculated for a group of all possible combinations of
    %%% delta(CNR) which are always taken on the same scanning ray
    %%% at the neigbouring as well as distant ranges
    [B,BINT,R,RINT,STATS] = regress(Y,XX,0.01); 
    reg = B(2)/(-2); % angle of the linear fit
    offs = B(1); % the free coefficient "b" of the linear fit
    reg_err = BINT(2,:)/(-2);
    offs_err = BINT(1,:);

    %%% METHOD 2
    %%% here "alpha" is calculated from the overall average CNR profile of the PPI
    clear B BINT R RINT STATS 
    [B,BINT,R,RINT,STATS] = regress(YM,XM,0.01); % delta (mean CNR(R, all azim))
    reg1 = B(2)/(-2); % angle of the linear fit
    offs1 = B(1); % the free coefficient "b" of the linear fit
    reg_err1 = BINT(2,:)/(-2);
    offs_err1 = BINT(1,:);
    
    if reg >= 0 | reg1 >= 0 % important!
        DA = [reg_err(2) reg reg_err(1) offs_err(2) offs offs_err(1) reg_err1(2) reg1 reg_err1(1) offs_err1(2) offs1 offs_err1(1)];        
    end

end 