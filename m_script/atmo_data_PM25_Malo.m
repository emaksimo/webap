%%%% create ATMO PM2.5 [micro gr par m3], record at CapLaGr
%%%% Hour in GMT

clear all
close all

[num,txt] = xlsread('/media/elena/Transcend/Leosphere/ATMO/Malo_July2013_hourly_PM25.xls'); 
[token,resid] = strtok(txt(:,1), '-');
yyyy = str2num(cell2mat(token));
[md,rd] = strtok(resid(:),'-');
mm = abs(str2num(cell2mat(md)));
dd = abs(str2num(cell2mat(strtok(rd))));
july2013 = [yyyy,mm,dd,num];

clear num txt yyyy token resid md rd dd mm
[num,txt] = xlsread('/media/elena/Transcend/Leosphere/ATMO/Malo_Aug2013_hourly_PM25.xls'); 
[token,resid] = strtok(txt(:,1), '-');
yyyy = str2num(cell2mat(token));
[md,rd] = strtok(resid(:),'-');
mm = abs(str2num(cell2mat(md)));
dd = abs(str2num(cell2mat(strtok(rd))));
aug2013 = [yyyy,mm,dd,num];

clear num txt yyyy token resid md rd dd mm
[num,txt] = xlsread('/media/elena/Transcend/Leosphere/ATMO/Malo_Sept2013_hourly_PM25.xls'); 
[token,resid] = strtok(txt(:,1), '-');
yyyy = str2num(cell2mat(token));
[md,rd] = strtok(resid(:),'-');
mm = abs(str2num(cell2mat(md)));
dd = abs(str2num(cell2mat(strtok(rd))));
sept2013 = [yyyy,mm,dd,num];

clear num txt yyyy token resid md rd dd mm
[num,txt] = xlsread('/media/elena/Transcend/Leosphere/ATMO/Malo_Oct2013_hourly_PM25.xls'); 
[token,resid] = strtok(txt(:,1), '-');
yyyy = str2num(cell2mat(token));
[md,rd] = strtok(resid(:),'-');
mm = abs(str2num(cell2mat(md)));
dd = abs(str2num(cell2mat(strtok(rd))));
oct2013 = [yyyy,mm,dd,num];

clear num txt yyyy token resid md rd dd mm
[num,txt] = xlsread('/media/elena/Transcend/Leosphere/ATMO/Malo_Nov2013_hourly_PM25.xls'); 
[token,resid] = strtok(txt(:,1), '-');
yyyy = str2num(cell2mat(token));
[md,rd] = strtok(resid(:),'-');
mm = abs(str2num(cell2mat(md)));
dd = abs(str2num(cell2mat(strtok(rd))));
nov2013 = [yyyy,mm,dd,num];

clear num txt yyyy token resid md rd dd mm
[num,txt] = xlsread('/media/elena/Transcend/Leosphere/ATMO/Malo_Dec2013_hourly_PM25.xls'); 
[token,resid] = strtok(txt(:,1), '-');
yyyy = str2num(cell2mat(token));
[md,rd] = strtok(resid(:),'-');
mm = abs(str2num(cell2mat(md)));
dd = abs(str2num(cell2mat(strtok(rd))));
dec2013 = [yyyy,mm,dd,num];

clear num txt yyyy token resid md rd dd mm
[num,txt] = xlsread('/media/elena/Transcend/Leosphere/ATMO/Malo_Jan2014_hourly_PM25.xls'); 
[token,resid] = strtok(txt(:,1), '-');
yyyy = str2num(cell2mat(token));
[md,rd] = strtok(resid(:),'-');
mm = abs(str2num(cell2mat(md)));
dd = abs(str2num(cell2mat(strtok(rd))));
jan2014 = [yyyy,mm,dd,num];

clear num txt yyyy token resid md rd dd mm
[num,txt] = xlsread('/media/elena/Transcend/Leosphere/ATMO/Malo_Feb2014_hourly_PM25.xls'); 
[token,resid] = strtok(txt(:,1), '-');
yyyy = str2num(cell2mat(token));
[md,rd] = strtok(resid(:),'-');
mm = abs(str2num(cell2mat(md)));
dd = abs(str2num(cell2mat(strtok(rd))));
feb2014 = [yyyy,mm,dd,num];

clear num txt yyyy token resid md rd dd mm
[num,txt] = xlsread('/media/elena/Transcend/Leosphere/ATMO/Malo_Mar2014_hourly_PM25.xls'); 
[token,resid] = strtok(txt(:,1), '-');
yyyy = str2num(cell2mat(token));
[md,rd] = strtok(resid(:),'-');
mm = abs(str2num(cell2mat(md)));
dd = abs(str2num(cell2mat(strtok(rd))));
mar2014 = [yyyy,mm,dd,num];

clear num txt yyyy token resid md rd dd mm
[num,txt] = xlsread('/media/elena/Transcend/Leosphere/ATMO/Malo_Apr2014_hourly_PM25.xls'); 
[token,resid] = strtok(txt(:,1), '-');
yyyy = str2num(cell2mat(token));
[md,rd] = strtok(resid(:),'-');
mm = abs(str2num(cell2mat(md)));
dd = abs(str2num(cell2mat(strtok(rd))));
apr2014 = [yyyy,mm,dd,num];

clear num txt yyyy token resid md rd dd mm
[num,txt] = xlsread('/media/elena/Transcend/Leosphere/ATMO/Malo_May2014_hourly_PM25.xls'); 
[token,resid] = strtok(txt(:,1), '-');
yyyy = str2num(cell2mat(token));
[md,rd] = strtok(resid(:),'-');
mm = abs(str2num(cell2mat(md)));
dd = abs(str2num(cell2mat(strtok(rd))));
may2014 = [yyyy,mm,dd,num];

clear num txt yyyy token resid md rd dd mm
[num,txt] = xlsread('/media/elena/Transcend/Leosphere/ATMO/Malo_June2014_hourly_PM25.xls'); 
[token,resid] = strtok(txt(:,1), '-');
yyyy = str2num(cell2mat(token));
[md,rd] = strtok(resid(:),'-');
mm = abs(str2num(cell2mat(md)));
dd = abs(str2num(cell2mat(strtok(rd))));
june2014 = [yyyy,mm,dd,num];

clear num txt yyyy token resid md rd dd mm
[num,txt] = xlsread('/media/elena/Transcend/Leosphere/ATMO/Malo_July2014_hourly_PM25.xls'); 
[token,resid] = strtok(txt(:,1), '-');
yyyy = str2num(cell2mat(token));
[md,rd] = strtok(resid(:),'-');
mm = abs(str2num(cell2mat(md)));
dd = abs(str2num(cell2mat(strtok(rd))));
july2014 = [yyyy,mm,dd,num];

clear num txt yyyy token resid md rd dd mm
atmo_dat = [july2013 ; aug2013 ; sept2013 ; oct2013 ; nov2013; dec2013; jan2014; feb2014; mar2014; apr2014; may2014; june2014; july2014];

script = {'atmo_data_PM25_Malo.m'};
data_descr = {['ATMO PM2.5 [micro gr par m3] hourly record at Malo'];['Hour in GMT']};
save('/media/elena/Transcend/Elena_ULCO/my_matlab_data/Malo_atmo_hourly_PM25.mat','script','atmo_dat','data_descr');



