#!/bin/bash


# Functions
function display_title(){
    # Display title
    # You may add your name if you have contributed to this file.
    echo -e "
        ╔══════════════════════════════════════╗
        ║                                      ║
        ║  Linux/macOS Translation utility 1.0 ║
        ║     Powered by David Copperfield     ║
        ║             Jojo-Schmitz             ║
        ║                 2024                 ║
        ║                                      ║
        ╚══════════════════════════════════════╝"
}


function Line() {
    # Draw lines across the screen
    _window_width=$(tput cols) # Detect terminal width
    _style=$1                  # The style of the line e.g, ---, ====, etc.
    echo
    for ((i = 0; i < _window_width; i++)); do
        echo -n "$_style"
    done
    echo -e "\n"
}


function Countdown() {
    # Countdown timer, format: Countdown [time in sec]
    _countdown=$1
    while [[ $_countdown -gt 0 ]]; do
        echo -ne "The programme will exit in $_countdown sec."
        ((_countdown--))
        sleep 1 # time interval
        echo -ne "\r"
    done
}


function Confirmation() {
    # Process Yes/No/Quit response
    while :; do
        echo -e "Confirm? (y/n) "
        read -p "   "
        echo
        case ${REPLY} in
            # Approved
            [Yy]* | [Oo][Kk] | 1) 
                return 3
                ;;
            # Leave
            [Qq]uit* | [Ee]sc* | [Ee]xit | -1)
                Countdown 5
                exit
                ;;
            # Avoid empty input
            "")
                continue
                ;;
            # No / Not confirmed
            *)
                return
                ;;
        esac
    done
}


function get_qt_version(){
    # This function can get qt version via directory
    # Return: an array of version number in case there are multiple version
    local pattern="*.*.*"  # Pattern to match QT version
    cd "$HOME/Qt/" || exit # Go to QT directory
    items=()
    for e in *; do
        case "$e" in
            $pattern)
                items+=("$e")
                ;;
        esac
    done
}


# Functions End
# ===== Modules ====
qt_ver=5.15.2
CheckBinPath() { # Check if the bin path exists
    does_lupdate_exist=$(/usr/bin/env lupdate 2>/dev/null)
    if [[ $does_lupdate_exist ]]; then # if detected then continue
        return
    else
        case $(uname -s) in
        ### Default bin path for each system here ###
            # macOS
            Darwin)
                clang_path=$HOME/Qt/"$qt_ver"/clang_64
                ;;
            Linux)
                echo "Default path support for Linux will be added in the future."
                ;;
        esac
        until [[ -d $clang_path ]]; do # Confirm the existence of the default path
            echo ===========
            echo -e "\033[31mPath to lupdate / lrelease not found.\033[0m This utility requires lupdate / lrelease."
            echo -e "Please provide a path to the location of the \033[33mQt/\033[37m%VERSION%\033[33m/clang_64\033[0m folder."
            read -p "   " clang_path
        done
        # Configuring the temporary $PATH
        export QTDIR=$PATH:clang_path
        export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$QTDIR/lib
        export PATH=$PATH:$QTDIR/bin
    fi
    echo
    return
}


OpenLinguist() {
    echo -e Opening Linguist for
    for ts_file in "$@"; do
        echo "  $ts_file"
        open -a linguist "$(dirname $0)/$ts_file" || continue
    done
    return
}


Lupdate() { # Generating/Updating .ts files
    while :; do
        _ts_name=""
        echo -e "Language code example: \033[36mde, fr, zh-cn\033[0m
Input \033[33m*\033[0m to re-generate .ts files for existing languages.
You can create multiple .ts files by separating lang codes with space.\n"
        read -rp "  Input your language code: "
        case $REPLY in
            # Update all existing .ts files
            "*" | all) 
                echo
                cd $(dirname $0)
                _ts_name=$(find . -name "*.ts")
                echo -e "You are updating\033[33m all existing .ts files\033[0m."
                ;;
            # Avoid mis-press the Enter
            "") 
                echo
                continue
                ;;
            *)
                echo
                for each in $REPLY; do
                    _name=locale_$each.ts
                    echo -e "Your .ts file name: \033[33m${_name}\033[0m"
                    _ts_name=$_name" $_ts_name"
                done
                ;;
        esac
        Confirmation
        if [[ $? -eq 3 ]]; then break; fi
    done

    echo Generating ${_ts_name}
    cd $(dirname $0)
    lupdate .. -no-obsolete -locations absolute -ts ${_ts_name}
    OpenLinguist $_ts_name
    return
}


Lrelease() { # Generating/Updating .qm files
    cd $(dirname $0)
    echo "lrelease *.ts"
    lrelease *.ts
    return
}


# Module End
###########
Main() {
    display_title
    CheckBinPath
    while :; do
        echo -e "Choose the mode:\n1. Generate .ts files.\n2. Update .qm files."
        read -p "   "
        Line "="
        case $REPLY in
            1 | lupdate)
                Lupdate
                break
                ;;
            2 | lrelease)
                Lrelease
                break
                ;;
            [Qq]uit* | [Ee]* | -1)
                exit
                ;;
            *)
                continue
                ;;
        esac
    done
    # End of loop
    sleep 1
    Line "="
    echo -e "\033[32mFinished\033[0m"
    Countdown 30
    exit
}


# Main
get_qt_version
