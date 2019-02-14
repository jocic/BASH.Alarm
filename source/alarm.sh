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
alarm_display="";
sound_effect="";
sound_volume="";
dump_location="";

###############################
# CONTROL PARAMETER VARIABLES #
###############################

install_deps="no";
interactive_mode="no";
show_help="no";
show_version="no";
list_alarms="no";
remove_alarm="no";
enable_alarm="no";
disable_alarm="no";
toggle_alarm="no";
import_alarms="no";
export_alarms="no";
stop_alarms="no";
global_alarm="no";
test_sound="no";
verbose_mode="no";

###################
# OTHER VARIABLES #
###################

queue="";
probe="";
temp="";

##################################
# Step 1 - Export Core Variables #
##################################

export J_A_USER_ID="$(id -u)";
export J_A_SOURCE_DIR="$(cd -- "$(dirname -- "$0")" && pwd -P)";
export J_A_VERSION="1.2.4";
export J_A_CONF_DIR="alarm";
export J_A_CONF_FILE="basic.conf";
export J_A_SUPRESS_DCHECK="no";

##############################
# Step 2 - Include Functions #
##############################

. "$J_A_SOURCE_DIR/includes/core.sh";
. "$J_A_SOURCE_DIR/includes/alarm-core.sh";
. "$J_A_SOURCE_DIR/includes/alarm.sh";
. "$J_A_SOURCE_DIR/includes/countdown.sh";
. "$J_A_SOURCE_DIR/includes/interval.sh";

##############################
# STEP 3 - Process Arguments #
##############################

for arg in "$@"; do
    
    # Assign Queued Values
    
    [ "$queue" = "time" ] && alarm_time=$arg;
    
    [ "$queue" = "delay" ] && alarm_delay=$arg;
    
    [ "$queue" = "message" ] && alarm_message=$arg;
    
    [ "$queue" = "sound" ] && sound_effect=$arg;
    
    [ "$queue" = "volume" ] && sound_volume=$arg;
    
    [ "$queue" = "name" ] && alarm_name=$arg;
    
    [ "$queue" = "remove" ] || [ "$queue" = "enable" ] || [ "$queue" = "disable" ] || [ "$queue" = "toggle" ] && alarm_index=$arg;
    
    [ "$queue" = "export" ] || [ "$queue" = "import" ] && dump_location=$arg;
    
    [ "$queue" = "alarm-display" ] && alarm_display=$arg;
    
    [ "$queue" = "alarm-command" ] && alarm_command="$arg";
    
    # Reset Queue Value
    
    queue="";
    
    # Queue Commands
    
    [ "$arg" = "-t" ] || [ "$arg" = "--time" ] && queue="time";
    
    [ "$arg" = "-d" ] || [ "$arg" = "--delay" ] && queue="delay";
    
    [ "$arg" = "-m" ] || [ "$arg" = "--message" ] && queue="message";
    
    [ "$arg" = "-s" ] || [ "$arg" = "--sound" ] && queue="sound";
    
    [ "$arg" = "-v" ] || [ "$arg" = "--volume" ] && queue="volume";
    
    [ "$arg" = "-n" ] || [ "$arg" = "--name" ] && queue="name";
    
    [ "$arg" = "-a" ] || [ "$arg" = "--alarm" ] && alarm_type="alarm" && queue="alarm-command";
    
    [ "$arg" = "-c" ] || [ "$arg" = "--countdown" ] && alarm_type="countdown" && queue="alarm-command";
    
    [ "$arg" = "-i" ] || [ "$arg" = "--interval" ] && alarm_type="interval" && queue="alarm-command";
    
    [ "$arg" = "-r" ] || [ "$arg" = "--remove" ] && remove_alarm="yes" && queue="remove";
    
    [ "$arg" = "-e" ] || [ "$arg" = "--enable" ] && enable_alarm="yes" && queue="enable";
    
    [ "$arg" = "-b" ] || [ "$arg" = "--disable" ] && disable_alarm="yes" && queue="disable";
    
    [ "$arg" = "-o" ] || [ "$arg" = "--toggle" ] && toggle_alarm="yes" && queue="toggle";
    
    [ "$arg" = "--verbose" ] && verbose_mode="yes";
    
    [ "$arg" = "--import" ] && import_alarms="yes" && queue="import";
    
    [ "$arg" = "--export" ] && export_alarms="yes" && queue="export";
    
    [ "$arg" = "--display" ] && queue="alarm-display";
    
    [ "$arg" = "-g" ] || [ "$arg" = "--global" ] && global_alarm="yes";
    
    [ "$arg" = "-h" ] || [ "$arg" = "--help" ] && show_help="yes";
    
    [ "$arg" = "-l" ] || [ "$arg" = "--list" ] && list_alarms="yes";
    
    [ "$arg" = "--stop" ] && stop_alarms="yes";
    
    [ "$arg" = "--test" ] && test_sound="yes";
    
    [ "$arg" = "--interactive" ] && interactive_mode="yes";
    
    [ "$arg" = "--install" ] && install_deps="yes";
    
    [ "$arg" = "--version" ] && show_version="yes";
    
    [ "$arg" = "--suppress-dependency-check" ] && J_A_SUPRESS_DCHECK="yes";
    
done

############################
# STEP 4 - PROCESS REQUEST #
############################

if [ "$install_deps" = "yes" ]; then
    
    if [ "$J_A_USER_ID" = "0" ]; then
        
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
    
    if [ "$J_A_SUPRESS_DCHECK" = "no" ]; then
        
        temp=$(check_dependencies);
        
        if [ -n "$temp" ]; then
            printf "%s\n" "$temp" && exit;
        fi
        
    fi
    
    # Handle Interactive Mode
    
    if [ "$interactive_mode" = "yes" ]; then
        get_user_input;
    fi
    
    # Handle Request
    
    if [ "$show_help" = "yes" ]; then
        
        show_help;
        
    elif [ "$show_version" = "yes" ]; then
        
        show_version;
        
    elif [ "$list_alarms" = "yes" ]; then
        
        list_alarms "$verbose_mode";
        
    elif [ "$remove_alarm" = "yes" ]; then
        
        remove_alarm "$alarm_index" "$verbose_mode";
        
    elif [ "$enable_alarm" = "yes" ]; then
        
        enable_alarm "$alarm_index" "$verbose_mode";
        
    elif [ "$disable_alarm" = "yes" ]; then
        
        disable_alarm "$alarm_index" "$verbose_mode";
        
    elif [ "$toggle_alarm" = "yes" ]; then
        
        toggle_alarm "$alarm_index" "$verbose_mode";
        
    elif [ "$import_alarms" = "yes" ]; then
        
        import_alarms "$dump_location";
        
    elif [ "$export_alarms" = "yes" ]; then
        
        export_alarms "$dump_location";
        
    elif [ "$stop_alarms" = "yes" ]; then
        
        stop_alarms;
        
    else
        
        # Check Privileges For Global Alarm
        
        if [ "$global_alarm" = "yes" ] && [ "$J_A_USER_ID" != "0" ]; then
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
        
        # Check Alarm Display
        
        if [ -n "$alarm_display" ] && [ -z "$(echo "$alarm_display" | grep -oP "^(:[0-9]+)?(.[0-9]+)$")" ]; then
            printf "Error: Invalid alarm display selected, try using a :0 or :0.0 format.\n" && exit;
        fi
        
        # Check Type
        
        if [ -z "$alarm_type" ]; then
            printf "Error: You haven't selected a type.\n" && exit;
        fi
        
        # Check Sound Effect
        
        if [ -z "$sound_effect" ] || [ -n "$(echo "$sound_effect" | grep -oP "$number_regex")" ]; then
            
            # Resolve Sound Effect ID
            
            if [ "$alarm_type" = "alarm" ]; then
                sound_effect=$(print_alarm_effect_path "$J_A_SOURCE_DIR/effects/alarms" "$sound_effect");
            elif [ "$alarm_type" = "countdown" ]; then
                sound_effect=$(print_countdown_effect_path "$J_A_SOURCE_DIR/effects/alarms" "$sound_effect");
            elif [ "$alarm_type" = "interval" ]; then
                sound_effect=$(print_interval_effect_path "$J_A_SOURCE_DIR/effects/beeps" "$sound_effect");
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
                test_sound "Alarm" "$global_alarm" "$sound_effect" "$sound_volume";
            else
                create_alarm "$J_A_SOURCE_DIR" "$alarm_time" "$alarm_delay" "$alarm_message" "$sound_effect" "$sound_volume" "$alarm_command" "$global_alarm" "$alarm_display";
            fi
            
        elif [ "$alarm_type" = "countdown" ]; then
            
            if [ "$test_sound" = "yes" ]; then
                test_sound "Countdown" "$global_alarm" "$sound_effect" "$sound_volume";
            else
                create_countdown "$alarm_time" "$alarm_delay" "$alarm_message" "$sound_effect" "$sound_volume" "$alarm_command" "$global_alarm" "$alarm_display";
            fi
            
        elif [ "$alarm_type" = "interval" ]; then
            
            if [ "$test_sound" = "yes" ]; then
                test_sound "Interval" "$global_alarm" "$sound_effect" "$sound_volume";
            else
                create_interval "$alarm_time" "$alarm_delay" "$alarm_message" "$sound_effect" "$sound_volume" "$alarm_command" "$global_alarm" "$alarm_display";
            fi
            
        else
            
            printf "Invalid type selected.\n";
            
        fi
        
    fi
    
fi
