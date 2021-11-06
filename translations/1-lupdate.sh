#!/bin/bash
# You may add your name if you have contributed to this file.
echo -ne "
    ╔══════════════════════════════════════╗
    ║                                      ║
    ║     Powered by David Copperfield     ║
    ║           A MuseScore User           ║
    ║                                      ║
    ╚══════════════════════════════════════╝\n\n"

function Countdown() { # Countdown timer, format: Countdown [time in sec]
    countdown=$1
    while [[ $countdown -gt 0 ]]; do
        echo -ne "The programme will exit in $countdown sec."
        ((countdown--))
        sleep 1 #time interval
        echo -ne "\r"
    done
}
function Confirmation() { # Process Yes/No/Quit response
    while :; do
        echo -e "Confirm? (y/n) "
        read
        case ${REPLY} in
        [Yy]* | [Oo][Kk] | 1) # Approved
            return 3
            ;;
        [Qq]uit* | [Ee]sc* | -1) # Leave
            Countdown 5
            exit
            ;;
        "") # Avoid mis-press the Enter
            continue
            ;;
        *) # Not confirmed
            return
            ;;
        esac
    done
}

cd $(dirname $0)
bin_path=$HOME/Qt/5.15.2/clang_64/bin # Default bin path

until [[ -d $bin_path ]]; do # Find the default bin path
    echo =========
    echo -e "\033[31mPath to lupdate not found.\033[0m"
    echo -e "Please provide a path to /Qt/(version)/clang_64/bin."
    read bin_path
done

export PATH="$PATH":$bin_path # Set user defined bin path

while :; do
    read -rp "Input your language code: "
    case $REPLY in
    \* | all) # Update all existed .ts files
        ts_name=$(find . -name "*.ts")
        echo -e "You are updating\033[33m all existed .ts files\033[0m."
        ;;
    "") # Avoid mis-press the Enter
        continue
        ;;
    *)
        ts_name=./locale_${REPLY}.ts
        # ts_name+=$REPLY
        echo -e "Your ts file name is \033[33m${ts_name}\033[0m"
        ;;
    esac
    Confirmation
    if [[ $? -eq 3 ]]; then break; fi
done
echo Generating ${ts_name}
lupdate ../ -no-obsolete -locations absolute -ts ${ts_name}
sleep 1
echo -e "\033[32mFinished\033[0m"
Countdown 10
exit
