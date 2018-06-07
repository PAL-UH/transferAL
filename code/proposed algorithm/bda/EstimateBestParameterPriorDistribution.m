clc
clear all
close all

SourceInputFolder='';
SourceOutputFolder='';
SamplePercentage=80;

NumberOfSampleDatasets=100;

SourceParameterRange=2:50;
SourceInputResultsFileType='Source_Results_Sample_Dataset_%d.csv';
SourceHistorgramFileName='Source_Best_Accuracy_Parameters_Histogram';
SourcePlotFileName='Source_Best_Accuracy_Parameters_Distribution';
BestSourceParameters='BestSourcePrecisionParameters.xlsx';

AllSourceAccuracy=zeros(length(SourceParameterRange),NumberOfSampleDatasets+1);
AllSourceAccuracy(:,1)=(SourceParameterRange)';
%AllSourceAUC=zeros(length(SourceParameterRange),NumberOfSampleDatasets+1);
%AllSourceAUC(:,1)=(SourceParameterRange)';
AllSourceTPRate=zeros(length(SourceParameterRange),NumberOfSampleDatasets+1);
AllSourceTPRate(:,1)=(SourceParameterRange)';
AllSourcePrecision=zeros(length(SourceParameterRange),NumberOfSampleDatasets+1);
AllSourcePrecision(:,1)=(SourceParameterRange)';

tic

for SampleNumber=1:NumberOfSampleDatasets
    SourceInputResultsFile=sprintf(SourceInputResultsFileType,SampleNumber);
    SourceInputData=csvread(strcat(SourceInputFolder,SourceInputResultsFile));
    
    AllSourceAccuracy(:,SampleNumber+1)=SourceInputData(:,2);
    %AllSourceAUC(:,SampleNumber+1)=SourceInputData(:,3);
    AllSourceTPRate(:,SampleNumber+1)=SourceInputData(:,6);
    AllSourcePrecision(:,SampleNumber+1)=SourceInputData(:,12);
    
end

tp2 = toc

[MaxSourceAccuracyValue MaxSourceAccuracyIndex]=max(AllSourceAccuracy(:,2:end));
[MaxSourceTPRateValue MaxSourceTPRateIndex]=max(AllSourceTPRate(:,2:end));
%[MaxSourceAUCValue MaxSourceAUCIndex]=max(AllSourceAUC(:,2:end));
[MaxSourcePrecisionValue MaxSourcePrecisionIndex]=max(AllSourcePrecision(:,2:end));

display('Source Analysis Done');

figure
set(gca,'fontsize',18)
hold on
hist(MaxSourceAccuracyIndex)
title('Histogram of parameters with Best Accuracy of Landmine Source Data')
xlabel('Parameter : Number Of Nodes of the Hidden layer of MNN');
ylabel('Frequency');
saveas(gcf, strcat(SourceOutputFolder,SourceHistorgramFileName),'pdf');

figure
set(gca,'fontsize',18)
hold on
[mu,sigma] = normfit(MaxSourceAccuracyIndex)
Y = normpdf(SourceParameterRange,mu,sigma);
plot(SourceParameterRange,Y);
title('Distribution of parameters with Best Accuracy of Landmine Source Data')
xlabel('Parameter : Number Of Nodes of the Hidden layer of MNN');
ylabel('Probability');
saveas(gcf, strcat(SourceOutputFolder,SourcePlotFileName),'pdf');
csvwrite(strcat(SourceOutputFolder,'Priors_BasedOnMaxAccuracy.csv'),horzcat(SourceParameterRange',Y'));
csvwrite(strcat(SourceOutputFolder,'BestPriorsMean.csv'),mu);
csvwrite(strcat(SourceOutputFolder,'BestPriorsStandardDeviation.csv'),sigma);

