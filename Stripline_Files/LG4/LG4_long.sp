* 100 ohm Differential Stripline Pair *
* Material: DX LG4_long, RTF copper foil
 
************************************************************************* 
 .PARAM thick	= 0.6		* Trace thickness, mils -- 1/2 oz copper
 .PARAM width	= 4.5		* Trace width, mils
 .PARAM space	= 7.5		* Trace pair air gap, mils
 .PARAM etch	= 0.0		* Trace etch factor, mils
 .PARAM rrms	= 4u		* RMS trace roughness, meters
 .PARAM core	= 5.1		* Core dielectric thickness, mils  (2x1035)
 .PARAM preg	= 5.3		* Pre-preg dielectric thickness, mils  (2x1035)
 .PARAM dk_core	= 3.68		* Core relative dielectric constant 
 .PARAM dk_preg	= 3.63		* Pre-preg relative dielectric constant
 .PARAM df_core	= 0.005		* Core dissipation factor
 .PARAM df_preg	= 0.005		* Pre-preg dissipation factor
 .PARAM length	= 13.0		* Trace length, inches
 .PARAM Zo_diff	= 49.4		* Differential impedance, ohms
************************************************************************* 

 Vs 1 2 AC 2
*Vp 1 0 AC 2
*Vn 0 2 AC 2
 R1 1     in1  '0.5*Zo_diff'
 R2 2     in2  '0.5*Zo_diff'
 R3 out1  0    '0.5*Zo_diff'
 R4 out2  0    '0.5*Zo_diff'
 E1 vdiff 0 (out1,out2) 1
 
 W1 in1 in2 gnd out1 out2 gnd FSmodel=diff_stripline INCLUDERSIMAG=YES N=2 l='0.0254*length' delayopt=3
 .MATERIAL diel_1 DIELECTRIC ER=dk_core LOSSTANGENT=df_core
 .MATERIAL diel_2 DIELECTRIC ER=dk_preg LOSSTANGENT=df_preg
 
 .MATERIAL copper METAL CONDUCTIVITY=57.6meg ROUGHNESS=rrms
 
 .SHAPE trap TRAPEZOID TOP='(width-2*etch)*25.4e-6' BOTTOM='width*25.4e-6' HEIGHT='thick*25.4e-6'
 
 .LAYERSTACK stack_1
 + LAYER=(copper,'thick*25.4e-6'), LAYER=(diel_1,'core*25.4e-6')
 + LAYER=(diel_2,'preg*25.4e-6'), LAYER=(copper,'thick*25.4e-6')
 
 .FSOPTIONS opt1 PRINTDATA=YES
 + COMPUTE_GD=YES
 + COMPUTE_RS=YES
 
 .MODEL diff_stripline W MODELTYPE=FieldSolver
 + LAYERSTACK=stack_1, FSOPTIONS=opt1 RLGCFILE=LG4_long.rlgc
 + CONDUCTOR=(SHAPE=trap, MATERIAL=copper, ORIGIN=(0,'(thick+core)*25.4e-6'))
 + CONDUCTOR=(SHAPE=trap, MATERIAL=copper, ORIGIN=('(width+space)*25.4e-6','(thick+core)*25.4e-6'))
 
 .OPTION POST=1 ACCURATE
 .AC DEC 100 1meg 40G
 .END

