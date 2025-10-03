% Figure 3: CDL-A Channel Impulse Response and Multipath Characteristics
function generateFigure3()
    % 3GPP CDL-A Channel Model Parameters
    cdl_a_delays_ns = [0, 10, 20, 30, 40, 50, 60, 70, 90];  % 9 taps
    cdl_a_powers_db = [0, -1.2, -1.0, -1.8, -0.6, -1.8, -5.4, -7.3, -12.0];
    
    % Convert to linear scale and normalize
    cdl_a_powers_linear = 10.^(cdl_a_powers_db / 10);
    cdl_a_powers_normalized = cdl_a_powers_linear / sum(cdl_a_powers_linear);
    
    % Calculate channel statistics
    mean_excess_delay = sum(cdl_a_powers_normalized .* cdl_a_delays_ns);
    rms_delay_spread = sqrt(sum(cdl_a_powers_normalized .* ...
                           (cdl_a_delays_ns - mean_excess_delay).^2));
    total_delay_spread = cdl_a_delays_ns(end) - cdl_a_delays_ns(1);
    coherence_bandwidth = 1 / (2 * pi * rms_delay_spread * 1e-9) / 1e6;  % MHz
    
    % Create figure with subplots
    figure('Position', [100, 100, 1200, 900]);
    
    % Top subplot: Power Delay Profile
    subplot(2, 1, 1);
    stem(cdl_a_delays_ns, cdl_a_powers_db, 'LineWidth', 3, 'MarkerSize', 10, ...
         'MarkerFaceColor', 'blue', 'Color', 'blue');
    hold on;
    
    % Add tap labels
    for i = 1:length(cdl_a_delays_ns)
        text(cdl_a_delays_ns(i), cdl_a_powers_db(i) + 0.8, ...
             sprintf('Tap %d', i), 'HorizontalAlignment', 'center', ...
             'FontSize', 9, 'FontWeight', 'bold', 'Color', 'red');
    end
    
    % Add statistics annotations
    text(55, -1, sprintf('RMS Delay Spread: %.1f ns', rms_delay_spread), ...
         'FontSize', 11, 'BackgroundColor', 'white', 'EdgeColor', 'black', ...
         'FontWeight', 'bold');
    text(55, -3, sprintf('Mean Excess Delay: %.1f ns', mean_excess_delay), ...
         'FontSize', 11, 'BackgroundColor', 'white', 'EdgeColor', 'black', ...
         'FontWeight', 'bold');
    text(55, -5, sprintf('Total Delay Spread: %d ns', total_delay_spread), ...
         'FontSize', 11, 'BackgroundColor', 'white', 'EdgeColor', 'black', ...
         'FontWeight', 'bold');
    text(55, -7, sprintf('Coherence BW: %.1f MHz', coherence_bandwidth), ...
         'FontSize', 11, 'BackgroundColor', 'white', 'EdgeColor', 'black', ...
         'FontWeight', 'bold');
    
    % Formatting for top subplot
    grid on; grid minor;
    xlabel('Delay (ns)', 'FontSize', 12, 'FontWeight', 'bold');
    ylabel('Relative Power (dB)', 'FontSize', 12, 'FontWeight', 'bold');
    title('Power Delay Profile', 'FontSize', 14, 'FontWeight', 'bold');
    xlim([-5, 95]);
    ylim([-15, 2]);
    set(gca, 'FontSize', 11);
    
    % Bottom subplot: Channel Impulse Response
    subplot(2, 1, 2);
    
    % Create continuous time axis for smooth visualization
    time_ns = 0:0.5:100;
    impulse_response = zeros(size(time_ns));
    
    % Add impulses at tap locations
    for i = 1:length(cdl_a_delays_ns)
        [~, idx] = min(abs(time_ns - cdl_a_delays_ns(i)));
        impulse_response(idx) = sqrt(cdl_a_powers_normalized(i));
    end
    
    % Plot impulse response
    plot(time_ns, impulse_response, 'b-', 'LineWidth', 2);
    hold on;
    
    % Highlight individual taps with stems
    stem(cdl_a_delays_ns, sqrt(cdl_a_powers_normalized), 'r', ...
         'LineWidth', 3, 'MarkerSize', 8, 'MarkerFaceColor', 'red');
    
    % Add delay spread indication
    delay_spread_height = max(sqrt(cdl_a_powers_normalized)) * 1.2;
    area([0, cdl_a_delays_ns(end)], [delay_spread_height, delay_spread_height], ...
         0, 'FaceColor', 'yellow', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
    text(45, delay_spread_height * 0.7, ...
         sprintf('Delay Spread = %d ns', total_delay_spread), ...
         'HorizontalAlignment', 'center', 'FontSize', 12, ...
         'FontWeight', 'bold', 'BackgroundColor', 'yellow');
    
    % Add RMS delay spread indicator
    line([mean_excess_delay, mean_excess_delay], [0, delay_spread_height], ...
         'Color', 'magenta', 'LineWidth', 2, 'LineStyle', '--');
    text(mean_excess_delay + 5, delay_spread_height * 0.9, ...
         sprintf('Mean Excess\nDelay: %.1f ns', mean_excess_delay), ...
         'FontSize', 10, 'Color', 'magenta', 'FontWeight', 'bold');
    
    % Formatting for bottom subplot
    grid on; grid minor;
    xlabel('Time (ns)', 'FontSize', 12, 'FontWeight', 'bold');
    ylabel('Normalized Amplitude', 'FontSize', 12, 'FontWeight', 'bold');
    title('Channel Impulse Response', 'FontSize', 14, 'FontWeight', 'bold');
    xlim([0, 100]);
    ylim([0, delay_spread_height * 1.3]);
    set(gca, 'FontSize', 11);
    
    % Add legend for bottom subplot
    legend({'Impulse Response', 'Individual Taps', 'Delay Spread Region', 'Mean Excess Delay'}, ...
           'Location', 'northeast', 'FontSize', 10);
    
    % Add overall title
    sgtitle({'Fig. 3: CDL-A Channel Impulse Response and Multipath Characteristics', ...
             '3GPP TR 38.901 CDL-A channel model for realistic urban propagation characteristics'}, ...
            'FontSize', 13, 'FontWeight', 'bold');
    
    % Save figure
    saveas(gcf, 'Figure3_CDL_A_Channel.png', 'png');
    saveas(gcf, 'Figure3_CDL_A_Channel.fig', 'fig');
    
    % Display channel parameters
    fprintf('=== CDL-A Channel Model Parameters ===\n');
    fprintf('Number of taps: %d\n', length(cdl_a_delays_ns));
    fprintf('Delay spread: %d ns\n', total_delay_spread);
    fprintf('RMS delay spread: %.1f ns\n', rms_delay_spread);
    fprintf('Mean excess delay: %.1f ns\n', mean_excess_delay);
    fprintf('Coherence bandwidth: %.1f MHz\n', coherence_bandwidth);
    
    % Print tap information
    fprintf('\n=== Individual Tap Information ===\n');
    fprintf('Tap\tDelay(ns)\tPower(dB)\tNorm Power\n');
    for i = 1:length(cdl_a_delays_ns)
        fprintf('%d\t%d\t\t%.1f\t\t%.3f\n', i, cdl_a_delays_ns(i), ...
                cdl_a_powers_db(i), cdl_a_powers_normalized(i));
    end


