% This is MATLAB Version of Replicating Fama&French 1993 paper 
% Author: Yunting Liu 
% Copyright Protected 

%% First, read from csv into MATLAB tables

% crsp is the monthly dataset for stock returns
% ccm_june is the end of June stock returns dataset
% combined with balance sheet information for the last fiscal year
crsp=readtable('crsp_class.csv');


ccm_june=readtable('ccm_june.csv');

% lme is the l-month lag of market equity for each firm
% We use lag of month equity to calculate value-weighted return 
crsp.wt=crsp.lme;

nyse_index= (ccm_june.exchcd==1)& (ccm_june.beme>0)& (ccm_june.me>0) ...
 & (ccm_june.count>1) & (ccm_june.shrcd==10|ccm_june.shrcd==11);

nyse=ccm_june(nyse_index,1:end);

%%
% Sort the dataset by two variables jdate and permno
[G,jdate]=findgroups(nyse.jdate);
nyse=sortrows(nyse,{'jdate','permno'},{'ascend','ascend'});
nyse_breaks=table(jdate);

prctile_20=@(input)prctile(input,20);
prctile_40=@(input)prctile(input,40);
prctile_60=@(input)prctile(input,60);
prctile_80=@(input)prctile(input,80);

nyse_breaks.sz20=splitapply(prctile_20,nyse.me,G);
nyse_breaks.sz40=splitapply(prctile_40,nyse.me,G);
nyse_breaks.sz60=splitapply(prctile_60,nyse.me,G);
nyse_breaks.sz80=splitapply(prctile_80,nyse.me,G);

nyse_breaks.bm20=splitapply(prctile_20,nyse.beme,G);
nyse_breaks.bm40=splitapply(prctile_40,nyse.beme,G);
nyse_breaks.bm60=splitapply(prctile_60,nyse.beme,G);
nyse_breaks.bm80=splitapply(prctile_80,nyse.beme,G);

ccm1_june=outerjoin(ccm_june,nyse_breaks,'Keys',{'jdate'},'MergeKeys',true,'Type','left');

szport=rowfun(@sz_bucket,ccm1_june(:,{'me','sz20','sz40','sz60','sz80'}),'OutputFormat','cell');
ccm1_june.szport=cell2mat(szport);

bmport=rowfun(@bm_bucket,ccm1_june(:,{'beme','bm20','bm40','bm60','bm80'}),'OutputFormat','cell');
ccm1_june.bmport=cell2mat(bmport);

% Store portofolio assignment as of June 

port_june=ccm1_june(:,{'permno','date','jdate','bmport','szport','beme'});
port_june.ffyear=year(port_june.jdate);

% Merge back with monthly records 
crsp1=crsp(:,{'date','permno','shrcd','exchcd','retadj','me','wt','ffyear','jdate'});

crsp_port=outerjoin(crsp1,port_june(:,{'permno','ffyear','bmport','szport','beme'}),'Keys',{'permno','ffyear'},'MergeKeys',true,'Type','left');

% Keep only records that meet the criteria, drop missing observations
x=char(0); 
crsp_port1= crsp_port((crsp_port.wt>0)& (crsp_port.me>0) & (crsp_port.beme>0) & ~(crsp_port.szport==x)& ~(crsp_port.bmport==x)...
  &~ismissing(crsp_port.szport)&~ismissing(crsp_port.bmport)&(crsp_port.shrcd==10|crsp_port.shrcd==11)   ,1:end);

%% Set up portfolio
[G1,jdate,szport]=findgroups(crsp_port1.jdate,crsp_port1.szport);
vwret_sz=splitapply(@wavg,crsp_port1(:,{'retadj','wt'}),G1);
vwret_table_sz=table(vwret_sz,jdate,szport);
portfolio_sz=unstack(vwret_table_sz,'vwret_sz','szport');
nanRows = any(ismissing(portfolio_sz), 2);
portfolio_sz = portfolio_sz(~nanRows, :);
av_portfolio_sz = mean(portfolio_sz);

[G2,jdate,bmport]=findgroups(crsp_port1.jdate,crsp_port1.bmport);
vwret_bm=splitapply(@wavg,crsp_port1(:,{'retadj','wt'}),G2);
vwret_table_bm=table(vwret_bm,jdate,bmport);
portfolio_bm=unstack(vwret_table_bm,'vwret_bm','bmport');
nanRows = any(ismissing(portfolio_bm), 2);
portfolio_bm = portfolio_bm(~nanRows, :);
av_portfolio_bm = mean(portfolio_bm);






