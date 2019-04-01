function LBP = F_shiftBasedLBP(inImg, filtR) % filtR, isRotInv, isChanWiseRot
%% Description
%����������˲�������ȡLBPͼ

%%�������
% inImg- ����ͼ
% filtR- �˲����Ĵ�С����



%% �������
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

%��������������������͡�
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

    % ����ֵLBP������Ӧ��Ȩ��
possibleLBP =sum(binaryWord.*weigthMat, 3);

if strcmpi(outClass, calcClass)
    LBP =possibleLBP;
else
    LBP = cast(possibleLBP, outClass);
end
