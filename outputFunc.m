function [state,options,optchanged] = outputFunc(options,state,flag)
%UNT?TLED Summary of this function goes here
%   Detailed explanation goes here

global films_in_cliq itemsize usersize backupmap x
global    myMap bestcliq bestrating
global ratings_preds ratings_alt
global result bestcliqno isassigned num_at_gurobi
global setting bests  accuracy0

% global        alt_bestcliq alt_bestrating  alt_bestcliqno;
global  und_cliq

state.Score = updatefitness(state.Population , state.Score);
optchanged =0;


if mod(state.Generation,100) ==1
    state.Generation
end
if state.Generation >0  
    bests(1,state.Generation ) = sum(bestrating(1,:));
else
    accuracy0{(setting.cliq_threshold-10)/2} = sum(bestrating(1,:));
end

opt_start_num = setting.opt_start_num ;
every_node = setting.every_node;

remove(myMap,num2cell(setdiff(cell2mat(keys(myMap)),unique(bestcliq(:)))));


x=cell2mat(values(myMap, num2cell(int64(bestcliq))));


if state.Generation<opt_start_num
    [count,id]=hist([x(:) ; und_cliq(:)],unique([x(:) ;und_cliq(:)]));
    films_in_cliq=zeros(itemsize,1);
    if id(1)==0
        id(1)=[];
        count(1)=[];
    end
    films_in_cliq(id)=count;

else
    if (state.Generation==opt_start_num)|| ((state.Generation>(opt_start_num+10))&&(mod(state.Generation,every_node)==mod(opt_start_num,every_node)))
           
        mathProgFunc;

        backupmap = containers.Map('KeyType','int64','ValueType','any');  
        global user_no_und und_user und_num und_rat modelG
        und_cliq=[];
        und_user=[];
        und_rat=[];
        und_num=0;
        
        num_at_gurobi =full(sum((modelG.A(:,itemsize+1:end)),2));
        
        user_no_und = num_at_gurobi(1:usersize);
        x={};
        
        ratings_alt =  bsxfun(@minus,ratings_preds ,(result.pi(usersize+1:end))').*isassigned;
        bestrating = ones(bestcliqno,1)*result.pi(1:usersize)';
        bestcliq=zeros(bestcliqno,usersize);
        myMap(0) = zeros(10,1);
        
        
        
        calculaterand(5*(result.pi(usersize+1:end)+5.1))  ;
        
         
           options.MutationFcn = @mutationFunc;
           optchanged =1;
         
    end
  
    films_in_cliq = num_at_gurobi(usersize+1:end);
    
    if   ~isempty(x)
        
        [count,id]=hist([x(:) ; und_cliq(:)],unique([x(:) ;und_cliq(:)]));
        
        if length(count)>1.5
            if(id(1)==0)
                id(1)=[];
                count(1)=[];
            end
            films_in_cliq(id) = films_in_cliq(id) + count';
        end
        
    end
    
    
    
end
if state.Generation < opt_start_num
    ffl = state.Generation >(setting.mut_change-1);
else
    ffl =  (mod(state.Generation -opt_start_num,setting.every_node)>(setting.mut_change-1))  ;
end

       if ffl&&( mod(state.Generation,25)==1 )
            calculaterand(films_in_cliq )  ;
           options.MutationFcn = @mutationafter250;
           optchanged =1;
             c=fix(clock);      

       end
end


