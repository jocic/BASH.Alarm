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

# Plays an alarm sound effect, with an option to temporarily change the master
# volume of the system - both left & right sound channel independently.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @param string $sound_effect
#   Location of the sound effect that should be played.
# @param integer $sound_volume
#   Master volume (percentage) that should be used during playback.
# @return void

function play_sound_effect()
{
    # Core Variables
    
    sound_effect=$1;
    sound_volume=$2;
    
    # Regex Variables.
    
    effect_regex="(audio\/x-wav$)$";
    
    # Other Variables
    
    left_channel=$(amixer get "Master" | grep -oP "([0-9]+)%" | sed -n 1p);
    right_channel=$(amixer get "Master" | grep -oP "([0-9]+)%" | sed -n 2p);
    
    # Step 1 - Process Arguments
    
    if [[ ( ! -f "$sound_effect" ) || ( ! $(file --mime-type "$sound_effect") =~ $effect_regex ) ]]; then
        echo -e "Error: Invalid sound effect provided for playback." && exit;
    fi
    
    # Step 2 - Play Sound Effect
    
    sound_effect=$(parse_value "$sound_effect");
    
    if [[ -z "$sound_volume" ]]; then
        execute_alarm_command "aplay '$sound_effect' > /dev/null 2>&1" "$global_alarm";
    else
        execute_alarm_command "(amixer set 'Master' '$sound_volume%' && aplay '$sound_effect' && amixer set 'Master' '$left_channel,$right_channel') > /dev/null 2>&1 &" "$global_alarm";
    fi
}

# Shows an alarm message in form of a system notification.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @param string $alarm_message
#   Alarm message that should be shown.
# @return void

function show_alarm_message()
{
    # Core Variables
    
    alarm_message=$1;
    
    # Logic
    
    alarm_message=$(parse_value "$alarm_message");
    
    execute_alarm_command "echo '$alarm_message' | zenity --title 'Alarm Message' --text-info > /dev/null 2>&1 &" "$global_alarm";
}

# Executes command of an alarm.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @param string $alarm_command
#   Alarm command that should be executed.
# @param string $alarm_global
#   Flag <i>yes</i> if command should be executed globally, and vice versa.
# @return void

function execute_alarm_command()
{
    # Core Variables
    
    alarm_command=$1;
    alarm_global=$2;
    
    # Other Variables
    
    temp_file=$(mktemp);
    
    # Step 1 - Generate Temporary Script
    
    chmod 777 "$temp_file" && echo "$alarm_command" > "$temp_file";
    
    # Step 2 - Execute Temporary Script
    
    execute_alarm_script "$temp_file" "$alarm_global";
}

# Executes script of an alarm.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @param string $alarm_script
#   Alarm script that should be executed.
# @param string $alarm_global
#   Flag <i>yes</i> if script should be executed globally, and vice versa.
# @return void

function execute_alarm_script()
{
    # Core Variables
    
    alarm_script=$1;
    alarm_global=$2;
    
    # Other Variables
    
    logged_users=$(who | grep -oP "^([^\s]+)" | cut -f1 -d -);
    
    # Logic
    
    if [[ "$alarm_global" == "yes" ]]; then
        
        for user in ${logged_users[@]}; do
            sudo -u "$user" bash "$alarm_script" &
        done
        
    else
        
        bash "$alarm_script" &
        
    fi
}
