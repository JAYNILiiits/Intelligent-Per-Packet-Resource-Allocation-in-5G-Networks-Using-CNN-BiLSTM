%% 5G NR Network Configuration & Visualization
% This script sets up a slicing-like environment

% Carrier configuration
cfgCarrier = nrCarrierConfig;
cfgCarrier.SubcarrierSpacing = 30;  % kHz
cfgCarrier.NSizeGrid = 273;        % 100 MHz at 30 kHz SCS

% Slice information
sliceNames = {'eMBB','URLLC','mMTC'};
numSlices  = numel(sliceNames);
numUsers   = [50, 20, 100]; % Users per slice

% Slice-specific QoS parameters
Priority    = [3, 1, 2];
Latency     = [20e-3, 1e-3, 100e-3];
Reliability = [0.99, 0.99999, 0.9];

%% 1. User Distribution Visualization
figure;
bar(categorical(sliceNames), numUsers);
xlabel('Slice Type');
ylabel('Number of Users');
title('User Distribution Across Network Slices');
grid on;

%% 2. Bandwidth Allocation Visualization
totalBW = 100e6; % 100 MHz
allocBW = totalBW * (numUsers / sum(numUsers));
figure;
pie(allocBW, sliceNames);
title('Bandwidth Allocation per Slice (Proportional to Users)');

%% 3. QoS Visualization
figure;
scatter(Latency*1e3, Reliability, 200, Priority, 'filled');
text(Latency*1e3, Reliability, sliceNames, ...
    'VerticalAlignment','bottom','HorizontalAlignment','right','FontSize',10);
xlabel('Latency (ms)');
ylabel('Reliability');
title('QoS Characteristics of 5G Slices');
colorbar; ylabel(colorbar,'Slice Priority');
grid on;

%% 4. TDD Frame Structure Example
cfgTDD = nrTDDConfig;
cfgTDD.SlotAllocation = [1 1 0 1 1 0 1 0 1 1]; % DL=1, UL=0
cfgTDD.PatternLength = numel(cfgTDD.SlotAllocation);

figure;
bar(cfgTDD.SlotAllocation, 'FaceColor',[0.3 0.7 0.9]);
set(gca,'xtick',1:cfgTDD.PatternLength, ...
    'xticklabel', string(cfgTDD.SlotAllocation));
xlabel('Slot Index');
ylabel('DL/UL (1=DL,0=UL)');
title('TDD Frame Structure');
grid on;
