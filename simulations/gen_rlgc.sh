#!/bin/bash

config=(HG1 HG2 HG3 HG4 MG1 MG2 MG3 MG4 LG1 LG2 LG3 LG4)
echo [Y] Started
for i in "${config[@]}"
do
	path=/home/ymalviya/afs-home/EE273/design_project/stripline_files/$i
	cd "$path"
	hspice ${i}_long >! ${i}_long.lis	
        echo [Y] ${i}_long RLGC generated
	hspice ${i}_short >! ${i}_short.lis	
        echo [Y] ${i}_short RLGC generated
done
echo Finished
