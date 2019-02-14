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
# Core Variables #
##################

source_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)";

#################
# Primary Tests #
#################

# Tests validation function - <i>is_config_dir_valid</i>.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return integer
#   It always returns <i>0</i> - SUCCESS.

testDirectoryValidationFunction()
{
    # Step 1 - Test Valid Directory Names
    
    assertEquals 0 $(is_config_dir_valid "foo"; echo "$?");
    assertEquals 0 $(is_config_dir_valid "foo-bar"; echo "$?");
    assertEquals 0 $(is_config_dir_valid "foo-bar-123"; echo "$?");
    
    # Step 2 - Test Invalid Directory Names
    
    assertEquals 1 $(is_config_dir_valid ""; echo "$?");
    assertEquals 1 $(is_config_dir_valid "foo#"; echo "$?");
    assertEquals 1 $(is_config_dir_valid "foo-bar#"; echo "$?");
    
    return 0;
}

# Tests validation function - <i>is_config_file_valid</i>.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return integer
#   It always returns <i>0</i> - SUCCESS.

testFileValidationFunction()
{
    # Step 1 - Test Valid Directory Names
    
    assertEquals 0 $(is_config_file_valid "foo"; echo "$?");
    assertEquals 0 $(is_config_file_valid "foo-bar"; echo "$?");
    assertEquals 0 $(is_config_file_valid "foo-bar.conf"; echo "$?");
    
    # Step 2 - Test Invalid Directory Names
    
    assertEquals 1 $(is_config_file_valid ""; echo "$?");
    assertEquals 1 $(is_config_file_valid "foo#"; echo "$?");
    assertEquals 1 $(is_config_file_valid "foo-bar#"; echo "$?");
    
    return 0;
}

# Tests validation function - <i>is_config_key_valid</i>.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return integer
#   It always returns <i>0</i> - SUCCESS.

testKeyValidationFunction()
{
    # Step 1 - Test Valid Directory Names
    
    assertEquals 0 $(is_config_key_valid "foo"; echo "$?");
    assertEquals 0 $(is_config_key_valid "foo-123"; echo "$?");
    assertEquals 0 $(is_config_key_valid "foo-BAR"; echo "$?");
    
    # Step 2 - Test Invalid Directory Names
    
    assertEquals 1 $(is_config_key_valid ""; echo "$?");
    assertEquals 1 $(is_config_key_valid "foo#"; echo "$?");
    assertEquals 1 $(is_config_key_valid "foo-bar="; echo "$?");
    
    return 0;
}

# Tests creation function - <i>create_config_dir</i>.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return integer
#   It always returns <i>0</i> - SUCCESS.

testDirectoryCreationFunction()
{
    # Step 1 - Prepare Directories For Testing
    
    if [ -d "$HOME/.config/alarm" ]; then
        mv "$HOME/.config/alarm" "$HOME/.config/alarm.old";
    fi
    
    rm -rfd "$HOME/.config/alarm-test";
    
    # Step 2 - Test Creation Function
    
    assertEquals 0 $(create_config_dir ""; echo "$?"); # Doesn't Exist
    assertEquals 1 $(create_config_dir ""; echo "$?"); # Exists
    assertEquals 1 $(create_config_dir "test###"; echo "$?"); # Invalid
    assertEquals 0 $(create_config_dir "alarm-test"; echo "$?"); # Custom
    
    # Step 3 - Test Check Function
    
    assertEquals 0 $(is_config_dir_created ""; echo "$?"); # Exists
    assertEquals 1 $(is_config_dir_created "test"; echo "$?"); # Doesn't Exist
    assertEquals 0 $(is_config_dir_created "alarm"; echo "$?"); # Exists
    
    # Step 4 - Handle Old & Test Configurations
    
    rm -rfd "$HOME/.config/alarm" "$HOME/.config/alarm-test";
    
    if [ -d "$HOME/.config/alarm.old" ]; then
        mv "$HOME/.config/alarm.old" "$HOME/.config/alarm";
    fi
}

# Tests creation function - <i>create_config_file</i>.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return integer
#   It always returns <i>0</i> - SUCCESS.

testFileCreationFunction()
{
    # Step 1 - Prepare Directories For Testing
    
    if [ -d "$HOME/.config/alarm" ]; then
        mv "$HOME/.config/alarm" "$HOME/.config/alarm.old";
    fi
    
    mkdir "$HOME/.config/alarm";
    
    # Step 2 - Test Creation Function
    
    assertEquals 0 $(create_config_file ""; echo "$?"); # Doesn't Exist
    assertEquals 1 $(create_config_file ""; echo "$?"); # Exists
    assertEquals 1 $(create_config_file "test###"; echo "$?"); # Invalid
    assertEquals 0 $(create_config_file "some-config"; echo "$?"); # Custom
    assertEquals 1 $(create_config_file "" "###"; echo "$?"); # Invalid
    
    # Step 3 - Test Check Function
    
    assertEquals 0 $(is_config_file_created ""; echo "$?"); # Exists
    assertEquals 1 $(is_config_file_created "test"; echo "$?"); # Doesn't Exist
    assertEquals 0 $(is_config_file_created "basic.conf"; echo "$?"); # Exists
    
    # Step 4 - Handle Old & Test Configurations
    
    rm -rfd "$HOME/.config/alarm";
    
    if [ -d "$HOME/.config/alarm.old" ]; then
        mv "$HOME/.config/alarm.old" "$HOME/.config/alarm";
    fi
}

###################
# Secondary Tests #
###################

# Tests creation function - <i>create_config_dir</i>.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return integer
#   It always returns <i>0</i> - SUCCESS.

testGetSetFunctions()
{
    # Step 1 - Prepare Directories For Testing
    
    if [ -d "$HOME/.config/alarm" ]; then
        mv "$HOME/.config/alarm" "$HOME/.config/alarm.old";
    fi
    
    mkdir "$HOME/.config/alarm";
    
    touch "$HOME/.config/alarm/basic.conf";
    
    # Step 2 - Test Get & Set Function
    
    set_config_param "test-key-1" "test-value-1";
    set_config_param "test-key-2" "test-value-2";
    set_config_param "test-key-3" "test-value-3";
    
    assertEquals "test-value-1" $(get_config_param "test-key-1");
    assertEquals "test-value-2" $(get_config_param "test-key-2");
    assertEquals "test-value-3" $(get_config_param "test-key-3");
    
    # Step 3 - Test Specific Cases (Set)
    
    assertEquals 1 $(set_config_param "#" ""; echo "$?"); # Invalid Key
    assertEquals 1 $(set_config_param "" "" "#"; echo "$?"); # Invalid Conf.
    assertEquals 1 $(set_config_param "" "" "" "#"; echo "$?"); # Invalid Conf.
    assertEquals 1 $(set_config_param "" "" "test"; echo "$?"); # Missing Conf.
    
    # Step 4 - Test Specific Cases (Get)
    
    assertEquals 1 $(get_config_param "#" ; echo "$?"); # Invalid Key
    assertEquals 1 $(get_config_param "" "#"; echo "$?"); # Invalid Conf.
    assertEquals 1 $(get_config_param "" "" "#"; echo "$?"); # Invalid Conf.
    assertEquals 1 $(get_config_param "" "test"; echo "$?"); # Missing Conf.
    
    # Step 5 - Handle Old & Test Configurations
    
    rm -rfd "$HOME/.config/alarm";
    
    if [ -d "$HOME/.config/alarm.old" ]; then
        mv "$HOME/.config/alarm.old" "$HOME/.config/alarm";
    fi
}

##################
# Tertiary Tests #
##################

# TERTIARY TESTS GO HERE

########################
# Include Dependencies #
########################

export J_A_VERSION="1.2.4";
export J_A_CONF_DIR="alarm";
export J_A_CONF_FILE="basic.conf";

. "$source_dir/../../source/includes/configuration.sh";

##################
# Include SHUnit #
##################

. "$source_dir/../../other/shunit2/executable";
