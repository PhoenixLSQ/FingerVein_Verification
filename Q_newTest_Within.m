%test_withinClassScoreCount1
%此程序用于测量类间匹配的文件名与对应分数
clear;

% imgFoldername = 'F:\·m-retrieve\指静脉\指静脉\pics-per3徐总（LSQ更改）\';
imgFoldername = 'F:\项目-指静脉\师弟交流\师弟新特征图片\20190306_高斯强化llbp_ROI\';
imgFolderList = dir([imgFoldername,'FvrQuryPicsEllbp']);%获取所有带有图片的文件夹


%cell中每一行分别存放sample，被对比的图片，还有对应的ellbp分数与SURF特征点距离
withinClassImgNameScoreFvrDataBaseV1sort = cell(1,8);

%设置一下等会要用的参数
numOfMatch = 0;
tic;
for num1 = 3:1:length(imgFolderList)%list中前两个不是文件夹，去掉
    imgSampleList = dir([imgFolderList(num1).folder,'\',imgFolderList(num1).name]);%获得文件夹中除去无效的字符串的所有的图片
    
        for num2 = 3:1:length(imgSampleList)%list中前两个不是文件夹，去掉
            imgSample = imread(strcat(imgSampleList(num2).folder,'\',imgSampleList(num2).name));%读取文件夹中的图片
            num_score = 0;
            mat_score = [];
                
            for num3  = (num2+1):1:length(imgSampleList)
                %读取所有类内图片并进行比较，注意图片可以自身比较，可以用文件夹名字来判断是不是类内
                imgBank = imread(strcat(imgSampleList(num3).folder,'\',imgSampleList(num3).name));
%                 num_score = num_score + 1;
%                 mat_score(num_score) = F_measureSimilarity(imresize(imgSample,0.6),imresize(imgBank,0.6));
                  [mat_score,pos,corrmaxvalue,overlapDegree,elasticScore] = Q_measureSimilarity(imresize(imgSample,0.6),imresize(imgBank,0.6)) ;
                
            
            numOfMatch = numOfMatch + 1; 
            withinClassImgNameScoreFvrDataBaseV1sort(numOfMatch,:) = {imgSampleList(num2).name,...
                                                                                    imgSampleList(num3).name,...
                                                                                    mat_score,...
                                                                                    imgSampleList(3).folder(end-4:end),...
                                                                                     pos,...
                                                                                     corrmaxvalue,...
                                                                                     overlapDegree,...
                                                                                     elasticScore};
             disp(numOfMatch);                                                                                                  
             end
 %          [~,y] = max(mat_score);%找到最高得分对应的图片索引
        end
end
toc;
save('0306_Within_per3_NewTest_师弟高斯强化llbp_ROI_无激活.mat','withinClassImgNameScoreFvrDataBaseV1sort');
load splat;
sound(y,Fs);