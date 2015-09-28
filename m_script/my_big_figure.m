%%% create a big figure with many subplots
clear a zz nl loc
set(f1,'PaperType','A4','PaperUnits','centimeters','Units','centimeters','PaperSize',[55 30],'Position',[1 1 55 30]); hold on
set(f1,'PaperPositionMode','auto') ;

nl = 0.18 ;
zz = 0.02 : nl + 0.017 : 0.98 ; %

loc(:,2) = zz; % from the bottom
loc(:,1) = 0.018 ; % from the left

clear a ; 
a = size(loc,1);
loc(a+1:a+length(zz),2) = zz ; % from the bottom
loc(a+1:a+length(zz),1) = 2*0.018 + nl ; % from the left

clear a;
a = size(loc,1);
loc(a+1:a+length(zz),2) = zz ; % from the bottom
loc(a+1:a+length(zz),1) = 2*(0.018 + nl) + .018; % from the left

clear a;
a = size(loc,1);
loc(a+1:a+length(zz),2) = zz ; % from the bottom
loc(a+1:a+length(zz),1) = 3*(0.018 + nl)  + .018; % from the left

clear a;
a = size(loc,1);
loc(a+1:a+length(zz),2) = zz ; % from the bottom
loc(a+1:a+length(zz),1) = 4*(0.018 + nl)  + .018; % from the left

loc(:,3) = nl ;
loc(:,4) = nl ;

%  for i = 1:size(loc,1)
%             subplot('Position',loc(i,:)); hold on
%             
% end
