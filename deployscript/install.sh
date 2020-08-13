#!/bin/bash
#=========================
die() { echo >&2 "$*"; exit 1; };
#=========================
export CHROOT_DISTRO="bionic"
export CHROOT_MIRROR="http://archive.ubuntu.com/ubuntu/"

# add deps for wine:
sudo add-apt-repository -y ppa:cybermax-dexter/sdl2-backport || die "* add-apt-repository fail!"

# updating wine https://wiki.winehq.org/Ubuntu:
wget -O - https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
sudo add-apt-repository "deb https://dl.winehq.org/wine-builds/ubuntu/ ${CHROOT_DISTRO} main"
sudo apt-get -q -y update
sudo apt-get install -y procps mpg123 x264 ffmpeg xvfb xdotool x11-apps zenity winbind cabextract winetricks fuseiso binutils policykit-1 xdg-utils unzip unrar p7zip-full wget aria2 tor git sudo tar gzip xz-utils bzip2 gawk sed winehq-staging=5.11~bionic wine-staging=5.11~bionic wine-staging-amd64=5.11~bionic wine-staging-i386=5.11~bionic || die "* main apt fail!"
