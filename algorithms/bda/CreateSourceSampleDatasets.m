clc
clear all
close all
InputFolder='';
OutputFolder='';
SourceInputFile='Target_Pool_1.csv';%Insert Data file
StartingColumn=1;
SourceRawData= csvread(strcat(InputFolder,SourceInputFile));
[SourceRawDataRows SourceDataRawCols]=size(SourceRawData);
SourceData=SourceRawData(:,StartingColumn:SourceDataRawCols-1);
SourceLabels=SourceRawData(:,SourceDataRawCols);
[SourceDataRows SourceDataCols]=size(SourceData);


SampleDataFileType='Source_Sample_Dataset_%d.csv';%Insert Sample file name
SamplePercentages=80;
NumberOfSampleDatasets=100;
NumberOfSamples=floor(SourceRawDataRows*(SamplePercentages/100));
DisplayString='SamplePercentage = %d , DatasetNumber= %d';
tic
for SamplePercentageNumber=1:length(SamplePercentages)
    for SampleNumber=1:NumberOfSampleDatasets
        %Create Sample datasets
        SamplePercentage=SamplePercentages(1,SamplePercentageNumber);
        display(sprintf(DisplayString,SamplePercentage,SampleNumber));
        [SampleData SampleDataIndices]=datasample(SourceRawData,NumberOfSamples(1,SamplePercentageNumber),'Replace',false);
        SampleDataFile=sprintf(SampleDataFileType,SamplePercentage,SampleNumber);
        csvwrite(strcat(OutputFolder,SampleDataFile),SampleData);
    end
    
end
t=toc



