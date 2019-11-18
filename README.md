# RecOpt
This repository contains the source code and the dataset information used in the paper titled &quot;Integrating Individual and Aggregate Diversity in Top-N Recommendation&quot; published in INFORMS Journal on Computing.

- &quot;Diversity3.m&quot;: The main script to run the algorithm. The parameters of the algorithm should be set in the preamble of the code.
- &quot;mathProgFunc.m&quot;: The mathematical programming part of the algorithm. In order to run the code Gurobi must be installed in the computer and the Matlab interface should be activated. The Bertsekas&#39; auction algorithm can be activated using the flag variable &quot;isHungarian&quot; in the first line of the code after installing the implementation below.

([https://www.mathworks.com/matlabcentral/fileexchange/48448-fast-linear-assignment-problem-using-auction-algorithm-mex](https://www.mathworks.com/matlabcentral/fileexchange/48448-fast-linear-assignment-problem-using-auction-algorithm-mex))

- &quot;multioptions1.mat&quot;: The option file for the Matlab implementation of genetic algorithm.
- &quot;InputData.mat&quot;: A small sample dataset with 100 items and 50 users, consisting of two matrices, dist (item-item distance matrix) and ratings\_preds (user-item rating predictions). In order to run algorithm on different datasets the InputData.mat file should be updated with appropriate matrices.
