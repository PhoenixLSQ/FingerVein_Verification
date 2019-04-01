function [im_finalEdge, upperEdge_fitted, lowerEdge_fitted] = F_edgeDetection(im_original)
%%Description
%根据输入的finger vein图像, 检测出手指的边缘

%% input:
%im_original:  经过裁剪的原图, 裁剪是为了去除设备的固有干扰
%                   注意,本算法中使用的是原图来进行边缘检测, 不是局部直方图均衡化的图
%                   因为, 局部直方图均衡化会导致检测出ROI区域内的边缘, 影响边缘的去伪效果
 
%% output:
%im_finalEdge: 最终的检测结果. 二值图, 上下边缘
%upperEdge_fitted: 对上边缘拟合的结果, n×2的数组, 
%                            第一列是横坐标，第二列是纵坐标
%lowerEdge_fitted:  对下边缘拟合的结果, n×2的数组, 
%                            第一列是横坐标，第二列是纵坐标

    im = im_original;
    [im_h, im_w] = size(im);
    
    %% 利用sobel算子进行初次边缘检测
    im = imgaussfilt(im);%gaussian滤波去噪
    im_edge = edge(im, 'Sobel', [], 'horizontal');%sobel水平边缘检测，自适应阈值

    
    %% 对于检测出来的边缘， 去除不符合条件的边缘点。
    %不符合条件的边缘点指的是:
    %两个端点的水平距离小于一定的阈值
    lineProp  = regionprops(im_edge, 'PixelList', 'Area');%统计连通区域的性质
    regionIdx = {lineProp(:).PixelList};
    regionArea = [lineProp(:).Area];

    idx = 1:length(regionArea) ;
    for iPiexlList = 1 : length(idx)
        subscripts = regionIdx{idx(iPiexlList)};
        subscripts = subscripts(:, 2:-1:1);
        maxCol = max( subscripts(:, 2));
        minCol = min( subscripts(:, 2));
        if maxCol - minCol < 60 %若线段的水平距离小于60
            linear_idx  = sub2ind(size(im_edge), subscripts(:, 1), subscripts(:, 2));
            im_edge(linear_idx) = 0;
        end
    end


    
    %% 图像边缘的二次检测,并去除伪边缘
    %1. 将初次边缘检测的结果分块判断，是否检测出了足够的边缘点, 若无足够边缘点, 则进行二次判断
    %2. 分块判断是否检测除了虚假的边缘点, 如果是则去除伪边缘点
   
    %图像分块（分为上、下、左、右四个子块）
    upperLeft_part = im_edge(1:floor(im_h/2), 1:floor(im_w/2));
    upperRight_part = im_edge(1:floor(im_h/2), ceil(im_w/2):end);
    lowerLeft_part = im_edge(ceil(im_h/2):end, 1:floor(im_w/2));
    lowerRight_part = im_edge(ceil(im_h/2):end, ceil(im_w/2):end);   
    edgeBlockSets = {upperLeft_part, upperRight_part, lowerLeft_part, lowerRight_part} ;
    
    
    imBlockSets{1, 1} = im_original(1:floor(im_h/2), 1:floor(im_w/2));
    imBlockSets{2, 1} = im_original(1:floor(im_h/2), ceil(im_w/2):end);
    imBlockSets{3, 1} = im_original(ceil(im_h/2):end, 1:floor(im_w/2));
    imBlockSets{4, 1} = im_original(ceil(im_h/2):end, ceil(im_w/2):end);   

            %对每个子块判断是否检测出足够的边缘点.  或者过渡检测出点
    new_edgeBlockSets = cell(4, 1);
    for iBlock = 1: 4
        edgePart = edgeBlockSets{iBlock};
        if length(find(edgePart==1)) <= size(edgePart, 2) * 0.7 
            %判断  检测出的边缘点是否过少
            %判断条件: 边缘点数<=子块宽度的0.7倍， 认为需要进行二次检测
            
            %进行二次检测，并将结果与一次结果进行or
            edgePart = F_edgeDetection_again(imBlockSets{iBlock}) | edgeBlockSets{iBlock};
            
        elseif   length(find(edgePart==1)) >= size(edgePart, 2) * 1.3
            %判断是否过渡检测出边缘点， 也就是受到干扰
            %判断条件:  边缘点数>=子块宽度的1.3倍
              
            %统计各连通区域(i.e.线条)的信息
            %1. 连通区域像素点的索引
            %2. 连通区域的长度(左端点和右端点之间的距离)
            %3. 联通区域的行均值
            lineProp  = regionprops(edgePart, 'PixelList');
             lineIdx = {lineProp(:).PixelList};
             lineLength = zeros(length(lineIdx), 1);
             lineMeanRow = zeros(length(lineIdx), 1);
             for iLine = 1: length(lineIdx)
                 lineLength(iLine)= abs(max(lineIdx{iLine}(:, 1)) - min(lineIdx{iLine}(:, 1)));% 直线的长度
                 lineMeanRow(iLine) = mean(lineIdx{iLine}(:, 2));%直线的各点的行均值
             end
             
             if sum(lineLength>size(edgePart, 2) * 0.7)
                 %假如子块中存在很长的线段(左右端点很长, 并非面积最大)，
                 %就让此线段作为有效的边缘。
                 [~, ind] = max(lineLength);
                 newEdge = zeros(size(edgePart));
                 lineInd = sub2ind(size(edgePart), lineIdx{ind}(:, 2), lineIdx{ind}(:, 1));
                 newEdge(lineInd) = 1;
                 edgePart = newEdge;
                 
             else
                 %如果子块中没有明显的长的连通区域(线条)，
                 %则看哪个连通区域的行均值符合要求
                 meanRow =zeros(length(lineIdx), 1) ;
                 if iBlock == 1 ||  iBlock == 2
                     %对于上半图像的子块(子块1以及子块2),选取行均值最大的连通区域(线条)
                     for iPiexlList = 1 : length(lineIdx)
                        subscripts = lineIdx{iPiexlList};%第一列是 col坐标, 第二列是row坐标
                        meanRow(iPiexlList, 1) = mean(subscripts(:, 2));%row坐标的均值
                     end
                    [~, ind] = max(meanRow) ;
                    newEdge = zeros(size(edgePart));
                    lineInd = sub2ind(size(edgePart), lineIdx{ind}(:, 2), lineIdx{ind}(:, 1));
                    newEdge(lineInd) = 1;
                    edgePart = newEdge;

                 elseif iBlock == 3 ||  iBlock == 4
                     %对于下半图像的子块(子块3以及子块4),选取行均值最小的连通区域(线条)
                     for iPiexlList = 1 : length(lineIdx)
                        subscripts = lineIdx{iPiexlList};%第一列是 col坐标, 第二列是row坐标
                        meanRow(iPiexlList, 1) = mean(subscripts(:, 2));
                     end
                    [~, ind] = min(meanRow) ;
                    newEdge = zeros(size(edgePart));
                    lineInd = sub2ind(size(edgePart), lineIdx{ind}(:, 2), lineIdx{ind}(:, 1));
                    newEdge(lineInd) = 1;
                    edgePart = newEdge;
                 end
                 
             end
        end
        
        new_edgeBlockSets{iBlock} = edgePart;
    end
     new_edge = [new_edgeBlockSets{1}, new_edgeBlockSets{2}; ...
                            new_edgeBlockSets{3}, new_edgeBlockSets{4}];

    %% 二次检测的边缘进行拟合, 得到最终拟合的边缘图
    upperEdge_fitted = F_fittedCurve(new_edge(1:floor(im_h/2), :));
    lowerEdge_fitted = F_fittedCurve(new_edge(floor(im_h/2)+1:end, :));
    lowerEdge_fitted(:, 2) = lowerEdge_fitted(:, 2)+floor(im_h/2) -1 ;


    im_finalEdge = zeros(im_h, im_w);
    im_finalEdge(sub2ind([im_h, im_w], upperEdge_fitted(:, 2), upperEdge_fitted(:, 1))) = 1;
    im_finalEdge(sub2ind([im_h, im_w], lowerEdge_fitted(:, 2), lowerEdge_fitted(:, 1))) = 1;


    
end








