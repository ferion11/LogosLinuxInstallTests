#!/bin/bash
#=========================
die() { echo >&2 "$*"; exit 1; };
#=========================
# result dir
mkdir result || die "* cant create result dir!"

# add deps for wine:
sudo add-apt-repository -y ppa:cybermax-dexter/sdl2-backport || die "* add-apt-repository fail!"

# updating wine https://wiki.winehq.org/Ubuntu:
wget -O - https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main'
sudo apt update
sudo apt install -y --install-recommends mpg123 xvfb xdotool x11-apps zenity winehq-staging winbind cabextract || die "* main apt fail!"
sudo apt install -y --allow-downgrades --install-recommends winehq-staging=5.11~bionic wine-staging=5.11~bionic wine-staging-amd64=5.11~bionic wine-staging-i386=5.11~bionic || die "* downgrade apt fail!"
