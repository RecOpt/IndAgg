function xoverKids  = crossoverFunc(parents,~,GenomeLength,~,~,thisPopulation)

%CROSSOVER function derived from MATLAB crossover


% How many children to produce?
nKids = length(parents)/2;
% Extract information about linear constraints, if any
%%%   linCon = options.LinearConstr;
%%%    constr = ~isequal(linCon.type,'unconstrained');
% Allocate space for the kids
xoverKids = zeros(nKids,GenomeLength);

% To move through the parents twice as fast as thekids are
% being produced, a separate index for the parents is needed
for i=1:nKids
    parent1 = thisPopulation(parents(2*(i)-1),:);
    parent2 = thisPopulation(parents(2*(i)),:);
    
    dnm=[setdiff(union(parent1,parent2),intersect(parent1,parent2))];
    xoverKids(i,:) = [intersect(parent1,parent2) dnm( randperm(length(dnm),length(dnm)/2))];  
end
end
