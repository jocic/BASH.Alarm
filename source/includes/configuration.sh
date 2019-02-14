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

# Gets a configuration a parameter from a desired configuration file.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @param string $config_key
#   Config. key to be used, ex. <i>version</i>.
# @param string $config_file
#   Config. file name that should be used, ex. <i>basic.conf</i>.
# @param string $config_dir
#   Config. directory name that should be used, ex. <i>my-directory</i>.
# @return integer
#   Value <i>0</i> for <i>SUCCESS</i>, or value <i>1</i> for <i>FAILURE</i>.

get_config_param()
{
    # Core Variables
    
    local config_key="$1";
    local config_file="$2";
    local config_dir="$3";
    local config_path="";
    
    # Other Variables
    
    local config="";
    local line_key="";
    local line_value="";
    
    # Step 1 - Check Provided Arguments
    
    if [ -z "$config_file" ]; then
        config_file="$J_A_CONF_FILE";
    elif [ $(is_config_file_valid "$config_file"; echo "$?") = 1 ]; then
        return 1;
    fi
    
    if [ -z "$config_dir" ]; then
        config_dir="$J_A_CONF_DIR";
    elif [ $(is_config_dir_valid "$config_dir"; echo "$?") = 1 ]; then
        return 1;
    fi
    
    if [ $(is_config_key_valid "$config_key"; echo "$?") = 1 ]; then
        return 1;
    fi
    
    if [ $(is_config_file_created "$config_file"; echo "$?") = 1 ]; then
        return 1;
    fi
    
    # Step 2 - Set Configuration Parameters
    
    config_path="$HOME/.config/$config_dir/$config_file";
    
    config=$(cat "$config_path");
   
    for config_line in $config; do
        
        line_key=$(printf "%s" "$config_line" | cut -d "=" -f 1);
        line_value=$(printf "%s" "$config_line" | cut -d "=" -f 2-);
        
        if [ "$line_key" = "$config_key" ]; then
            printf "$line_value" && break;
        fi
        
    done
    
    return 0;
}

#################
# SET FUNCTIONS #
#################

# Sets a configuration a parameter to a desired configuration file.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @param string $config_key
#   Config. key to be used, ex. <i>version</i>.
# @param string $config_value
#   Config. value to be used, ex. <i>1.0.0</i>.
# @param string $config_file
#   Config. file name that should be used, ex. <i>basic.conf</i>.
# @param string $config_dir
#   Config. directory name that should be used, ex. <i>my-directory</i>.
# @return integer
#   Value <i>0</i> for <i>SUCCESS</i>, or value <i>1</i> for <i>FAILURE</i>.

set_config_param()
{
    # Core Variables
    
    local config_key="$1";
    local config_value="$2";
    local config_file="$3";
    local config_dir="$4";
    local config_path="";
    
    # Other Variables
    
    local config="";
    local line_key="";
    local line_value="";
    
    # Step 1 - Check Provided Arguments
    
    if [ -z "$config_file" ]; then
        config_file="$J_A_CONF_FILE";
    elif [ $(is_config_file_valid "$config_file"; echo "$?") = 1 ]; then
        return 1;
    fi
    
    if [ -z "$config_dir" ]; then
        config_dir="$J_A_CONF_DIR";
    elif [ $(is_config_dir_valid "$config_dir"; echo "$?") = 1 ]; then
        return 1;
    fi
    
    if [ $(is_config_key_valid "$config_key"; echo "$?") = 1 ]; then
        return 1;
    fi
    
    if [ $(is_config_file_created "$config_file"; echo "$?") = 1 ]; then
        return 1;
    fi
    
    # Step 2 - Set Configuration Parameters
    
    config_path="$HOME/.config/$config_dir/$config_file";
    
    config=$(cat "$config_path");
    
    for config_line in $config; do
        
        line_key=$(printf "%s" "$config_line" | cut -d "=" -f 1);
        line_value=$(printf "%s" "$config_line" | cut -d "=" -f 2-);
        
        [ "$line_key" != "$config_key" ] \
            && printf "%s=%s\n" "$line_key" "$line_value" >> "$config_path.new";
        
    done
    
    printf "%s=%s\n" "$config_key" "$config_value" >> "$config_path.new";
    
    if [ -f "$config_path.new" ]; then
        mv "$config_path.new" "$config_path";
    fi
    
    return 1;
}

##################
# CORE FUNCTIONS #
##################

# Creates a configuration directory.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @param string $dir_name
#   Config. directory name that should be used, ex. <i>my-directory</i>.
# @return integer
#   Value <i>0</i> for <i>SUCCESS</i>, or value <i>1</i> for <i>FAILURE</i>.

create_config_dir()
{
    # Core Variables
    
    local dir_name="$1";
    
    # Other Variables
    
    local dir_path="";
    
    # Step 1 - Handle Passed Directory
    
    if [ -z "$dir_name" ]; then
        dir_name="$J_A_CONF_DIR";
    elif [ $(is_config_dir_valid "$dir_name"; echo "$?") = 1 ]; then
        return 1;
    fi
    
    # Step 2 - Create Directory
    
    dir_path="$HOME/.config/$dir_name";
    
    if [ ! -d "$dir_path" ]; then
        mkdir -p "$dir_path" > /dev/null 2>&1 && return "$?";
    fi
    
    return 1;
}

# Creates a basic configuration file.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @param string $file_name
#   Config. file name that should be used, ex. <i>basic.conf</i>.
# @param string $dir_name
#   Config. directory name that should be used, ex. <i>my-directory</i>.
# @return integer
#   Value <i>0</i> for <i>SUCCESS</i>, or value <i>1</i> for <i>FAILURE</i>.

create_config_file()
{
    # Core Variables
    
    local file_name="$1";
    local dir_name="$2";
    
    # Other Variables
    
    local file_path="";
    
    # Step 1 - Handle Passed File
    
    if [ -z "$file_name" ]; then
        file_name="$J_A_CONF_FILE";
    elif [ $(is_config_file_valid "$file_name"; echo "$?") = 1 ]; then
        return 1;
    fi
    
    # Step 2 - Handle Passed Directory
    
    if [ -z "$dir_name" ]; then
        dir_name="$J_A_CONF_DIR";
    elif [ $(is_config_dir_valid "$dir_name"; echo "$?") = 1 ]; then
        return 1;
    fi
    
    # Step 3 - Create File
    
    file_path="$HOME/.config/$dir_name/$file_name";
    
    if [ ! -f "$file_path" ]; then
        
        touch "$file_path" > /dev/null 2>&1;
        
        set_config_param "version" "$J_A_VERSION" "$file_name" "$dir_name";
        
        return 0;
        
    fi
    
    return 1;
}

###################
# CHECK FUNCTIONS #
###################

# Checks if a provided configuration directory name is valid or not.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @param string $dir_name
#   Config. directory name that should be checked, ex. <i>my-directory</i>.
# @return integer
#   Value <i>0</i> for <i>SUCCESS</i>, or value <i>1</i> for <i>FAILURE</i>.

is_config_dir_valid()
{
    # Core Variables
    
    local dir_name="$1";
    
    # Logic
    
    printf "%s" "$dir_name" | grep -qP "^[A-z0-9-]+$";
    
    return "$?";
}

# Checks if a configuration directory was created or not.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @param string $dir_name
#   Config. directory name that should be checked, ex. <i>my-directory</i>.
# @return integer
#   Value <i>0</i> for if it was created, and <i>1</i> if it wasn't.


is_config_dir_created()
{
    # Core Variables
    
    local dir_name="$1";
    
    # Logic
    
    [ -z "$dir_name" ] && dir_name="$J_A_CONF_DIR";
    
    [ $(is_config_dir_valid "$dir_name"; echo "$?") = 1 ] \
       || [ ! -d "$HOME/.config/$dir_name" ] \
           && return 1;
    
    return 0;
}

# Checks if a provided configuration filename name is valid or not.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @param string $file_name
#   Config. file name that should be checked, ex. <i>my-directory</i>.
# @return integer
#   Value <i>0</i> for <i>SUCCESS</i>, or value <i>1</i> for <i>FAILURE</i>.

is_config_file_valid()
{
    # Core Variables
    
    local file_name="$1";
    
    # Logic
    
    printf "%s" "$file_name" | grep -qP "^[A-z-.]+$";
    
    return "$?";
}

# Checks if a configuration file was created or not.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @param string $file_name
#   Config. file name that should be checked, ex. <i>my-directory</i>.
# @param string $dir_name
#   Config. directory name that should be checked, ex. <i>my-directory</i>.
# @return integer
#   Value <i>0</i> for if it was created, and <i>1</i> if it wasn't.

is_config_file_created()
{
    # Core Variables
    
    local file_name="$1";
    local dir_name="$2";
    
    # Logic
    
    [ -z "$file_name" ] && file_name="$J_A_CONF_FILE";
    
    [ -z "$dir_name" ] && dir_name="$J_A_CONF_DIR";
    
    [ $(is_config_dir_valid "$dir_name"; echo "$?") = 1 ] \
        || [ $(is_config_file_valid "$file_name"; echo "$?") = 1 ] \
            || [ ! -f "$HOME/.config/$dir_name/$file_name" ] \
                && return 1;
    
    return 0;
}

# Checks if a provided configuration key is valid or not.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @param string $config_key
#   Config. key that should be checked, ex. <i>version</i>.
# @return integer
#   Value <i>0</i> for <i>SUCCESS</i>, or value <i>1</i> for <i>FAILURE</i>.

is_config_key_valid()
{
    # Core Variables
    
    local config_key="$1";
    
    # Logic
    
    printf "%s" "$config_key" | grep -qP "^[A-z0-9-]+$";
    
    return "$?";
}

###################
# OTHER FUNCTIONS #
###################

# OTHER FUNCTIONS GO HERE
