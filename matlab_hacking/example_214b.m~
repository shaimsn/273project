clear all; close all;

% path to haspice toolbox; not needed if you have sourced DOT.cshrc
addpath('./hspice_toolbox')

% % if you find this convenient, you can launch your sim from within Matlab
% [status,result] = system('/afs/ir/class/ee/synopsys/hspice/I-2013.12-SP2/hspice/bin/hspice example_214b.sp >! example_214b.out');
% if(status)
%     disp('Simulation error!')
%     return;
% end

h = loadsig('../LinkModel/diff_channel_single_pulse.tr0');
lssig(h)

v_rx_diff = evalsig(h,'v_rx_diff');
% idp = evalsig(h,'i_mp1');
% vds = evalsig(h,'ds');

figure(1);
plot(v_rx_diff, 'linewidth', 2);
set(gca,'FontSize',14);
title('Rx Voltage')
xlabel('V_D_S [V]');
ylabel('I_D [A]');
grid;


