%%% columns : 
%%% (1) ij, 
%%% (2) L, 
%%% (3) lower scanning distance of the domain where delta CNR is const
%%% (4) upper scanning distance of the domain where delta CNR is const
clear re

re = [     3         100        2000        2300 ; ... 
           4          47        2000        2300 ; ... %
           5         108        1950        2200 ; ... 
           5         115        1850        2300 ; ... 
           7         688        1850        2200 ; ... 
           9         411        2000        3000 ; ... 
           9        1027        1850        3000 ; ...       
           9        1033        2450        2850 ; ... 
          10         944        2100        2250 ; ... 
          10        1005        2350        2550 ; ... 
          10        1006        2500        2950 ; ... 
          10        1007        2350        2950 ; ... 
          10        1124        1800        2650
          16         954        2250        2500 ; ... 
          16         959        2300        2700 ; ... 
          16         995        2600        2850 ; ... 
          16         998        2550        2950 ; ... 
          16         999        2800        2950 ; ... 
          17          84        1900        2600 ; ... 
          17         105        1950        2300 ; ... 
          17         297        1850        2150 ; ... 
          17         298        1800        2300 ; ... 
          17         300        1850        2350 ; ... 
          17         304        1950        2350 ; ... 
          17         330        1850        2250 ; ... 
          17         335        1850        2300 ; ... 
          17         337        1850        2200 ; ... 
          17         371        2200        2450 ; ... 
          17         380        2500        2750 ; ... 
          17         431        2550        3000 ; ... 
          17         433        2150        2450 ; ...           
          18          33        1800        2450 ; ... 
          18          34        1800        2700 ; ... 
          18          69        2000        2300 ; ... 
          18          89        1800        2900 ; ... 
          18          89        2300        3000 ; ... 
          18          91        2650        2850 ; ... 
          18          94        2550        3000 ; ... 
          18         103        2350        2950 ; ... 
          18         104        2550        2650 ; ... 
          18         107        2450        2800 ; ... 
          18         108        2400        2650 ; ... 
          18         110        2400        2750 ; ... 
          18         172        1800        2300 ; ... 
          18         178        1900        2150 ; ... 
          18         197        1900        2250 ; ...   
          18         307        2400        2700 ; ... 
          18         311        2700        2950 ; ... 
          18         319        2450        2600 ; ... 
          18         422        2000        2250 ; ...     
          19         196        2650        2850 ; ... 
          19         201        2650        2900 ; ... 
          19         216        2050        2550 ; ... 
          19         252        2650        2900 ; ... 
          19         619        2700        2850 ; ... 
          19         633        2100        2800 ; ... 
          19         639        2100        2500 ; ... 
          19         641        2000        2450 ; ... 
          19         674        2450        2950 ; ... 
          19         820        2350        2950 ; ... 
          19        1069        2400        2650 ] ;

% re = [4 47    2000 2300 ; ... % 2450 2900
%     10 944  2100 2250 ; ... % 2500 2650
%     10 1005 2350 2550 ; ... % 2600 2900
%     10 1006 2500 2950 ; ... % 2450 2950
%     10 1007 2350 2950 ; ... % 2450 2850
%     16 954  2250 2500 ; ... % 2200 2550
%     16 959  2300 2700 ; ...
%     16 995  2600 2850 ; ... % 2650 2750
%     16 998  2550 2950 ; ... % 2050 2300
%     16 999  2800 2950 ; ... % 2200 2350
%     17 84   1900 2600 ; ... % 2000 2700
%     17 371  2200 2450 ; ...
%     17 380  2500 2750 ; ... % 2050 2450
%     17 431  2550 3000 ; ... % 2350 3000
%     17 433  2150 2450 ; ...
%     18 89   2300 3000 ; ...
%     18 91   2650 2850 ; ... % 2250 2550
%     18 94   2550 3000 ; ... % 2000 2450
%     18 103  2350 2950 ; ...    % 1900 2950
%     18 104  2550 2650 ; ...
%     18 107  2450 2800 ; ...
%     18 108  2400 2650 ; ...
%     18 110  2400 2750 ; ...
%     18 307  2400 2700 ; ...
%     18 311  2700 2950 ; ...
%     18 319  2450 2600 ; ...
%     18 422  2000 2250 ; ...
%     19 196  2650 2850 ; ...
%     19 201  2650 2900 ; ...
%     19 252  2650 2900] ;
