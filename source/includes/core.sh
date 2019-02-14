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

#################
# GET FUNCTIONS #
#################

# GET FUNCTIONS GO HERE

#################
# SET FUNCTIONS #
#################

# GET FUNCTIONS GO HERE

##################
# CORE FUNCTIONS #
##################

# Prints project's help.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return integer
#   It always returns <i>0</i> - SUCCESS.

show_help()
{
    # Logic
    
    cat "$J_A_SOURCE_DIR/other/help.txt" && exit;
}

# Prints project's version.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return integer
#   It always returns <i>0</i> - SUCCESS.

show_version()
{
    # Logic
    
    printf "Alarm %s\n" "$J_A_VERSION";
    
    cat "$J_A_SOURCE_DIR/other/version.txt" && exit;
}

# Installs project's dependencies.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return integer
#   It always returns <i>0</i> - SUCCESS.

install_dependencies()
{
    # Core Variables
    
    local dependencies=$(echo "alsa-utils zenity" | tr " " "\n");
    
    # Logic
    
    for dependency in $dependencies; do
        
        if [ -n "$(command -v apt-get)" ]; then
            apt-get install "$dependency" -y;
        elif [ -n "$(command -v yum)" ]; then
            yum install "$dependency" -y;
        else
            printf "Error: Your system isn't supported.\n" && exit;
        fi;
        
    done
    
    return 0;
}

###################
# CHECK FUNCTIONS #
###################

# Checks dependencies and the potential error message.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return integer
#   It always returns <i>0</i> - SUCCESS.

check_dependencies()
{
    # Core Variables
    
    local packages=$(echo "alsa-utils zenity" | tr " " "\n");
    
    # Logic
    
    for package in $packages; do
        
        if [ "$(dpkg -l | grep "$package")" = "" ]; then
            
            if [ -n "$(command -v apt-get)" ]; then
                printf "Error: Command \"%s\" is missing. Please install the dependency by typing \"apt-get install %s\".\n" "$package" "$package";
            elif [ -n "$(command -v yum)" ]; then
                printf "Error: Command \"%s\" is missing. Please install the dependency by typing \"yum install %s\".\n" "$package" "$package";
            else
                printf "Error: Command \"%s\" is missing. Please install \"%s\".\n" "$package" "$package";
            fi
            
        fi
        
    done
    
    return 0;
}

###################
# OTHER FUNCTIONS #
###################

# Parses provided value for use in single quotes.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @param string $value
#   Value that should be parsed.
# @return integer
#   It always returns <i>0</i> - SUCCESS.

parse_value()
{
    # Core Variables
    
    local value="$1";
    
    # Logic
    
    printf "%s" "$value" | sed -e "s/'/'\\\''/g";
}
