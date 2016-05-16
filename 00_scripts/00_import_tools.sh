#!/bin/bash

#pre-requis
module load apps/git/1.8.5.3

#move to current directory

cd $(pwd)

git clone https://github.com/genomeannotation/transvestigator 00_scripts/transvestigator_utils
