load("E_PCA.mat");

rng(1); % For reproducibility

shuffled_PCA = PCA_out(randperm(size(PCA_out, 1)), :);

X_train = shuffled_PCA(1:36,1:end-1);
Y_train = cellstr(num2str(shuffled_PCA(1:36,20)));
X_test = shuffled_PCA(37:end,1:end-1);
Y_test = cellstr(num2str(shuffled_PCA(37:end,20)));

% t = templateTree('Reproducible',true);  % For reproducibility of random predictor selections
% tree_model = fitcensemble(X_train,Y_train,'Method','Bag','NumLearningCycles',200,'Learners',t)

% figure
% plot(loss(tree_model,X_test,Y_test,'mode','cumulative'))
% xlabel('Number of trees')
% ylabel('Test classification error')

tree_model = TreeBagger(150,array2table(X_train),Y_train,'Method','Classification','OOBPredictorImportance','On');

figure
plot(loss(tree_model,X_test,Y_test,'mode','cumulative'))
xlabel('Number of trees')
ylabel('Test classification error')

figure
plot(oobError(tree_model))
xlabel('Number of Grown Trees')
ylabel('Out-of-Bag Mean Squared Error')

% figure
% bar(tree_model.OOBPermutedPredictorDeltaError)
% xlabel('Feature Number') 
% ylabel('Out-of-Bag Feature Importance')

% view(tree_model.Trees{1},'mode','graph') % graphic description
% view(tree_model.Trees{2},'mode','graph') % graphic description



Y_pred = predict(tree_model,X_test);
C = confusionmat(Y_test, Y_pred);

names = {'acrylic', 'foam', 'car sponge', 'flour', 'kitchen sponge', 'steel vase'};
C_tab = array2table(C, 'RowNames', names, 'VariableNames', names);

