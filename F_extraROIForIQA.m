function ROI = F_extraROIForIQA(im)
%%
%����ͼ���������۽׶ε�ROI��ȡ�㷨
%����ԭ����sobelˮƽ��Ե���+ȥ��

%input
%im:    ԭʼͼ��

%output
%ROI:   ͼ��ĸ���Ȥ����
    
%%
  %����������������
    if ndims(im) == 3
        im = rgb2gray(im);
    end
    if ~isa(im, 'double')   
        im = double(im);
    end
  
    [im_h, im_w] = size(im);
    
    %sobelˮƽ��Ե��⣬������̶���ֵ(ƫС)���Ա���ȡ������Ե
    imEdge = edge(im, 'sobel', 10, 'horizontal');
    
    %�Ա�Եͼ�ֿ�
    edgeBlock{1, 1} = imEdge(1:floor(im_h/2), 1:floor(im_w/2));
    edgeBlock{2, 1} = imEdge(1:floor(im_h/2), floor(im_w/2):end);
    edgeBlock{3, 1} = imEdge(floor(im_h/2):end, 1:floor(im_w/2));
    edgeBlock{4, 1} = imEdge(floor(im_h/2):end,  floor(im_w/2):end);
    
    %��ѡȡÿ���ӿ��У�ѡȡ���������ͨ������Ϊ��Ե
    for iBlock = 1 : 4
        edgePart = edgeBlock{iBlock, 1};
        newEdgePart =zeros(size(edgePart), 'logical');
        
        %��ȡ��ǰ�ӿ��б�Եͼ����ͨ���� ��ͳ�������������Լ����
        regionProp = regionprops(edgePart, 'PixelIdxList', 'Area');
        pixelLinarInd = {regionProp.PixelIdxList};
        regionArea = [regionProp.Area];
        
        %ѡȡ���������ͨ������Ϊ��Ե
        [~, ind] = max(regionArea);
        if ~isempty(ind)
            newEdgePart(pixelLinarInd{ind}) = 1;
        end
                      
        edgeBlock{iBlock, 1} = newEdgePart;     
    end
    
    newEdge = [edgeBlock{1}, edgeBlock{2};edgeBlock{3}, edgeBlock{4}];

    %����ϱ�Ե�е���͵�������꣨����У�
    upperEdge = newEdge(1:floor(im_h/2), :);
    [row, ~] = find(upperEdge==1);
    upperEdgeMaxRow = max(row);
    
    %����±�Ե����ߵ�������꣨��С�У�
    lowerEdge = newEdge(floor(im_h/2)+1:end, :);
    [row, ~] = find(lowerEdge==1);
    lowerEdgeMinRow = min(row) + floor(im_h/2) ;

    %��ȡROI���ҹ�һ������ֵΪ0~255
    ROI = im(upperEdgeMaxRow:lowerEdgeMinRow, :);
    ROI = floor(mat2gray(ROI)*255);%��һ������ֵΪ0~255


end





