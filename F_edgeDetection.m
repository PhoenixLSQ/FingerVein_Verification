function [im_finalEdge, upperEdge_fitted, lowerEdge_fitted] = F_edgeDetection(im_original)
%%Description
%���������finger veinͼ��, ������ָ�ı�Ե

%% input:
%im_original:  �����ü���ԭͼ, �ü���Ϊ��ȥ���豸�Ĺ��и���
%                   ע��,���㷨��ʹ�õ���ԭͼ�����б�Ե���, ���Ǿֲ�ֱ��ͼ���⻯��ͼ
%                   ��Ϊ, �ֲ�ֱ��ͼ���⻯�ᵼ�¼���ROI�����ڵı�Ե, Ӱ���Ե��ȥαЧ��
 
%% output:
%im_finalEdge: ���յļ����. ��ֵͼ, ���±�Ե
%upperEdge_fitted: ���ϱ�Ե��ϵĽ��, n��2������, 
%                            ��һ���Ǻ����꣬�ڶ�����������
%lowerEdge_fitted:  ���±�Ե��ϵĽ��, n��2������, 
%                            ��һ���Ǻ����꣬�ڶ�����������

    im = im_original;
    [im_h, im_w] = size(im);
    
    %% ����sobel���ӽ��г��α�Ե���
    im = imgaussfilt(im);%gaussian�˲�ȥ��
    im_edge = edge(im, 'Sobel', [], 'horizontal');%sobelˮƽ��Ե��⣬����Ӧ��ֵ

    
    %% ���ڼ������ı�Ե�� ȥ�������������ı�Ե�㡣
    %�����������ı�Ե��ָ����:
    %�����˵��ˮƽ����С��һ������ֵ
    lineProp  = regionprops(im_edge, 'PixelList', 'Area');%ͳ����ͨ���������
    regionIdx = {lineProp(:).PixelList};
    regionArea = [lineProp(:).Area];

    idx = 1:length(regionArea) ;
    for iPiexlList = 1 : length(idx)
        subscripts = regionIdx{idx(iPiexlList)};
        subscripts = subscripts(:, 2:-1:1);
        maxCol = max( subscripts(:, 2));
        minCol = min( subscripts(:, 2));
        if maxCol - minCol < 60 %���߶ε�ˮƽ����С��60
            linear_idx  = sub2ind(size(im_edge), subscripts(:, 1), subscripts(:, 2));
            im_edge(linear_idx) = 0;
        end
    end


    
    %% ͼ���Ե�Ķ��μ��,��ȥ��α��Ե
    %1. �����α�Ե���Ľ���ֿ��жϣ��Ƿ�������㹻�ı�Ե��, �����㹻��Ե��, ����ж����ж�
    %2. �ֿ��ж��Ƿ��������ٵı�Ե��, �������ȥ��α��Ե��
   
    %ͼ��ֿ飨��Ϊ�ϡ��¡������ĸ��ӿ飩
    upperLeft_part = im_edge(1:floor(im_h/2), 1:floor(im_w/2));
    upperRight_part = im_edge(1:floor(im_h/2), ceil(im_w/2):end);
    lowerLeft_part = im_edge(ceil(im_h/2):end, 1:floor(im_w/2));
    lowerRight_part = im_edge(ceil(im_h/2):end, ceil(im_w/2):end);   
    edgeBlockSets = {upperLeft_part, upperRight_part, lowerLeft_part, lowerRight_part} ;
    
    
    imBlockSets{1, 1} = im_original(1:floor(im_h/2), 1:floor(im_w/2));
    imBlockSets{2, 1} = im_original(1:floor(im_h/2), ceil(im_w/2):end);
    imBlockSets{3, 1} = im_original(ceil(im_h/2):end, 1:floor(im_w/2));
    imBlockSets{4, 1} = im_original(ceil(im_h/2):end, ceil(im_w/2):end);   

            %��ÿ���ӿ��ж��Ƿ�����㹻�ı�Ե��.  ���߹��ɼ�����
    new_edgeBlockSets = cell(4, 1);
    for iBlock = 1: 4
        edgePart = edgeBlockSets{iBlock};
        if length(find(edgePart==1)) <= size(edgePart, 2) * 0.7 
            %�ж�  �����ı�Ե���Ƿ����
            %�ж�����: ��Ե����<=�ӿ��ȵ�0.7���� ��Ϊ��Ҫ���ж��μ��
            
            %���ж��μ�⣬���������һ�ν������or
            edgePart = F_edgeDetection_again(imBlockSets{iBlock}) | edgeBlockSets{iBlock};
            
        elseif   length(find(edgePart==1)) >= size(edgePart, 2) * 1.3
            %�ж��Ƿ���ɼ�����Ե�㣬 Ҳ�����ܵ�����
            %�ж�����:  ��Ե����>=�ӿ��ȵ�1.3��
              
            %ͳ�Ƹ���ͨ����(i.e.����)����Ϣ
            %1. ��ͨ�������ص������
            %2. ��ͨ����ĳ���(��˵���Ҷ˵�֮��ľ���)
            %3. ��ͨ������о�ֵ
            lineProp  = regionprops(edgePart, 'PixelList');
             lineIdx = {lineProp(:).PixelList};
             lineLength = zeros(length(lineIdx), 1);
             lineMeanRow = zeros(length(lineIdx), 1);
             for iLine = 1: length(lineIdx)
                 lineLength(iLine)= abs(max(lineIdx{iLine}(:, 1)) - min(lineIdx{iLine}(:, 1)));% ֱ�ߵĳ���
                 lineMeanRow(iLine) = mean(lineIdx{iLine}(:, 2));%ֱ�ߵĸ�����о�ֵ
             end
             
             if sum(lineLength>size(edgePart, 2) * 0.7)
                 %�����ӿ��д��ںܳ����߶�(���Ҷ˵�ܳ�, ����������)��
                 %���ô��߶���Ϊ��Ч�ı�Ե��
                 [~, ind] = max(lineLength);
                 newEdge = zeros(size(edgePart));
                 lineInd = sub2ind(size(edgePart), lineIdx{ind}(:, 2), lineIdx{ind}(:, 1));
                 newEdge(lineInd) = 1;
                 edgePart = newEdge;
                 
             else
                 %����ӿ���û�����Եĳ�����ͨ����(����)��
                 %���ĸ���ͨ������о�ֵ����Ҫ��
                 meanRow =zeros(length(lineIdx), 1) ;
                 if iBlock == 1 ||  iBlock == 2
                     %�����ϰ�ͼ����ӿ�(�ӿ�1�Լ��ӿ�2),ѡȡ�о�ֵ������ͨ����(����)
                     for iPiexlList = 1 : length(lineIdx)
                        subscripts = lineIdx{iPiexlList};%��һ���� col����, �ڶ�����row����
                        meanRow(iPiexlList, 1) = mean(subscripts(:, 2));%row����ľ�ֵ
                     end
                    [~, ind] = max(meanRow) ;
                    newEdge = zeros(size(edgePart));
                    lineInd = sub2ind(size(edgePart), lineIdx{ind}(:, 2), lineIdx{ind}(:, 1));
                    newEdge(lineInd) = 1;
                    edgePart = newEdge;

                 elseif iBlock == 3 ||  iBlock == 4
                     %�����°�ͼ����ӿ�(�ӿ�3�Լ��ӿ�4),ѡȡ�о�ֵ��С����ͨ����(����)
                     for iPiexlList = 1 : length(lineIdx)
                        subscripts = lineIdx{iPiexlList};%��һ���� col����, �ڶ�����row����
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

    %% ���μ��ı�Ե�������, �õ�������ϵı�Եͼ
    upperEdge_fitted = F_fittedCurve(new_edge(1:floor(im_h/2), :));
    lowerEdge_fitted = F_fittedCurve(new_edge(floor(im_h/2)+1:end, :));
    lowerEdge_fitted(:, 2) = lowerEdge_fitted(:, 2)+floor(im_h/2) -1 ;


    im_finalEdge = zeros(im_h, im_w);
    im_finalEdge(sub2ind([im_h, im_w], upperEdge_fitted(:, 2), upperEdge_fitted(:, 1))) = 1;
    im_finalEdge(sub2ind([im_h, im_w], lowerEdge_fitted(:, 2), lowerEdge_fitted(:, 1))) = 1;


    
end








