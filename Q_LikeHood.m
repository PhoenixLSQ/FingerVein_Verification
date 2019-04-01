% 计算似然函数，根据似然比确定结果为类内还是类间
% 输入计算的类内Within与类间Between的结果
clear

load '0220_Within_per3_NewTest_LSQ删减.mat'
load '0220_Between_per3_NewTest_LSQ删减.mat'


wi = cell2mat(withinClassImgNameScoreFvrDataBaseV1sort(:,6));
bt = cell2mat(betweenClassImgNameScoreFvrDataBaseV1sort(:,7));

x = 0:0.01:1;                                        % 相似度数组 0-1
[num_in,sim_in] = hist(wi,x);
pr_in = num_in./length(wi);                          % 类内概率

% 找到相似度对应概率为0的位置，左右取概率均值
zero_point_in = find(pr_in == 0);
for n = 2:length(zero_point_in)-1
    z = zero_point_in(n);
    if pr_in(z-1) ~= 0 && pr_in(z+1) ~= 0
        pr_in(z) = pr_in(z-1) + pr_in(z+1);
    end
end
[num_bt,sim_bt] = hist(bt,x);
pr_bt = num_bt./length(bt);                          % 类间概率

% 找到相似度对应概率为0的位置，左右取概率均值
zero_point_bt = find(pr_in == 0);
for m = 2:length(zero_point_bt)-1
    z = zero_point_bt(m);
    if pr_bt(z-1) ~= 0 && pr_bt(z+1) ~= 0
        pr_bt(z) = pr_bt(z-1) + pr_bt(z+1);
    end
end
ProbTable = [x;pr_in;pr_bt];

k = 0;
FAR_FRR_Thresh = zeros(1,3);

% 遍历似然阈值 lht：likehood thresh
for lht = 1:0.1:2                            
    %% 计算Within类内的似然比，并判断是否为类内
    
    sr_in = roundn(wi,-2);                         % similarity rounded :四舍五入保留两位小数的相似度
    
    WithinLikeHood = cell(1,3);
    for i = 1:length(sr_in)
        pp = pr_in(abs(x-sr_in(i))<=1e-5);
        pn = pr_bt(abs(x-sr_in(i))<=1e-5);
        
        if pp == 0
            jg = 0;
        elseif pn == 0 && pp > 0
            jg = 1;
        else
            lh = pp / pn;
            if lh >= lht
                jg = 1;
            else
                jg = 0;
            end
        end
        WithinLikeHood(i,:) = {pp,pn,jg};
        disp([num2str(i),'    似然比阈值： ',num2str(lht)])
    end
    
    %% 计算Between类间似然比，并判断是否为同类
    
    sr_bt = roundn(bt,-2);           % similarity rounded :四舍五入保留两位小数的相似度
    
    BetweenLikeHood = cell(1,3);
    for j = 1:length(sr_bt)
        pp = pr_in(abs(x-sr_bt(j))<=1e-5);
        pn = pr_bt(abs(x-sr_bt(j))<=1e-5);
        
        if pp == 0
            jg = 0;
        elseif pn == 0 && pp > 0
            jg = 1;
        else
            lh = pp / pn;
            if lh >= lht
                jg = 1;
            else
                jg = 0;
            end
        end
        BetweenLikeHood(j,:) = {pp,pn,jg};
        disp([num2str(j),'    似然比阈值： ',num2str(lht)])
    end
    k = k + 1;
    FAR_FRR_Thresh(k,:) = [sum(cell2mat(BetweenLikeHood(:,3)))/length(betweenClassImgNameScoreFvrDataBaseV1sort),...
                           sum(cell2mat(WithinLikeHood(:,3))==0)/length(withinClassImgNameScoreFvrDataBaseV1sort),...
                                                                                                                 lht];
    % FAR = sum(cell2mat(BetweenLikeHood(:,3)))/length(betweenClassImgNameScoreFvrDataBaseV1sort);
end
idx = find(FAR_FRR_Thresh(:,1)==0);
OUT = FAR_FRR_Thresh(idx(1),:)