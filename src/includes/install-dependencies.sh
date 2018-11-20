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
# CORE VARIABLES #
##################

dependencies=("alsa-utils" "zenity");
install_answer="";

#########
# LOGIC #
#########

if [[ $(is_root_user) -eq 0 ]]; then
    
    # Get Confirmation
    
    read -p "Install dependencies? (y/n) - " -n 1 install_answer;
    
    # Install Depndencies
    
    if [[ $install_answer =~ ^[Yy]$ ]]; then
        
        echo -e "\n";
        
        for dependency in ${dependencies[@]}; do
            
            if [[ ! -z "$(command -v apt-get)" ]]; then
                apt-get install $dependency -y;
            elif [[ ! -z "$(command -v yum)" ]]; then
                yum install $depndency -y;
            else
                echo "Error: Your system isn't supported." && exit;
            fi;
            
        done
        
    else
        
        echo -e "\n\nCancelling...";
        
    fi
    
else
    
    echo "Error: You need root privileges to install dependencies.";
    
fi
