
idx = find(FAR(:,1)==0);
FRR_expect1 = FRR(idx(1),1);
thr1 = FRR(idx(1),2);


x = 1:length(withinClassImgNameScoreFvrDataBaseV1sort);
scatter(x,cell2mat(withinClassImgNameScoreFvrDataBaseV1sort(:,6)))
hold on
