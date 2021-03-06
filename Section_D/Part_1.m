load("F1_PVT.mat")
% 

% Evaluate optimal number of clusters
X = PVT_outmat(:,1:3);
[m,~]=size(X); %getting the number of samples
ToTest=15;
Cutoff=0.95;
Repeats=3;
%unit-normalize
MIN=min(X); MAX=max(X);
X=(X-MIN)./(MAX-MIN);
D=zeros(ToTest,1); %initialize the results matrix
for c=1:ToTest %for each sample
    [~,~,dist]=kmeans(X,c,'emptyaction','drop'); %compute the sum of intra-cluster distances
    tmp=sum(dist); %best so far
    
    for cc=2:Repeats %repeat the algo
        [~,~,dist]=kmeans(X,c,'emptyaction','drop');
        tmp=min(sum(dist),tmp);
    end
    D(c,1)=tmp; %collect the best so far in the results vecor
end
Var=D(1:end-1)-D(2:end); %calculate %variance explained
PC=cumsum(Var)/(D(1)-D(end));
[r,~]=find(PC>Cutoff); %find the best index
K=1+r(1,1); %get the optimal number of clusters
[IDX,C,SUMD]=kmeans(X,K); %now rerun one last time with the optimal number of clusters
C=C.*(MAX-MIN)+MIN;

plot(D)
xlabel('Number of clusters','Fontsize',18);
ylabel('Sum of point-centroid distances','Fontsize',18);
title('Elbow point plot for PVT data clustering','Fontsize',22);
xlim([1 15])


opts = statset('Display','final');
[idx,C] = kmeans(PVT_outmat(:, 1:3),6,'Replicates',5,'Options',opts);
[idx_cb,C] = kmeans(PVT_outmat(:, 1:3),6,'Distance','cityblock','Replicates',5,'Options',opts);


figure;
subplot(2,1,1);

scatter3(PVT_outmat(:,1), PVT_outmat(:,2), PVT_outmat(:,3), 15, idx, 'filled');
title('K-means clusters (Euclidian distance)', 'Fontsize', 28)
xlabel('Pressure','FontSize',15)
ylabel('Vibration','FontSize',15)
zlabel('Temperature','FontSize',15)
set(gca,'FontSize',13)
subplot(2,1,2);
scatter3(PVT_outmat(:,1), PVT_outmat(:,2), PVT_outmat(:,3), 15, idx_cb, 'filled');
title('K-means clusters (Manhattan distance)', 'Fontsize', 28)
xlabel('Pressure','FontSize',15)
ylabel('Vibration','FontSize',15)
zlabel('Temperature','FontSize',15)
set(gca,'FontSize',13)

