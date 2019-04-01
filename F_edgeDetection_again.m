function edgeMap = F_edgeDetection_again(im_part)
    %% ���α�Ե��⣺
    %���ܣ� �����ԭͼ�����Լ���Ե��
    %ԭ������ȷ����Ե�����ֵ
    %input��ԭͼ����ķ�֮һ�����α�Ե����б�ȷ����Ч��Ե�����
    %output�������ס��ı�Ե��
    
    %% �õ�������ͼ�� ����ֵ���õ���Ե��ѡ��
    differMap= abs(im_part - circshift(im_part, -3));%circshift ѭ��λ��
    differMap(end-2:end, :) = 0;%ȥ��ѭ��λ�Ƶ�Ӱ��

    diffThreshold = mean(differMap(:)) * 2.8;
    differMap = imbinarize(differMap, diffThreshold);
    
    
    %% ��Ե��ѡ�㵱��,ɸѡ�� '����'�ı�Ե�㣨y�������Ƶ�ν϶�ĵ㣩
    [row, col] = find(differMap==1);
    freTable = tabulate(row);%frequence table of elements in row
    freTable = sortrows(freTable, -2);%sort  by frequence 
    if size(freTable, 1)>=5
        topN = 5;
        edgePoints = zeros(sum(freTable(1:topN, 2)), 2);%top 1 ~ top 5
        edgeMap = zeros(size(differMap), 'logical') ;
    else
        error('��ѡ��Ե��, �ֲ���5��֮��');
    end
    for i = 1 : topN
        %����"ͶƱ"�Ľ��, ѡ��"���׵ı�Ե��"
        edgePoints(1:freTable(i, 2), 1) =  row(row == freTable(i, 1));
        edgePoints(1:freTable(i, 2), 2) = col(row == freTable(i, 1));
        edgeMap(edgePoints(1:freTable(i, 2), 1) , edgePoints(1:freTable(i, 2), 2) ) = 1;
    end

    %% ��̬ѧ���������͡��Ա����Ե�Ͽ�
    se = strel('square', 2);
    edgeMap = imdilate(edgeMap, se);

   %% ȥ����ٱ�Ե�� Ҳ�����������˾����С����ͨ����
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



