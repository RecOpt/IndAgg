function [ output_args ] = randiFunc(number)
%UNT?TLED3 Summary of this function goes here
%   Detailed explanation goes here

global films itemsize;
r=rand(1,number) ;
output_args = sum(((films * ones(1,number)) <(   ones(itemsize,1)*r)  ),1)+1;

end

