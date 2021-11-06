#!/bin/bash
# You may add your name if you have contributed to this file.
echo -ne "
    ╔══════════════════════════════════════╗
    ║                                      ║
    ║ Linux/MacOS Translation utility 0.9  ║
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

bin_path=$HOME/Qt/5.15.2/clang_64/bin

until [[ -d $bin_path ]]; do
    echo =========
    echo -e "\033[31mPath to lupdate not found.\033[0m"
    echo -e "Please provide a path to /Qt/(version)/clang_64/bin."
    read bin_path
done

export PATH="$PATH":$bin_path
cd $(dirname $0)
echo lrelease *.ts
lrelease *.ts

echo finished
Countdown 10
exit
