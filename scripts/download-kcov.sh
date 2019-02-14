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

kcov_dir="$1";
kcov_version="$2";
kcov_link=$(printf "https://github.com/SimonKagstrom/kcov/archive/v%s.tar.gz" "$kcov_version");
kcov_archive=$(printf "kcov-v%s.tar.gz" "$kcov_version");

###################
# Other Variables #
###################

temp="";

###################################
# Step 1 - Prepare Work Directory #
###################################

printf "[+] Preparing work directory...\n";

if [ -z "$kcov_dir" ]; then
    printf "\nError: Directory wasn't provided...\n" && exit 1;
fi

mkdir -p "$kcov_dir" > /dev/null 2>&1;

if [ ! -d "$kcov_dir" ]; then
    printf "\nError: Directory couldn't be created...\n" && exit 1;
fi

cd "$kcov_dir";

#############################
# Step 2 - Download Archive #
#############################

printf "[+] Downloading KCOV...\n" "$kcov_version";

if [ -z "$kcov_version" ]; then
    printf "\nError: Version wasn't provided...\n" && exit 1;
fi

(wget "$kcov_link" -O "$kcov_archive") > /dev/null 2>&1;

##########################
# Step 3 - Check Archive #
##########################

printf "[+] Checking downloaded archive...\n";

temp=$(file --mime-type "$kcov_archive" | cut -d " " -f 2);

if [ "$temp" != "application/gzip" ]; then
    printf "\nError: Procedure failed...\n" && exit 1;
fi
