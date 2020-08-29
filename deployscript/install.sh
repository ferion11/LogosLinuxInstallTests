#!/bin/bash
#=========================
die() { echo >&2 "$*"; exit 1; };
#=========================
export WINEHQ_STAGING_VERSION="5.11"
export UBUNTU_DISTRO="bionic"
export UBUNTU_MIRROR="http://archive.ubuntu.com/ubuntu/"

# add deps for wine:
sudo dpkg --add-architecture i386 >/dev/null
sudo add-apt-repository -y ppa:cybermax-dexter/sdl2-backport >/dev/null || die "* add-apt-repository fail!"

# updating wine https://wiki.winehq.org/Ubuntu:
wget -q https://dl.winehq.org/wine-builds/winehq.key >/dev/null || die "* wget winehq.key fail!"
sudo apt-key add <./winehq.key || die "* apt-key fail!"
sudo add-apt-repository "deb https://dl.winehq.org/wine-builds/ubuntu/ ${UBUNTU_DISTRO} main" >/dev/null
sudo apt-get -q -y update >/dev/null
sudo apt-get -q -y install procps psmisc mpg123 x264 ffmpeg xvfb xdotool x11-apps zenity winbind cabextract gawk sed winehq-staging="${WINEHQ_STAGING_VERSION}"~"${UBUNTU_DISTRO}" wine-staging="${WINEHQ_STAGING_VERSION}"~"${UBUNTU_DISTRO}" wine-staging-amd64="${WINEHQ_STAGING_VERSION}"~"${UBUNTU_DISTRO}" wine-staging-i386="${WINEHQ_STAGING_VERSION}"~"${UBUNTU_DISTRO}" >/dev/null || die "* main apt fail!"
