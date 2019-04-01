
ovl_genuine = cell2mat(withinClassImgNameScoreFvrDataBaseV1sort(:,7));   % 类内的overlap分数
ovl_imposter = cell2mat(betweenClassImgNameScoreFvrDataBaseV1sort(:,8)); % 类间的overlap分数

els_genuine = cell2mat(withinClassImgNameScoreFvrDataBaseV1sort(:,8));   % 类内的elastic分数
els_imposter = cell2mat(betweenClassImgNameScoreFvrDataBaseV1sort(:,9)); % 类间的elastic分数 

m = 0;
out = zeros(1,3);
for a = 0.01:0.01:(1-0.01)
% 几何平均，算术加权    
% genuineScore = sqrt(((2-a) * ovl_genuine) .* (a * els_genuine)); 
% imposterScore = sqrt(((2-a) * ovl_imposter) .* (a * els_imposter));

% 加权几何平均
% genuineScore = sqrt((ovl_genuine.^(2-a)) .* (els_genuine.^a)); 
% imposterScore = sqrt((ovl_imposter.^(2-a)) .* (els_imposter.^a));

% 算术加权
genuineScore = ((1-a) * ovl_genuine) + (a * els_genuine); 
imposterScore = ((1-a) * ovl_imposter) + (a * els_imposter);


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

% thresh = 0.42;
% ind = find(cell2mat(withinClassImgNameScoreFvrDataBaseV1sort(:,3)) < thresh);
% FR_Sample = withinClassImgNameScoreFvrDataBaseV1sort(ind,:)
m = m + 1;
idx = find(FAR(:,1)==0);
out(m,:) = [a,FRR(idx(1),:)];
end
out(out(:,2) == min(out(:,2)),:)