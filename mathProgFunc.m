
isHungarian=0;
global setting  
global  myMap bestcliq bestcliqno  modelG    itemsize usersize
global ratings_preds
global und_num und_cliq und_user
global und_rat
global objs
sol_num = length(objs)+1;
initial_sol_flag = isempty(objs);
cc = int64(bestcliq);
nums_add_cl = sum(cc~=0,2);
A=sparse(usersize, sum(nums_add_cl));
B=sparse(usersize,und_num);
C=sparse(itemsize,und_num);

C(bsxfun(@plus,und_cliq  ,itemsize*[0:und_num-1]')) = 1; %
B(bsxfun(@plus,und_user  ,usersize*[0:und_num-1])) = 1; %

FF=sparse(0,0);
for i=1:bestcliqno
    birim_mat=eye(usersize); 
    A(1:usersize, sum(nums_add_cl(1:i-1))+1: sum(nums_add_cl(1:i))) = birim_mat(:,cc(i,:)~=0);    
    cc1=num2cell(cc(i,cc(i,:)~=0));
    eee=cell2mat(values(myMap, cc1));
    FilM =sparse(itemsize,nums_add_cl(i));
    FilM(eee+ones(10,1)*(0:(nums_add_cl(i)-1))*itemsize)=1;
    modelG.obj = [modelG.obj full(sum(FilM.*ratings_preds(cc(i,:)~=0,:)'))];
    FF=[FF FilM];
end

modelG.obj = [modelG.obj     und_rat];
modelG.A=[modelG.A , sparse([[A;FF] , [B;C]])  ];
clear A FF B C FiLM eee cc1 tt;
 
global result
modelG.vbasis = [modelG.vbasis  -ones(1,sum(nums_add_cl) + und_num)];

params.OutputFlag = 0;
result = gurobi(modelG,params);

objs(sol_num).original_model=modelG;

modeltopN = modelG;
modeltopN.rhs =  [ones(usersize,1) ; zeros(itemsize,1) ];
resultmodeltopN = gurobi(modeltopN,params);

%%
global selected
if initial_sol_flag
    [ selected, num_needed] = initial_solution_heuristic(modelG, setting.ZZ );   
    if num_needed>0
        [ selected, num_needed, modelG, new ] = solution_heuristic_feasibility( modelG,setting.ZZ, selected);
    else 
              new=0;
  
    end
     objs(sol_num).initialselection=selected;
  objs(sol_num).initialmodel=modelG;
else
    selected = [selected, false(1,length(modelG.obj)-length(selected))]; 
    num_needed = objs(sol_num-1).num_needed;
    if num_needed>0
        
        [selected, num_needed, modelG, new] = solution_heuristic_feasibility(modelG, setting.ZZ, selected);
    else
        new=0;
    end   
end

objs(sol_num).heuristic =  sum(modelG.obj(selected))/usersize/10;


%% hungarian
    if isHungarian
    hung = zeros(usersize);
    clls = modelG.A(usersize+1:end,selected);
    global thres
    for i=1:usersize
        hung(:,i) = sum(ratings_preds(:,clls( :,i)==1),2) ;
        hung(   hung(:,i)      <thres',i)=0.0;
    end
    hung = sparse(hung);  
    [assignments1] = sparseAssignmentProblemAuctionAlgorithm( 	 (hung), [], [], 0);
      
    cll_usr = modelG.A(1:usersize,selected);
    [i,~,~] = find(cll_usr);
    [~,I] = sort(assignments1);
    aa=find(selected);
    del_it = aa(I==i);
    
    
    
    modelG.A = [modelG.A [sparse(1:usersize,assignments1,1)    ;sparse(clls)  ]] ;
    modelG.obj = [ modelG.obj full(hung(sparse(1:usersize,assignments1,1)==1))'] ;
    
    objs(sol_num).asssignment = sum(full(hung(sparse(1:usersize,assignments1,1)==1)) ) /usersize/10;
    selected = [false(1,length(selected)) true(1,usersize)];
    end

%% upgrade

[selected, perf, count ] = sol_upgrade(modelG, selected);
objs(sol_num).upgrade =  sum(modelG.obj(selected))/usersize/10;
objs(sol_num).upgrade_count =  count;

%% log part

objs(sol_num).topN = resultmodeltopN.objval/usersize/10;
objs(sol_num).lp = result.objval/usersize/10;
objs(sol_num).result_mat=result;



objs(sol_num).num_needed = (num_needed);
disp (objs(sol_num) );

% Cleaning Part
zero_rc = sum(result.rc>-0.001);
nonzero_rc=floor(   (length(modelG.obj)-sum(result.rc>-0.001))*.2   );
sortedrc = sort(result.rc,'descend');
thres_rc=sortedrc(nonzero_rc+zero_rc);
thres_rc = -20;
sr_rc = result.rc<thres_rc;
sr_rc(resultmodeltopN.x==1) = 0;
sr_rc(1:itemsize) = 0;


%  sr_rc(selected) = 0;
if isHungarian
    sr_rc(del_it) = 1;
    sr_rc = [sr_rc  ;(false(usersize+new,1)) ];
    modelG.vbasis = [result.vbasis' -ones(1,usersize+new)];
else
    modelG.vbasis = [result.vbasis'  -ones(1,new) ];
    sr_rc = [sr_rc  ;(false(new,1)) ];
end
sr_rc(selected) = 0;

objs(sol_num).deleted_model=modelG;


modelG.A(:,sr_rc) = [];
modelG.vbasis(:,sr_rc)=[];
modelG.obj(:,sr_rc)=[];
selected(sr_rc) = [];

objs(sol_num).last_model=modelG;
objs(sol_num).finalselection=selected;


%