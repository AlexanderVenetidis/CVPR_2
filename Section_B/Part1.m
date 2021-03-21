load("F0_PVT.mat");

% Get cov matrix, etc.
C = cov(PVT_outmat);
[V,D] = eig(C);

% Normalize
PVT_norm = (PVT_outmat-mean(PVT_outmat))./(std(PVT_outmat));

% Scatter 3D and show principal components
vbls = {'pressure', 'vibration', 'temperature'};
[coefs, score, latent,tsquared,explained] = pca(PVT_norm);
% biplot(V, 'Scores', D);

hold off; scatter3(PVT_norm(:, 1),PVT_norm(:, 2),PVT_norm(:, 3)); hold on;
X_avg = mean(PVT_norm);
plot3([X_avg(1) X_avg(1)+V(1,1)] , [X_avg(2) X_avg(2)+V(2,1)], [X_avg(3) X_avg(3)+V(3,1)]);
plot3([X_avg(1) X_avg(1)+V(1,2)] , [X_avg(2) X_avg(2)+V(2,2)], [X_avg(3) X_avg(3)+V(3,2)]);
plot3([X_avg(1) X_avg(1)+V(1,3)] , [X_avg(2) X_avg(2)+V(2,3)], [X_avg(3) X_avg(3)+V(3,3)]);
xlim([min(PVT_norm(:, 1)), max(PVT_norm(:, 1))])
ylim([min(PVT_norm(:, 2)), max(PVT_norm(:, 2))])
zlim([min(PVT_norm(:, 3)), max(PVT_norm(:, 3))])
hold off;

% Reducing to order 2
scatter1= biplot(coefs(:, 1:2),'scores',score(:,1:2),'varlabels',vbls,'MarkerSize',13);

subplot(3,1,1);
s = scatter(score(:, 1), 0, 30, 'b','+', 'MarkerFaceAlpha', 0.5);
title("Scores for Principal Component 1")

subplot(3,1,2);

scatter(score(:, 2), 0, 30, 'b','+', 'MarkerFaceAlpha', 0.5);
title("Scores for Principal Component 2")

subplot(3,1,3);

scatter(score(:, 3), 0, 30, '+','b', 'MarkerFaceAlpha', 0.5);
title("Scores for Principal Component 3")

explained