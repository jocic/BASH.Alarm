#!/bin/bash

###################################################################
# Script Author: Djordje Jocic                                    #
# Script Year: 2018                                               #
# Script License: MIT License (MIT)                               #
# =============================================================== #
# Personal Website: http://www.djordjejocic.com/                  #
# =============================================================== #
# Permission is hereby granted, free of charge, to any person     #
# obtaining a copy of this software and associated documentation  #
# files (the "Software"), to deal in the Software without         #
# restriction, including without limitation the rights to use,    #
# copy, modify, merge, publish, distribute, sublicense, and/or    #
# sell copies of the Software, and to permit persons to whom the  #
# Software is furnished to do so, subject to the following        #
# conditions.                                                     #
# --------------------------------------------------------------- #
# The above copyright notice and this permission notice shall be  #
# included in all copies or substantial portions of the Software. #
# --------------------------------------------------------------- #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, #
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES #
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND        #
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT     #
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,    #
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, RISING     #
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR   #
# OTHER DEALINGS IN THE SOFTWARE.                                 #
###################################################################

##################
# Core Variables #
##################

source_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)";
fakers=$(echo "mv dirname tr" | tr " " "\n");

##########################
# Step 1 - Prepare Tests #
##########################

for faker in $fakers; do
    
    [ -f "$source_dir/fakers/$faker" ] \
        && rm "$source_dir/fakers/$faker";
    
    ln -s "$(command -v $faker)" "$source_dir/fakers/$faker";
    
done

###########################
# Step 2 - Test Functions #
###########################

bash "$source_dir/../tests/generic/test-config-funcs.sh";
bash "$source_dir/../tests/generic/test-core-funcs.sh";

############################
# Step 3 - Test Parameters #
############################

bash "$source_dir/../tests/test-param-none.sh";
bash "$source_dir/../tests/test-param-help.sh";
bash "$source_dir/../tests/test-param-version.sh";
#bash "$source_dir/../tests/test-param-init.sh";
