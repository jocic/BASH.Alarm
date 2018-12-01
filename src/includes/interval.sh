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

# Creates an interval based on the provided parameters.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @param string $interval_time
#   Interval time that should be used, ex. <i>10s</i> or <i>15s,10s</i>.
# @param integer $interval_delay
#   Interval delay that should be used, ex. <i>10</i> for a 10s delay.
# @param string $interval_message
#   Interval message that should be used, ex. <i>renew the cert</i>.
# @param string $interval_effect
#   Sound effect that should be used for an interval.
# @param integer $interval_volume
#   Master volume (percentage) that should be used during playback.
# @param string $interval_command
#   Command that should be executed when an interval is triggered.
# @return void

create_interval()
{
    # Core Variables
    
    local interval_time="$1";
    local interval_delay="$2";
    local interval_message="$3";
    local interval_effect="$4";
    local interval_volume="$5";
    local interval_command="$6";
    
    # Other Variables
    
    local interval="";
    
    # Step 1 - Print Notice
    
    interval=$(echo "$interval_time" | tr "\n" "-" | sed -e "s/-$//g");
    
    if [ ! -z "$interval_delay" ]; then
        printf "Starting a %s interval, after a %s second delay...\n" "$interval" "$interval_delay";
    else
        printf "Starting a %s interval...\n" "$interval";
    fi
    
    if [ ! -z "$interval_message" ]; then
        printf "\nFollowing message will be shown: %s\n" "$interval_message";
    fi
    
    printf "\nPress CTRL + C to stop it...\n\n";
    
    # Step 2 - Delay Interval
    
    if [ ! -z "$interval_delay" ]; then
        sleep_for "Delay" "${interval_delay}s";
    fi
    
    # Step 3 - Initialize Interval
    
    while [ 1 = 1 ]; do
        
        # Handle Multiple Interval Times
        
        for time in $interval_time; do
            
            # Delay Playback & Command Execution
            
            sleep_for "Interval" "$time";
            
            # Trigger Alarm
            
            play_sound_effect "$interval_effect" "$interval_volume" &
            
            if [ ! -z "$interval_message" ]; then
                show_alarm_message "$interval_message" &
            fi
            
            if [ ! -z "$interval_command" ]; then
                execute_alarm_command "$interval_command" &
            fi
            
        done
        
    done
}

###################
# CHECK FUNCTIONS #
###################

# CHECK FUNCTIONS GO HERE

###################
# OTHER FUNCTIONS #
###################

# Resolves a provided sound effect ID and prints the path toward it.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @param string $effect_id
#   ID of a sound effect that should be resolved.
# @return void

print_interval_effect_path()
{
    # Core Variables
    
    local effect_id="$1";
    
    # Logic
    
    case "$effect_id" in
        
        "")
            echo "$source_dir/effects/beeps/electronic-chime.wav";
        ;;
        
        "1")
            echo "$source_dir/effects/beeps/electronic-chime.wav";
        ;;
        
        "2")
            echo "$source_dir/effects/beeps/am-fm-beep.wav";
        ;;
        
        "3")
            echo "$source_dir/effects/beeps/beep-in-a.wav";
        ;;
        
        "4")
            echo "$source_dir/effects/beeps/generic-bleep.wav";
        ;;
        
    esac
}
