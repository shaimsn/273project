clc;
clear;

% Signaling Constraints

n_lncds = 8;
n_xbars = 4;
sfp = 64;
sfp_tput = 10; %[Gbps]
lncd_tput = 2*sfp*sfp_tput; %fact 2 comes from duplex
lncd_to_xbar_tput = lncd_tput./n_xbars; %[Gbps] 
xbar_tput = lncd_to_xbar_tput*n_lncds;

tx_per_xchip = 128;
rx_per_xchip = 128;
links_per_xchip = tx_per_xchip + rx_per_xchip;
xbar_link_speed = [5, 10]; %[Gbps] %LPH _dup_ is misleading here
single_xchip_tput = links_per_xchip .* xbar_link_speed; 
n_xchips = ceil(xbar_tput./single_xchip_tput);

% Cost Calculation Script
% xbar_cost
cost_per_xwatt = 20; %[$]
five_gbps_xwatt = 1*60 + 1.3*17.4 + 3.3*0.3;
ten_gbps_xwatt = 1*60 + 1.3*30 + 3.3*0.3;
watt_per_xchip = [five_gbps_xwatt, ten_gbps_xwatt]; 
pow_cost_per_xchip = cost_per_xwatt .* watt_per_xchip;
build_cost_per_xchip = 300; %[$]
cost_per_conn = 0.35; %[$]
conn_cost_per_chip = cost_per_conn * links_per_xchip;
xbar_cost = n_xchips .* (pow_cost_per_xchip + build_cost_per_xchip + conn_cost_per_chip)


%cost of connectors 


