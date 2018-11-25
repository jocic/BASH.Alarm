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

cron_details="";
cron_task="";

###################
# OTHER VARIABLES #
###################

cron_hour="";
cron_minutes="";
temp_file=$(mktemp);

#########
# LOGIC #
#########

if [[ "$test_sound" == "yes" ]]; then
    
    # Print Notice
    
    echo -e "Testing alarm sound...";
    
    # Play Effect
    
    play_sound_effect $sound_effect $sound_volume;
    
else
    
    # Print Notice
    
    echo "Creating an alarm that will trigger at ${alarm_time[0]}:${alarm_time[1]} ${alarm_time[2]} everyday...";
    
    # Get Crontab Details
    
    cron_details=$(crontab -l > "$temp_file" 2>&1 && cat "$temp_file");
    
    # Handle 12-Hour Clock
    
    cron_hour=$(echo "${alarm_time[0]}" | sed "s/^0//");
    cron_minutes=$(echo "${alarm_time[1]}" | sed "s/^0//");
    
    if [[ "${alarm_time[2]}" == "PM" ]]; then
        
        if [[ "${alarm_time[0]}" == "12" ]]; then
            cron_hour=0;
        else
            cron_hour=$[ $cron_hour + 12 ];
        fi
        
    fi
    
    # Parse Cron Parameters
    
    source_dir=$(parse_value "$source_dir");
    sound_effect=$(parse_value "$sound_effect");
    alarm_message=$(parse_value "$alarm_message");
    alarm_command=$(parse_value "$alarm_command");
    
    # Generate Cron Task
    
    cron_task="$cron_minutes $cron_hour * * * bash '$source_dir/alarm.sh' -t 0s";
    
    cron_task="$cron_task -s '$sound_effect'";
    
    if [[ $global_alarm == "yes" ]]; then
        cron_task="$cron_task --global";
    fi
    
    if [[ ! -z "$sound_volume" ]]; then
        cron_task="$cron_task -v '$sound_volume'";
    fi
    
    if [[ ! -z "$alarm_message" ]]; then
        cron_task="$cron_task -m '$alarm_message'";
    fi
    
    if [[ -z "$alarm_command" ]]; then
        cron_task="$cron_task -c";
    else
        cron_task="$cron_task -c '$alarm_command'";
    fi
    
    # Add Cron Task
    
    cron_details="$cron_details\n$cron_task";
    
    echo -e "$cron_details" | crontab;
    
fi
