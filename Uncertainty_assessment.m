%评估三角帽方法融合、熵权法及固定阈值法融合的三套数据的不确定形评估
clear all;clc;
%加载数据
load('TCH_integ_index.mat');
load('Entropyweightindex.mat');
load('Cindex.mat');
%因为基于固定值得到的综合指数Cindex，未考虑到NaN情况，被赋值为1，需要重置下
Cindex(isnan(TCH_integ_index(:,3)),3:end)=NaN;
%% 基于TCH不确定性评估方法，评估三套数据的不确定性
[m,n]=size(TCH_integ_index);
TCH_data_TCH=zeros(m,3);
TCH_data_Entropy=zeros(m,3);
TCH_data_Guding=zeros(m,3);
for i=3:m
    x1=TCH_integ_index(i,3:end);
    x2=wight_index(i,3:end);
    x3=Cindex(i,3:end);
    X=[x1',x2',x3'];
    [std,xd_std] = TCH_main(X);
    TCH_data_TCH(i,3)=std(1);
    TCH_data_Entropy(i,3)=std(2);
    TCH_data_Guding(i,3)=std(3);
end
TCH_data_TCH(3:end,1:2)=Cindex(3:end,1:2);
TCH_data_Entropy(3:end,1:2)=Cindex(3:end,1:2);
TCH_data_Guding(3:end,1:2)=Cindex(3:end,1:2);
%保存数据
save TCH_data_uncertainty_TCH TCH_data_TCH
save TCH_data_uncertainty_Entropy TCH_data_Entropy
save TCH_data_uncertainty_Guding TCH_data_Guding
%% 不确定性的作图
%为读取经纬度坐标，读取nc文件来获取经纬度矩阵数据
lon=ncread('H:\CN051格点八要素数据\CN05.1_Tm_1961_2021_daily_025x025.nc','lon');
lat=ncread('H:\CN051格点八要素数据\CN05.1_Tm_1961_2021_daily_025x025.nc','lat');
%生成经纬格网
[CN_lon,CN_lat]=meshgrid(lon,lat);
%读取边界数据
CHN=shaperead('D:\A学习与科研\1学术论文写作\边界基础数据boundary\中国国家基础地理信息SHP\SHP\国界_arc.shp');
CHNx=[CHN(:).X];CHNy=[CHN(:).Y];
%作图
tiledlayout(3,2)
nexttile
% lon=TCHdata(:,1);lat=TCHdata(:,2);
data1=TCH_data_Entropy(3:end,3);data1=reshape(data1,283,163);
set(gcf,'position',[0 0 1440 780]);
m_proj('Mercator','lon',[70 140],'lat',[0 56]);
m_plot(CHNx,CHNy,'k');
hold on
m_grid('linestyle','none','linewidth',1,'tickdir','out','xaxisloc','bottom','yaxisloc','left','fontname','Times New Roman','fontsize',11);
hold on; 
% m_scatter(lon,lat,0.5,data1);
m_contourf(CN_lon,CN_lat,data1');
hold on
clb=textread('GMT_polar.txt');
colormap(clb);
h=colorbar;
caxis([0 2.0]);
ylabel(h,'Uncertainty','fontsize',12,'fontname','Times New Roman');
title('(a) Entropy method','FontSize',12,'FontName','Times New Roman')
nexttile
histogram(data1);
xlabel('Uncertainty','fontsize',12,'fontname','Times New Roman');
ylabel('Grids number','fontsize',12,'fontname','Times New Roman');
title('(b)','fontsize',12,'fontname','Times New Roman');

nexttile
% lon=TCHdata(:,1);lat=TCHdata(:,2);
data1=TCH_data_TCH(3:end,3);data1=reshape(data1,283,163);
set(gcf,'position',[0 0 1440 780]);
m_proj('Mercator','lon',[70 140],'lat',[0 56]);
m_plot(CHNx,CHNy,'k');
hold on
m_grid('linestyle','none','linewidth',1,'tickdir','out','xaxisloc','bottom','yaxisloc','left','fontname','Times New Roman','fontsize',11);
hold on; 
% m_scatter(lon,lat,0.5,data1);
m_contourf(CN_lon,CN_lat,data1');
hold on
clb=textread('GMT_polar.txt');
colormap(clb);
h=colorbar;
caxis([0 2.0]);
ylabel(h,'Uncertainty','fontsize',12,'fontname','Times New Roman');
title('(c) TCH method','FontSize',12,'FontName','Times New Roman')

nexttile
histogram(data1);
xlabel('Uncertainty','fontsize',12,'fontname','Times New Roman');
ylabel('Grids number','fontsize',12,'fontname','Times New Roman');
title('(d)','fontsize',12,'fontname','Times New Roman');

nexttile
% lon=TCHdata(:,1);lat=TCHdata(:,2);
data1=TCH_data_Guding(3:end,3);data1=reshape(data1,283,163);
set(gcf,'position',[0 0 1440 780]);
m_proj('Mercator','lon',[70 140],'lat',[0 56]);
m_plot(CHNx,CHNy,'k');
hold on
m_grid('linestyle','none','linewidth',1,'tickdir','out','xaxisloc','bottom','yaxisloc','left','fontname','Times New Roman','fontsize',11);
hold on; 
% m_scatter(lon,lat,0.5,data1);
m_contourf(CN_lon,CN_lat,data1');
hold on
clb=textread('GMT_polar.txt');
colormap(clb);
h=colorbar;
caxis([0 2.0]);
ylabel(h,'Uncertainty','fontsize',12,'fontname','Times New Roman');
title('(e) Expert method','FontSize',12,'FontName','Times New Roman')
nexttile
histogram(data1);
xlabel('Uncertainty','fontsize',12,'fontname','Times New Roman');
ylabel('Grids number','fontsize',12,'fontname','Times New Roman');
title('(f)','fontsize',12,'fontname','Times New Roman');