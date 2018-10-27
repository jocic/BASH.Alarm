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

#######################
# PARAMETER VARIABLES #
#######################

display_help="no";
display_version="no";

#####################
# CONTROL VARIABLES #
#####################

param_key="";
param_value="";
current_param=1;
next_param=2;

#########
# LOGIC #
#########

while :
  do
    
    #############################
    # STEP 1 - CHECK PARAMETERS #
    #############################
    
    param_key=$(eval echo \${$current_param});
    param_value=$(eval echo \${$next_param});
    
    if [[ -z $param_key ]]; then
        break;
    elif [[ $param_key == "-h" ]] || [[ $param_key == "--help" ]]; then
        display_help="yes";
    elif [[ $param_key == "--version" ]]; then
        display_version="yes";
    fi
    
    ######################################
    # STEP 2 - INCREMENT PARAM VARIABLES #
    ######################################
    
    current_param=$(($current_param+1));
    next_param=$(($next_param+1));
    
done
