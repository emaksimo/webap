
 %%%%AXE radial
 for j=1:6
     rj(j)=500.*j;
 for i=1:360
     theta_axe(i)=i.*0.5;
     r_axe(i)=rj(j);
     xaxe(i)=r_axe(i).*cos(theta_axe(i).*pi./180);
     yaxe(i)=r_axe(i).*sin(theta_axe(i).*pi./180);
     zaxe(i)=999;
 end;
 plot3(xaxe,yaxe,zaxe,'-w','MarkerSize',1);
hold on;
 end;
 
 nb_sect=6;
 for i=1:nb_sect
     theta_r(i)=(180./nb_sect).*i-180./nb_sect;
     rr=max_range;
     rxaxe(2)=rr.*cos(theta_r(i).*pi./180);
     ryaxe(2)=rr.*sin(theta_r(i).*pi./180);
     rzaxe(2)=999;
     plot3(rxaxe,ryaxe,rzaxe,'w');
hold on;
     
 end;
 
 
 
 hold on;
 
 %%%%%%%%%%Fin Axe radial