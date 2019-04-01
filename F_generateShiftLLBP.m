function filtLLBP = F_generateShiftLLBP(nElems, isVer)
%% 
%�����˲���

%input
%nElems��   �˲����е�Ԫ����Ŀ

%output
%isVer ��    �˲����ķ��������
%                true�� ����������˲���
%                false���������ϵ��˲���
    
%%
% default parameter is Horizontal filter
if nargin<2 
    isVer = false;
end
% generate filter suitable for line LBP

% Rows- shift in x- horizontal (left-right) 
% Columns- shift in y- vertical (up-down)
filtLLBP = zeros(nElems, 2);
filtLLBP(1:nElems, 1) = 1:nElems;

if isVer % shift dimentsions
    filtLLBP = filtLLBP(:, [2, 1]);
end