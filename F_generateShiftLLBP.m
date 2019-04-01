function filtLLBP = F_generateShiftLLBP(nElems, isVer)
%% 
%生成滤波器

%input
%nElems：   滤波器中的元素数目

%output
%isVer ：    滤波器的方向参数，
%                true： 生成向左的滤波器
%                false：生成向上的滤波器
    
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