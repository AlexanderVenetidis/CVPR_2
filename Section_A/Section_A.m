acr = importdata('./PR_CW_DATA_2021/acrylic_211_01_HOLD.mat');
foam = importdata('./PR_CW_DATA_2021/black_foam_110_03_HOLD.mat');
flour = importdata('./PR_CW_DATA_2021/flour_sack_410_02_HOLD.mat');



PVTE_plt({acr, 'Acrylic';foam, 'Black foam';flour, 'Flour sack'});

% PVTE_plt({});
% PVTE_plt({flour, 'Flour sack'}); %use timestep sep_idx, good way after the robot has grasped it

sep_idx = 35;

PVT_outmat = [];
E_outmat = [];
myDir = './PR_CW_DATA_2021/'; %gets directory
myFiles = dir(fullfile(myDir,'*.mat')); %gets all wav files in struct

names = ['acrylic', 'foam', 'car sponge', 'flour', 'kitchen sponge', 'steel vase'];
labels = [1;2;3;4;5;6];
% classes = repelem(labels,[10],[1]);

for k = 1:length(myFiles)
  baseFileName = myFiles(k).name;
  fullFileName = fullfile(myDir, baseFileName);
%   fprintf(1, 'Now reading %s\n', fullFileName);
  curfile = importdata(fullFileName);
  PVT_outmat = [PVT_outmat; curfile.F1pdc(sep_idx) curfile.F1pac(2, sep_idx) curfile.F1tdc(sep_idx)];
  E_outmat = [E_outmat curfile.F1Electrodes(:, sep_idx)];
  
  %[wavData, Fs] = wavread(fullFileName);
  % all of your actions for filtering and plotting go here
end
E_outmat = E_outmat';
PVT_outmat = [PVT_outmat repelem(labels,[10],[1])];

save('F1_PVT.mat','PVT_outmat');
save('F1_E.mat','E_outmat');
E_labels = repelem(labels,[10],[1]);
save('F1_E_labels.mat', 'E_labels');

clr = [1 0 0; 0 1 0; 0 0 1; 1 1 0; 1 0 1; 0 0 0];


cls_col = PVT_outmat(:,4); 


figure()

for i=0:10:50
    scatter3(PVT_outmat(i+1:i+10,1),PVT_outmat(i+1:i+10,2),PVT_outmat(i+1:i+10,3),30,clr(i/10+1, :), 'filled');
%     scatter(PVT_outmat(i+1:i+10,1),PVT_outmat(i+1:i+10,3),30,clr(i/10+1, :), 'filled');
    set(gca,'fontsize',17)
    hold on;
end
legend('acrylic', 'foam', 'car sponge', 'flour', 'kitchen sponge', 'steel vase' );
xlabel('Pressure','Fontsize',17);
ylabel('Vibration','Fontsize',17);
zlabel('Temperature','Fontsize',17);
title('PVT plot at timestep 35','Fontsize',22);





function plt = PVTE_plt(some_mat)
    for i=1:size(some_mat,1)  
        A = some_mat{i,1};
        
        
        figure(1)
        ax1 = subplot(2,2,1);
        plot(ax1, A.F1pdc, 'Tag', 'tl')
        hold on;
        title('Pressure','Fontsize',32)
        set(gca,'fontsize',22)

        ax2 = subplot(2,2,2);
        plot(ax2, A.F1pac(2, :),'Tag','tr')
        hold on;
        title('Vibration','Fontsize',32)
        set(gca,'fontsize',22)

        ax3 = subplot(2,2,3);
        plot(ax3, A.F1tdc, 'Tag', 'bl')
        hold on;
        title('Temperature','Fontsize',32)
        set(gca,'fontsize',22)

        ax4 = subplot(2,2,4);
        plot(ax4, A.F1Electrodes(2, :)' , 'Tag', 'br')
        hold on;
        title('Electrode Impedance','Fontsize',32)
        set(gca,'fontsize',22)
        
        
        hold on;
    end

    legend(ax1, some_mat{:,2});
%     sgtitle(tit);

    
    
end