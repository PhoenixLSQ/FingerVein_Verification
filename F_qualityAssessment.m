function result = F_qualityAssessment(im)
%image quality assessment based on 
%contrast score, gradient score,infromation entropy


%input:     ROI of image
%output:   result     {good, medium, bad}
    
%% Description:
 %

%% 
    if ~isa(im, 'double')
        im = double(im);
    end
    
    %delete the disturbance
    im(1:5, :) = [];  im(end-4:end, :) = []; 
    im(:, 1:10) = [];    im(:, end-9:end) = [];
    
    [~, im_w] = size(im);
    
    
    part_1 = im(:,  1:floor(im_w/3));
    part_2 = im(:,  floor(im_w/3):floor(im_w/3)*2);
    part_3 = im(:,  floor(im_w/3)*2:end);
    
    %results of Frank score
    qualityScore_1 = F_qualityScore(part_1);
    qualityScore_2 = F_qualityScore(part_2);
    qualityScore_3 = F_qualityScore(part_3);
    

    qualityScore = [qualityScore_1, qualityScore_2, qualityScore_3];

%     if sum(qualityScore <= 0.5) >=2 || sum(qualityScore <= 0.4) >= 1
%         result = 'bad' ;
%     elseif sum(qualityScore >= 2) >=2 
%         result = 'good';
%     else
%         result = 'medium' ;
%     end
%     
    result = qualityScore;

end