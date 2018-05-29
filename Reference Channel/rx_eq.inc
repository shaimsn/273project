 * Single Zero Linear Equalizer *
 *
 *	az1 = zero location in Hz (real axis)
 *	ap1 = pole location in Hz (real axis)
 *	ap2 = secondary pole location; default is 10 GHz (real axis)
 *
 * Overall gain is normalized to 1 at mid-band.
 *
 .SUBCKT (rx_eq) in out  az1=1k ap1=10k ap2=10g fz1=0 fp1=0 fp2=0 pi=3.14159265359
*     E1  out 0 POLE in 0  '2*pi*ap2' '2*pi*az1' '2*pi*fz1' / 
*+                          1         '2*pi*ap1' '2*pi*fp1' '2*pi*ap2' '2*pi*fp2'
     R1  out 0 1G
     R2  in  0 1G

 * For normalization to 1 at DC, substitute the following line:
   E1  out 0 POLE in 0  '4*pi*pi*ap1*ap2' '2*pi*az1' '2*pi*fz1' / 
+                       '2*pi*az1'        '2*pi*ap1' '2*pi*fp1' '2*pi*ap2' '2*pi*fp2'

 .ENDS (rx_eq)

