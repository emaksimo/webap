%%% evaluate statistics of 360 CNR values at each distance R
%%% CF(L,1:59)  = std at each distance R and each PPI file
%%% RAN(L,1:59) = min-max range after removing 5% of data on eigther side 
%%% mother scripts : PPI_list_stats.m and main.m

function [B,A] = cnr_stats(ccnr,r_0)

    wls_setup % get the instrumental parameters
    
    A(1,1:sdi) = NaN;
    B = A;
    
    for d = 1 : sdi  % scanning range off the lidar, see wls_PPI_loop_1.m
        clear Y PRC HT nx bx
        Y = plus(ccnr(:,d)./epsilon, 2*log(r_0(1,d)));   % all CNR values at the first radius   
        HT = Y(find(~isnan(Y))); 
        clear Y 

        if length(HT) > 200 % if at least 200 scans are available at given range     

            %%%%%%%%%%%%%%  begining ???  
%             [nx,bx]= hist(HT,min(HT)-1 : 0.25 : max(HT) + 0.5) ;
%             if length(find(nx == max(nx))) > 1
%                 clear nx bx
%                 [nx,bx]= hist(HT,min(HT)-1 : 0.2 : max(HT) + 0.5) ; 
%                 if length(find(nx == max(nx))) > 1
%                      clear nx bx
%                      [nx,bx]= hist(HT,min(HT)-1 : 0.15 : max(HT) + 0.5) ; 
%                      if length(find(nx == max(nx))) > 1
%                             clear nx bx
%                             [nx,bx]= hist(HT,min(HT)-1 : 0.1 : max(HT) + 0.5) ;  
%                             if length(find(nx == max(nx))) > 1 & (mean(bx(find(nx == max(nx)))) < ME(L,d)-CT(L,d) | mean(bx(find(nx == max(nx)))) > ME(L,d)+CT(L,d))
%                                 continue % d
%                             elseif length(find(nx == max(nx))) > 1 & (min(bx(find(nx == max(nx)))) < ME(L,d)-CT(L,d) | max(bx(find(nx == max(nx)))) > ME(L,d)+CT(L,d))
%                                 continue % d
%                             end
%                      end
%                 end  
%             end
            %%%%%%%%%%%%  end ??

            PRC = prctile(HT,[25 75]) ; % 25% and 75% percentiles of the distribution
            if PRC(2) >= 0 
                 A(1,d)  = minus(PRC(2),PRC(1)); 
            else 
                PRC
                display(['see PRC, cnr_stats.m' ])
                 keyboard
                 A(1,d)  = abs(plus(abs(PRC(2)),PRC(1))); % ?????
            end

            B(1,d)   = skewness(HT);  % if the distribution is inclinated                
        end 
    end 
end

