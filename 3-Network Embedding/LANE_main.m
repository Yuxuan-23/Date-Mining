clear;
%load('cornell/cornell.mat');  %打开数据总文件
%load('texas/texas.mat');
%load('washington/washington.mat');
load('wisconsin/wisconsin.mat');
[n,m]=size(F);
%%
%划分数据集
k=5;%类的个数
tem=randperm(n);
A=A(tem,:);A=A(:,tem);%对A随机排序
F=F(tem,:);label=label(tem,:);
trainNum=round(0.8*n);
testNum=n-trainNum;
train_G=A(1:trainNum,1:trainNum);G1=A(1:trainNum,:);
test_G=A(trainNum+1:n,:);G2=A(trainNum+1:n,:);
train_A=F(1:trainNum,:);
test_A=F(trainNum+1:n,:);
train_label=label(1:trainNum);test_label=label(trainNum+1:n);
Y=zeros(n,k);
for i=1:n
    Y(i,label(i))=1;
end
train_Y=Y(1:trainNum,:);
test_Y=Y(trainNum+1:n,:);
%%
d=100;a1=10;a2=100;
H_train=LANE(train_G,train_A,train_Y,d,a1,a2);
del=1;
H_test=G2*pinv(pinv(H_train)*G1)+del*test_A*pinv(pinv(H_train)*train_A);
%%
t=templateSVM('Standardize',true);
model=fitcecoc(H_train,train_label,'Learners',t);
predicted_label=predict(model,H_test);
classificationACC(test_label,predicted_label)