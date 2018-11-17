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
    
    if [[ ( ! -f $sound_effect ) || ( ! $(file --mime-type $sound_effect) =~ $effect_regex ) ]]; then
        echo -e "Error: Invalid sound effect provided for playback." && exit;
    fi
    
    # Step 2 - Play Sound Effect
    
    if [[ -z $sound_volume ]]; then
        aplay $sound_effect > /dev/null 2>&1;
    else
        (amixer set "Master" "$sound_volume%" && aplay $sound_effect && amixer set "Master" "$left_channel,$right_channel") > /dev/null 2>&1 &
    fi
}
