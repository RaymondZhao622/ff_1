% This is MATLAB Version of Replicating Fama&French 1993 paper 
% Author: Yunting Liu 
% Copyright Protected 

% First, read from csv into MATLAB tables

% crsp is the monthly dataset for stock returns
% ccm_june is the end of June stock returns dataset
% combined with balance sheet information for the last fiscal year
crsp=readtable('crsp_class.csv');


ccm_june=readtable('ccm_june.csv');

% lme is the l-month lag of market equity for each firm
% We use lag of month equity to calculate value-weighted return 
crsp.wt=crsp.lme;