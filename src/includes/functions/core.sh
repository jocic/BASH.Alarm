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

parse_value()
{
    # Core Variables
    
    value=$1;
    
    # Logic
    
    printf $value | sed -e "s/'/'\\\''/g";

}

# Processes passed script arguments.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return void

process_arguments()
{
    # Control Variables
    
    queue="";
    
    # Logic
    
    for arg in "$@"; do
        
        # Assign Queued Values
        
        if [ "$queue" = "time" ]; then
            alarm_time=$arg;
        elif [ "$queue" = "delay" ]; then
            alarm_delay=$arg;
        elif [ "$queue" = "message" ]; then
            alarm_message=$arg;
        elif [ "$queue" = "sound" ]; then
            sound_effect=$arg;
        elif [ "$queue" = "volume" ]; then
            sound_volume=$arg;
        elif [ "$queue" = "alarm-command" ]; then
            alarm_command="$arg";
        fi
        
        # Reset Queue Value
        
        queue="";
        
        # Queue Commands
        
        if [ "$arg" = "-t" ] || [ "$arg" = "--time" ]; then
            queue="time";
        elif [ "$arg" = "-d" ] || [ "$arg" = "--delay" ]; then
            queue="delay";
        elif [ "$arg" = "-m" ] || [ "$arg" = "--message" ]; then
            queue="message";
        elif [ "$arg" = "-s" ] || [ "$arg" = "--sound" ]; then
            queue="sound";
        elif [ "$arg" = "-v" ] || [ "$arg" = "--volume" ]; then
            queue="volume";
        elif [ "$arg" = "-g" ] || [ "$arg" = "--global" ]; then
            global_alarm="yes";
        elif [ "$arg" = "-h" ] || [ "$arg" = "--help" ]; then
            display_help="yes";
        elif [ "$arg" = "--test" ]; then
            test_sound="yes";
        elif [ "$arg" = "--install" ]; then
            install_deps="yes";
        elif [ "$arg" = "--version" ]; then
            display_version="yes";
        elif [ "$arg" = "-a" ] || [ "$arg" = "--alarm" ]; then
            alarm_type="alarm";
        elif [ "$arg" = "-c" ] || [ "$arg" = "--countdown" ]; then
            alarm_type="countdown";
        elif [ "$arg" = "-i" ] || [ "$arg" = "--interval" ]; then
            alarm_type="interval";
        fi
        
    done
}

# Checks dependencies and the potential error message.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return void

check_dependencies()
{
    # Core Variables
    
    packages=$(echo "alsa-utils zenity" | tr " " "\n");
    
    # Logic
    
    for package in $packages; do
        
        if [ "$(dpkg -l | grep "$package")" = "" ]; then
            
            if [ ! -z "$(command -v apt-get)" ]; then
                printf "Error: Command \"$package\" is missing. Please install the dependency by typing \"apt-get install $package\".\n";
            elif [ ! -z "$(command -v yum)" ]; then
                printf "Error: Command \"$package\" is missing. Please install the dependency by typing \"yum install $package\".\n";
            else
                printf "Error: Command \"$package\" is missing. Please install \"$package\".\n";
            fi
            
        fi
        
    done
}

# Prints project's help.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return void

show_help()
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

show_version()
{
    # Logic
    
    printf "Alarm $version\n";
    
    cat "$source_dir/other/version.txt" && exit;
}

# Installs project's dependencies.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return void

install_dependencies()
{
    # Core Variables
    
    dependencies=$(echo "alsa-utils zenity" | tr " " "\n");
    
    # Logic
    
    for dependency in $dependencies; do
        
        if [ ! -z "$(command -v apt-get)" ]; then
            apt-get install $dependency -y;
        elif [ ! -z "$(command -v yum)" ]; then
            yum install $depndency -y;
        else
            printf "Error: Your system isn't supported.\n" && exit;
        fi;
        
    done
}
