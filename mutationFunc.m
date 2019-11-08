function mutationChildren = mutationFunc(parents,options,GenomeLength,FitnessFcn,state,thisScore,thisPopulation,mutationRate)
%MUTATION  function derived from MATLAB MUTATION
global itemsize ;
if nargin < 8 || isempty(mutationRate)
    mutationRate = 0.1; % default mutation rate
end

mutationChildren = zeros(length(parents),GenomeLength);
for i=1:length(parents)
    child = thisPopulation(parents(i),:);
    mutationPoints = find(rand(1,length(child)) < mutationRate);
    
    if length(mutationPoints)>0
        
        child(mutationPoints) = randi(itemsize,1,length(mutationPoints));
        if length(unique(child))~=10
            child =  thisPopulation(parents(i),:);
            
        end
        
        
        
        
    end
    mutationChildren(i,:) = child;
end
end

