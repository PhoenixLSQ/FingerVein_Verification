function LBP = F_shiftBasedLBP(inImg, filtR) % filtR, isRotInv, isChanWiseRot
%% Description
%根据输入的滤波器来求取LBP图

%%输入参数
% inImg- 输入图
% filtR- 滤波器的大小参数



%% 输出参数
%   LBP-    LBP image UINT8/UINT16/UINT32/UINT64/DOUBLE of same dimentions





%% 
inImgType = class(inImg);
calcClass = 'single' ;

isCalcClassInput = strcmpi(inImgType, calcClass);
if ~isCalcClassInput
    inImg=cast(inImg, calcClass);
end
imgSize=size(inImg);

nNeigh=size(filtR, 1);

%用来控制输出的数据类型、
outClass='uint8';


%% LBP with filtR
weigthVec=reshape(2.^( (1:nNeigh) -1), 1, 1, nNeigh);
weigthMat=repmat( weigthVec, imgSize([1, 2]) );

binaryWord = zeros(imgSize(1), imgSize(2), nNeigh, calcClass);
for iShift=1:nNeigh
    % calculate relevant LBP elements via difference of original image and it's shifted version
    differ = circshift( inImg, filtR(iShift, :) )- inImg;
    binaryWord(:, :, iShift)=cast( round(differ, 3) >= 0, calcClass );     
end 

    % 将二值LBP乘上相应的权重
possibleLBP =sum(binaryWord.*weigthMat, 3);

if strcmpi(outClass, calcClass)
    LBP =possibleLBP;
else
    LBP = cast(possibleLBP, outClass);
end
