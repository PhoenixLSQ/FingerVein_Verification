function ROI = F_extraROIForIQA(im)
%%
%用于图像质量评价阶段的ROI提取算法
%基本原理是sobel水平边缘检测+去噪

%input
%im:    原始图像

%output
%ROI:   图像的感兴趣区域
    
%%
  %检查输入参数的类型
    if ndims(im) == 3
        im = rgb2gray(im);
    end
    if ~isa(im, 'double')   
        im = double(im);
    end
  
    [im_h, im_w] = size(im);
    
    %sobel水平边缘检测，并给予固定阈值(偏小)，以便提取出弱边缘
    imEdge = edge(im, 'sobel', 10, 'horizontal');
    
    %对边缘图分块
    edgeBlock{1, 1} = imEdge(1:floor(im_h/2), 1:floor(im_w/2));
    edgeBlock{2, 1} = imEdge(1:floor(im_h/2), floor(im_w/2):end);
    edgeBlock{3, 1} = imEdge(floor(im_h/2):end, 1:floor(im_w/2));
    edgeBlock{4, 1} = imEdge(floor(im_h/2):end,  floor(im_w/2):end);
    
    %对选取每个子块中，选取面积最大的连通区域作为边缘
    for iBlock = 1 : 4
        edgePart = edgeBlock{iBlock, 1};
        newEdgePart =zeros(size(edgePart), 'logical');
        
        %提取当前子块中边缘图的连通区域， 并统计其像素坐标以及面积
        regionProp = regionprops(edgePart, 'PixelIdxList', 'Area');
        pixelLinarInd = {regionProp.PixelIdxList};
        regionArea = [regionProp.Area];
        
        %选取面积最大的连通区域作为边缘
        [~, ind] = max(regionArea);
        if ~isempty(ind)
            newEdgePart(pixelLinarInd{ind}) = 1;
        end
                      
        edgeBlock{iBlock, 1} = newEdgePart;     
    end
    
    newEdge = [edgeBlock{1}, edgeBlock{2};edgeBlock{3}, edgeBlock{4}];

    %获得上边缘中的最低点的行坐标（最大行）
    upperEdge = newEdge(1:floor(im_h/2), :);
    [row, ~] = find(upperEdge==1);
    upperEdgeMaxRow = max(row);
    
    %获得下边缘的最高点的行坐标（最小行）
    lowerEdge = newEdge(floor(im_h/2)+1:end, :);
    [row, ~] = find(lowerEdge==1);
    lowerEdgeMinRow = min(row) + floor(im_h/2) ;

    %截取ROI，且归一化像素值为0~255
    ROI = im(upperEdgeMaxRow:lowerEdgeMinRow, :);
    ROI = floor(mat2gray(ROI)*255);%归一化像素值为0~255


end





