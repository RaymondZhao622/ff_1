function value = sz_bucket(sz,sz20,sz40,sz60,sz80)
%SZ_BUCKET Summary of this function goes here
%   row is a table class

if isnan(sz)
    value=blanks(1);
elseif sz<=sz20
    value='1';
elseif sz<=sz40
    value='2';
elseif sz<=sz60
    value='3';
elseif sz<=sz80
    value='4';
elseif sz>sz80
    value='5';
else
    value=blanks(1);
end

