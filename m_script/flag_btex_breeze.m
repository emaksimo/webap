
clear all
close all

%  load('/home/elena/Downloads/BreezeFlags.mat')
%  
%  tim = datestr(inBreezeFlagDates) ;
%  
%  % day beg-hour beg-min end-hour end-min
%  D = [ 1, 10, 30, 20, 0 ; ...
%  2, 11, 15, 19, 30 ; ...
%  7, 9, 0, 19, 15 ; ...
%  8,  8, 0, 17, 0 ; ...
%  9, 11, 30, 22, 0 ; ...
%  11, 13, 0, 22, 0 ; ...
%  12, 17, 0, 19, 15 ; ...
%  17, 8, 30, 20, 0 ; ...
%  18, 11, 30, 18, 15 ];
%  
%  dat = [D(:,1), D(:,2)+(D(:,3)/60), D(:,4)+(D(:,5)/60) ] ;
%  
%  U = [str2num(tim(:,1:2)) , str2num(tim(:,13:14)) + (str2num(tim(:,16:17)))/60 ] ; % day hour min 
%  
%  inBreezeFlag(:)=0;
%  
%  for i = 1: length(dat)
%      clear idx    
%      idx = find(U(:,1) == dat(i,1) & U(:,2) >= dat(i,2) & U(:,2) <= dat(i,3) ) ;  
%      inBreezeFlag(idx) = 1 ;
%  end
%      
%  [datestr(inBreezeFlagDates), num2str(inBreezeFlag)]
%  
%  save('/home/elena/Downloads/BreezeFlags_EM.mat','inBreezeFlagDates','inBreezeFlag')

load('/home/elena/Downloads/BreezeFlags_EM.mat')

[datestr(inBreezeFlagDates), num2str(inBreezeFlag)]
