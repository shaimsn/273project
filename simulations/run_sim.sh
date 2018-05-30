#!/bin/bash
# The following script simulates all configurations specified by dynamically generating the
# spice files for given material and length scenarios.

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

            # Generating required data eye response config	
	    cp $CURRPATH/diff_channel_data_eye.sp $CURRPATH/${i}/${i}_${len1}_${len2}/${i}_${len1}_${len2}_data_eye.sp	
	    sed -i -e 's/x1/'$j'/g' $CURRPATH/${i}/${i}_${len1}_${len2}/${i}_${len1}_${len2}_data_eye.sp
	    sed -i -e 's/x2/'$k'/g' $CURRPATH/${i}/${i}_${len1}_${len2}/${i}_${len1}_${len2}_data_eye.sp
	    sed -i -e 's/x3/'${i}_long.rlgc'/g' $CURRPATH/${i}/${i}_${len1}_${len2}/${i}_${len1}_${len2}_data_eye.sp

	    # Launching spice simulations
	    echo Launching single pulse $i $j $k 
	    hspice ${i}_${len1}_${len2}_single_pulse >! ${i}_${len1}_${len2}_single_pulse.lis 
	    
   	    echo Launching data eye $i $j $k 
	    hspice ${i}_${len1}_${len2}_data_eye >! ${i}_${len1}_${len2}_data_eye.lis
	    
	done
    done
done

echo Finished simulation
