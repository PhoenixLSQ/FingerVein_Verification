% input:���������
% output:ѡ�з���ֱ��ͼ
wi = cell2mat(withinClassImgNameScoreFvrDataBaseV1sort(:,3));
bt = cell2mat(betweenClassImgNameScoreFvrDataBaseV1sort(:,3));

figure,
histogram(wi)
hold on
histogram(bt)
legend('����','���');

xlabel('Similarity')
ylabel('ͼ�������')
title('Elastic Scroe')