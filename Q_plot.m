clear;
load('SortWithin0114-ƽ��.mat')
trans = cell2mat(withinClassImgNameScoreFvrDataBaseV1sort(:,5));% translation :λ��
rows = trans(:,1);
cols = trans(:,2);
figure;
histogram(rows,20:1:143)
figure;
histogram(cols,120:1:200)