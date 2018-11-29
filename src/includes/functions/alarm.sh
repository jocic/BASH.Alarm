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
    
    alarm_type=$1;
    time=$2;
    seconds=0;
    passed=0;
    
    # Other Variables
    
    identifier="";
    amount="";
    input="";
    diff="";
    
    # Step 1 - Determine Number Of Seconds For Pause
    
    identifier=$(echo "$time" | grep -oP "[^0-9]+");
    amount=$(echo "$time" | grep -oP "[0-9]+");
    
    if [ "$identifier" = "d" ]; then
        seconds=$[ $amount * 24 * 60 * 60 ];
    elif [ "$identifier" = "h" ]; then
        seconds=$[ $amount * 60 * 60 ];
    elif [ "$identifier" = "m" ]; then
        seconds=$[ $amount * 60 ];
    elif [ "$identifier" = "s" ]; then
        seconds=$amount;
    fi
    
    # Step 2 - Pause Execution
    
    stty -icanon time 0 min 0;
    
    while [ "$passed" -lt "$seconds" ]; do
        
        for i in $(seq 1 4); do
            
            read input;
            
            if [ "$input" != "" ]; then
                
                diff=$((seconds - passed))
                
                if [ "$input" = "d" ]; then
                    diff=$(( ((diff / 60) / 60 ) / 24 )) && printf "ays requested...%s will end in %sd...\n" $alarm_type $diff;
                elif [ "$input" = "h" ]; then
                    diff=$(( ($diff / 60) / 60 )) && printf "ours requested...%s will end in %sh...\n" $alarm_type $diff;
                elif [ "$input" = "m" ]; then
                    diff=$(( diff / 60 )) && printf "inutes requested...%s will end in %sm...\n" $alarm_type $diff;
                elif [ "$input" = "s" ]; then
                    printf "econds requested...%s will end in %ss...\n" $alarm_type $diff;
                elif [ "$input" = "q" ]; then
                    printf "uitting...\n" && exit;
                fi
                
            fi
            
            sleep 0.25;
            
        done
       
        passed=$((passed + 1))
        
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
    
    sound_effect=$1;
    sound_volume=$2;
    play_command="";
    
    # Regex Variables
    
    wav_regex="(audio\/x-wav)$";
    mp3_regex="(audio\/mpeg)$";
    
    # Other Variables
    
    left_channel=$(amixer get "Master" | grep -oP "([0-9]+)%" | sed -n 1p);
    right_channel=$(amixer get "Master" | grep -oP "([0-9]+)%" | sed -n 2p);
    
    # Step 1 - Process Arguments
    
    if [ ! -z $(file --mime-type "$sound_effect" | grep -oP $wav_regex) ]; then
        
        play_command="aplay -q";
        
    elif [ ! -z $(file --mime-type "$sound_effect" | grep -oP $mp3_regex) ]; then
        
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

execute_alarm_command()
{
    # Core Variables
    
    alarm_command=$1;
    alarm_global=$2;
    
    # Other Variables
    
    temp_file=$(mktemp);
    
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
    
    alarm_script=$1;
    alarm_global=$2;
    
    # Other Variables
    
    user_id="";
    temp_file=$(mktemp);
    logged_users=$(who | grep -oP "^([^\s]+)" | cut -f1 -d -);
    
    # Logic
    
    if [ "$alarm_global" = "yes" ]; then
        
        for user in ${logged_users[@]}; do
            
            user_id=$(id -u $user);
            
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

# Lists available alarms.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return void

list_alarms()
{
    # Core Variables
    
    alarm="";
    alarm_hour="";
    alarm_minute="";
    alarm_period="";
    index=1;
    
    # Temp Variables
    
    temp="";
    temp_file=$(mktemp);
    
    # Step 1 - Gather Data
    
    crontab -l > "$temp_file" 2>&1;
    
    # Step 2 - Print Data
    
    printf "Available alarms:\n\n";
    
    while read alarm; do
        
        if [ ! -z $(echo "$alarm" | grep -oP "$alarm_mark$" | cut -c 1) ]; then
            
            temp=$(echo "$alarm" | grep -oP "^([0-9]+)\s([0-9]+)" | tr " " "\n");
            
            alarm_hour=$(echo "$temp" | sed -n 2p);
            alarm_minute=$(echo "$temp" | sed -n 1p);
            
            if [ "$alarm_hour" -lt "12" ]; then
                
                alarm_period="AM";
                
            else
                
                alarm_hour=$(( clock_hour - 12 ));
                alarm_period="PM";
                
            fi
            
            printf "%02d. alarm: %02d:%02d %s\n" $index $alarm_hour $alarm_minute $alarm_period;
            
            index=$(( index + 1 ));
            
        fi
        
    done < $temp_file;
}
