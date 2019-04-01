%% 分步执行
% load 0315_Within_2kinds_ft.mat
a = 0.34;

ovl_genuine = cell2mat(withinClassImgNameScoreFvrDataBaseV1sort(:,7));   % 类内的overlap分数
els_genuine = cell2mat(withinClassImgNameScoreFvrDataBaseV1sort(:,8));   % 类内的elastic分数

genuineScore = ((1-a) * ovl_genuine) + (a * els_genuine); 
% imposterScore = ((1-a) * ovl_imposter) + (a * els_imposter);

within_newft = withinClassImgNameScoreFvrDataBaseV1sort;

for i  = 1:length(within_newft)
   within_newft(i,9) =  {genuineScore(i)};
end

%% 分步执行
thresh_old = 0.46; 
ind1 = find(cell2mat(within_oldft(:,9)) < thresh_old);
fr1 = within_oldft(ind1,:)

thresh_new = 0.38; 
ind2 = find(cell2mat(within_newft(:,9)) < thresh_new);
fr2 = within_newft(ind2,:)