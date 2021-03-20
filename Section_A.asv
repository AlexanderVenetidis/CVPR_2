acr = importdata('.\PR_CW_DATA_2021\acrylic_211_01_HOLD.mat');
foam = importdata('.\PR_CW_DATA_2021\black_foam_110_03_HOLD.mat');
flour = importdata('.\PR_CW_DATA_2021\flour_sack_410_02_HOLD.mat');



% PVTE_plt(acr, 'Acrylic');
% PVTE_plt(foam, 'Black Foam');
% PVTE_plt(flour, 'Flour sack'); %use timestep 500, good way after the robot has grasped it


PVT_outmat = [];
E_outmat = [];
myDir = '.\PR_CW_DATA_2021\'; %gets directory
myFiles = dir(fullfile(myDir,'*.mat')); %gets all wav files in struct
for k = 1:length(myFiles)
  baseFileName = myFiles(k).name;
  fullFileName = fullfile(myDir, baseFileName);
%   fprintf(1, 'Now reading %s\n', fullFileName);
  curfile = importdata(fullFileName);
  PVT_outmat = [PVT_outmat; curfile.F0pdc(500) curfile.F0pac(2, 500) curfile.F0tdc(500)];
  E_outmat = [E_outmat; curfile.F0Electrodes(2, 500)];
  
  %[wavData, Fs] = wavread(fullFileName);
  % all of your actions for filtering and plotting go here
end

save('F0_PVT.mat','PVT_outmat');
save('F0_E.mat','E_outmat');

clr = ['r' 'g' 'b' 'y' 'k'];
for i = 0:50:10
    scatter3(PVT_outmat(i:i+10,1),PVT_outmat(i:i+10,2),PVT_outmat(i:i+10,3),5,clr(1/10));
    hold on;
end

xlabel('Pressure');
ylabel('Vibration');
zlabel('Temperature');





function plt = PVTE_plt(A, str)
    figure()
    subplot(2,2,1)
    plot(A.F0pdc)
    title('Pressure')

    subplot(2,2,2)
    plot(A.F0pac(2, :))
    title('Vibration')

    subplot(2,2,3)
    plot(A.F0tdc)
    title('Temperature')

    subplot(2,2,4)
    plot(A.F0Electrodes(2, :))
    title('Electrode Impedance')
    
    sgtitle(str) 
end