# FingerVein_Verification
本项目为一个指静脉验证的算法，提取8方向Gabor滤波增强后的ELLBP特征，后根据相关分数激活的OverlapScoreE以及ElasticScore融合判断结果  
运行测试：  
类间：Q_newTest_Between.m  
类内：Q_newTest_Within.m  
数据文件夹 FvrQuryPicsEllbp 为提好的ELLBP特征  
测试结果输出分别为：  
对比图1，对比图2，对比分数，文件夹名称，模板匹配平移坐标，相关分数，overlapScore,ElasticScore
