load("F1_E.mat");
load("F1_E_labels.mat");

% Normalize
E_norm = (E_outmat-mean(E_outmat))./(std(E_outmat));
[V, D] = eig(cov(E_norm));

% Scatter 3D and show principal components
vbls = {'pressure', 'vibration', 'temperature'};
[coefs, score, latent,tsquared,explained] = pca(E_norm);

eigvs = zeros(size(D, 1), 1);
for i=1:size(D, 1)
    eigvs(i, 1) = D(size(D, 1)-i+1,size(D, 1)-i+1);
end
plot(eigvs);
xlabel('Component Number','Fontsize',18);
ylabel('Eigenvalue','Fontsize',18);
title('Scree plot for PCA of electrode data','Fontsize',22);
xlim([1 19])
set(gca,'FontSize',13)

clr = [1 0 0; 0 1 0; 0 0 1; 1 1 0; 1 0 1; 0 0 0];

figure()

for i=0:10:50
    scatter3(score(i+1:i+10,1),score(i+1:i+10,2),score(i+1:i+10,3),30,clr(i/10+1, :), 'filled')
    hold on;
end


xlabel('Component 1','Fontsize',18);
ylabel('Component 2','Fontsize',18);
zlabel('Component 3','Fontsize',18);
title('Projection onto 3 components of the electrode data','Fontsize',22);
set(gca,'FontSize',13)
legend('acrylic', 'foam', 'car sponge', 'flour', 'kitchen sponge', 'steel vase','Fontsize',15);



PCA_out = [score E_labels];

save('E_PCA.mat','PCA_out');