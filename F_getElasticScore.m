function  similarity = F_getElasticScore(img_based, img_2, neighborSize, nFingerVeinPoints)
% 计算两个vein network的相似度


% output: 
% nMatchedPoints:  总的匹配点的数目
% similarity:              二者的相似度

% input:                    
% img_based:           基于此图计算相似度
% img_2:                  将img_2基于img_based计算相似度
% neighborSize:       计算分数时用到的领域范围
    [im_h, im_w] = size(img_based);

    [row_idx, col_idx] = find(img_based==1);

    
    %% 删除过于靠近图像边界的点
        %删除过于靠近图像上下边界的点
        idx_1 = find(row_idx<=(neighborSize-1)/2 | row_idx>= im_h-(neighborSize-1)/2);
        row_idx(idx_1) = []; 
        col_idx(idx_1) = [];
        
        %删除过于靠近图像左右边界的点
        idx_2 = find(col_idx<=(neighborSize-1)/2 | col_idx>= im_w-(neighborSize-1)/2);
        row_idx(idx_2) = []; 
        col_idx(idx_2) = [];
        

        
    %% 基于 img_based 的相似度计算 
    nMatchedPoints = 0;

 
    for iPoint = 1: length(row_idx)
        currentRow = row_idx(iPoint);
        currentCol = col_idx(iPoint);
        sub_region = img_2(currentRow-(neighborSize-1)/2:currentRow+(neighborSize-1)/2, ...
                                                currentCol-(neighborSize-1)/2:currentCol+(neighborSize-1)/2);
     
         if    sum(sub_region(:))~= 0
             
             nMatchedPoints = nMatchedPoints + 1;

         end

    end
    
    if nFingerVeinPoints ~= 0
        similarity = nMatchedPoints/nFingerVeinPoints ;
    elseif nFingerVeinPoints ==0
        similarity = 0;
    end

end


