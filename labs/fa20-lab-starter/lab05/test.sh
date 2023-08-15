#!/bin/bash

cp ex1.circ ex2.circ ex3.circ ex4.circ ex5.circ testing/circ_files

cd testing
rm -rf student_output
mkdir student_output
python3 test.py
cd ..
