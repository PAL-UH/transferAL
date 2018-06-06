function [Precisions]=find_precision_rate_per_class(TrueLabels,PredictedLabels)
AllClasses=unique(TrueLabels);
NumClasses=length(AllClasses);
Precisions=zeros(1,NumClasses*3);

ColShift=NumClasses;
for ClassNumber=1:NumClasses
	Class=AllClasses(ClassNumber,1);
	TrueLabelIndicesMatchingClass=find(TrueLabels==Class);
	PredictedLabelIndicesMatchingClass=find(PredictedLabels==Class);
	NumTruePositives=length(intersect(PredictedLabelIndicesMatchingClass,TrueLabelIndicesMatchingClass));
    NumFalsePositives=length(setdiff(PredictedLabelIndicesMatchingClass,TrueLabelIndicesMatchingClass));
    PrecisionForThisClass=NumTruePositives/(NumTruePositives+NumFalsePositives);
	Precisions(1,ClassNumber)=NumTruePositives;
    Precisions(1,+ColShift)=NumFalsePositives;
	Precisions(1,ClassNumber+(2*ColShift))=PrecisionForThisClass;
end