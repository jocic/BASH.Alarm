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

user_id="$(id -u)";
source_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)";
version="1.2.0";

###################
# REGEX VARIABLES #
###################

alarm_regex="#?(.*)\s(.*)\s(.*)\s(.*)\s(.*)\sbash(.*)# ALARM,?(.*) #$";
time_regex="^(([0-9]+)(s|m|h|d)(,?))+$";
clock_regex="^([0-9]{2,2})(:)([0-9]{2,2})(\s)(AM|PM)$";
number_regex="^([0-9]+)$";
effect_regex="(audio\/x-wav|audio\/mpeg)$";
wav_regex="(audio\/x-wav)$";
mp3_regex="(audio\/mpeg)$";
volume_regex="^([0-9]{1,2}[0]?|100)$";
yes_regex="^Y|y$";

###############################
# GENERIC PARAMETER VARIABLES #
###############################

alarm_index="";
alarm_name="";
alarm_type="";
alarm_time="";
alarm_delay="";
alarm_command="";
alarm_message="";
sound_effect="";
sound_volume="";

###############################
# CONTROL PARAMETER VARIABLES #
###############################

alarm_removal="no";
alarm_enabling="no";
alarm_disabling="no";
test_sound="no";
global_alarm="no";
install_deps="no";
display_help="no";
display_version="no";
list_alarms="no";
interactive_mode="no";

###################
# OTHER VARIABLES #
###################

probe="";
temp="";

##############################
# STEP 1 - INCLUDE FUNCTIONS #
##############################

. "$source_dir/includes/script.sh";
. "$source_dir/includes/core.sh";
. "$source_dir/includes/alarm.sh";
. "$source_dir/includes/countdown.sh";
. "$source_dir/includes/interval.sh";

############################
# STEP 2 - PROCESS REQUEST #
############################

process_arguments "$@";

if [ "$install_deps" = "yes" ]; then
    
    if [ "$user_id" = "0" ]; then
        
        # Get Confirmation
        
        read -rp "Install dependencies? (y/n) - " temp;
        
        # Install Depndencies
        
        if [ -n "$(echo "$temp" | grep -oP "$yes_regex")" ]; then
            printf "\n" && install_dependencies;
        else
            printf "\nCancelling...\n";
        fi
        
    else
        printf "Error: You need root privileges to install dependencies.\n" && exit;
    fi
    
else
    
    # Check Dependencies
    
    temp=$(check_dependencies);
    
    if [ -n "$temp" ]; then
        printf "%s\n" "$temp" && exit;
    fi
    
    # Handle Interactive Mode
    
    if [ "$interactive_mode" = "yes" ]; then
        get_user_input;
    fi
    
    # Handle Request
    
    if [ "$display_help" = "yes" ]; then
        
        show_help;
        
    elif [ "$display_version" = "yes" ]; then
        
        show_version;
        
    elif [ "$list_alarms" = "yes" ]; then
        
        list_alarms;
        
    elif [ "$alarm_removal" = "yes" ]; then
        
        remove_alarm "$alarm_index";
        
    elif [ "$alarm_enabling" = "yes" ]; then
        
        enable_alarm "$alarm_index";
        
    elif [ "$alarm_disabling" = "yes" ]; then
        
        disable_alarm "$alarm_index";
        
    else
        
        # Check Privileges For Global Alarm
        
        if [ "$global_alarm" = "yes" ] && [ "$user_id" != "0" ]; then
            printf "Error: Global alarms can only be created by users with root privileges.\n" && exit;
        fi
        
        # Check Alarm Time
        
        if [ "$test_sound" = "no" ]; then
            
            if [ "$alarm_type" = "countdown" ] || [ "$alarm_type" = "interval" ] && [ -z "$(echo "$alarm_time" | grep -P "$time_regex")" ]; then
                printf "Error: Invalid time provided, please use an integer with the correct suffix.\n" && exit;
            elif [ "$alarm_type" = "alarm" ] && [ -z "$(echo "$alarm_time" | grep -oP "$clock_regex")" ]; then
                printf "Error: Invalid time provided, please use the HH:MM AM/PM format.\n" && exit;
            fi
            
        fi
        
        # Check Alarm Delay
        
        if [ "$test_sound" = "no" ] && [ -n "$alarm_delay" ] && [ -z "$(echo "$alarm_delay" | grep -oP "$number_regex")" ]; then
            printf "Error: Invalid alarm delay provided, please use an integer.\n" && exit;
        fi
        
        # Check Type
        
        if [ -z "$alarm_type" ]; then
            printf "Error: You haven't selected a type.\n" && exit;
        fi
        
        # Check Sound Effect
        
        if [ -z "$sound_effect" ] || [ -n "$(echo "$sound_effect" | grep -oP "$number_regex")" ]; then
            
            # Resolve Sound Effect ID
            
            if [ "$alarm_type" = "alarm" ]; then
                sound_effect=$(print_alarm_effect_path "$sound_effect");
            elif [ "$alarm_type" = "countdown" ]; then
                sound_effect=$(print_countdown_effect_path "$sound_effect");
            elif [ "$alarm_type" = "interval" ]; then
                sound_effect=$(print_interval_effect_path "$sound_effect");
            fi
            
            # Check Resolved Path
            
            if [ -z "$sound_effect" ]; then
                printf "Error: Invalid sound effect selected.\n" && exit;
            fi
            
        elif [ -f "$sound_effect" ]; then
            
            # Check Sound Effect
            
            if [ -z "$(file --mime-type "$sound_effect" | grep -oP "$effect_regex")" ]; then
                printf "Error: Unsupported audio file types used. Only WAV & MP3 files are supported.\n" && exit;
            fi
            
            # Check If MP3 Playback Requested
            
            if [ -n "$(file --mime-type "$sound_effect" | grep -oP "$mp3_regex")" ] && [ -z "$(command -v ffplay)" ]; then
                printf "Error: MP3 support is optional, please install ffmpeg to enable it.\n" && exit;
            fi
            
        fi
        
        # Check Sound Volume
        
        if [ -n "$sound_volume" ] && [ -z "$(echo "$sound_volume" | grep -oP "$volume_regex")" ]; then
            printf "Error: Invalid volume value provided, please use an integer with value between 0 to 100.\n" && exit;
        fi
        
        # Process Alarm Time
        
        if [ "$alarm_type" = "countdown" ] || [ "$alarm_type" = "interval" ]; then
            alarm_time=$(echo "$alarm_time" | tr "," "\n");
        else
            alarm_time=$(echo "$alarm_time" | tr ": " "\n");
        fi
        
        # Test Or Create Alarm
        
        if [ "$alarm_type" = "alarm" ]; then
            
            if [ "$test_sound" = "yes" ]; then
                test_sound "Alarm" "$sound_effect" "$sound_volume";
            else
                create_alarm "$source_dir" "$alarm_time" "$alarm_delay" "$alarm_message" "$sound_effect" "$sound_volume" "$alarm_command";
            fi
            
        elif [ "$alarm_type" = "countdown" ]; then
            
            if [ "$test_sound" = "yes" ]; then
                test_sound "Countdown" "$sound_effect" "$sound_volume";
            else
                create_countdown "$alarm_time" "$alarm_delay" "$alarm_message" "$sound_effect" "$sound_volume" "$alarm_command";
            fi
            
        elif [ "$alarm_type" = "interval" ]; then
            
            if [ "$test_sound" = "yes" ]; then
                test_sound "Interval" "$sound_effect" "$sound_volume";
            else
                create_interval "$alarm_time" "$alarm_delay" "$alarm_message" "$sound_effect" "$sound_volume" "$alarm_command";
            fi
            
        else
            
            printf "Invalid type selected.\n";
            
        fi
        
    fi
    
fi
