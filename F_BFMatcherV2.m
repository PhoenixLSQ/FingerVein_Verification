function minDistance = F_BFMatcherV2(features1,features2)
%Description
%���Ϊfeatures1,features2֮�����С���룬���indexPairsΪƥ���ϵ���������������������飩��matchmetricΪ��Ӧ�ľ��루���飩
%����Ϊ����������features1,features2��nά������

%%
%features1�е�һ����������features2�е���������������ŷʽ����,�б��Ƿ�����MatchThreshold��ѡ����С�ģ��б��Ƿ�����MaxRatio
%Ȼ�󽫾����ƥ���ϵĵ������������������洢��һ��ά����features1������ͬ���������У���Ϊ��features1��features2ƥ�䣩
%ƥ���ϵĵ�������洢��һ��������features1������ͬ������������
count = 0;
[numOfFeatures1,~] = size(features1);%�õ�һ��ͼ�������ӵĸ���
[numOfFeatures2,~] = size(features2);
minDistance = [];
temp_ED = [];

if (numOfFeatures1 ~= 0) && (numOfFeatures2 ~= 0)%features1��features2�ж�������������ʱ��ż������֮��ľ������
    for num1 = 1:1:numOfFeatures1
        for num2 = 1:1:numOfFeatures2
            %��������ÿһ�д���features1�е�һ�����������е��д���ղŵ�һ��������features2�е�������������ŷ����þ���
            temp_ED(num1,num2) = pdist2(features1(num1,:),features2(num2,:),'cityblock');%�õ��������
        end
    end
end
%%
%����temp_ED���е��У���һ�е������н�����������ȡǰ2(ֻ��ʾĿ�ģ�����ʾ���)�������Ƿ�����MatchThreshold��MaxRatio
if (size(temp_ED) ~= 0)
        for indexOfFeatures1 = 1:1:numOfFeatures1
            valueOfEachRows = temp_ED(indexOfFeatures1,:);%ÿ��ѭ��ȡ��ÿһ�е�������
            [minValueEachRows,~] = min(valueOfEachRows);%����ÿһ�е���Сֵ����Сֵ��λ��
            count = count + 1;
            minDistance(count) = minValueEachRows;


        end
end








end