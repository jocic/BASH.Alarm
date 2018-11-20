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

if [[ $test_sound == "yes" ]]; then
    
    # Print Notice
    
    echo -e "Testing interval sound...";
    
    # Play Effect
    
    play_sound_effect $sound_effect $sound_volume;
    
else
    
    # Print Notice
    
    if [[ ! -z $alarm_delay ]]; then
        echo "Starting a ${alarm_time[@]} interval, after a $alarm_delay second delay...";
    else
        echo -e "Starting a ${alarm_time[@]} interval...";
    fi
    
    echo -e "\nPress CTRL + C to stop it...";
    
    # Delay Interval
    
    if [[ ! -z $alarm_delay ]]; then
        sleep $alarm_delay;
    fi
    
    # Initialize Interval
    
    while [[ 1 == 1 ]]; do
        
        # Handle Multiple Interval Times
        
        for time in ${alarm_time[@]}; do
            
            # Delay Playback & Command Execution
            
            sleep $time;
            
            # Trigger Alarm
            
            play_sound_effect $sound_effect $sound_volume &
            
            if [[ ! -z $alarm_message ]]; then
                show_alarm_message "$alarm_message" &
            fi
            
            if [[ ! -z $alarm_command ]]; then
                execute_alarm_command "$alarm_command" &
            fi
            
        done
        
    done
    
fi
