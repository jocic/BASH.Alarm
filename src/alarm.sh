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

user_id=$(id -u);
source_dir="$(cd "$( dirname "${BASH_SOURCE[0]}")" && pwd)"
version="1.1.0";

###################
# REGEX VARIABLES #
###################

time_regex="^(([0-9]+)(s|m|h|d)(,?))+$";
clock_regex="^([0-9]{2,2})(:)([0-9]{2,2})(\s)(AM|PM)$";
number_regex="^([0-9]+)$";
effect_regex="(audio\/x-wav$)$";
volume_regex="^([0-9]{1,2}[0]?|100)$";

#######################
# PARAMETER VARIABLES #
#######################

alarm_type="";
alarm_time="";
alarm_delay="";
alarm_command="";
alarm_message="";
sound_effect="";
sound_volume="";
test_sound="no";
global_alarm="no";
install_deps="no";
display_help="no";
display_version="no";

###################
# OTHER VARIABLES #
###################

temp="";

##############################
# STEP 1 - INCLUDE FUNCTIONS #
##############################

source "$source_dir/includes/functions/core.sh";
source "$source_dir/includes/functions/alarm.sh";

############################
# STEP 2 - PROCESS REQUEST #
############################

process_arguments "$@";

if [[ $display_help == "yes" ]]; then
    
    show_help;
    
elif [[ $display_version == "yes" ]]; then
    
    show_version;
    
elif [[ $install_deps == "yes" ]]; then
    
    if [[ $user_id == "0" ]]; then
        
        # Get Confirmation
        
        read -p "Install dependencies? (y/n) - " -n 1 temp;
        
        # Install Depndencies
        
        if [[ $temp =~ ^[Yy]$ ]]; then
            echo -e "\n" && install_dependencies;
        else
            echo -e "\n\nCancelling...";
        fi
        
    else
        echo "Error: You need root privileges to install dependencies." && exit;
    fi
    
else
    
    ###############################
    # STEP 1 - CHECK DEPENDENCIES #
    ###############################
    
    temp=$(check_dependencies);
    
    if [[ ! -z $temp ]]; then
        echo $temp && exit;
    fi
    
    #############################
    # STEP 2 - CHECK PARAMETERS #
    #############################
    
    # Check Privileges For Global Alarm
    
    if [[ ( $global_alarm == "yes" ) && ( $user_id != "0" ) ]]; then
        echo -e "Error: Global alarms can only be created by users with root privileges." && exit;
    fi
    
    # Check Alarm Time
    
    if [[ $test_sound == "no" ]]; then
        
        if [[ ( $alarm_type == "countdown" || $alarm_type == "interval" ) && ( ! $alarm_time =~ $time_regex ) ]]; then
            echo -e "Error: Invalid time provided, please use an integer with the correct suffix." && exit;
        elif [[ ( $alarm_type == "alarm" ) && ( ! $alarm_time =~ $clock_regex ) ]]; then
            echo -e "Error: Invalid time provided, please use the HH:MM AM/PM format." && exit;
        fi
        
    fi
    
    # Check Alarm Delay
    
    if [[ ( $test_sound == "no" ) && ( ! -z $alarm_delay ) && ( ! $alarm_delay =~ $number_regex ) ]]; then
        echo -e "Error: Invalid alarm delay provided, please use an integer." && exit;
    fi
    
    # Check Type
    
    if [[ -z $alarm_type ]]; then
        echo -e "Error: You haven't selected a type." && exit;
    fi
    
    # Check Sound Effect
    
    if [[ ( -z $sound_effect ) || ( $sound_effect =~ $number_regex ) ]]; then
        
        # Handle Countdown & Alarm
        
        if [[ $alarm_type == "alarm" || $alarm_type == "countdown" ]]; then
            
            case $sound_effect in
                
                "")
                    sound_effect="$source_dir/effects/alarms/fire-alarm.wav";
                ;;
                
                "1")
                    sound_effect="$source_dir/effects/alarms/fire-alarm.wav";
                ;;
                
                "2")
                    sound_effect="$source_dir/effects/alarms/analogue-watch.wav";
                ;;
                
                "3")
                    sound_effect="$source_dir/effects/alarms/annoying-alarm.wav";
                ;;
                
                *)
                    echo -e "Error: Invalid sound effect selected." && exit;
                ;;
                
            esac
            
        fi
        
        # Handle Interval
        
        if [[ $alarm_type == "interval" ]]; then
            
            case $sound_effect in
                
                "")
                    sound_effect="$source_dir/effects/beeps/electronic-chime.wav";
                ;;
                
                "1")
                    sound_effect="$source_dir/effects/beeps/electronic-chime.wav";
                ;;
                
                "2")
                    sound_effect="$source_dir/effects/beeps/am-fm-beep.wav";
                ;;
                
                "3")
                    sound_effect="$source_dir/effects/beeps/beep-in-a.wav";
                ;;
                
                *)
                    echo -e "Error: Invalid sound effect selected." && exit;
                ;;
                
            esac
            
        fi
        
    elif [[ ( ! -f $sound_effect ) || ( ! $(file --mime-type $sound_effect) =~ $effect_regex ) ]]; then
        
        echo -e "Error: Invalid sound effect provided." && exit;
        
    fi
    
    # Check Sound Volume
    
    if [[ ( ! -z $sound_volume ) && ( ! $sound_volume =~ $volume_regex ) ]]; then
        echo -e "Error: Invalid volume value provided, please use an integer with value between 0 to 100." && exit;
    fi
    
    ###############################
    # STEP 3 - PROCESS ALARM TIME #
    ###############################
    
    if [[ ( $alarm_type == "countdown" || $alarm_type == "interval" ) ]]; then
        alarm_time=($(echo "$alarm_time" | tr "," "\n"));
    else
        alarm_time=($(echo "$alarm_time" | tr ":" "\n"));
    fi
    
    ############################
    # STEP 4 - PROCESS REQUEST #
    ############################
    
    if [[ $alarm_type == "alarm" ]]; then
        source "$source_dir/includes/create-alarm.sh";
    elif [[ $alarm_type == "countdown" ]]; then
        source "$source_dir/includes/create-countdown.sh";
    elif [[ $alarm_type == "interval" ]]; then
        source "$source_dir/includes/create-interval.sh";
    else
        echo -e "Invalid type selected.";
    fi
    
    exit;
    
fi
