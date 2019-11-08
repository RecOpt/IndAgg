function  Population = createFunc(GenomeLength, FitnessFcn, options)
%UNT?TLED6 Summary of this function goes here

global itemsize;
global ratings_preds

clear bestrating
clear bestcliq
global bestrating
global bestcliq

totalPopulation = sum(options.PopulationSize);
Population = zeros(totalPopulation ,GenomeLength);

for  i=1:totalPopulation
    Population(i,:) = randperm(itemsize,10);
end


end

