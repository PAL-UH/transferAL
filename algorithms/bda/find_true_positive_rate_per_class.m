function [TruePostives]=find_true_positive_rate_per_class(TrueLabels,PredictedLabels);
AllClasses=unique(TrueLabels);
NumClasses=length(AllClasses);
TruePostives=zeros(1,NumClasses*2);

ColShift=NumClasses;
for ClassNumber=1:NumClasses
	Class=AllClasses(ClassNumber,1);
	TrueLabelIndicesMatchingClass=find(TrueLabels==Class);
	PredictedLabelIndicesMatchingClass=find(PredictedLabels==Class);
	NumIncorrectlyClassifedForThisClass=length(setdiff(TrueLabelIndicesMatchingClass,PredictedLabelIndicesMatchingClass));
	NumCorrectlyClassifedForThisClass=length(TrueLabelIndicesMatchingClass)-NumIncorrectlyClassifedForThisClass;
    TPRateForThisClass=NumCorrectlyClassifedForThisClass/length(TrueLabelIndicesMatchingClass);
	TruePostives(1,ClassNumber)=NumCorrectlyClassifedForThisClass;
	TruePostives(1,ClassNumber+ColShift)=TPRateForThisClass;
end