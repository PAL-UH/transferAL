clc
clear all
close all
InputFolder='data/';
OutputFolder='';
TargetInputFile='mars-tgt.csv';%Insert Data file
StartingColumn=1;
TargetRawData= csvread(strcat(InputFolder,TargetInputFile));
[TargetRawDataRows, TargetDataRawCols]=size(TargetRawData);


PoolDataFileType='Target_Pool_%d.csv';
RandomPoolDataFileType='Target_Random_Pool_%d.csv';
TestDataFileType='Target_Test_%d.csv';
AllIndices=(1:TargetRawDataRows)';
PoolPercentages=50;
NumberOfPoolDatasets=10;
NumberOfInstances=floor(TargetRawDataRows*(PoolPercentages/100));
DisplayString='PoolPercentage = %d , DatasetNumber= %d';

for PoolNumber=1:NumberOfPoolDatasets
    %Create Pool datasets
    %PoolPercentage=PoolPercentages(1,PoolPercentageNumber);
    %display(sprintf(DisplayString,PoolPercentage,PoolNumber));
    [PoolData PoolDataIndices]=dataPool(TargetRawData,NumberOfInstances);
    PoolDataFile=sprintf(PoolDataFileType,PoolNumber);
    csvwrite(strcat(OutputFolder,PoolDataFile),horzcat(PoolDataIndices,PoolData));
    TestDataIndices=setdiff(AllIndices,PoolDataIndices);
    TestData=TargetRawData(TestDataIndices,:);
    TestDataFile=sprintf(TestDataFileType,PoolNumber);
    csvwrite(strcat(OutputFolder,TestDataFile),horzcat(TestDataIndices,TestData));
    [RandomPoolData RandomPoolDataIndices]=dataPool(PoolData,NumberOfInstances);
    RandomPoolDataFile=sprintf(RandomPoolDataFileType,PoolNumber);
    ActualPoolDataIndices=PoolDataIndices(RandomPoolDataIndices,:);
    csvwrite(strcat(OutputFolder,RandomPoolDataFile),horzcat(RandomPoolDataIndices,ActualPoolDataIndices,RandomPoolData));
end





