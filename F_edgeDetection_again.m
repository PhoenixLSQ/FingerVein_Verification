function edgeMap = F_edgeDetection_again(im_part)
    %% 二次边缘检测：
    %功能： 针对在原图中难以检测边缘，
    %原理：降低确定边缘点的阈值
    %input：原图像的四分之一，初次边缘检测中被确认有效边缘点过少
    %output：“靠谱”的边缘点
    
    %% 得到纵向差分图， 并阈值化得到边缘候选点
    differMap= abs(im_part - circshift(im_part, -3));%circshift 循环位移
    differMap(end-2:end, :) = 0;%去除循环位移的影响

    diffThreshold = mean(differMap(:)) * 2.8;
    differMap = imbinarize(differMap, diffThreshold);
    
    
    %% 边缘候选点当中,筛选出 '靠谱'的边缘点（y坐标出现频次较多的点）
    [row, col] = find(differMap==1);
    freTable = tabulate(row);%frequence table of elements in row
    freTable = sortrows(freTable, -2);%sort  by frequence 
    if size(freTable, 1)>=5
        topN = 5;
        edgePoints = zeros(sum(freTable(1:topN, 2)), 2);%top 1 ~ top 5
        edgeMap = zeros(size(differMap), 'logical') ;
    else
        error('候选边缘点, 分布与5行之内');
    end
    for i = 1 : topN
        %根据"投票"的结果, 选出"靠谱的边缘点"
        edgePoints(1:freTable(i, 2), 1) =  row(row == freTable(i, 1));
        edgePoints(1:freTable(i, 2), 2) = col(row == freTable(i, 1));
        edgeMap(edgePoints(1:freTable(i, 2), 1) , edgePoints(1:freTable(i, 2), 2) ) = 1;
    end

    %% 形态学操作“膨胀”以避免边缘断开
    se = strel('square', 2);
    edgeMap = imdilate(edgeMap, se);

   %% 去除虚假边缘， 也就是左右两端距离过小的连通区域
    regionProp  = regionprops(edgeMap, 'PixelList', 'Area');
    regionIdx = {regionProp(:).PixelList};
    regionArea = [regionProp(:).Area];
    areaThreshold = 1000;
    idx = find(regionArea<= areaThreshold);
    for iPiexlList = 1 : length(idx)
        subscripts = regionIdx{idx(iPiexlList)};
        subscripts = subscripts(:, 2:-1:1);
        maxCol = max( subscripts(:, 2));
        minCol = min( subscripts(:, 2));
        if maxCol - minCol < 40
            linear_idx  = sub2ind(size(edgeMap), subscripts(:, 1), subscripts(:, 2));
            edgeMap(linear_idx) = 0;    
        end
    end


end



