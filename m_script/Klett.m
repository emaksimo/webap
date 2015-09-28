%Variables:
%Z1: Altitude
%d1: distance
%r1
%pr2
%Sa
%niveau: 'ASL' ou 'AGL'
%orientation: 'Vers Nord'ou ...
%P0: pression depart
%T0: Temp�rature depart
%lambda_mic: longueur d'onde en microm�tre
%figscan2: si 0, pas figure scan vert et si 1, trace figure scan vert (P, T, ro, ext_mol, bet_mol)
%figscan3: trace ou pas ext totale
%betaslope: Backscattering coef. r�f�rence
%m: distance de la r�f�rence de b�taslope

%%%%%%%CALCUL DE L'ExTINCTION MOL
for k = 1 : length(fichier)
    
M = 0.0289644; % en [kg/mol]
R = 8.31447;   % en [J/mol/K]
N = 6.022141*10^23 ;
L = 0.0065;    % [K/m]
gr = 9.80665;  % [m/s2]
ro0 = P0*M/(R*T0); % en [kg/m3]
P(:,k) = P0.*((1-(L.*(z1(:,k)))./T0)).^(gr*M/R/L) ;

T(:,k) = (T0-L*(z1(:,k)));      % vertical temp profile 
ro(:,k) = P(:,k).*M./R./T(:,k); %

ro_mol(:,k) = ro(:,k)*N/M ; % vertical molar air density
ro0_mol = ro0*N/M ; % surface air density 

 %%% ?
 N1 = 6.0221367*10^23*273.15/(22.4141*1000) ; 
 N2(:,k) = N1./(T(:,k)) ; 
 Nok(:,k) = N2(:,k).*(P(:,k)./1013) ; % (en cm-3)
 a1 = 1.0455996 - 341.29061*(lambda_mic)^-2-0.9023085*(lambda_mic)^2; %
 a2 = 1 + 0.0027059889*(lambda_mic)^-2-85.968563*(lambda_mic)^2;
 cross = a1/a2*10^-28; %(en cm-2)
 scatmol(:,k) = Nok(:,k).*cross*10^2;%(m-1)
 
 ext_mol(:,k) = scatmol(:,k);  % (m-1)
 beta_mol(:,k) = ext_mol(:,k).*3/8/pi; % (m-1.sr-1)

end;

% 
if figscan2 == 1 %(voir les scans pour le calcul de l'ext mol)
 figure(29);
surf(d1,z1,P,'EdgeLighting','phong','LineStyle','none'); 
shading interp
view(0,90);
title('Pressure [Pa]');
xlabel(['     Range from Lidar to ',orientation,' (m)']) %
alti=['Altitude ',niveau,' (m)'];
ylabel(alti);
colorbar;
box on;
 figure(28);
surf(d1,z1,T,'EdgeLighting','phong','LineStyle','none'); 
shading interp
view(0,90);
title('Temperature [K]');
xlabel(['     Range from Lidar to ',orientation,' (m)'])%�����
alti=['Altitude ',niveau,' (m)'];
ylabel(alti);
colorbar;
box on;

figure(27);
surf(d1,z1,ro_mol,'EdgeLighting','phong','LineStyle','none'); 
shading interp
view(0,90);
title('Air density [molecules/m3]');
xlabel(['     Range from Lidar to ',orientation,' (m)'])%�����
alti=['Altitude ',niveau,' (m)'];
ylabel(alti);
colorbar;
box on;
figure(31);
surf(d1,z1,beta_mol,'EdgeLighting','phong','LineStyle','none'); 
shading interp
view(0,90);
title('Backscatter coeff. [sr-1.m-1]');
xlabel(['     Range from Lidar to ',orientation,' (m)'])%�����
alti=['Altitude ',niveau,' (m)'];
ylabel(alti);
colorbar;
box on;
hold on;  

figure(32);
surf(d1,z1,ext_mol,'EdgeLighting','phong','LineStyle','none'); 
shading interp
view(0,90);
title('Extinction coeff. [m-1]');
xlabel(['     Range from Lidar to ',orientation,' (m)'])%�����
alti=['Altitude ',niveau,' (m)'];
ylabel(alti);
colorbar;
box on;
hold on;
end;

%Calcul ext et BS 

Sa2=Sa-8*pi/3;
%Integrale intbetamolok
for k=1:length(fichier)  
for j=1:m+1
    i=m+2:-1:j;
    intbetamol(j,k)=trapz(r1(i,k),beta_mol(i,k));
  end;
end;
  
%Integrale d1ok
for k=1:length(fichier)  
 for j=1:m
    i=m+1:-1:j;
    intd1(j,k)=trapz(r1(i,k),pr2(i,k).*exp(-2*Sa2*intbetamol(i,k)));
 end;
end;

for k=1:length(fichier) 
 for i=1:m
   N01(i,k)= pr2(i,k).*exp(-2*Sa2*intbetamol(i,k));
   D02(i,k)=pr2(m,k)./(betaslope(k));
   betatotal(i,k)=N01(i,k)./(D02(i,k)-2*Sa*intd1(i,k));
   extinctiontotal(i,k)=(betatotal(i,k)-beta_mol(i,k)).*Sa+ext_mol(i,k);
   ext_aer(i,k)=(betatotal(i,k)-beta_mol(i,k)).*Sa;
    
   r1_klett(i,k)=r1(i,k); 
     z1_klett(i,k)=r1(i,k).*cos(ze(k)*pi/180)+gl;
     d1_klett(i,k)=r1(i,k).*sin(ze(k)*pi/180);
  
 end;
ext_fin_klett(k)=ext_aer(m-2,k);
  
end;
 
% figure(100)
 % plot(r1_klett,extinctiontotal,'-or');
   
 
  
%   fid=fopen([chemin3,'ExT_Scan',sscan,'_Sa_',num2str(Sa),'.txt'],'wt');
%    fprintf(fid,'%s %g%s\n','Ext.Coef.[m-1]',Sa,'Sr');
%    %fprintf(fid,'%s %s %s %s\n','Range[m]','Time(HH:MM:SS)',' Ze[deg]','R[m]','Ext.Coef.[m-1]');
% 
%      fprintf(fid,'%s ','Range[m]');
%  
%    for j=1:length(fichier)
%     fprintf(fid,'%02i%s%02i%s%02i ',hh(j),':',mn(j),':',ss(j));
%    end;
%    fprintf(fid,'\n');
%    for i=1:size(extinctiontotal,1)
%    
%    fprintf(fid,'%f %f ',r1(i),extinctiontotal(i,:) );
%    fprintf(fid,'\n');
%    
%    end;
%    fclose(fid);  


if figscan3==1
% figure(33)
%  surf(d1_klett,z1_klett,extinctiontotal,'EdgeLighting','phong','LineStyle','none'); 
%  shading interp
%  view(0,90);
%  title([mode, ' of extinction coefficient [m-1] at ',location,' (',datestr(datenum(aa(1),mm(1),jg(1),hh(1),mn(1),ss(1)),15),...
%     '-',datestr(datenum(aa(1),mm(1),jg(1),hh(length(fichier)),mn(length(fichier)),ss(length(fichier))),15),...
%     ' ',temps,', ',datestr(datenum(aa(1),mm(1),jg(1)),20),') ']);
% xlabel(['     Range from Lidar to ',orientation,' (m)'])%�����
% alti=['Altitude ',niveau,' (m)'];
% ylabel(alti);
% colorbar;
% box on;
% hold on;
% titre1=[num2str(hh(1)),'h',num2str(mn(1)),'-',num2str(hh(length(fichier))),'h',...
%     num2str(mn(length(fichier))),'_',num2str(nbshot(1)),'shots'];

figure(34)
 surf(d1_klett,z1_klett,ext_aer*1000,'EdgeLighting','phong','LineStyle','none'); 
 shading interp
 view(0,90);
 title([mode, ' of aerosol extinction coefficient [m-1] at ',location,' (',datestr(datenum(aa(1),mm(1),jg(1),hh(1),mn(1),ss(1)),15),...
    '-',datestr(datenum(aa(1),mm(1),jg(1),hh(length(fichier)),mn(length(fichier)),ss(length(fichier))),15),...
    ' ',temps,', ',datestr(datenum(aa(1),mm(1),jg(1)),20),') ']);
xlabel(['     Range from Lidar to ',orientation,' (m)'])%�����
alti=['Altitude ',niveau,' (m)'];
ylabel(alti);
colorbar;
box on;
%hold on;
titre1=[num2str(hh(1)),'h',num2str(mn(1)),'-',num2str(hh(length(fichier))),'h',...
    num2str(mn(length(fichier))),'_',num2str(nbshot(1)),'shots'];


 end;





