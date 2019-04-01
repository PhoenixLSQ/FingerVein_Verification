% input:��ȡ���ȶԵķ�������FvrDataBaseV1SortV1.3���ƥ���ļ��������190104����
%       �޸ģ�Thresh
% output����ʾ���ȶԵľ���ͼƬ������

thresh = 0.42; %0.5172;
ind = find(cell2mat(withinClassImgNameScoreFvrDataBaseV1sort(:,3)) < thresh);

path = 'F:\��m-retrieve\ָ����\ָ����\20190306_��˹ǿ��llbp_ROI\';
% path = 'F:\��m-retrieve\ָ����\ָ����\pics-per3���ܣ�LSQ���ģ�\';

for n = 1:length(ind)
out = withinClassImgNameScoreFvrDataBaseV1sort(ind(n),:);

querypath = [path,'FvrQuryPicsEllbp\',out{4},'\',out{1}];
bankpath = [path,'FvrQuryPicsEllbp\',out{4},'\',out{2}];

query = imread(querypath);
bank = imread(bankpath);

figure;
subplot(2,1,1),imshow(query),title([out{4},'\',out{1}(1:end-4),'  [',num2str(out{5}),']','  norm:  ',num2str(out{6}),' s:',num2str(out{3})],'Interpreter','none');
subplot(2,1,2),imshow(bank),title([out{4},'\',out{2}(1:end-4)],'Interpreter','none');
set(gcf,'position',[610 480 500 500]);

fprintf('n = %d\n',n)
Q_analy(querypath,bankpath)

query_image = imread([path,'FvrQuryPics\',out{4},'\',out{1}]);
bank_image = imread([path,'FvrQuryPics\',out{4},'\',out{2}]);

figure;
subplot(2,1,1),imshow(query_image),title([out{4},'\',out{1}(1:end-4)],'Interpreter','none');
subplot(2,1,2),imshow(bank_image),title([out{4},'\',out{2}(1:end-4)],'Interpreter','none');
set(gcf,'position',[10 480 500 500]);

pause

close all
end