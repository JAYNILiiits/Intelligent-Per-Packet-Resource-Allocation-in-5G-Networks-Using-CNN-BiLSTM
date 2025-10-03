clc; clear; close all;

%% --------------------------
%% Step 1: Initialize Python ONNX
%% --------------------------
py.importlib.import_module('numpy');
py.importlib.import_module('onnxruntime');

% Mock ONNX session (replace with your actual model)
% ort_session = py.onnxruntime.InferenceSession('intelligent_allocator_optimized.onnx');

%% --------------------------
%% Step 2: Simulation Setup
%% --------------------------
numTTIs = 100;             % simulate 100 ms for demo
numApps = 4;               % 4 application types
B_current = zeros(1, numApps);
performance_metrics = zeros(numTTIs, numApps); % store allocated bandwidth
inference_times = zeros(1, numTTIs);

%% --------------------------
%% Step 3: Real-time loop (mock)
%% --------------------------
for tti = 1:numTTIs
    % --- Mock packet features ---
    numPackets = randi([5, 20]);
    features = rand(numPackets, 10); % 10 header features per packet
    
    % --- Mock ML inference (replace with ONNX inference) ---
    tic;
    % Example: random probabilities for each application
    app_probabilities = rand(1, numApps);
    app_probabilities = app_probabilities / sum(app_probabilities);
    inference_time = toc*1000; % ms
    
    % --- Compute bandwidth requirement ---
    B_req = 100 * app_probabilities; % assume total 100 Mbps available
    
    % --- Feedback control: smooth allocation ---
    alpha = 0.7;
    B_new = alpha*B_current + (1-alpha)*B_req;
    B_current = B_new;
    
    % --- Save performance metrics ---
    performance_metrics(tti,:) = B_new;
    inference_times(tti) = inference_time;
end

%% --------------------------
%% Step 4: Plot results
%% --------------------------

% Bandwidth allocation over time
figure;
plot(1:numTTIs, performance_metrics, 'LineWidth', 2);
xlabel('TTI (ms)'); ylabel('Allocated Bandwidth (Mbps)');
title('Dynamic Bandwidth Allocation per Application');
legend(arrayfun(@(x) sprintf('App %d',x), 1:numApps, 'UniformOutput', false));
grid on;

% Inference time per TTI
figure;
plot(1:numTTIs, inference_times, '-o');
xlabel('TTI (ms)'); ylabel('Inference Time (ms)');
title('ML Inference Latency per TTI');
grid on;

% Final allocation heatmap
figure;
imagesc(performance_metrics'); colorbar;
xlabel('TTI (ms)'); ylabel('Applications');
title('Bandwidth Allocation Heatmap');
yticks(1:numApps); yticklabels(arrayfun(@(x) sprintf('App %d',x),1:numApps,'UniformOutput',false));
grid on;
