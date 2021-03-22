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

opts = statset('Display','final');
[idx,C] = kmeans(PVT_outmat(:, 1:3),6,'Replicates',5,'Options',opts);
[idx_cb,C] = kmeans(PVT_outmat(:, 1:3),6,'Distance','cityblock','Replicates',5,'Options',opts);


figure;
subplot(1,2,1);

scatter3(PVT_outmat(:,1), PVT_outmat(:,2), PVT_outmat(:,3), 15, idx, 'filled');

subplot(1,2,2);

scatter3(PVT_outmat(:,1), PVT_outmat(:,2), PVT_outmat(:,3), 15, idx_cb, 'filled');
