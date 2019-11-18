# RecOpt
This repository contains the source code and the dataset information used in the paper titled &quot;Integrating Individual and Aggregate Diversity in Top-N Recommendation&quot; published in INFORMS Journal on Computing.

- &quot;Diversity3.m&quot;: The main script to run the algorithm. The parameters of the algorithm should be set in the preamble of the code.
- &quot;mathProgFunc.m&quot;: The mathematical programming part of the algorithm. In order to run the code Gurobi must be installed in the computer and the Matlab interface should be activated. The Bertsekas&#39; auction algorithm can be activated using the flag variable &quot;isHungarian&quot; in the first line of the code after installing the implementation below.

([https://www.mathworks.com/matlabcentral/fileexchange/48448-fast-linear-assignment-problem-using-auction-algorithm-mex](https://www.mathworks.com/matlabcentral/fileexchange/48448-fast-linear-assignment-problem-using-auction-algorithm-mex))

- &quot;multioptions1.mat&quot;: The option file for the Matlab implementation of genetic algorithm.
- &quot;InputData.mat&quot;: A small sample dataset with 100 items and 50 users, consisting of two matrices, dist (item-item distance matrix) and ratings\_preds (user-item rating predictions). In order to run algorithm on different datasets the InputData.mat file should be updated with appropriate matrices.
- &quot;outputs.mat&quot;: Sample output file for the input dataset

The auxiliary functions for genetic algorithm implemantation are as follows:
- &quot;createFunc.m&quot;: population initilization function
- &quot;fitnessFunc.m&quot;: Fitness function that returns three different fitness values explained ias in the paper for each individual
- &quot;crossoverFunc.m&quot;:Crossover function for the cliques
- &quot;mutationFunc.m&quot;: Mutation function used in the first 250 generations
- &quot;mutationafter250.m&quot;: Mutation function used after the first 250 generations
- &quot;randiFunc.m&quot;: Random number generator used to emphasize rare items 
- &quot;calculaterand.m&quot;: Function used by &quot;randiFunc.m&quot;
- &quot;outputFunc.m&quot;: Function used to calculate key metrics at each generation of genetic algorithm
- &quot;updatefitness.m&quot;: Re-calculate fitness value of clique at each generation


The functions used to find solutions for the second part of the algorithm are as follows:
- &quot;mathProgFunc.m&quot;: Script to create solutions at each run of of the second part algorithm
- &quot;initial_solution_heuristic.m&quot;: Initial solution generator.
- &quot;solution_heuristic_feasibility.m&quot;: Check feasibility of solution and make it feasible if not so.
- &quot;sol_upgrade.m&quot;: Increase optimality of solution. 




