%test_computeROC

genuineScore = cell2mat(withinClassImgNameScoreFvrDataBaseV1sort(:,3));
imposterScore = cell2mat(betweenClassImgNameScoreFvrDataBaseV1sort(:,3));

genuineAttempts = length(genuineScore);
imposterAttempts = length(imposterScore);

FRR = zeros(1, 2);
FAR = zeros(1, 2);
k= 0;


for thresh = 0:0.01:1
    
    k = k + 1;
    FRR(k, :) = [length(find(genuineScore<thresh))/genuineAttempts, thresh];
    FAR(k, :) = [length(find(imposterScore>thresh))/imposterAttempts, thresh];
    
end

% plot(FAR(:, 1),FRR(:, 1), 'r-',  'LineWidth', 2, 'MarkerSize', 3); % 'LineWidth', 2
% hold on
% plot(FAR(:, 1),FRR(:, 1), 'g*',  'LineWidth', 2, 'MarkerSize', 3);
% ax = gca;
% ax.FontSize = 15;
% 
% % plot([0.001 0.001], [0 1], 'b--', 'LineWidth', 1);
% 
% xlim([0 0.001]);
% ylim([0 1]);
% xlabel('False acceptance rate');
% ylabel('False rejection rate');

thresh = 0.42;
ind = find(cell2mat(withinClassImgNameScoreFvrDataBaseV1sort(:,3)) < thresh);
FR_Sample = withinClassImgNameScoreFvrDataBaseV1sort(ind,:)


idx = find(FAR(:,1)==0);
OUT = FRR(idx(1),:)