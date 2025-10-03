% Figure 2: 5G NR Frame Structure and OFDM Symbol Timing
function generateFigure2()
    % 5G NR parameters for 30 kHz SCS (μ=1)
    mu = 1;                    % Numerology
    scs = 30e3;               % Subcarrier spacing (Hz)
    symbols_per_slot = 14;    % Normal CP
    slots_per_subframe = 2^mu; % 2 slots for μ=1
    
    % Calculate timing parameters
    symbol_duration_us = 1e6 / scs;  % 33.33 μs
    slot_duration_us = symbol_duration_us * symbols_per_slot;
    
    % CP parameters for 30.72 MSPS
    cp_extended_us = 0.65;    % Extended CP duration
    cp_normal_us = 0.59;      % Normal CP duration
    
    % Create figure
    figure('Position', [100, 100, 1400, 800]);
    
    % Time axis for 2 subframes
    time_span_us = 2000;  % 2 ms
    
    % Define hierarchy levels and colors
    y_levels = [4, 3, 2, 1];  % Top to bottom
    colors = struct('subframe', [1, 0.2, 0.2], ...
                   'slot', [0.2, 0.2, 1], ...
                   'cp_extended', [1, 0.4, 0.4], ...
                   'cp_normal', [0.4, 0.4, 1], ...
                   'useful', [0.2, 0.8, 0.2]);
    
    % Draw subframe level
    for sf = 0:1
        x_start = sf * 1000;
        rectangle('Position', [x_start, y_levels(1)-0.15, 1000, 0.3], ...
                  'FaceColor', colors.subframe, 'EdgeColor', 'black', ...
                  'LineWidth', 2);
        text(x_start + 500, y_levels(1), sprintf('Subframe %d (1 ms)', sf), ...
             'HorizontalAlignment', 'center', 'FontWeight', 'bold', ...
             'FontSize', 12, 'Color', 'white');
        hold on;
    end
    
    % Draw slot level
    for sf = 0:1
        for slot = 0:(slots_per_subframe-1)
            x_start = sf * 1000 + slot * 500;
            rectangle('Position', [x_start, y_levels(2)-0.12, 500, 0.24], ...
                      'FaceColor', colors.slot, 'EdgeColor', 'black');
            text(x_start + 250, y_levels(2), sprintf('Slot %d', slot), ...
                 'HorizontalAlignment', 'center', 'FontWeight', 'bold', ...
                 'FontSize', 10, 'Color', 'white');
        end
    end
    
    % Draw symbol level with detailed CP visualization
    symbol_count = 0;
    for sf = 0:1
        for slot = 0:(slots_per_subframe-1)
            for sym = 0:(symbols_per_slot-1)
                x_start = sf * 1000 + slot * 500 + sym * symbol_duration_us;
                
                % Determine CP type and color
                if sym == 0 && slot == 0  % First symbol of subframe
                    cp_color = colors.cp_extended;
                    cp_duration = cp_extended_us;
                    cp_label = 'Ext';
                else
                    cp_color = colors.cp_normal;
                    cp_duration = cp_normal_us;
                    cp_label = 'Norm';
                end
                
                % Draw CP portion
                rectangle('Position', [x_start, y_levels(3)-0.1, cp_duration, 0.2], ...
                          'FaceColor', cp_color, 'EdgeColor', 'none');
                
                % Draw useful symbol portion
                useful_duration = symbol_duration_us - cp_duration;
                rectangle('Position', [x_start + cp_duration, y_levels(3)-0.1, ...
                          useful_duration, 0.2], ...
                          'FaceColor', colors.useful, 'EdgeColor', 'none');
                
                % Add symbol boundary
                line([x_start, x_start], [y_levels(3)-0.12, y_levels(3)+0.12], ...
                     'Color', 'black', 'LineWidth', 0.5);
                
                % Label symbols in first slot
                if sf == 0 && slot == 0
                    text(x_start + symbol_duration_us/2, y_levels(4), num2str(sym), ...
                         'HorizontalAlignment', 'center', 'FontSize', 9, ...
                         'FontWeight', 'bold');
                    
                    % Add CP label for first few symbols
                    if sym < 4
                        text(x_start + cp_duration/2, y_levels(3), cp_label, ...
                             'HorizontalAlignment', 'center', 'FontSize', 7, ...
                             'Color', 'white', 'FontWeight', 'bold');
                    end
                end
                
                symbol_count = symbol_count + 1;
            end
        end
    end
    
    % Add timing annotations
    % Symbol duration arrow
    arrow_y = 0.3;
    annotation('doublearrow', [0.1, 0.1 + 33.33/2000*0.8], [arrow_y, arrow_y], ...
               'Color', 'red', 'LineWidth', 2);
    text(50, arrow_y*5, sprintf('Symbol Duration\n%.2f μs', symbol_duration_us), ...
         'FontSize', 10, 'FontWeight', 'bold', 'Color', 'red', ...
         'HorizontalAlignment', 'center');
    
    % CP duration annotations
    text(200, 0.8, sprintf('CP: Ext=%.2f μs, Norm=%.2f μs', ...
         cp_extended_us, cp_normal_us), 'FontSize', 10, ...
         'BackgroundColor', 'yellow', 'EdgeColor', 'black');
    
    % Formatting
    xlim([0, time_span_us]);
    ylim([0, 5]);
    xlabel('Time (μs)', 'FontSize', 14, 'FontWeight', 'bold');
    ylabel('Frame Hierarchy', 'FontSize', 14, 'FontWeight', 'bold');
    title({'Fig. 2: 5G NR Frame Structure and OFDM Symbol Timing (30 kHz SCS, μ=1)', ...
           'Detailed timing diagram showing frame hierarchy with symbol-dependent cyclic prefix implementation'}, ...
          'FontSize', 12, 'FontWeight', 'bold');
    
    % Custom y-axis labels
    set(gca, 'YTick', y_levels, 'YTickLabel', {'Subframes', 'Slots', 'Symbols', 'Symbol ID'}, ...
         'FontSize', 12);
    
    % Add legend
    legend_handles = [
        rectangle('Position', [NaN, NaN, 0, 0], 'FaceColor', colors.subframe, 'EdgeColor', 'none');
        rectangle('Position', [NaN, NaN, 0, 0], 'FaceColor', colors.slot, 'EdgeColor', 'none');
        rectangle('Position', [NaN, NaN, 0, 0], 'FaceColor', colors.cp_extended, 'EdgeColor', 'none');
        rectangle('Position', [NaN, NaN, 0, 0], 'FaceColor', colors.cp_normal, 'EdgeColor', 'none');
        rectangle('Position', [NaN, NaN, 0, 0], 'FaceColor', colors.useful, 'EdgeColor', 'none');
    ];
    legend(legend_handles, {'Subframes', 'Slots', 'Extended CP', 'Normal CP', 'Useful Symbol'}, ...
           'Location', 'northeast', 'FontSize', 10);
    
    % Add grid
    grid on; grid minor;
    
    % Save figure
    saveas(gcf, 'Figure2_5G_Frame_Structure.png', 'png');
    saveas(gcf, 'Figure2_5G_Frame_Structure.fig', 'fig');
    
    % Print timing information
    fprintf('=== 5G NR Timing Parameters ===\n');
    fprintf('Numerology (μ): %d\n', mu);
    fprintf('Subcarrier Spacing: %d kHz\n', scs/1000);
    fprintf('Symbol Duration: %.2f μs\n', symbol_duration_us);
    fprintf('Slot Duration: %.2f μs\n', slot_duration_us);
    fprintf('Extended CP: %.2f μs\n', cp_extended_us);
    fprintf('Normal CP: %.2f μs\n', cp_normal_us);
end