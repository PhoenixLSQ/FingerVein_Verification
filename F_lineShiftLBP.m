function LLBP = F_lineShiftLBP(inImg, nFiltDims, isScale, targetClass)
%% lineLBP
% The function implements enhanced LLBP (Line Local Binary Pattern) analysis.


%% Syntax
%  LLBP = lineLBP(inImg, nFiltDims, hLBP, isScale, targetClass);


%% Input arguments (defaults exist):
% inImg            输入的图片
% nFiltDims      一个二维向量, 表示横纵滤波器的大小
% isScale          像素值归一化至[0, 1],方便计算.   
% targetClass   指明输输出的数据类型

%% Output arguments
%   LLBP-    


%% Default parameters
if nargin < 4
    targetClass = [];
end

%% 验证参数的合法性
%inImg must be a double
if ~isa(inImg, 'double')
    inImg = double(inImg);
end

%nFiltDims 必须是一个 1×2的向量
if ~isequal(size(nFiltDims), [1, 2])
    error('nFiltDims must be a array with size 2 × 1');
end
if isScale
    targetClass = 'single';
end


%% 构建四个方向的滤波器
upFiltLLBP = F_generateShiftLLBP( nFiltDims(1), false );%向上的滤波器
downFiltLLBP  = -1*upFiltLLBP;%向下的滤波器

leftFiltLLBP = F_generateShiftLLBP( nFiltDims(2), true );
rigthFiltLLBP = -1*leftFiltLLBP;


% Calculate 2 Vertical Line components
%利用垂直滤波器(上和下)计算LBP
upLLBP    = F_shiftBasedLBP(inImg,   upFiltLLBP );

downLLBP  = F_shiftBasedLBP(inImg,  downFiltLLBP );

% Calculate 2 Horizontal Line components
%利用水平滤波器(左和右)计算LBP
leftLLBP  = F_shiftBasedLBP(inImg,leftFiltLLBP);
rightLLBP = F_shiftBasedLBP(inImg, rigthFiltLLBP);

vertLLBP = single(leftLLBP) + single(rightLLBP);
horzLLBP = single(upLLBP)   + single(downLLBP);

% Combine Vrtical and Horizontal lines combinations(ELLBP)
%结合垂直方向和水平方向的LLBP。
LLBP = sqrt((0.7*horzLLBP).^2 + (0.3*vertLLBP).^2);

if isScale
    % Scale data to be [0, 1]
    LLBP = LLBP - min(LLBP(:));
    LLBP = LLBP / max(LLBP(:));
end


if isempty(targetClass)
    LLBP = cast( LLBP, 'like', upLLBP);
elseif ~strcmpi( targetClass, class(LLBP) )
    LLBP = cast( LLBP, targetClass);
end

end

