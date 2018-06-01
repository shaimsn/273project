#!/bin/bash
# The following script simulates all configurations specified by dynamically generating the
# spice files for given material and length scenarios.

module load matlab
CURRPATH=/home/ymalviya/afs-home/EE273/design_project/273project/simulations
length1=(1) #12.75 5.75 11.75)
length3=(5) #11 0.25 12)
material=(HG1) #HG2 HG3 HG4 MG1 MG2 MG3 MG4 LG1 LG2 LG3 LG4)
for i in "${material[@]}"
do
    for j in "${length1[@]}"
    do
        for k in "${length3[@]}"
        do
	    # Printing current configuration
	    echo Material : ${i}  
	    echo Length1 : $j inch
 	    echo Length2 : $k inch

	    len1="${j//./}"
	    len2="${k//./}"

	    path=$CURRPATH/${i}/${i}_${len1}_${len2}
	    mkdir -p $path
       	    cd "$path"

	    # Generating required single pulse response config	
	    cp $CURRPATH/diff_channel_single_pulse.sp $CURRPATH/${i}/${i}_${len1}_${len2}/${i}_${len1}_${len2}_single_pulse.sp	
	    sed -i -e 's/x1/'$j'/g' $CURRPATH/${i}/${i}_${len1}_${len2}/${i}_${len1}_${len2}_single_pulse.sp
	    sed -i -e 's/x2/'$k'/g' $CURRPATH/${i}/${i}_${len1}_${len2}/${i}_${len1}_${len2}_single_pulse.sp
	    sed -i -e 's/x3/'${i}_long.rlgc'/g' $CURRPATH/${i}/${i}_${len1}_${len2}/${i}_${len1}_${len2}_single_pulse.sp
	    sed -i -e 's/x4/'0.00'/g' $CURRPATH/${i}/${i}_${len1}_${len2}/${i}_${len1}_${len2}_single_pulse.sp
	    sed -i -e 's/x5/'0.00'/g' $CURRPATH/${i}/${i}_${len1}_${len2}/${i}_${len1}_${len2}_single_pulse.sp
	    sed -i -e 's/x6/'0.00'/g' $CURRPATH/${i}/${i}_${len1}_${len2}/${i}_${len1}_${len2}_single_pulse.sp

	    # Launching spice simulations
	    echo Launching single pulse $i $j $k 
	    hspice ${i}_${len1}_${len2}_single_pulse >! ${i}_${len1}_${len2}_single_pulse.lis 
	    
	    cp $CURRPATH/compute_eq_coeffs.m $CURRPATH/${i}/${i}_${len1}_${len2}/compute_eq_coeffs.m
            sed -i -e 's/filename/'${i}_${len1}_${len2}_single_pulse.tr0'/g' $CURRPATH/${i}/${i}_${len1}_${len2}/compute_eq_coeffs.m 
	    sed -i -e 's/imagename/'v_rx.jpeg'/g' $CURRPATH/${i}/${i}_${len1}_${len2}/compute_eq_coeffs.m 
	    sed -i -e 's/resultfile/'eq_coeff.txt'/g' $CURRPATH/${i}/${i}_${len1}_${len2}/compute_eq_coeffs.m 

	    # Calculate equalization coefficients
            matlab -nodisplay -nodesktop -r "run compute_eq_coeffs.m"
	    
	    # Read equalized coefficients
	    coeff=()
	    while IFS='' read -r line || [[ -n "$line" ]];
 	    do
    	        echo "Text read from file: $line"
	  	coeff+=($line)
	    done < eq_coeff.txt
	    echo ${coeff[0]}

	    cp $CURRPATH/diff_channel_single_pulse.sp $CURRPATH/${i}/${i}_${len1}_${len2}/${i}_${len1}_${len2}_single_pulse_equalized.sp	
	    sed -i -e 's/x1/'$j'/g' $CURRPATH/${i}/${i}_${len1}_${len2}/${i}_${len1}_${len2}_single_pulse_equalized.sp
	    sed -i -e 's/x2/'$k'/g' $CURRPATH/${i}/${i}_${len1}_${len2}/${i}_${len1}_${len2}_single_pulse_equalized.sp
	    sed -i -e 's/x3/'${i}_long.rlgc'/g' $CURRPATH/${i}/${i}_${len1}_${len2}/${i}_${len1}_${len2}_single_pulse_equalized.sp
	    sed -i -e 's/x4/'${coeff[0]}'/g' $CURRPATH/${i}/${i}_${len1}_${len2}/${i}_${len1}_${len2}_single_pulse_equalized.sp
	    sed -i -e 's/x5/'${coeff[2]}'/g' $CURRPATH/${i}/${i}_${len1}_${len2}/${i}_${len1}_${len2}_single_pulse_equalized.sp
	    sed -i -e 's/x6/'${coeff[3]}'/g' $CURRPATH/${i}/${i}_${len1}_${len2}/${i}_${len1}_${len2}_single_pulse_equalized.sp

	    hspice ${i}_${len1}_${len2}_single_pulse_equalized >! ${i}_${len1}_${len2}_single_pulse_equalized.lis 

	    cp $CURRPATH/compute_eq_coeffs.m $CURRPATH/${i}/${i}_${len1}_${len2}/compute_eq_coeffs.m 
	    sed -i -e 's/filename/'${i}_${len1}_${len2}_single_pulse_equalized.tr0'/g' $CURRPATH/${i}/${i}_${len1}_${len2}/compute_eq_coeffs.m
	    sed -i -e 's/imagename/'v_rx_equalized.jpeg'/g' $CURRPATH/${i}/${i}_${len1}_${len2}/compute_eq_coeffs.m 
	    sed -i -e 's/resultfile/'trash.txt'/g' $CURRPATH/${i}/${i}_${len1}_${len2}/compute_eq_coeffs.m 

	    matlab -nodisplay -nodesktop -r "run compute_eq_coeffs.m"

	done
    done
done

echo Finished simulation
