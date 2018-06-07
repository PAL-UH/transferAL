function [Model]=train_with_MNN(Data,Labels,NumberOfHiddenNodes)
Number_Of_Examples=length(Data(:,1));
DataClasses=unique(Labels);
NumberOfDataClasses=length(DataClasses);
LabelsForNN=zeros(Number_Of_Examples,NumberOfDataClasses);
for ClassNumber=1:NumberOfDataClasses
    IndicesForThisClass=find(Labels==DataClasses(ClassNumber));
    LabelsForNN(IndicesForThisClass,ClassNumber)=1;
end

inputs = Data';
targets = LabelsForNN';

% Create a Pattern Recognition Network
hiddenLayerSize = round(NumberOfHiddenNodes);
net = patternnet((hiddenLayerSize));
% if Setwb~=[]
%     net = setwb(net,wb) ;
% end


% Set up Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 30/100;
net.divideParam.testRatio = 0/100;

% Train the Network
net.trainParam.max_fail=20;
[net,tr] = train(net,inputs,targets);
Model=net;
% if Setwb==[]
%     Gotwb = getwb(net)
% else
%     Gotwb=[];
% end

% Test the Network


%outputs = net(inputs);
%errors = gsubtract(targets,outputs);
%performance = perform(net,targets,outputs);

% iteration=0;
% %performance_error_margin=performance;
% previous_five_performance=1;
% previous_four_performance=1;
% previous_three_performance=1;
% previous_two_performance=1;
% previous_one_performance=performance;
% performance_error_margin=previous_five_performance-previous_one_performance;
% %previous_performance=ones(5,1);
% while abs(performance_error_margin)>0.002
%     
%     iteration=iteration+1;
%     if (iteration>5)
%         previous_five_performance=previous_four_performance;
%     end
%     if (iteration>4)
%         previous_four_performance=previous_three_performance;
%         end
%     if (iteration>3)
%         previous_three_performance=previous_two_performance;
%     end
%     if (iteration>2)
%         previous_two_performance=previous_one_performance;
%     end
%     if (iteration>1)
%         previous_one_performance=performance;
%     end
%     %previous_performance=performance;
%     [net,tr] = train(net,inputs,targets);
%     outputs = net(inputs);
%     performance = perform(net,targets,outputs);
%     performance_error_margin=previous_five_performance-previous_one_performance;
%     
% end