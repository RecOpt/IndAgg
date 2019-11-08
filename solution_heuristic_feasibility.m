function [selected, num_needed, opt_model, new] = solution_heuristic_feasibility(opt_model, zVal, selected )
%UNT?TLED3 Summary of this function goes here
%   Detailed explanation goes here
global   usersize itemsize
global ratings_preds

A=opt_model.A(:,itemsize+1:end);
objs = opt_model.obj(itemsize+1:end);
selected(1:itemsize) = [];

new=0;
global thres
meanrat = sum(ratings_preds); % total rating of item i over all users.

tt =[ false(usersize,1);  (max(zVal-sum(A(usersize+1:end,selected),2),0)) ]>0; % the items that has been recommended less than Z
nums = (sum(A(usersize+1:end,selected),2)-zVal)>0; % items that has been recommended more than Z

removable = selected &(sum(A([false(usersize,1); nums],:))==10 ); % find the cliqs than has been selected, consists of items in nums
[~,ia_rem] = unique(cumsum(removable));
ia_rem(1)=[];
[row_rem,~] =find(A(1:usersize,ia_rem)); %removable rows.

addable = sum(   A(tt,:)  ,1  )>0;
[~,ia_add] = unique(cumsum(addable));
ia_add(1)=[];

c=fix(clock);

disp([num2str(c(4)) ':' num2str(c(5)) ':' num2str(c(6)) ' multiplier:' num2str(3) ' numneeded: ' num2str(    sum(    (sum(A(usersize+1:end,selected),2)-zVal)   <0)   )]);


num_needed=sum(max(zVal-sum(A(usersize+1:end,selected),2),0));
ff=1000;
while sum(    (sum(A(usersize+1:end,selected),2)-zVal)   <0)&&(new<(2*num_needed+10))&&ff %if there  are items that does not satisfy Z value
    [~,ind_ins] = max(meanrat*A(1+usersize:end,addable)    );
    ind_ins = ia_add(ind_ins);                                  % Find the column c_add with the highest average rating over all addable columns (addable column: the columns which has items that has recommendadion less than Z)
    cols = (A(usersize+1:end,ind_ins)>0)';    % cols: The items in c_add
    [nn,ind_rem] = max(sum(ratings_preds(row_rem,cols),2)'-thres(row_rem)); % find the user u* that has the highest rating for candidate item
    ind_rem = ia_rem(ind_rem);
    if nn>0 % if such user exists
        selected(ind_rem)=0;  %remove the cliq assigned to that user
        A = [A, [A(1:usersize,ind_rem) ;A(1+usersize:end,ind_ins) ]];  %create a new cliq with items from c_add and assign to user u*
        selected = [selected , 1]==1;
        objs = [objs sum(ratings_preds( A(1:usersize,ind_rem)==1, A(1+usersize:end,ind_ins)==1  ) ) ];
        tt =[false(usersize,1);  (max(zVal-sum(A(usersize+1:end,selected),2),0))]>0; % the items that has been recommended less than Z
        nums = (sum(A(usersize+1:end,selected),2)-zVal)>0; % items that has been recommended more than Z
        removable = selected &(sum(A([false(usersize,1); nums],:))==10 ); % find the cliqs than has been selected, consists of items in nums
        [~,ia_rem] = unique(cumsum(removable));
        ia_rem(1)=[];
        [row_rem,~] =find(A(1:usersize,ia_rem));
        addable = sum(   A(tt,:)  ,1  )>0;
        [~,ia_add] = unique(cumsum(addable));
        ia_add(1)=[];
        new = (new+1);
        ff=1000;
    else % if no suitable user for the  cliq c_add exists remove c_add cliq from candidate list
        addable(ind_ins)=0;
        [~,ia_add] = unique(cumsum(addable));
        ia_add(1)=[];
        ff=ff-1;
        
    end
    
end

num_needed=sum(max(zVal-sum(A(usersize+1:end,selected),2),0));
opt_model.A=[opt_model.A(:,1:itemsize) A ];
opt_model.obj=[opt_model.obj( 1:itemsize)    objs ];

selected = [ false(1,itemsize), selected] ;


end


