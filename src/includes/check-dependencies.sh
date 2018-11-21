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

deps_commands=("aplay" "zenity");
deps_packages=("alsa-utils" "zenity");

#########
# LOGIC #
#########

if [[ ${#deps_commands[@]} == ${#deps_packages[@]} ]]; then
    
    if [[ $install_deps == "no" ]]; then
        
        for i in "${!deps_commands[@]}"; do
            
            if [[ -z "$(command -v ${deps_commands[$i]})" ]]; then
                
                if [[ ! -z "$(command -v apt-get)" ]]; then
                    echo -e "Error: Command \"${deps_commands[$i]}\" is missing. Please install the dependency by typing \"apt-get install ${deps_packages[$i]}\"." && exit;
                elif [[ ! -z "$(command -v yum)" ]]; then
                    echo -e "Error: Command \"${deps_commands[$i]}\" is missing. Please install the dependency by typing \"yum install ${deps_packages[$i]}\"." && exit;
                else
                    echo -e "Error: Command \"${deps_commands[$i]}\" is missing. Please install \"${deps_packages[$i]}\"." && exit;
                fi
                
            fi
            
        done
        
    fi
    
else
    
    echo -e "Error: Dependency command count doesn't correspond to it's package counterpart." && exit;
    
fi
