function [score] = updatefitness(population,score)
global ratings_alt
global bestrating
global bestcliqno

global films_in_cliq usersize

for i=1:length(population)
    score(i,2) = usersize - sum(sum(ratings_alt(:,(population(i,:))),2) >.99*  (bestrating(bestcliqno,:))');
    score(i,1) =  sum(films_in_cliq(population(i,:)));   
end