clear all; close all;

% path to haspice toolbox; not needed if you have sourced DOT.cshrc
% addpath('/afs/ir/class/ee214b/matlab/hspice_toolbox')

% if you find this convenient, you can launch your sim from within Matlab
[status,result] = system('/afs/ir/class/ee/synopsys/hspice/I-2013.12-SP2/hspice/bin/hspice example_214b.sp >! example_214b.out');
if(status)
    disp('Simulation error!')
    return;
end

h = loadsig('example_214b.sw0');
lssig(h)

idn = evalsig(h,'i_mn1');
idp = evalsig(h,'i_mp1');
vds = evalsig(h,'ds');

figure(1);
plot(vds, idn, 'linewidth', 2);
set(gca,'FontSize',14);
title('NCH')
xlabel('V_D_S [V]');
ylabel('I_D [A]');
grid;

figure(2);
plot(vds, idp, 'linewidth', 2);
set(gca,'FontSize',14);
title('PCH')
xlabel('-V_D_S [V]');
ylabel('I_D [A]');
grid;

