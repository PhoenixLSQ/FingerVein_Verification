
ovl_genuine = cell2mat(withinClassImgNameScoreFvrDataBaseV1sort(:,7));   % ���ڵ�overlap����
ovl_imposter = cell2mat(betweenClassImgNameScoreFvrDataBaseV1sort(:,8)); % ����overlap����

els_genuine = cell2mat(withinClassImgNameScoreFvrDataBaseV1sort(:,8));   % ���ڵ�elastic����
els_imposter = cell2mat(betweenClassImgNameScoreFvrDataBaseV1sort(:,9)); % ����elastic���� 

m = 0;
out = zeros(1,3);
for a = 0.01:0.01:(1-0.01)
% ����ƽ����������Ȩ    
% genuineScore = sqrt(((2-a) * ovl_genuine) .* (a * els_genuine)); 
% imposterScore = sqrt(((2-a) * ovl_imposter) .* (a * els_imposter));

% ��Ȩ����ƽ��
% genuineScore = sqrt((ovl_genuine.^(2-a)) .* (els_genuine.^a)); 
% imposterScore = sqrt((ovl_imposter.^(2-a)) .* (els_imposter.^a));

% ������Ȩ
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