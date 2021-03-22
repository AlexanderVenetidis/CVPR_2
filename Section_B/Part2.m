load("F1_E.mat");
load("F1_E_labels.mat");

% Normalize
E_norm = (E_outmat-mean(E_outmat))./(std(E_outmat));

% Scatter 3D and show principal components
vbls = {'pressure', 'vibration', 'temperature'};
[coefs, score, latent,tsquared,explained] = pca(E_norm);

plot(explained);

% 
% % biplot(V, 'Scores', D);
% 
% hold off; scatter3(PVT_norm(:, 1),PVT_norm(:, 2),PVT_norm(:, 3)); hold on;
% X_avg = mean(PVT_norm);
% plot3([X_avg(1) X_avg(1)+V(1,1)] , [X_avg(2) X_avg(2)+V(2,1)], [X_avg(3) X_avg(3)+V(3,1)]);
% plot3([X_avg(1) X_avg(1)+V(1,2)] , [X_avg(2) X_avg(2)+V(2,2)], [X_avg(3) X_avg(3)+V(3,2)]);
% plot3([X_avg(1) X_avg(1)+V(1,3)] , [X_avg(2) X_avg(2)+V(2,3)], [X_avg(3) X_avg(3)+V(3,3)]);
% xlim([min(PVT_norm(:, 1)), max(PVT_norm(:, 1))])
% ylim([min(PVT_norm(:, 2)), max(PVT_norm(:, 2))])
% zlim([min(PVT_norm(:, 3)), max(PVT_norm(:, 3))])
% hold off;
% 
% % Reducing to order 2
scatter3(score(:,1), score(:,2), score(:,3), E_labels)


clr = [1 0 0; 0 1 0; 0 0 1; 1 1 0; 1 0 1; 0 0 0];

figure()

for i=0:10:50
    scatter3(score(i+1:i+10,1),score(i+1:i+10,2),score(i+1:i+10,3),30,clr(i/10+1, :), 'filled')
    hold on;
end
% 
% subplot(3,1,1);
% s = scatter(score(:, 1), 0, 30, 'b','+', 'MarkerFaceAlpha', 0.5);
% title("Scores for Principal Component 1")
% 
% subplot(3,1,2);
% 
% scatter(score(:, 2), 0, 30, 'b','+', 'MarkerFaceAlpha', 0.5);
% title("Scores for Principal Component 2")
% 
% subplot(3,1,3);
% 
% scatter(score(:, 3), 0, 30, '+','b', 'MarkerFaceAlpha', 0.5);
% title("Scores for Principal Component 3")

% explained


PCA_out = [score E_labels];

save('E_PCA.mat','PCA_out');