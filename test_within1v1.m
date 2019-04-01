%test_withinClassScoreCount3
%此程序用于测量类间匹配的文件名与对应分数
clear;
% imgFolderList = dir('.\imgAll\FvrDataBase_V1.0_Ellbp');%获取所有带有图片的文件夹
imgFolderList = dir('.\20190117Ellbp');%获取所有带有图片的文件夹

withinClassImgNameScoreFvrDataBaseV1sort = cell(1,6);

%设置一下等会要用的参数
numOfMatch = 0;

for num1 = 3:1:length(imgFolderList)   %list中前两个不是文件夹，去掉
    imgSampleList = dir([imgFolderList(num1).folder,'\',imgFolderList(num1).name]);%获得文件夹中除去无效的字符串的所有的图片
    
    for num2 = 3:1:length(imgSampleList)   %list中前两个不是文件夹，去掉
        imgSample = imread(strcat(imgSampleList(num2).folder,'\',imgSampleList(num2).name));   %读取文件夹中的图片
        for num3  = 4:1:length(imgSampleList)
            if ~(strcmp(imgSampleList(num3).name,imgSampleList(num2).name))   %如果此时循环到的图片和自身不同才进行匹配
                imgBank = imread(strcat(imgSampleList(num3).folder,'\',imgSampleList(num3).name));
                
                [score,pos,corrmaxvalue] = Q_measureSimilarity(imresize(imgSample,0.6),imresize(imgBank,0.6));
                numOfMatch = numOfMatch + 1;
                
                withinClassImgNameScoreFvrDataBaseV1sort(numOfMatch,:) = {imgSampleList(num2).name,...
                                                                                imgSampleList(num3).name,...
                                                                                  score,...
                                                                                    imgSampleList(3).folder(end-4:end),...
                                                                                      pos,...
                                                                                        corrmaxvalue};
                
                disp(numOfMatch);
                
            end
        end
    end
end
save('1v1_Within0117.mat','withinClassImgNameScoreFvrDataBaseV1sort');
load splat;
sound(y,Fs);
