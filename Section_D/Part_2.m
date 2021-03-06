load("E_PCA.mat");

rng(5); % For reproducibility
% rng(3); % For reproducibility


shuffled_PCA = PCA_out(randperm(size(PCA_out, 1)), :);

X_train = shuffled_PCA(1:36,1:3);
Y_train = cellstr(num2str(shuffled_PCA(1:36,20)));
X_test = shuffled_PCA(37:end,1:3);
Y_test = cellstr(num2str(shuffled_PCA(37:end,20)));


tree_model = TreeBagger(100,array2table(X_train),Y_train,'Method','Classification','OOBPredictorImportance','On');


figure
plot(oobError(tree_model))
xlabel('Number of Grown Trees')
ylabel('Out-of-Bag Mean Squared Error')
title('OOB Error vs Number of trees for RF model')


view(tree_model.Trees{1},'mode','graph') % graphic description
view(tree_model.Trees{2},'mode','graph') % graphic description



Y_pred = predict(tree_model,X_test);
C = confusionmat(Y_test, Y_pred);

names = {'acrylic', 'foam', 'car sponge', 'flour', 'kitchen sponge', 'steel vase'};
Conf_tab = array2table(C, 'RowNames', names, 'VariableNames', names);


t = templateTree('Reproducible',true);  % For reproducibility of random predictor selections
tree_model = fitcensemble(X_train,Y_train,'Method','Bag','NumLearningCycles',200,'Learners',t)

figure
plot(loss(tree_model,X_test,Y_test,'mode','cumulative'))
xlabel('Number of trees')
ylabel('Test classification error')
title('Test set error vs number of trees');





%repeating for non-pca data
load("F1_E.mat")

cls = [1;2;3;4;5;6];
E_outmat = [E_outmat repelem(cls,[10],[1])];

shuffled_E = E_outmat(randperm(size(E_outmat, 1)), :);

X_train = shuffled_E(1:36,1:end-1);
Y_train = cellstr(num2str(shuffled_E(1:36,20)));
X_test = shuffled_E(37:end,1:end-1);
Y_test = cellstr(num2str(shuffled_E(37:end,20)));

tree_model = TreeBagger(100,array2table(X_train),Y_train,'Method','Classification','OOBPredictorImportance','On');


figure
plot(oobError(tree_model))
xlabel('Number of Grown Trees')
ylabel('Out-of-Bag Mean Squared Error')
title('OOB Error vs Number of trees for RF model - Electrode data')

figure
bar(tree_model.OOBPermutedPredictorDeltaError)
xlabel('Feature Number') 
ylabel('Out-of-Bag Feature Importance')
title('OOB feature importance(Electrode data)');

Y_pred = predict(tree_model,X_test);
C = confusionmat(Y_test, Y_pred);

names = {'acrylic', 'foam', 'car sponge', 'flour', 'kitchen sponge', 'steel vase'};
Conf_tab_Electrodes = array2table(C, 'RowNames', names, 'VariableNames', names);