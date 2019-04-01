% LSQ annotation: 此程序用将原图提取Elbp特征后，保存到原图总文件夹所在路径。2019.1.21

clear;

% picsFoldername = 'F:\·m-retrieve\指静脉\指静脉\pics-per3徐总（LSQ更改）\';
 picsFoldername = 'F:\·m-retrieve\指静脉\指静脉\测试\';
imgFoldername = 'FvrQuryPics\';

imgFolderList = dir([picsFoldername,imgFoldername]);
% imgFolderList = dir('F:\·m-retrieve\指静脉\指静脉\pics-徐总新编号0121\FvrQuryPics');

numOfFile = 0;

for num1 = 3:1:length(imgFolderList)%list中前两个不是文件夹，去掉
    imgSampleList = dir([imgFolderList(num1).folder,'\',imgFolderList(num1).name]);%获得文件夹中除去无效的字符串的所有的图片
%     imgNameAndSURFDescripter = cell(1,2);

        for num2 = 3:1:length(imgSampleList)%list中前两个不是文件夹，去掉，取一类内的所有图片
            numOfFile = numOfFile + 1;
            disp(numOfFile);
            imgSample = imread(strcat(imgSampleList(num2).folder,'\',imgSampleList(num2).name));%读取文件夹中的图片
            imgSample = F_extractFeatures(imgSample);
            mkdir([picsFoldername,'FvrQuryPicsEllbp\',imgFolderList(num1).name]);
                imwrite(imgSample,[picsFoldername,'\FvrQuryPicsEllbp\',imgFolderList(num1).name,'\',imgSampleList(num2).name]);
%                 mkdir('.\FvrQuryPicsEllbp\',imgFolderList(num1).name);
%                 imwrite(imgSample,['.\FvrQuryPicsEllbp\',imgFolderList(num1).name,'\',imgSampleList(num2).name]);
                
        end
end

