acr = importdata('.\PR_CW_DATA_2021\acrylic_211_01_HOLD.mat');
foam = importdata('.\PR_CW_DATA_2021\black_foam_110_03_HOLD.mat');
flour = importdata('.\PR_CW_DATA_2021\flour_sack_410_02_HOLD.mat');



% PVTE_plt(acr, 'Acrylic');
% PVTE_plt(foam, 'Black Foam');
% PVTE_plt(flour, 'Flour sack'); %use timestep sep_idx, good way after the robot has grasped it

sep_idx = 70;

PVT_outmat = [];
E_outmat = [];
myDir = '.\PR_CW_DATA_2021\'; %gets directory
myFiles = dir(fullfile(myDir,'*.mat')); %gets all wav files in struct

names = ['acrylic', 'foam', 'car sponge', 'flour', 'kitchen sponge', 'steel vase'];
labels = [1;2;3;4;5;6];
classes = repelem(labels,[10],[1]);

for k = 1:length(myFiles)
  baseFileName = myFiles(k).name;
  fullFileName = fullfile(myDir, baseFileName);
%   fprintf(1, 'Now reading %s\n', fullFileName);
  curfile = importdata(fullFileName);
  PVT_outmat = [PVT_outmat; curfile.F1pdc(sep_idx) curfile.F1pac(2, sep_idx) curfile.F1tdc(sep_idx)];
  E_outmat = [E_outmat; curfile.F1Electrodes(:, sep_idx)];
  
  %[wavData, Fs] = wavread(fullFileName);
  % all of your actions for filtering and plotting go here
end
PVT_outmat = [PVT_outmat classes];
E_outmat = [E_outmat classes];

save('F1_PVT.mat','PVT_outmat');
save('F1_E.mat','E_outmat');

clr = [1 0 0; 0 1 0; 0 0 1; 1 1 0; 1 0 1; 0 0 0];


cls_col = PVT_outmat(:,4); 


figure()

for i=0:10:50
    scatter3(PVT_outmat(i+1:i+10,1),PVT_outmat(i+1:i+10,2),PVT_outmat(i+1:i+10,3),30,clr(i/10+1, :), 'filled')
    hold on;
end
legend('acrylic', 'foam', 'car sponge', 'flour', 'kitchen sponge', 'steel vase' );
xlabel('Pressure');
ylabel('Vibration');
zlabel('Temperature');





function plt = PVTE_plt(A, str)
    figure()
    subplot(2,2,1)
    plot(A.F1pdc)
    title('Pressure')

    subplot(2,2,2)
    plot(A.F1pac(2, :))
    title('Vibration')

    subplot(2,2,3)
    plot(A.F1tdc)
    title('Temperature')

    subplot(2,2,4)
    plot(A.F1Electrodes(2, :))
    title('Electrode Impedance')
    
    sgtitle(str) 
end