function minDistance = F_BFMatcherV2(features1,features2)
%Description
%输出为features1,features2之间的最小距离，输出indexPairs为匹配上的特征点的坐标索引（数组），matchmetric为对应的距离（数组）
%输入为两个描述子features1,features2（n维向量）

%%
%features1中的一个向量遍历features2中的所有向量，计算欧式距离,判别是否满足MatchThreshold，选出最小的，判别是否满足MaxRatio
%然后将距离和匹配上的点的索引存起来，距离存储在一个维度与features1行数相同的列向量中（因为是features1和features2匹配）
%匹配上的点的索引存储在一个与行数features1行数相同的两列数组中
count = 0;
[numOfFeatures1,~] = size(features1);%得到一张图中描述子的个数
[numOfFeatures2,~] = size(features2);
minDistance = [];
temp_ED = [];

if (numOfFeatures1 ~= 0) && (numOfFeatures2 ~= 0)%features1和features2中都有特征向量的时候才计算二者之间的距离矩阵
    for num1 = 1:1:numOfFeatures1
        for num2 = 1:1:numOfFeatures2
            %距离矩阵的每一行代表features1中的一个向量，所有的列代表刚才的一个向量与features2中的所有向量计算欧几里得距离
            temp_ED(num1,num2) = pdist2(features1(num1,:),features2(num2,:),'cityblock');%得到距离矩阵
        end
    end
end
%%
%遍历temp_ED所有的行，将一行的所有列进行升序排序，取前2(只表示目的，不表示语句)，测试是否满足MatchThreshold与MaxRatio
if (size(temp_ED) ~= 0)
        for indexOfFeatures1 = 1:1:numOfFeatures1
            valueOfEachRows = temp_ED(indexOfFeatures1,:);%每次循环取出每一行的所有列
            [minValueEachRows,~] = min(valueOfEachRows);%返回每一行的最小值和最小值的位置
            count = count + 1;
            minDistance(count) = minValueEachRows;


        end
end








end