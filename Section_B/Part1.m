load("F1_PVT.mat");

% Get cov matrix, etc.
PVT_data = PVT_outmat(:,1:3);
C = cov(PVT_data)
[V,D] = eig(C)

% Normalize
PVT_norm = (PVT_data-mean(PVT_data))./(std(PVT_data));

% Scatter 3D and show principal components
vbls = {'pressure', 'vibration', 'temperature'};
[coefs, score, latent,tsquared,explained] = pca(PVT_norm);
% biplot(V, 'Scores', D);
figure()

for i=0:10:50
    scatter3(PVT_norm(i+1:i+10,1),PVT_norm(i+1:i+10,2),PVT_norm(i+1:i+10,3),30,clr(i/10+1, :), 'filled')
    hold on;
end

xlabel('Pressure');
ylabel('Vibration');
zlabel('Temperature');

X_avg = mean(PVT_norm);
plot3([X_avg(1) X_avg(1)+V(1,1)] , [X_avg(2) X_avg(2)+V(2,1)], [X_avg(3) X_avg(3)+V(3,1)],'LineWidth',3);
plot3([X_avg(1) X_avg(1)+V(1,2)] , [X_avg(2) X_avg(2)+V(2,2)], [X_avg(3) X_avg(3)+V(3,2)],'LineWidth',3);
plot3([X_avg(1) X_avg(1)+V(1,3)] , [X_avg(2) X_avg(2)+V(2,3)], [X_avg(3) X_avg(3)+V(3,3)],'LineWidth',3);
xlim([min(PVT_norm(:, 1)), max(PVT_norm(:, 1))])
ylim([min(PVT_norm(:, 2)), max(PVT_norm(:, 2))])
zlim([min(PVT_norm(:, 3)), max(PVT_norm(:, 3))])
legend('acrylic', 'foam', 'car sponge', 'flour', 'kitchen sponge', 'steel vase', 'PC 1', 'PC 2', 'PC 3');
hold off;
% 
% % Reducing to order 2
% scatter1= biplot(coefs(:, 1:2),'scores',score(:,1:2),'varlabels',vbls,'MarkerSize',13);
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
% 
% explained