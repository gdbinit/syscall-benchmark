#!/bin/bash

if [ $1 ]
 then
  CYCLES=$1
 else
  CYCLES=10
fi

echo AAAAAAAAAAAAAAAAAAAAAAAAAA >/tmp/lseek_test_file
> results.log
uname -a  >> results.log
echo -n "Build:" >> results.log
sw_vers -buildVersion >> results.log
echo >> results.log

# results: binary;run#;real;user;system
TIMEFORMAT="%R;%U;%S"
for PROGRAM in bench_*; do
	echo "Running $PROGRAM..."
	> bench.log
	
	for ((i=1; i <= $CYCLES; i++)); do
		echo -n "$PROGRAM;$i;" >> bench.log	
		(time ./$PROGRAM) 2>> bench.log
	done
	
	echo -n "$PROGRAM;average;" >> results.log
	awk 'BEGIN { FS=";" }
		    { r += $3; u += $4; s += $5; }
		END { printf("%.3f;%.3f;%.3f\n", r / NR, u / NR, s / NR); }
	' bench.log  >> results.log
	cat bench.log >> results.log
done

echo >> results.log

rm -f bench.log
