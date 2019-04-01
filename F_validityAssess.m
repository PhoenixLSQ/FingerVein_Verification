function assessResult = F_validityAssess(im)
%% assess the validity of image
%用于判断 指静脉图像是否可用 

%input
%im:  image to be assessed

%output
%assessResult:  result of validity assess.  {bright, dark, valid}
%                       'bright' means the image is too bright to be valid
%                       'dark' means the image is too dark to be valid 
%                       'valid' means the image is valid


%% 
    blockSize = 8 ;%parameter of non-overlapping blocks
    [im_h, im_w] = size(im);
    meanVal =zeros(floor(im_h/blockSize) * floor(im_w/blockSize), 1);
    
    %循环取非重叠块， 计算均值
    k = 0;
    for iRow = 1: blockSize : im_h-blockSize
        for iCol = 1 : blockSize : im_w-blockSize
            
            patch = im(iRow:iRow+blockSize-1, iCol:iCol+blockSize-1);
            k =  k + 1;
            meanVal(k, 1) = mean(patch(:));
            
        end
    end
    
    %均值大于180的子块占总块数的比例
    %以及 小于40的子块占总块数的比例
    percentage_bright = length(find(meanVal>180))/length(meanVal);
    percentage_dark = length(find(meanVal<40))/length(meanVal);
    
    if percentage_bright  >= 0.4
        assessResult = 'bright';
    elseif percentage_dark >= 0.5
        assessResult = 'dark';
    else
        assessResult = 'valid';
    end
    
end