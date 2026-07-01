%基于TCH不确定性评估的结果，融合TCH融合和商权法融合的气候舒适度指数
%融合方法为根据不确定性评估的结果，同一个格点，取不确定性最小的方法的指标为该格点的气候舒适度指数
clear all;clc;
%加载数据
load('TCH_integ_index.mat');
load('Entropyweightindex.mat');
load('Cindex.mat');
%因为基于固定值得到的综合指数Cindex，未考虑到NaN情况，被赋值为1，需要重置下
Cindex(isnan(TCH_integ_index(:,3)),3:end)=NaN;
%加载三套数据的不确定性数据
load TCH_data_uncertainty_TCH.mat
load TCH_data_uncertainty_Entropy.mat
load TCH_data_uncertainty_Guding.mat

%在这个不确定性评估的基础上，采用贝叶斯三角帽来进行数据融合，得到一个新的指数
std_data=[TCH_data_TCH(3:end,3),TCH_data_Entropy(3:end,3),TCH_data_Guding(3:end,3)];
[m1,n1]=size(std_data);
Deno_reslt=zeros(m1,1);
for num=1:n1
    std1=std_data;
    std1(:,num)=[];
    tem_data=cumprod(std1,2);%按列秋累积乘积
    Deno_reslt=Deno_reslt+tem_data(:,end);    
end
for num=1:n1
    std1=std_data;
    std1(:,num)=[];
    tem_data=cumprod(std1,2);%按列秋累积乘积
    wight_data(:,num)=tem_data(:,end)./Deno_reslt;     
end
wight_data_new=[TCH_data_TCH(3:end,1:2),wight_data];%添加经纬度坐标
% 数据融合
[m,n]=size(TCH_integ_index);
% wight_data=[ones(2,3).*NaN;wight_data];
Final_TCH_integ_index=zeros(m,n);
for ii=3:n
    Final_TCH_integ=TCH_integ_index(3:end,ii).*wight_data(:,1)+wight_index(3:end,ii).*wight_data(:,2)+Cindex(3:end,ii).*wight_data(:,3);
    Final_TCH_integ_index(3:end,ii)=Final_TCH_integ;
end
%添加坐标和日期
Final_TCH_integ_index(:,1:2)=TCH_integ_index(:,1:2);
Final_TCH_integ_index(1:2,3:end)=TCH_integ_index(1:2,3:end);

% 输出数据
titlename={'NaN','NaN','TCH_integ_index','Entropywight_index','Guding_index'};
wight_data_index=[titlename;num2cell(wight_data_new)];
xlswrite('Final_Climateindex_TCH_Fusion_权重.xlsx',wight_data_index);
%输出融合数据
save Final_Climateindex_TCH_Fusion_method.mat Final_TCH_integ_index
