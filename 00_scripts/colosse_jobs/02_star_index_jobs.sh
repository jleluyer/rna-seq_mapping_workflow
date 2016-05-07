#!/bin/bash

#set working directory
sed -i "s#__PWD__#$(pwd)#g" 00_scripts/02_star_index.sh

#submit jobs
msub 00_scripts/02_star_index.sh 

