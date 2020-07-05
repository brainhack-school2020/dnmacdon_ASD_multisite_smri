#!/bin/bash
cd /input
./harmonize_and_show_effect_sizes.sh -i /input/data.csv \
				     -o /output \
				     -s Site \
				     -x DX \
				     -c Age,Sex,TBV \
				     -l Control \
				     -q "L_str,L_thal,L_GP,R_str,R_GP,R_thal" \
				     -z "Age,Sex" \
				     -t 0.5

