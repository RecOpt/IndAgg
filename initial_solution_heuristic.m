function [ selected, num_needed ] = initial_solution_heuristic( opt_model, zVal, multiplier )
global   usersize itemsize

if nargin==2
    multiplier = zVal + 2;
end

A=opt_model.A(:,itemsize+1:end);
objs = opt_model.obj(itemsize+1:end);
selected = false(1,length(A));
sums=full(sum(A,2));

num_needed = [100*ones(usersize,1);   zVal * ones(itemsize,1)];
for i=1: (usersize)
    [~,itemno]=max(objs+multiplier* (num_needed + num_needed./sums)'*A       ) ;
    selected(itemno)=1;
    num_needed = max(num_needed - [100*A(1:usersize,itemno); A(1+usersize:end,itemno) ],0);
end
num_needed=sum(max(zVal-sum(A(usersize+1:end,selected),2),0));

selected = [ false(1,itemsize), selected] ;
end