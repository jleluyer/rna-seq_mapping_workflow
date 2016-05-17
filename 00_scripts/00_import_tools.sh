#!/bin/bash

#pre-requis
module load apps/git/1.8.5.3

#move to current directory

cd $(pwd)


# clone trinotate
git clone https://github.com/Trinotate/Trinotate 00_scripts/trinotate_utils

#clone transDecoder
git clone https://github.com/TransDecoder/TransDecoder 00_scripts/transdecoder_utils

# clone transvestigator
git clone https://github.com/genomeannotation/transvestigator 00_scripts/transvestigator_utils

#clone transrate
git clone https://github.com/blahah/transrate 00_scripts/transrate_utils

