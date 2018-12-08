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

# Gets initial input.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return void

get_initial_input()
{
    # Step 1 - Print Question
    
    printf -- "- What do you want to do?\n\n";
    
    # Step 2 - Print Options
    
    printf "1. Add an alarm\n";
    printf "2. Manage alarms\n";
    printf "3. Test alarm sound\n";
    printf "4. Display help\n";
    printf "5. Display version\n\n";
    
    # Step 3 - Get Answer
    
    read -rp "Option: " temp && printf "\n";
}

# Get add alarm input.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return void

get_add_alarm_input()
{
    # Step 1 - Print Question
    
    printf -- "- What do you want to add?\n\n";
    
    # Step 2 - Print Options
    
    printf "1. Alarm\n";
    printf "2. Countdown\n";
    printf "3. Interval\n\n";
    
    # Step 3 - Get Answer
    
    read -rp "Option: " temp && printf "\n";
}

# Gets manage alarms input.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return void

get_manage_alarms_input()
{
    # Step 1 - Print Question
    
    printf -- "- What do you want to do?\n\n";
    
    # Step 2 - Print Options
    
    printf "1. List alarms\n";
    printf "2. Remove an alarm\n";
    printf "3. Enable an alarm\n";
    printf "4. Disable an alarm\n\n";
    
    # Step 3 - Get Answer
    
    read -rp "Option: " temp && printf "\n";
}

# Gets test alarm sound input.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return void

get_test_alarm_sound_input()
{
    # Step 1 - Print Question
    
    printf -- "- What do you want to do?\n\n";
    
    # Step 2 - Print Options
    
    printf "1. Alarm\n";
    printf "2. Countdown\n";
    printf "3. Interval\n\n";
    
    # Step 3 - Get Answer
    
    read -rp "Option: " temp && printf "\n";
}

#################
# SET FUNCTIONS #
#################

# GET FUNCTIONS GO HERE

##################
# CORE FUNCTIONS #
##################

# Pauses script execution for a given time.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @param string $alarm_type
#   Identifier, ex. <i>alarm</i>, <i>countdown</i>, or <i>interval</i>.
# @param string $time
#   Time that the script should be paused.
# @return void

sleep_for()
{
    # Core Variables
    
    local alarm_type="$1";
    local time="$2";
    local seconds=0;
    local passed=0;
    
    # Other Variables
    
    local identifier="";
    local amount="";
    local input="";
    local diff="";
    
    # Step 1 - Determine Number Of Seconds For Pause
    
    local identifier=$(echo "$time" | grep -oP "[^0-9]+");
    local amount=$(echo "$time" | grep -oP "[0-9]+");
    
    if [ "$identifier" = "d" ]; then
        seconds=$(( amount * 24 * 60 * 60 ));
    elif [ "$identifier" = "h" ]; then
        seconds=$(( amount * 60 * 60 ));
    elif [ "$identifier" = "m" ]; then
        seconds=$(( amount * 60 ));
    elif [ "$identifier" = "s" ]; then
        seconds=$amount;
    fi
    
    # Step 2 - Pause Execution
    
    stty -icanon time 0 min 0;
    
    while [ "$passed" -lt "$seconds" ]; do
        
        for i in $(seq 1 4); do
            
            read -r input;
            
            if [ "$input" != "" ]; then
                
                diff=$(( seconds - passed ))
                
                if [ "$input" = "d" ]; then
                    diff=$(( ((diff / 60) / 60 ) / 24 )) && printf "ays requested...%s will end in %sd...\n" "$alarm_type" "$diff";
                elif [ "$input" = "h" ]; then
                    diff=$(( (diff / 60) / 60 )) && printf "ours requested...%s will end in %sh...\n" "$alarm_type" "$diff";
                elif [ "$input" = "m" ]; then
                    diff=$(( diff / 60 )) && printf "inutes requested...%s will end in %sm...\n" "$alarm_type" "$diff";
                elif [ "$input" = "s" ]; then
                    printf "econds requested...%s will end in %ss...\n" "$alarm_type" "$diff";
                elif [ "$input" = "q" ]; then
                    printf "uitting...\n" && exit;
                fi
                
            fi
            
            sleep 0.25;
            
        done
       
        passed=$(( passed + 1 ))
        
    done
}

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

play_sound_effect()
{
    # Core Variables
    
    local sound_effect="$1";
    local sound_volume="$2";
    local play_command="";
    
    # Regex Variables
    
    local wav_regex="(audio\/x-wav)$";
    local mp3_regex="(audio\/mpeg)$";
    
    # Other Variables
    
    local left_channel=$(amixer get "Master" | grep -oP "([0-9]+)%" | sed -n 1p);
    local right_channel=$(amixer get "Master" | grep -oP "([0-9]+)%" | sed -n 2p);
    
    # Step 1 - Process Arguments
    
    if [ -n "$(file --mime-type "$sound_effect" | grep -oP "$wav_regex")" ]; then
        
        play_command="aplay -q";
        
    elif [ -n "$(file --mime-type "$sound_effect" | grep -oP "$mp3_regex")" ]; then
        
        if [ -z "$(command -v ffplay)" ]; then
            printf "Error: MP3 support is optional, please install ffmpeg to enable it.\n" && exit;
        else
            play_command="ffplay -nodisp";
        fi
        
    else
        
        printf "Error: Provided audio file isn't supported. Only WAV & MP3 files are supported.\n" && exit
        
    fi
    
    # Step 2 - Play Sound Effect
    
    sound_effect=$(parse_value "$sound_effect");
    
    if [ -z "$sound_volume" ]; then
        execute_alarm_command "$play_command '$sound_effect' > /dev/null 2>&1" "$global_alarm";
    else
        execute_alarm_command "(amixer set 'Master' '$sound_volume%' && $play_command '$sound_effect' && amixer set 'Master' '$left_channel,$right_channel') > /dev/null 2>&1 &" "$global_alarm";
    fi
}

# Stops all alarms.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return void

stop_alarms()
{
    # Core Variables
    
    processes="$(pgrep -f alarm)";
    
    # Logic
    
    printf "Stopping alarms...\n\n";
    
    for process in $processes; do
        
        printf "Stopping alarm with PID: $process\n";
        
        kill "$process" > /dev/null 2>&1 &
        
    done
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

show_alarm_message()
{
    # Core Variables
    
    local alarm_message="$1";
    
    # Other Variables
    
    local active_displays=$(ls /tmp/.X11-unix | tr "X" ":");
    
    # Logic
    
    alarm_message=$(parse_value "$alarm_message");
    
    if [ -n "$alarm_display" ]; then
        
        execute_alarm_command "echo '$alarm_message' | zenity --title 'Alarm Message' --text-info --display=$alarm_display > /dev/null 2>&1 &" "$global_alarm";
        
    else
        
        for active_display in $active_displays; do
            
            if [ -n "$(echo "$active_display" | grep -oP "^:[0-9]+$")" ]; then
                execute_alarm_command "echo '$alarm_message' | zenity --title 'Alarm Message' --text-info --display=$active_display > /dev/null 2>&1 &" "$global_alarm";
            fi
            
        done
        
    fi
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

execute_alarm_command()
{
    # Core Variables
    
    local alarm_command="$1";
    local alarm_global="$2";
    
    # Other Variables
    
    local temp_file=$(mktemp);
    
    # Step 1 - Generate Temporary Script
    
    chmod 777 "$temp_file" && echo "$alarm_command" >> "$temp_file";
    
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

execute_alarm_script()
{
    # Core Variables
    
    local alarm_script="$1";
    local alarm_global="$2";
    
    # Other Variables
    
    local user_id="";
    local temp_file=$(mktemp);
    local logged_users=$(who | grep -oP "^([^\s]+)" | cut -f1 -d -);
    
    # Logic
    
    if [ "$alarm_global" = "yes" ]; then
        
        for user in $logged_users; do
            
            user_id="$(id -u "$user")";
            
            chmod 777 "$temp_file";
            
            echo "export XDG_RUNTIME_DIR='/run/user/$user_id'" >> "$temp_file" && cat "$alarm_script" >> "$temp_file";
            
            mv "$temp_file" "$alarm_script";
            
            sudo -u "$user" bash "$alarm_script" &
            
        done
        
    else
        
        user_id=$(id -u);
        
        export XDG_RUNTIME_DIR="/run/user/$user_id";
        
        bash "$alarm_script" &
        
    fi
}

# Gets input from a user interactively.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return void

get_user_input()
{
    # Core Variables
    
    local answer="";
    
    # Step 1 - Handle Initial Input
    
    get_initial_input;
    
    if [ "$temp" = "4" ]; then
        show_help="yes";
    elif [ "$temp" = "5" ]; then
        show_version="yes";
    elif [ "$temp" != "1" ] && [ "$temp" != "2" ] && [ "$temp" != "3" ]; then
        printf "Error: Invalid input provided.\n" && exit;
    fi
    
    # Step 2 - Handle Add Alarm Input
    
    if [ "$temp" = "1" ]; then
        
        get_add_alarm_input;
        
        if [ "$temp" = "1" ]; then
            alarm_type="alarm";
        elif [ "$temp" = "2" ]; then
            alarm_type="countdown";
        elif [ "$temp" = "3" ]; then
            alarm_type="interval";
        else
            printf "Error: Invalid input provided.\n" && exit;
        fi
        
        read -rp "Enter alarm's time: - " alarm_time && printf "\n";
        
        read -rp "Enter alarm's delay (optional): " alarm_delay && printf "\n";
        read -rp "Enter alarm's message (optional): " alarm_message && printf "\n";
        read -rp "Enter alarm's sound (optional): " sound_effect && printf "\n";
        read -rp "Enter alarm's volume (optional): " sound_volume && printf "\n";
        read -rp "Enter alarm's command (optional): " alarm_command && printf "\n";
        
        read -rp "Should alarm be global? (y/n) - " answer && printf "\n";
        
        if [ -n "$(echo "$answer" | grep -oP "$yes_regex")" ]; then
            global_alarm="yes";
        fi
        
        temp="";
        
    fi
    
    # Step 3 - Handle Manage Alarms Input
    
    if [ "$temp" = "2" ]; then
        
        get_manage_alarms_input;
        
        if [ "$temp" = "1" ]; then
            
            list_alarms="yes";
            
        else
            
            read -rp "Enter alarm's index: " alarm_index && printf "\n";
            
            if [ "$temp" = "2" ]; then
                remove_alarm="yes";
            elif [ "$temp" = "3" ]; then
                enable_alarm="yes";
            elif [ "$temp" = "4" ]; then
                disable_alarm="yes";
            else
                printf "Error: Invalid input provided.\n" && exit;
            fi
            
        fi
        
        temp="";
        
    fi
    
    # Step 4 - Handle Test Alarm Sound Input
    
    if [ "$temp" = "3" ]; then
        
        get_test_alarm_sound_input;
        
        if [ "$temp" = "1" ]; then
            alarm_type="alarm";
        elif [ "$temp" = "2" ]; then
            alarm_type="countdown";
        elif [ "$temp" = "3" ]; then
            alarm_type="interval";
        else
            printf "Error: Invalid input provided.\n" && exit;
        fi
        
        test_sound="yes";
        
        read -rp "Enter alarm's sound (optional): " sound_effect && printf "\n";
        read -rp "Enter alarm's volume (optional): " sound_volume && printf "\n";
        
    fi
}

###################
# CHECK FUNCTIONS #
###################

# CHECK FUNCTIONS GO HERE

###################
# OTHER FUNCTIONS #
###################

# Test plays a sound based on the provided parameters.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @param string $alarm_type
#   Type of an alarm, ex. <i>alarm</i>, <i>countdown</i>, or an <i>interval</i>.
# @param string $sound_effect
# @param integer $sound_volume
#   Master volume (percentage) that should be used during playback.
# @return void

test_sound()
{
    # Core Variables
    
    local alarm_type="$1";
    local sound_effect="$2";
    local sound_volume="$3";
    
    # Print Notice
    
    printf "%s sound testing...\n" "$alarm_type";
    
    # Play Effect
    
    play_sound_effect "$sound_effect" "$sound_volume";
}
