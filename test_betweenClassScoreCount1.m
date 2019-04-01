%test_betweenClassScoreCount1
%此程序用于按照公司的方法测量类间匹配的文件名与对应分数
%每类10张图片，前3张用作库中图片，10张图片用作查询图片（有重复）
%类间：每一类的10张中的1张分别与剩下其他所有类库中的三张图片作相似性度量，再将三个分数中的最高分取出
%       作为此次相似性度量的结果，其他图片以此类推
%类内：每一类的10张中的1张分别与此类的有3张图片的图库作一次相似性度量（有重复），取出其中的最高分作为此次相似性
%       度量的结果
clear;

% imgFolderList = dir('.\imgAll\FvrDataBase_V1.0_Ellbp');%获取所有带有图片的文件夹
imgFoldername = 'F:\·m-retrieve\指静脉\指静脉\pics-0.54%frr\';
imgFolderList = dir([imgFoldername,'FvrQuryPicsEllbp']);%获取所有带有图片的文件夹

%cell中每一行分别存放sample，被对比的图片，还有对应的ellbp分数与SURF特征点距离
betweenClassImgNameScoreFvrDataBaseV1sort = cell(1, 7);

%设置一下等会要用的参数
numOfMatch = 0;
tic;
for num1 = 3:1:length(imgFolderList)%list中前两个不是文件夹，去掉
    imgSampleList = dir([imgFolderList(num1).folder,'\',imgFolderList(num1).name]);%获得文件夹中除去无效的字符串的所有的图片
    
        for num2 = 3:1:length(imgSampleList)%list中前两个不是文件夹，去掉，取一类内的所有图片
                imgSample = imread(strcat(imgSampleList(num2).folder,'\',imgSampleList(num2).name));%读取文件夹中的图片
                
            for num3  = 3:1:length(imgFolderList)
                imgList = dir([imgFolderList(num3).folder,'\',imgFolderList(num3).name]);%读取到所有的文件夹
                num_score = 0;
                mat_score = [];
                
                for num4 = 3:1:5%只读前三张图片（作为类间匹配）
                    %类间每类只取前3张图片,可以用文件夹名字来判断是不是类内
                    if ~(strcmp(imgList(num4).folder,imgSampleList(num2).folder))%如果 此时循环到的文件夹和自身不同才进行匹配
                        imgBank = imread(strcat(imgList(num4).folder,'\',imgList(num4).name));
                        num_score = num_score + 1;
%                         [mat_score(num_score)] = F_measureSimilarity(imresize(imgSample,0.6),imresize(imgBank,0.6));
                        [mat_score(num_score),pos(num_score,:),corrmaxvalue(num_score)] = Q_measureSimilarity(imresize(imgSample,0.6),imresize(imgBank,0.6));                        
                    end
                end
                if ~isempty(mat_score)
                    numOfMatch = numOfMatch + 1;
                    disp(numOfMatch);
                    [~,y] = max(mat_score);%找到最高得分对应的图片索引
                    % 每行cell的每列存放的依次是：查询图文件名、库图文件名、相似度、查询图所在文件夹名、库图所在文件夹名,norm的平移量
                    betweenClassImgNameScoreFvrDataBaseV1sort(numOfMatch,:) = {imgSampleList(num2).name,...
                                                                                            imgList(y+2).name,...
                                                                                            max(max(mat_score)),...
                                                                                            imgSampleList(1).folder(end-4:end),...
                                                                                            imgList(1).folder(end-4:end),...
                                                                                            pos(y,:),...
                                                                                            corrmaxvalue(y)};
                end
                
            end
        end
end
toc;
save('0118_Between_limit_CorrRatioThresh0.1.mat','betweenClassImgNameScoreFvrDataBaseV1sort');

load splat;
sound(y,Fs);