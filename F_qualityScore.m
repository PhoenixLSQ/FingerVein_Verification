function  qualityScore  = F_qualityScore(im)
% ����ͼ�������
% ���ݶȷ���, �Աȶȷ���, �Լ���Ϣ����Frank���Ƿ����ں�. 
    
    if ndims(im) == 3
        im = rgb2gray(im);
    end
    if ~isa(im, 'double')
        im = double(im);
    end

        
    %gaussian filter
    im = round(imgaussfilt(im));

    %initial values
    [im_h, im_w] = size(im);
    nBlocks = 0;
    j_11 = 0;
    j_12 = 0;
    j_22 = 0;
    k_i = 0;
    C_j = 0;

    %% �ݶ���Ϣ�Լ��Աȶ���Ϣ
    blockSize = 8;
    for iRow = 1: blockSize :im_h-blockSize
        for iCol= 1: blockSize :im_w-blockSize
            nBlocks = nBlocks + 1;%number of blocks
            
            %��ǰͼ���ӿ�
            imBlock = im(iRow:iRow+blockSize-1, iCol:iCol+blockSize-1);
            
            %���㵱ǰ�ӿ�ĶԱȶȷ���, ���ۼ����п�ĶԱȶȷ���
            meanValue = mean(imBlock(:)) ;
            equalMat = (imBlock == meanValue);
            C_j = C_j + sqrt(sum(sum(imBlock-meanValue).^2)/blockSize^2) ;%contrast score

            if sum(equalMat(:)) == blockSize^2
                %���block�и�Ԫ��ȫ����ͬ(����,����Ԫ��ȫΪ5)
                k_i = k_i + 0 ;
            else
                
                %%��⵱ǰ�ӿ���ݶ�, ���ۼ������ӿ���ݶ�
                %matlab �������ݶȵķ�ʽ����ֵ���,(��ԵӦ�þ�������Ԫ��ֱ�����)
                [g_x, g_y] = gradient(imBlock);

                j_11 = sum(sum(g_x.^2))/blockSize^2    ; 
                j_12 = sum(sum(g_x.*g_y))/blockSize^2 ;
                j_21 = j_12 ;
                j_22 = sum(sum(g_y.^2))/blockSize^2    ;

                J = [j_11, j_12;j_21, j_22];

                lambda_1 = 0.5*(trace(J) + sqrt( trace(J)^2 - 4 * det(J))) ;
                lambda_2 = 0.5*(trace(J) - sqrt( trace(J)^2 - 4 * det(J))) ;

                k_i = k_i + (lambda_2 - lambda_1)^2 / (lambda_2 + lambda_1)^2 ;%gradient score

            end

            if isnan(k_i)
                error('�ӿ���ݶ�ֵΪ����');
            end

        end
    end
    gradientScore = k_i/nBlocks;
    contrastScore = C_j/nBlocks;

    %% information entropy
    a = zeros(256, 1);
    for iPixel = 1 : numel(im)
            a(im(iPixel)+1) = a(im(iPixel)+1) + 1;
    end
    pb =  a/sum(a);
    pb(pb == 0) = [] ;%delete the possibility which is 0;
    inforEntropy = sum(- pb.*(log(pb)/log(2)))  ;

    
    %frank ���Ƿ����ں� 
    p = 0.4;
    frankScore_GI = F_frankScore(gradientScore, inforEntropy, p);
    frankScore_GIC = F_frankScore(frankScore_GI, contrastScore, p);
    
    qualityScore = abs(frankScore_GIC);

end

    


