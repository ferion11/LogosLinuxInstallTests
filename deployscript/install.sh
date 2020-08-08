#!/bin/bash
#=========================
die() { echo >&2 "$*"; exit 1; };
#=========================
export CHROOT_DISTRO="bionic"
export CHROOT_MIRROR="http://archive.ubuntu.com/ubuntu/"

#==================================================================================================
#==================================================================================================
old_install() {
cat > /etc/apt/sources.list << EOF
###### Ubuntu Main Repos:
deb ${CHROOT_MIRROR} ${CHROOT_DISTRO} main restricted universe multiverse
deb-src ${CHROOT_MIRROR} ${CHROOT_DISTRO} main restricted universe multiverse

###### Ubuntu Update Repos:
deb ${CHROOT_MIRROR} ${CHROOT_DISTRO}-security main restricted universe multiverse
deb ${CHROOT_MIRROR} ${CHROOT_DISTRO}-updates main restricted universe multiverse
deb ${CHROOT_MIRROR} ${CHROOT_DISTRO}-proposed main restricted universe multiverse
deb ${CHROOT_MIRROR} ${CHROOT_DISTRO}-backports main restricted universe multiverse
deb-src ${CHROOT_MIRROR} ${CHROOT_DISTRO}-security main restricted universe multiverse
deb-src ${CHROOT_MIRROR} ${CHROOT_DISTRO}-updates main restricted universe multiverse
deb-src ${CHROOT_MIRROR} ${CHROOT_DISTRO}-proposed main restricted universe multiverse
deb-src ${CHROOT_MIRROR} ${CHROOT_DISTRO}-backports main restricted universe multiverse

EOF

apt-get -q -y update >/dev/null
echo "* Install software-properties-common..."
apt-get -q -y install software-properties-common apt-utils wget git sudo tar gzip xz-utils bzip2 gawk sed >/dev/null || die "* apt software-properties-common and apt-utils erro!"
dpkg --add-architecture i386 >/dev/null
#-------------------------------------------------

# add deps for wine:
add-apt-repository -y ppa:cybermax-dexter/sdl2-backport >/dev/null || die "* add-apt-repository fail!"

# updating wine https://wiki.winehq.org/Ubuntu:
wget -O - https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
add-apt-repository "deb https://dl.winehq.org/wine-builds/ubuntu/ ${CHROOT_DISTRO} main" >/dev/null
apt-get -q -y update >/dev/null
apt install -y --install-recommends imagemagick mpg123 xvfb xdotool x11-apps zenity winehq-staging winbind cabextract >/dev/null || die "* main apt fail!"
apt install -y --allow-downgrades --install-recommends winehq-staging=5.11~bionic wine-staging=5.11~bionic wine-staging-amd64=5.11~bionic wine-staging-i386=5.11~bionic >/dev/null || die "* downgrade apt fail!"
}
#==================================================================================================
#==================================================================================================

# add deps for wine:
sudo add-apt-repository -y ppa:cybermax-dexter/sdl2-backport >/dev/null || die "* add-apt-repository fail!"

# updating wine https://wiki.winehq.org/Ubuntu:
wget -O - https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
sudo add-apt-repository "deb https://dl.winehq.org/wine-builds/ubuntu/ ${CHROOT_DISTRO} main" >/dev/null
sudo apt-get -q -y update >/dev/null
sudo apt install -y --install-recommends mpg123 xvfb xdotool x11-apps zenity winehq-staging winbind cabextract >/dev/null || die "* main apt fail!"
sudo apt install -y --allow-downgrades --install-recommends winehq-staging=5.11~bionic wine-staging=5.11~bionic wine-staging-amd64=5.11~bionic wine-staging-i386=5.11~bionic >/dev/null || die "* downgrade apt fail!"
