function [  ] = calculaterand(films_in_cliq)
%UNTÝTLED2 Summary of this function goes here
%   Detailed explanation goes here

global films
films= cumsum(1./max(films_in_cliq,0.5))/sum(1./max(films_in_cliq,0.5));
end

