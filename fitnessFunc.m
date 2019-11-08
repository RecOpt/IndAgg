function [ output_args ] = fitnessFunc( gene, distance )
%UNTTLED4 Summary of this function goes here
%   Detailed explanation goes here
global  ratings_norm thres
global ratings_alt usersize ratings_preds
global setting

cliq_threshold = setting.cliq_threshold;

global films_in_cliq;

global myMap backupmap;
global bestcliqno;
global bestrating gene_
global bestcliq
gene_=gene;

global und_cliq und_user und_num und_rat
global user_no_und

output_args(:,1) = max(    (sum(sum(distance(gene,gene))) )-cliq_threshold ,0    );
output_args(:,2) = usersize - sum((sum(ratings_alt(:,(gene_)),2)./(bestrating(bestcliqno,:))')>.50);
output_args(:,3) =  sum(films_in_cliq(gene));

if ((output_args(:,1) < 0.01)     )
    aa = int64([1 10 100 1000 10000 100000 1000000 10000000 100000000 1000000000]*sort(gene)');
    
    if ~isKey(myMap,aa)
        
        rats =   sum(ratings_alt(:,(gene)),2)';
        rats_org =   sum(ratings_preds(:,(gene)),2)';
        
        success = (  ( rats  >bestrating(bestcliqno,:)) );%&   (rats_org  >thres )   );
        if sum(success)>0
            elig_8=find(success);
            for   tt=elig_8
                loc = sum(bestrating(:,tt)>rats(tt));
                bestrating(:,tt) = [bestrating(1:loc,tt); sum(ratings_alt(tt,(gene)),2)'; bestrating(loc+1:end-1,tt)    ];
                bestcliq(:,tt) = [bestcliq(1:loc,tt); aa; bestcliq(loc+1:end-1,tt)    ];
                
                
            end
            
            myMap(aa) = gene';
            
            
        elseif  (~isKey(backupmap,aa)& (prod(max(films_in_cliq(gene)-9,0))==0 )&   sum(rats_org  >thres ))
            
            und_num=und_num+1;
            und_cliq(und_num,:)=gene;
            
            [~, und_user(und_num)]=max(sum(ratings_norm(:,(gene)),2)- user_no_und-(rats_org  <thres )'*10000);
            user_no_und(und_user(und_num))=user_no_und(und_user(und_num))+1;
            films_in_cliq(gene)=films_in_cliq(gene)+1;
            und_rat(und_num)=sum(ratings_preds(und_user(und_num),(gene)),2) ;
            
            backupmap(aa) = gene';
            
            
            
            
            
        end
    end
end


