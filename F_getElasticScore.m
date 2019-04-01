function  similarity = F_getElasticScore(img_based, img_2, neighborSize, nFingerVeinPoints)
% ��������vein network�����ƶ�


% output: 
% nMatchedPoints:  �ܵ�ƥ������Ŀ
% similarity:              ���ߵ����ƶ�

% input:                    
% img_based:           ���ڴ�ͼ�������ƶ�
% img_2:                  ��img_2����img_based�������ƶ�
% neighborSize:       �������ʱ�õ�������Χ
    [im_h, im_w] = size(img_based);

    [row_idx, col_idx] = find(img_based==1);

    
    %% ɾ�����ڿ���ͼ��߽�ĵ�
        %ɾ�����ڿ���ͼ�����±߽�ĵ�
        idx_1 = find(row_idx<=(neighborSize-1)/2 | row_idx>= im_h-(neighborSize-1)/2);
        row_idx(idx_1) = []; 
        col_idx(idx_1) = [];
        
        %ɾ�����ڿ���ͼ�����ұ߽�ĵ�
        idx_2 = find(col_idx<=(neighborSize-1)/2 | col_idx>= im_w-(neighborSize-1)/2);
        row_idx(idx_2) = []; 
        col_idx(idx_2) = [];
        

        
    %% ���� img_based �����ƶȼ��� 
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


