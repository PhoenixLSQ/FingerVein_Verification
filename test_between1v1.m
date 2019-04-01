%test_betweenClassScoreCount3
%此程序用于测量类间匹配的文件名与对应分数
clear;

imgFolderList = dir('.\20190117Ellbp');%获取所有带有图片的文件夹

%cell中每一行分别存放sample，被对比的图片，还有对应的ellbp分数与SURF特征点距离
betweenClassImgNameScoreFvrDataBaseV1sort = cell(1, 7);

%设置一下等会要用的参数
numOfMatch = 0;
tic
for num1 = 3:1:length(imgFolderList)    % list中前两个不是文件夹，去掉
    imgSampleList = dir([imgFolderList(num1).folder,'\',imgFolderList(num1).name]);    % 获得文件夹中除去无效的字符串的所有的图片
    
    for num2 = 3:1:3    %list中前两个不是文件夹，去掉，取一类内的所有图片
        imgSample = imread(strcat(imgSampleList(num2).folder,'\',imgSampleList(num2).name));    %读取文件夹中的图片
        
        for num3  = 3:1:length(imgFolderList)
            imgList = dir([imgFolderList(num3).folder,'\',imgFolderList(num3).name]);    %读取到所有的文件夹
            
            for num4 = 4:1:length(imgList)%每一类的第二张图片当做库中图片
                %读取所有类间图片并进行比较,可以用文件夹名字来判断是不是类内
                if ~(strcmp(imgList(num4).folder,imgSampleList(num2).folder)) % 如果 此时循环到的文件夹和自身不同才进行匹配
                    imgBank = imread(strcat(imgList(num4).folder,'\',imgList(num4).name));
                    numOfMatch = numOfMatch + 1;
                    disp(numOfMatch);
                    
                    [score,pos,corrmaxvalue] = Q_measureSimilarity(imresize(imgSample,0.6),imresize(imgBank,0.6));
                    
                    betweenClassImgNameScoreFvrDataBaseV1sort(numOfMatch,:) = {imgSampleList(num2).name,...
                                                                                    imgList(num4).name,...
                                                                                        score,...
                                                                                            imgSampleList(1).folder(end-4:end),...
                                                                                                imgList(1).folder(end-4:end),...
                                                                                                    pos,...
                                                                                                        corrmaxvalue};
                    
                    
                    
                end
            end
        end
    end
end
toc
save('1v1_Between0117.mat','betweenClassImgNameScoreFvrDataBaseV1sort');

load splat;
sound(y,Fs);