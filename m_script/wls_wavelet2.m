%Programme transfome en ondelette pour dterminer le range min a partir
%duquel on peut appliquer la regression lineaire pour determiner la F(R)

if dem_w==1
figure(100)
 plot(r_0(:,g),lnpr2_0(:,g),'-ok')
 xlabel('Range (m)');
 ylabel(['log(Pr2)']);
  title(['log(Pr2) (a.u.) at ',location,' (',datestr(datenum(aa(g),mm(g),jj(g),hh(g),mn(g),ss(g)),15),...
     ' ',temps,', ',datestr(datenum(aa(g),mm(g),jj(g)),20),', az=',num2str(az(g)),'�)']);
end

 for a=adep:2:afin;   
    for b=bdep:bfin;
      if (b>a/2) & (b+a/2<=nk)
            c1=round(b-a/2);
            c2=round(b+a/2);    
      %Sort du panache
        %   wcf(b,a)=(sum(lnpr2_0(c1:b,g))-sum(lnpr2_0(b:c2,g)))./a;%+1 -1
      %Entre dans le panache      
       wcf(b,a)=(sum(lnpr2_0(b:c2,g))-sum(lnpr2_0(c1:b,g)))./a;%-1 +1
       %wcf(b,a)=(sum(log(pr2(b:c2,g)))-sum(log(pr2(c1:b,g))))./a;%-1 +1
      end;
   end;
      wcf(:,a+1)=wcf(:,a);
      for j=1:size(wcf,1)
        if isnan(wcf(j,a))
        wcf(j,a)=0;
      end;  
    end;
       
  wcf2(:,a)=wcf(:,a).*wcf(:,a);
  wcf2(:,a+1)=wcf(:,a+1).*wcf(:,a+1);
      
  D2=sum(wcf2);
            
   zwcf(:,a)=(r1(1:nk-1,g).*cos(az(g)*pi/180))+gl;
   zwcf(:,a+1)=r1(1:nk-1,g).*cos(az(g)*pi/180)+gl;
   awcf(:,a)=a;
   awcf(:,a+1)=a;
   rwcf(:,a)=r1(1:nk-1,g);
   rwcf(:,a+1)=r1(1:nk-1,g);
 
 end;
 
 for a=adep:2:afin;
     D2(a+1)=D2(a);
 end;
  
 if dem_w==1 
 traceD2=1;
  if traceD2==1
      
   figure(101)
   plot(awcf,D2,'-k');
   xlabel('Dilation Coefficient');
   ylabel(['Variance [a.u]']);
   box on;
   title(['Wavelet variance at ',location,' (',datestr(datenum(aa(g),mm(g),jj(g),hh(g),mn(g),ss(g)),15),...
     ' ',temps,', ',datestr(datenum(aa(g),mm(g),jj(g)),20),', az=',num2str(az(g)),'�)']);
  
   
  end;
 end;
  
   [amax1,Iamax1]=(max(D2));
   wcf(wcf==0)=NaN;
   wcf2(wcf2==0)=NaN;
%Iamax1
 awcf(:,1)=NaN;
 
if dem_w==1
trace102=1;
if trace102==1
figure(102);
  
   surf(awcf,rwcf,wcf,'EdgeLighting','phong','LineStyle','none'); 
 title(['Wavelet Covariance Transform at ',location,' (',datestr(datenum(aa(g),mm(g),jj(g),hh(g),mn(g),ss(g)),15),...
     ' ',temps,', ',datestr(datenum(aa(g),mm(g),jj(g)),20),', az=',num2str(az(g)),'�) ']);
 shading interp;
 box on;
    view(0,90);
    xlabel('Dilation Coefficient');
    ylabel(['Range from lidar (m)']);
%    %title(' WCT');
%ylim([gl zm])
%xlim([0 afin])
 colorbar;


 end; 
end;

[p1,In1]=max(wcf(:,Iamax1));


%'Coef. dilatation :'
%Iamax1

%'Pic wcf [m]:'
%In1.*res;

%Recherche des valeurs de wcf neg (pour d�terminer la fin de l'augmentation de lnpr2)
wcf_zero=(wcf(:,Iamax1)<=0);
[p2,In2]=max(wcf_zero);

%'Range d�part [m]:'
%r0(In2)
rs1(g)=r0(In2);


 %'Filtre 1 WCF pic'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%[pabis,Inabis]=(findpeaks(wcf(:,Iamax1)))

%'size WCF'
%f1=size(pabis,2)

%[pbbis,Inbbis]=(findpeaks(-D2))
%'size D2'
%f2=size(pbbis,2)

%[p1bis,In1bis]=(findpeaks(wcf(:,Iamax1),'minpeakdistance',4,'minpeakheight',mph));

%%%%% FILTRE seuil de Iamax1 PAR COEF DILATATION MIN
if Iamax1<=a_lim
    rs1(g)=NaN;
end;

if Iamax1>=a_lim2
    rs1(g)=NaN;
end;

%%%%% 'Filtre D2'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fD2=awcf(D2==0);
if size(fD2,2)>=2 & fD2(2)<afin./2
    rs1(g)=NaN;
end;
% if f1>=2
%     rs1(g)=NaN;
% end;

a1(g)=Iamax1;

if dem_w==1
figure(103)
   plot(rwcf(:,Iamax1),wcf(:,Iamax1),'o-k');
 xlabel('Range (m)');
    ylabel(['WCF (a.u.)']);
  title(['Wavelet Covariance Transform (a.u.) at ',location,' (',datestr(datenum(aa(g),mm(g),jj(g),hh(g),mn(g),ss(g)),15),...
     ' ',temps,', ',datestr(datenum(aa(g),mm(g),jj(g)),20),', az=',num2str(az(g)),'�)']);
 
 
end;
 
 %'CLEAR A ACTIVER'
 clear wcf rwcf awcf Iamax1 p1 In1 p2 In2 wcf_zero D2 zwcf amax1 f1 pabis Inabis fD2
 
 
 
