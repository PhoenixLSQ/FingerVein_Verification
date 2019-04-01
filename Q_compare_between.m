% input:读取类间比对的分数：“FvrDataBaseV1SortV1.3类间匹配文件名与分数190104”，
%       修改：Thresh
% output：显示类间比对的具体图片和名称
close all
thresh = 0.485;
ind = find(cell2mat(betweenClassImgNameScoreFvrDataBaseV1sort(:,3)) > thresh);

% path = 'F:\·m-retrieve\指静脉\指静脉\pics\';
path = 'F:\·m-retrieve\指静脉\指静脉\pics-per3徐总（LSQ更改）\';

for n = 1:length(ind)
out = betweenClassImgNameScoreFvrDataBaseV1sort(ind(n),:);

querypath = [path,'FvrQuryPicsEllbp\',out{4},'\',out{1}];
bankpath = [path,'FvrQuryPicsEllbp\',out{5},'\',out{2}];

query = imread(querypath);
bank = imread(bankpath);

figure;
subplot(2,1,1),imshow(query),title([out{4},'\',out{1}(1:end-4),'  [',num2str(out{6}),']','  norm:  ',num2str(out{7}),' s:',num2str(out{3})],'Interpreter','none');
subplot(2,1,2),imshow(bank),title([out{5},'\',out{2}(1:end-4)],'Interpreter','none');
set(gcf,'position',[610 480 500 500]);


fprintf('n = %d\n',n)
Q_analy(querypath,bankpath)

query_image = imread([path,'FvrQuryPics\',out{4},'\',out{1}]);
bank_image = imread([path,'FvrQuryPics\',out{5},'\',out{2}]);

figure;
subplot(2,1,1),imshow(query_image),title([out{4},'\',out{1}(1:end-4),'  [',num2str(out{6}),']'],'Interpreter','none');
subplot(2,1,2),imshow(bank_image),title([out{5},'\',out{2}(1:end-4)],'Interpreter','none');
set(gcf,'position',[10 480 500 500]);

pause

close all
end

idx = find(strcmp(betweenClassImgNameScoreFvrDataBaseV1sort(:,1),'2018-09-29-13_51_28.bmp'));
a = betweenClassImgNameScoreFvrDataBaseV1sort(idx,:);
ind = idx((cell2mat(betweenClassImgNameScoreFvrDataBaseV1sort(find(strcmp(betweenClassImgNameScoreFvrDataBaseV1sort(:,1),...
                                                                                   '2018-09-29-13_51_28.bmp')),3)) > thresh))