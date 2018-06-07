function [acc_lst, std_lst] = main(Xsrc, Ysrc, targetData, optionsTJM, optionsJDA, optionsARTL)
    acc_lst = zeros(1,4);
    std_lst = zeros(1,4);
    acc_lst_GFK = zeros(1,10);
    acc_lst_TJM = zeros(1,10);
    acc_lst_JDA = zeros(1,10);
    acc_lst_ARTL = zeros(1,10);

   [samples] = randomSampling(targetData);
    
    % Geodesic Flow Kernel
    for i = 1:10
        if size(targetData, 1) < 1000
            temp = samples{i};
            Xtar = temp(:, 1:3);
            Ytar = temp(:, 4);
        else
            temp = samples{i};
            Xtar = temp(:, 1:20);
            Ytar = temp(:, 21);
        end
        [acc_GFK, ~] = GFK(Xsrc, Ysrc, Xtar, Ytar, 0);
        acc_lst_GFK(i) = acc_GFK;
    end
        acc_lst(1) = mean(acc_lst_GFK);
        std_lst(1) = std(acc_lst_GFK);
    
  [samples] = randomSampling(targetData);
   
   % Transfer Joint Matching
   for i = 1:10
       if size(targetData, 1) < 1000
            temp = samples{i};
            Xtar = temp(:, 1:3);
            Ytar = temp(:, 4);
            optionsTJM.dim = 3;
        else
            temp = samples{i};
            Xtar = temp(:, 1:20);
            Ytar = temp(:, 21);
            optionsTJM.dim = 20;
        end
        [acc_TJM, ~] = TJM(Xsrc, Ysrc, Xtar, Ytar, optionsTJM);
        acc_lst_TJM(i) = acc_TJM;
    end
        acc_lst(2) = mean(acc_lst_TJM);
        std_lst(2) = std(acc_lst_TJM);
        
    [samples] = randomSampling(targetData);
    
    % Join Distribution Alignment
    for i = 1:10
       if size(targetData, 1) < 1000
            temp = samples{i};
            Xtar = temp(:, 1:3);
            Ytar = temp(:, 4);
            optionsJDA.dim = 3;
        else
            temp = samples{i};
            Xtar = temp(:, 1:20);
            Ytar = temp(:, 21);
            optionsJDA.dim = 20;
        end
        [acc_JDA, ~] = JDA(Xsrc, Ysrc, Xtar, Ytar, optionsJDA);
        acc_lst_JDA(i) = acc_JDA;
    end
        acc_lst(3) = mean(acc_lst_JDA);
        std_lst(3) = std(acc_lst_JDA);

    [samples] = randomSampling(targetData);
    
    % Adaptation Regularization
    for i = 1:10
        if size(targetData, 1) < 1000
            temp = samples{i};
            Xtar = temp(:, 1:3);
            Ytar = temp(:, 4);
        else
            temp = samples{i};
            Xtar = temp(:, 1:20);
            Ytar = temp(:, 21);
        end
        [acc_ARTL, ~] = ARTL(Xsrc, Ysrc, Xtar, Ytar, optionsARTL);
        acc_lst_ARTL(i) = acc_ARTL;
    end
        acc_lst(4) = mean(acc_lst_ARTL);
        std_lst(4) = std(acc_lst_ARTL);
end

function [samples] = randomSampling(data)
    samples = cell(10, 1);
    nSample = size(data,1) / 2;
    
    for j = 1:10
        data = data(randperm(size(data, 1)), :);
        rndIDX = randi(size(data, 1), nSample, 1);
        dataSample  = data(rndIDX, :);
        samples{j} = dataSample; 
    end
end