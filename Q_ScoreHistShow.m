% input:类内类间结果
% output:选中分数直方图
wi = cell2mat(withinClassImgNameScoreFvrDataBaseV1sort(:,3));
bt = cell2mat(betweenClassImgNameScoreFvrDataBaseV1sort(:,3));

figure,
histogram(wi)
hold on
histogram(bt)
legend('类内','类间');

xlabel('Similarity')
ylabel('图象对数量')
title('Elastic Scroe')