#!/bin/bash

#with current always first line in input file
#only execute when one line (with/without current) is complete (not only starting time)


DATA=/home/andreas/vip2/data/bin/SMI
IFS="..."
line_count=0
>"$DATA"/withcurrent.list # empties the file where the file names are to be written
>"$DATA"/withoutcurrent.list

while read -r line           
do           

   let line_count=line_count+1
   current=0

   if [ $((line_count%2)) -eq 0 ]; 
      then 
        current=0
      else
        current=1
   fi   
  
   line_tmp=(${line/"..."/" "})
   IFS=" "
   array=($line_tmp)
#   echo -e "${array[1]}"
   IFS="..."

   start_filename="${array[0]}"
   end_filename="${array[1]}"

#   echo $start_filename
#   echo $current
#   echo $line_count



#start_filename="20150615_1554"
#end_filename="20150615_1935-2043"
#echo $filename



#cd $SCRIPTS
#ls 2015*

itson=0
corr_filename=0

    for f in "$DATA"/201*
    do 
      cur_filename=${f##*/}      
   
      if [ "$cur_filename" = "$start_filename" ]; 
         then itson=1
              let corr_filename=corr_filename+1
      fi

      if [[ $itson = 1 && $current = 0 ]] ;
         then 
           echo "$cur_filename" >> "$DATA"/withoutcurrent.list
      fi

      if [[ $itson = 1 && $current = 1 ]];
         then 
           echo "$cur_filename" >> "$DATA"/withcurrent.list
      fi

      if [ "$cur_filename" = "$end_filename" ]; 
         then itson=0
              let corr_filename=corr_filename+1
      fi
  
    done

#echo "$corr_filename"
if [ "$corr_filename" -ne 2 ]; 
   then echo "WARNING: in line with $start_filename, there is an incorrect filename"
fi

done < "/home/andreas/vip2/files_wo_current.txt" 

