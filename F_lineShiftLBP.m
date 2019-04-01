function LLBP = F_lineShiftLBP(inImg, nFiltDims, isScale, targetClass)
%% lineLBP
% The function implements enhanced LLBP (Line Local Binary Pattern) analysis.


%% Syntax
%  LLBP = lineLBP(inImg, nFiltDims, hLBP, isScale, targetClass);


%% Input arguments (defaults exist):
% inImg            �����ͼƬ
% nFiltDims      һ����ά����, ��ʾ�����˲����Ĵ�С
% isScale          ����ֵ��һ����[0, 1],�������.   
% targetClass   ָ�����������������

%% Output arguments
%   LLBP-    


%% Default parameters
if nargin < 4
    targetClass = [];
end

%% ��֤�����ĺϷ���
%inImg must be a double
if ~isa(inImg, 'double')
    inImg = double(inImg);
end

%nFiltDims ������һ�� 1��2������
if ~isequal(size(nFiltDims), [1, 2])
    error('nFiltDims must be a array with size 2 �� 1');
end
if isScale
    targetClass = 'single';
end


%% �����ĸ�������˲���
upFiltLLBP = F_generateShiftLLBP( nFiltDims(1), false );%���ϵ��˲���
downFiltLLBP  = -1*upFiltLLBP;%���µ��˲���

leftFiltLLBP = F_generateShiftLLBP( nFiltDims(2), true );
rigthFiltLLBP = -1*leftFiltLLBP;


% Calculate 2 Vertical Line components
%���ô�ֱ�˲���(�Ϻ���)����LBP
upLLBP    = F_shiftBasedLBP(inImg,   upFiltLLBP );

downLLBP  = F_shiftBasedLBP(inImg,  downFiltLLBP );

% Calculate 2 Horizontal Line components
%����ˮƽ�˲���(�����)����LBP
leftLLBP  = F_shiftBasedLBP(inImg,leftFiltLLBP);
rightLLBP = F_shiftBasedLBP(inImg, rigthFiltLLBP);

vertLLBP = single(leftLLBP) + single(rightLLBP);
horzLLBP = single(upLLBP)   + single(downLLBP);

% Combine Vrtical and Horizontal lines combinations(ELLBP)
%��ϴ�ֱ�����ˮƽ�����LLBP��
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

