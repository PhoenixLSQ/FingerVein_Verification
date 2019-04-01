clc; clear; close all;
%%��������Ч�����۽׶ε�ROI��ȡ
    
%%
load SDUNameList.mat
imPath = '..\dataset\' ;
a = 0;
for iProbe = 1 :100%  3816
    
    imName = SDUNameList{iProbe, 1};
    im = imread([imPath, imName, '.bmp']);
    
    tic
    im = double(rgb2gray(im));
    
    %ȥ�����и���
    im(235:end, :) = [];   im(1:35, :) = [];
    im(:, 270:end) = [];   im(:, 1:10) = [];
     im = imresize(im, 0.5);
    [im_h, im_w] = size(im);
    
    %sobelˮƽ��Ե��⣬������̶���ֵ���Ա���ȡ������Ե
    imEdge = edge(im, 'sobel', 10, 'horizontal');

%     figure;
%     set(gcf, 'position', [200 200 600 400])
%     imshow(imEdge, []);
    
    %ͼ���Եͼ�ֿ�
    edgeBlock{1, 1} = imEdge(1:floor(im_h/2), 1:floor(im_w/2));
    edgeBlock{2, 1} = imEdge(1:floor(im_h/2), floor(im_w/2):end);
    edgeBlock{3, 1} = imEdge(floor(im_h/2):end, 1:floor(im_w/2));
    edgeBlock{4, 1} = imEdge(floor(im_h/2):end,  floor(im_w/2):end);
    
    %��ѡȡÿ���ӿ��У�ѡȡ���������ͨ������Ϊ��Ե
    for iBlock = 1 : 4
        edgePart = edgeBlock{iBlock, 1};
        newEdgePart =zeros(size(edgePart), 'logical');
        
        regionProp = regionprops(edgePart, 'PixelIdxList', 'Area');
        pixelLinarInd = {regionProp.PixelIdxList};
        regionArea = [regionProp.Area];
        
        [~, ind] = max(regionArea);
        newEdgePart(pixelLinarInd{ind}) = 1;
            
        edgeBlock{iBlock, 1} = newEdgePart;     
    end
    
    newEdge = [edgeBlock{1}, edgeBlock{2};edgeBlock{3}, edgeBlock{4}];

    
    upperEdge = newEdge(1:floor(im_h/2), :);
    [row, ~] = find(upperEdge==1);
    upperEdgeMaxRow = max(row);
    
    lowerEdge = newEdge(floor(im_h/2)+1:end, :);
    [row, ~] = find(lowerEdge==1);
    lowerEdgeMinRow = min(row) + floor(im_h/2) ;
%     figure; 
%     imshow(im, []);
%     hold on;
%     line([1, im_w], [upperEdgeMeanRow, upperEdgeMeanRow], 'Color', 'r');
%     line([1, im_w], [lowerEdgeMeanRow, lowerEdgeMeanRow], 'Color', 'r');
    
    imROI = im(upperEdgeMaxRow:lowerEdgeMinRow, :);
    a = a + toc;
    
    imROI = mat2gray(imROI);
    
%     imwrite(imROI, ['�򵥲ü�2\', imName, '.bmp']);
    

end



