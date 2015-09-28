%%% recalculate CNR(d) using constant alpha = 0.6 and using b(d)
%%% plot cnr as a function of d
%%% plot the measured cnr values (on the same figure)

clear ccnr

for d = 1:length(FM);  % distance off the lidar
    clear x y a 
    x = 2*epsilon*dist(d);
    ccnr(round(dist(d))) = .0006*-x + FM(d); % constant alpha = 0.6
end


figure(6)

ccnr(find(ccnr==0))=NaN;
plot(ccnr,'k','LineStyle','-','linewidth',25) ; hold on

% profile = 13
% scatter(r_0(profile,:)*cosd(profile-ref),BBT(profile,:)); hold on

