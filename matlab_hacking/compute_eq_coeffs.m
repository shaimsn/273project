clear all; close all;

addpath('./hspice_toolbox')

% Loading Hspice simulated signals
pulse_h = loadsig('../link_model/ffe_noeq_single_pulse_response.tr0');
freq = 6.25e9;
trans_tot_time = 10e-9;

% Measuring channel response at points of interest
lssig(pulse_h)
v_rx_diff = evalsig(pulse_h,'v_rx_diff');
tt = linspace(0, trans_tot_time, length(v_rx_diff));
[vmax, max_ndx] = max(v_rx_diff);
t_max = tt(max_ndx);

ui = 1/freq;                    %unit interval in time units
ui_d = round(ui/tt(2));         %unit interval in discrete steps units

vmax_p1ui = v_rx_diff(max_ndx + ui_d);
vmax_p2ui = v_rx_diff(max_ndx + 2*ui_d);
vmax_m1ui = v_rx_diff(max_ndx - ui_d);
vmin = min(v_rx_diff);

% Designing EQ coefficients (ported from hw5p1)
target = [0; 1; 0; 0];
Vsw = vmin;
xm1 = vmax_m1ui;
x0 = vmax;
x1 = vmax_p1ui;
x2 = vmax_p2ui;
x = [0 0 xm1 x0 x1 x2 0 0] - Vsw;
dirty_in_mat = [x0 xm1 0 0;
                x1 x0 xm1 0; 
                x2 x1 x0 xm1;
                0 x2 x1 x0]; 
dirty_in_mat(dirty_in_mat~=0) = ...
    dirty_in_mat(dirty_in_mat~=0) - Vsw;
c = dirty_in_mat\target;
c = c./sum(abs(c));

eq_coeff_for_hspice = -c
save eq_coeff.txt eq_coeff_for_hspice -ascii


%Plotting stuff
figure(1);
plot(tt,v_rx_diff, 'linewidth', 2);
hold on
plot(tt(max_ndx),vmax, 'r*')
plot(tt(max_ndx + ui_d),vmax_p1ui, 'r*')
plot(tt(max_ndx + 2*ui_d),vmax_p2ui, 'r*')
plot(tt(max_ndx - ui_d),vmax_m1ui, 'r*')
saveas(gcf, 'v_rx.jpeg')
set(gca,'FontSize',14);
title('Rx Voltage')
ylabel('Rx Voltage [V]');
xlabel('Time [s]');
grid;
exit
