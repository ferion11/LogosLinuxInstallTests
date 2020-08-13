#!/bin/bash
#=========================
die() { echo >&2 "$*"; exit 1; };
#=========================
export CHROOT_DISTRO="bionic"
export CHROOT_MIRROR="http://archive.ubuntu.com/ubuntu/"

# add deps for wine:
sudo dpkg --add-architecture i386 >/dev/null
sudo add-apt-repository -y ppa:cybermax-dexter/sdl2-backport >/dev/null || die "* add-apt-repository fail!"

# updating wine https://wiki.winehq.org/Ubuntu:
wget -q https://dl.winehq.org/wine-builds/winehq.key >/dev/null || die "* wget winehq.key fail!"
sudo apt-key add <./winehq.key || die "* apt-key fail!"
sudo add-apt-repository "deb https://dl.winehq.org/wine-builds/ubuntu/ ${CHROOT_DISTRO} main" >/dev/null
sudo apt-get -q -y update >/dev/null
sudo apt-get -q -y install procps mpg123 x264 ffmpeg xvfb xdotool x11-apps zenity winbind cabextract winetricks fuseiso binutils policykit-1 xdg-utils unzip unrar p7zip-full wget aria2 tor git sudo tar gzip xz-utils bzip2 gawk sed winehq-staging=5.11~bionic wine-staging=5.11~bionic wine-staging-amd64=5.11~bionic wine-staging-i386=5.11~bionic >/dev/null || die "* main apt fail!"
