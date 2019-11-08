clearvars


global bestcliqno;
bestcliqno = 10;
global isassigned
isassigned = 1; 

global setting
setting.generations = 2000;
setting.ZZ = 1;
setting.opt_start_num = 500;
setting.every_node = 300;
setting.mut_change = 150;
setting.PopulationSize = 400;
setting.cliq_threshold = 16;
cliq_threshold = setting.cliq_threshold;
load multioptions1;


global distancevals
distancevals =[];

global usersize itemsize ratings_preds dist;
load('InputData.mat','dist','ratings_preds');

%%


opt_mult.Generations = setting.generations;
opt_mult.PopulationSize = setting.PopulationSize;

[usersize,itemsize]=size(ratings_preds);
global modelG bests timeElapsed

bests = zeros(1,setting.generations);
timeElapsed = zeros(1,setting.generations);

bigM=-5;
modelG.obj = [ ones(1,itemsize)*bigM ];
modelG.A = sparse([sparse(usersize,itemsize) ;eye(itemsize)] );
modelG.sense = char([ ones([1 usersize])*'='  ones([1 itemsize])*'>'  ])';
modelG.rhs =  [ones(usersize,1) ; setting.ZZ  * ones(itemsize,1) ];
modelG.modelsense = 'max';
modelG.vtype = 'C';
modelG.vbasis = zeros(1,itemsize);

[Y_mf,bests_mf] = sort(ratings_preds,2, 'descend');
fouunn=zeros(itemsize,1);
f_s=0;
for i=1:usersize
    if sum(sum( dist(bests_mf(i,1:10),bests_mf(i,1:10))))<cliq_threshold
        f_s=f_s+1;
        fouunn( bests_mf(i,1:10),f_s)=1;
    end
end

if f_s
    obb=zeros(1,usersize);
    ftft=zeros(itemsize,usersize);
    for  i=1:usersize
        [obb(i), b] = max(ratings_preds(i,:)*fouunn);
        ftft(:,i)=fouunn(:,b);
        
    end
    
    modelG.obj = [  modelG.obj obb ];
    modelG.A = sparse([modelG.A [eye(usersize);ftft]] );
    modelG.sense = char([ ones([1 usersize])*'='  ones([1 itemsize])*'>'  ])';
    modelG.rhs =  [ones(usersize,1) ; setting.ZZ  * ones(itemsize,1) ];
    modelG.modelsense = 'max';
    modelG.vtype = 'C';
    modelG.vbasis =[ modelG.vbasis -ones(1,usersize)];
    
end

global objs



global ratings_alt ratings_norm meanrat thres
meanrat = mean(ratings_preds,2);
stdevrat = std(ratings_preds,0,2);
thres = 10*(meanrat  + stdevrat/sqrt(10))';

ratings_alt = ratings_preds;
ratings_norm = bsxfun(@minus,ratings_preds,mean(ratings_preds,2));

global user_no_und
user_no_und=zeros(usersize,1);
film_number = length(dist)  ; 
global films;         
films= zeros(film_number,1);

global myMap backupmap;

myMap = containers.Map('KeyType','int64','ValueType','any');  
backupmap = containers.Map('KeyType','int64','ValueType','any'); 

global bestrating
global bestcliq

% global alt_bestrating
% global alt_bestcliq

global films_in_cliq;

films_in_cliq=zeros(itemsize,1);

myMap(0) = zeros(10,1);
bestcliq = zeros(bestcliqno,usersize);
bestrating = zeros(bestcliqno,usersize);

global und_cliq und_user und_num und_rat
und_cliq=[];
und_user=[];
und_rat=[];
und_num=0;

global modelOld
ratings_alt = ratings_preds;
xx = gamultiobj(@(x)fitnessFunc(x, dist),10,[],[],[],[],[],[],[], opt_mult);

if (~isempty(objs))
    save(['outputs' ],'objs', 'setting' ,'objs','setting','opt_mult','-v7.3')  
end