acr = importdata('./PR_CW_DATA_2021/acrylic_211_01_HOLD.mat');
foam = importdata('./PR_CW_DATA_2021/black_foam_110_03_HOLD.mat');
flour = importdata('./PR_CW_DATA_2021/flour_sack_410_02_HOLD.mat');

PVTE_plt(acr, 'Acrylic');
PVTE_plt(foam, 'Black Foam');
PVTE_plt(flour, 'Flour sack'); %use timestep sep_idx, good way after the robot has grasped it

sep_idx = 35;

PVT_outmat = [];
E_outmat = [];
myDir = './PR_CW_DATA_2021/';
myFiles = dir(fullfile(myDir,'*.mat'));

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

    
    sgtitle(str) 
end


function [lineOut, fillOut] = stdshade(amatrix,alpha,acolor,F,smth)
% usage: stdshading(amatrix,alpha,acolor,F,smth)
% plot mean and sem/std coming from a matrix of data, at which each row is an
% observation. sem/std is shown as shading.
% - acolor defines the used color (default is red) 
% - F assignes the used x axis (default is steps of 1).
% - alpha defines transparency of the shading (default is no shading and black mean line)
% - smth defines the smoothing factor (default is no smooth)
% smusall 2010/4/23
if exist('acolor','var')==0 || isempty(acolor)
    acolor='r'; 
end
if exist('F','var')==0 || isempty(F)
    F=1:size(amatrix,2);
end
if exist('smth','var'); if isempty(smth); smth=1; end
else smth=1; %no smoothing by default
end  
if ne(size(F,1),1)
    F=F';
end
amean = nanmean(amatrix,1); %get man over first dimension
if smth > 1
    amean = boxFilter(nanmean(amatrix,1),smth); %use boxfilter to smooth data
end
astd = nanstd(amatrix,[],1); % to get std shading
% astd = nanstd(amatrix,[],1)/sqrt(size(amatrix,1)); % to get sem shading
if exist('alpha','var')==0 || isempty(alpha) 
    fillOut = fill([F fliplr(F)],[amean+astd fliplr(amean-astd)],acolor,'linestyle','none');
    acolor='k';
else
    fillOut = fill([F fliplr(F)],[amean+astd fliplr(amean-astd)],acolor, 'FaceAlpha', alpha,'linestyle','none');
end
if ishold==0
    check=true; else check=false;
end
hold on;
lineOut = plot(F,amean, 'color', acolor,'linewidth',1.5); %% change color or linewidth to adjust mean line
if check
    hold off;
end
end
function dataOut = boxFilter(dataIn, fWidth)
% apply 1-D boxcar filter for smoothing
fWidth = fWidth - 1 + mod(fWidth,2); %make sure filter length is odd
dataStart = cumsum(dataIn(1:fWidth-2),2);
dataStart = dataStart(1:2:end) ./ (1:2:(fWidth-2));
dataEnd = cumsum(dataIn(length(dataIn):-1:length(dataIn)-fWidth+3),2);
dataEnd = dataEnd(end:-2:1) ./ (fWidth-2:-2:1);
dataOut = conv(dataIn,ones(fWidth,1)/fWidth,'full');
dataOut = [dataStart,dataOut(fWidth:end-fWidth+1),dataEnd];
end
