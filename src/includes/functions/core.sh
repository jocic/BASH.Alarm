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

#########
# LOGIC #
#########

# Parses provided value for use in single quotes.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @param string $value
#   Value that should be parsed.
# @return void

function parse_value()
{
    # Core Variables
    
    value=$1;
    
    # Logic
    
    echo ${value//\'/\'\\\'\'};
}

# Processes passed script arguments.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return void

function process_arguments()
{
    # Control Variables
    
    param_key="";
    param_value="";
    current_param=1;
    next_param=2;
    
    # Logic
    
    while [[ 1 == 1 ]]; do
        
        # Check Parameters
        
        param_key=$(eval echo \${$current_param});
        param_value=$(eval echo \${$next_param});
        
        if [[ ( -z "$param_key" ) && ( -z "$param_value" ) ]]; then
            break;
        elif [[ "$param_key" == "-a" ]] || [[ "$param_key" == "--alarm" ]]; then
            alarm_type="alarm" && alarm_command=$param_value;
        elif [[ "$param_key" == "-c" ]] || [[ "$param_key" == "--countdown" ]]; then
            alarm_type="countdown" && alarm_command=$param_value;
        elif [[ "$param_key" == "-i" ]] || [[ "$param_key" == "--interval" ]]; then
            alarm_type="interval" && alarm_command=$param_value;
        elif [[ "$param_key" == "-t" ]] || [[ "$param_key" == "--time" ]]; then
            alarm_time=$param_value;
        elif [[ "$param_key" == "-d" ]] || [[ "$param_key" == "--delay" ]]; then
            alarm_delay=$param_value;
        elif [[ "$param_key" == "-m" ]] || [[ "$param_key" == "--message" ]]; then
            alarm_message=$param_value;
        elif [[ "$param_key" == "-s" ]] || [[ "$param_key" == "--sound" ]]; then
            sound_effect=$param_value;
        elif [[ "$param_key" == "-v" ]] || [[ "$param_key" == "--volume" ]]; then
            sound_volume=$param_value;
        elif [[ "$param_key" == "-g" ]] || [[ "$param_key" == "--global" ]]; then
            global_alarm="yes";
        elif [[ "$param_key" == "--test" ]]; then
            test_sound="yes";
        elif [[ "$param_key" == "--install" ]]; then
            install_deps="yes";
        elif [[ "$param_key" == "-h" ]] || [[ "$param_key" == "--help" ]]; then
            display_help="yes";
        elif [[ "$param_key" == "--version" ]]; then
            display_version="yes";
        fi
        
        # Increment Control Variables
        
        current_param=$(($current_param+1));
        next_param=$(($next_param+1));
        
    done
}

# Checks dependencies and the potential error message.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return void

function check_dependencies()
{
    # Core Variables
    
    deps_commands=("aplay" "zenity");
    deps_packages=("alsa-utils" "zenity");
    
    # Logic
    
    if [[ ${#deps_commands[@]} == ${#deps_packages[@]} ]]; then
        
        for i in "${!deps_commands[@]}"; do
            
            if [[ -z "$(command -v ${deps_commands[$i]})" ]]; then
                
                if [[ ! -z "$(command -v apt-get)" ]]; then
                    echo -e "Error: Command \"${deps_commands[$i]}\" is missing. Please install the dependency by typing \"apt-get install ${deps_packages[$i]}\".";
                elif [[ ! -z "$(command -v yum)" ]]; then
                    echo -e "Error: Command \"${deps_commands[$i]}\" is missing. Please install the dependency by typing \"yum install ${deps_packages[$i]}\".";
                else
                    echo -e "Error: Command \"${deps_commands[$i]}\" is missing. Please install \"${deps_packages[$i]}\".";
                fi
                
            fi
            
        done
        
    else
        
        echo -e "Error: Dependency command count doesn't correspond to it's package counterpart.";
        
    fi
}

# Prints project's help.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return void

function show_help()
{
    # Logic
    
    cat "$source_dir/other/help.txt" && exit;
}

# Prints project's version.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return void

function show_version()
{
    # Logic
    
    echo -e "Alarm $version";
    
    cat "$source_dir/other/version.txt" && exit;
}

# Installs project's dependencies.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return void

function install_dependencies()
{
    # Core Variables
    
    dependencies=("alsa-utils" "zenity");
    
    # Logic
    
    for dependency in ${dependencies[@]}; do
        
        if [[ ! -z "$(command -v apt-get)" ]]; then
            apt-get install $dependency -y;
        elif [[ ! -z "$(command -v yum)" ]]; then
            yum install $depndency -y;
        else
            echo "Error: Your system isn't supported." && exit;
        fi;
        
    done
}
