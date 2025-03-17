clear all, close all, clc

% Define simulation files
names = {'PID1', 'PID2', 'MPC1', 'DDPG'};
vars = {'time', 'r', 'y', 'e', 'u_c', 'u_ac'};

% Load data from each file
for j = 1:numel(names)
    name = names{j};
    data = load([name '.txt']);
    
    for i = 1:numel(vars)
        assignin('base', [vars{i} '_' name], data(:,i)); 
    end
end

% Define line styles, colors, and linewidths (consistent with second script)
lineStyles = {':', '-', '-.', ':', '--'}; 
lineColors = {[0.0 0.6 0.0], 'b', 'r', [0.7 0.1 0.2], 'm'}; 
lineWidth = [1.2, 1.5, 1.5, 2.5, 1.5]; 
labels = {'$r$', 'C1', 'C2', 'C3', 'C4'};

% Plot output response
figure,
pos = get(gcf, 'Position'); set(gcf, 'Position', [pos(1), 0, pos(3) * 1.1, pos(4) * 1.2]);

subplot(2,1,1)
hold on
plot(time_PID1, r_PID1, 'LineStyle', lineStyles{1}, 'Color', lineColors{1}, 'LineWidth', lineWidth(1));
plot(time_PID1, y_PID1, 'LineStyle', lineStyles{2}, 'Color', lineColors{2}, 'LineWidth', lineWidth(2));
plot(time_PID2, y_PID2, 'LineStyle', lineStyles{3}, 'Color', lineColors{3}, 'LineWidth', lineWidth(3));
plot(time_MPC1, y_MPC1, 'LineStyle', lineStyles{4}, 'Color', lineColors{4}, 'LineWidth', lineWidth(4));
plot(time_DDPG, y_DDPG, 'LineStyle', lineStyles{5}, 'Color', lineColors{5}, 'LineWidth', lineWidth(5));
xlim([0 10])

ylabel('Output $(y)$', 'Interpreter', 'latex', 'FontSize', 14)
legend(labels, 'Interpreter', 'latex', 'FontSize', 9, 'Location', 'best')
set(gca, 'FontSize', 14, 'TickLabelInterpreter', 'latex')
ylim([0,1.25])

% Plot control signals
subplot(2,1,2)
hold on
plot(time_PID1, u_ac_PID1, 'LineStyle', lineStyles{2}, 'Color', lineColors{2}, 'LineWidth', lineWidth(2));
plot(time_PID2, u_ac_PID2, 'LineStyle', lineStyles{3}, 'Color', lineColors{3}, 'LineWidth', lineWidth(3));
plot(time_MPC1, u_ac_MPC1, 'LineStyle', lineStyles{4}, 'Color', lineColors{4}, 'LineWidth', lineWidth(4));
plot(time_DDPG, u_ac_DDPG, 'LineStyle', lineStyles{5}, 'Color', lineColors{5}, 'LineWidth', lineWidth(5));
xlim([0 10])
ylabel('Control Signal $(u_{ac})$', 'Interpreter', 'latex', 'FontSize', 14)
xlabel('Time $(t)$', 'Interpreter', 'latex', 'FontSize', 14)
set(gca, 'FontSize', 14, 'TickLabelInterpreter', 'latex')
