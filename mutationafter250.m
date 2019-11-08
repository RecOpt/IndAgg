function mutationChildren = mutationafter250(parents,options,GenomeLength,FitnessFcn,state,thisScore,thisPopulation,mutationRate)
%MUTATIONUNIFORM  function derived from MATLAB mutation.
global films_in_cliq;

if nargin < 8 || isempty(mutationRate)
    mutationRate = 0.2; % default mutation rate
end

mutationChildren = zeros(length(parents),GenomeLength);
for i=1:length(parents)
    child = thisPopulation(parents(i),:);
    mutationPoints = find( ( rand(1,length(child))-(films_in_cliq(child)./1000)') < mutationRate);
    
    if length(mutationPoints)>0
        
        child(mutationPoints) = randiFunc(length(mutationPoints));
        if length(unique(child))~=10
            child =  thisPopulation(parents(i),:);          
        end       
    end
    mutationChildren(i,:) = child;
end
end

