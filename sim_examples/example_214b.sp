* EE214B simulation example
* MOSFET I-V curves
* B. Murmann

* ee214b device models
.include /afs/ir/class/ee214b/hspice/ee214b_hspice.sp

.param gs=1 ds=1

mn1 dn gn 0 0 nch w=5u l=0.18u
mp1 dp gp 0 0 pch w=5u l=0.18u

vgn gn 0 'gs'
vdn dn 0 'ds'
vgp gp 0 '-gs'
vdp dp 0 '-ds'

.op
.dc ds 0 1.8 0.01 gs 0.2 1.8 0.2
.option post brief nomod
.probe i(mn1) i(mp1)

.end
