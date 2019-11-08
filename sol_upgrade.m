function [selected, perf, count] = sol_upgrade(modelG_up, selected)
global itemsize usersize setting

params.OutputFlag = 0;
modeltopN = modelG_up;
modeltopN.vbasis = zeros(1,length(modeltopN.obj));
modeltopN.rhs =  [ones(usersize,1) ; zeros(itemsize,1) ];
resultmodeltopN = gurobi(modeltopN,params);
topn = (resultmodeltopN.x==1);
topn_loc = find(topn);

birToItemsize = (1:itemsize);

topn_id = (1:usersize)*modelG_up.A(1:usersize,topn);
topn_obj = modelG_up.obj(topn);
topn_obj(topn_id) = topn_obj;


not_rem=false(1,usersize);

count = 1;
flag = true;
while flag
    luk9=false(1,usersize);
    luk10=false(1,usersize);
    perf(count)= sum(modelG_up.obj(selected))/usersize;
    
    
    
    extra_items = [false(usersize,1); (sum(modelG_up.A(usersize+1:end,selected),2)>setting.ZZ )] ;  % can be replaced
    
    selected_A=modelG_up.A(:,selected);
    
    
    islenemeyecek = sum(selected_A(extra_items,:))<9;% shoul be kept
    cliq9 = (sum(selected_A( extra_items,:))==9);% 9-cliq
    cliq10 = (sum(selected_A( extra_items,:))==10);% 10-cliq
    
    
    
    
    select_loc = find(selected);
    
    select_id = (1:usersize)*modelG_up.A(1:usersize,selected) ;
    select_obj = modelG_up.obj(selected);
    select_obj(select_id) = select_obj;
    dd=topn_obj./select_obj;
    
    dd(select_id(islenemeyecek))=0;
    dd(not_rem)=0;
    luk9(select_id(cliq9)) = true;
    luk10(select_id(cliq10)) = true;
    
    [m,id] = max(dd);
    
    if m==1
        flag=false;
        
    else
        if luk10(id)
            
            if selected(select_loc(select_id==id))
                selected(select_loc(select_id==id))=false;
                if      selected(topn_loc(topn_id==id))
                    error('ERR');
                else
                    
                    selected(topn_loc(topn_id==id))=true;
                end
                
                selected(topn_loc(topn_id==id))=true;
                if sum(selected)~=usersize
                    error('ERR');
                end
            else
                error('ERR');
            end
            
            if sum(selected)>usersize
                error('ERR');
            end
            count = count +1;
        else
            if luk9(id)
                select_film_id =  birToItemsize(~extra_items(usersize+1:end))*selected_A([false(usersize,1) ; ~extra_items(usersize+1:end)],(select_id==id)) ;
                add_place=find(modelG_up.A(select_film_id+usersize,:).*~selected);
                add_price =    modelG_up.obj(add_place); % o filmi i?eren cliqler
                
                
                remm_user = (1:usersize)*modelG_up.A(1:usersize,add_place) ; % o filmi i?eren cliqlerin userlar?
                rem_price=select_obj(1,remm_user(2:end)) ;  % ve o userlarin su anki degerleri
                
                
                
                net_kar = topn_obj(id)+add_price(2:end)-select_obj(id)-rem_price-100 * (1-luk10(remm_user(2:end)));
                [nn, nn_id] = max(net_kar);
                if (nn>0) && (~(find( modelG_up.A(1:usersize,add_place(nn_id+1)))==id))    % burada sorun var
                    if selected(select_loc(select_id==id))
                        tmmpp = 0;
                        selected(select_loc(select_id==id))=false;
                        tmmpp = tmmpp - modelG_up.obj(    (select_loc(select_id==id)));
                        selected(topn_loc(topn_id==id))=true;
                        tmmpp = tmmpp + modelG_up.obj( (topn_loc(topn_id==id)));
                        
                        
                        if     selected(add_place(nn_id+1))
                            error('ERR5');
                        else
                            
                            selected(add_place(nn_id+1))=true;
                            tmmpp = tmmpp + modelG_up.obj(   (add_place(nn_id+1)));
                            if  selected(select_loc(select_id==find( modelG_up.A(1:usersize,add_place(nn_id+1)))))
                                selected(select_loc(select_id==find( modelG_up.A(1:usersize,add_place(nn_id+1)))))=false;
                            else
                                error('ERR4')
                            end
                            tmmpp = tmmpp - modelG_up.obj(  (select_loc(select_id==find( modelG_up.A(1:usersize,add_place(nn_id+1)))))) ;
                            count = count+1 ;
                        end
                        if sum(selected)~=usersize
                            error('ERR3')
                        end
                        
                    else
                        error('ERR2');
                    end
                    
                else
                    not_rem(id)=true;
                end
                
                
            else
                error('ERR1')
            end
            
            
            
            
        end
        
        
        
        
        
    end
    
    
end

end


% end

