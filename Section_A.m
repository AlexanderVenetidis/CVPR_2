acr = importdata('.\PR_CW_DATA_2021\acrylic_211_01_HOLD.mat');
foam = importdata('.\PR_CW_DATA_2021\black_foam_110_03_HOLD.mat');



PVTE_plt(acr, 'Acrylic');
PVTE_plt(foam, 'Black Foam');

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