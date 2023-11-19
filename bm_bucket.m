function value = bm_bucket(beme,bm20,bm40,bm60,bm80)
%BM_BUCKET Summary of this function goes here
%   row is a table class 
if isnan(beme)
    value=blanks(1); 
elseif beme<=bm20 && beme>=0
    value='1';
elseif beme<=bm40
    value='2';
elseif beme<=bm60
    value='3';
elseif beme<=bm80
    value='4';
elseif beme>bm80
    value='5';
else
    value=blanks(1);
    
end

