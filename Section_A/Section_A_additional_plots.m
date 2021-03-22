acr = importdata('./PR_CW_DATA_2021/acrylic_211_01_HOLD.mat');
foam = importdata('./PR_CW_DATA_2021/black_foam_110_03_HOLD.mat');
flour = importdata('./PR_CW_DATA_2021/flour_sack_410_02_HOLD.mat');

acr_files = dir(fullfile('./PR_CW_DATA_2021/','acrylic*.mat'));
foam_files = dir(fullfile('./PR_CW_DATA_2021/','black_foam*.mat'));
flour_files = dir(fullfile('./PR_CW_DATA_2021/','flour*.mat'));

[data_p_acr, data_v_acr, data_t_acr, data_e_acr] = parse_timeseries(acr_files);
[data_p_foam, data_v_foam, data_t_foam, data_e_foam] = parse_timeseries(foam_files);
[data_p_flour, data_v_flour, data_t_flour, data_e_flour] = parse_timeseries(acr_files);


PVTE_plt(data_p_acr, data_v_acr, data_t_acr, data_e_acr, 'Acrylic');
PVTE_plt(data_p_foam, data_v_foam, data_t_foam, data_e_foam, 'Foam');
PVTE_plt(data_p_flour, data_v_flour, data_t_flour, data_e_flour, 'Flour');

% PVTE_plt(foam, 'Black Foam');
% PVTE_plt(flour, 'Flour sack'); %use timestep sep_idx, good way after the robot has grasped it


function plt = PVTE_plt(data_p, data_v, data_t, data_e, str)
    figure()
    subplot(2,2,1)
    stdshade(data_p)
    title('Pressure')
    xlabel('Timestep')

    subplot(2,2,2)
    stdshade(data_v)
    title('Vibration')
    xlabel('Timestep')

    subplot(2,2,3)
    stdshade(data_t)
    title('Temperature')
    xlabel('Timestep')

    subplot(2,2,4)
    stdshade(data_e)
    title('Electrode Impedance')
    xlabel('Timestep')
    
    sgtitle(str) 
end

function [data_p, data_v, data_t, data_e] = parse_timeseries(dirs)
    data_p = [];
    data_v = [];
    data_t = [];
    data_e = [];
    for k = 1:length(dirs)
      baseFileName = dirs(k).name;
      fullFileName = fullfile('./PR_CW_DATA_2021/', baseFileName);

      curfile = importdata(fullFileName)
      data_p = [data_p; curfile.F1pdc(1, 1:1000)];
      data_v = [data_p; curfile.F1pac(2, 1:1000)];
      data_t = [data_p; curfile.F1tdc(1, 1:1000)];
      data_e = [data_e; curfile.F1Electrodes(2, 1:1000)];
    end
end

% 
% function plt = PVTE_plt(A, str)
%     figure()
%     subplot(2,2,1)
%     plot(A.F1pdc)
%     title('Pressure')
% 
%     subplot(2,2,2)
%     plot(A.F1pac(2, :))
%     title('Vibration')
% 
%     subplot(2,2,3)
%     plot(A.F1tdc)
%     title('Temperature')
% 
%     subplot(2,2,4)
%     plot(A.F1Electrodes(2, :))
%     title('Electrode Impedance')
%     
%     sgtitle(str) 
% end


function [lineOut, fillOut] = stdshade(amatrix,acolor,F,smth)
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
fillOut = fill([F fliplr(F)],[amean+astd fliplr(amean-astd)],acolor, 'FaceAlpha', 0.2,'linestyle','none');

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
