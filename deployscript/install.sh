#!/bin/bash
#=========================
die() { echo >&2 "$*"; exit 1; };
#=========================
export WINEHQ_STAGING_VERSION="5.11"
export UBUNTU_DISTRO="bionic"
export UBUNTU_MIRROR="http://archive.ubuntu.com/ubuntu/"

configure_wine_for_full_base() {
	# add deps for wine:
	sudo dpkg --add-architecture i386 >/dev/null
	sudo add-apt-repository -y ppa:cybermax-dexter/sdl2-backport >/dev/null || die "* add-apt-repository fail!"

	# updating wine https://wiki.winehq.org/Ubuntu:
	wget -q https://dl.winehq.org/wine-builds/winehq.key >/dev/null || die "* wget winehq.key fail!"
	sudo apt-key add <./winehq.key || die "* apt-key fail!"
	sudo add-apt-repository "deb https://dl.winehq.org/wine-builds/ubuntu/ ${UBUNTU_DISTRO} main" >/dev/null
	sudo apt-get -q -y update >/dev/null
}

install_minimal_monitor() {
	configure_wine_for_full_base
	sudo apt-get -q -y install procps psmisc mpg123 x264 imagemagick ffmpeg xvfb xdotool x11-apps zenity winbind cabextract gawk sed >/dev/null || die "* main apt fail!"
}

install_full_fixed() {
	configure_wine_for_full_base
	sudo apt-get -q -y install procps psmisc mpg123 x264 imagemagick ffmpeg xvfb xdotool x11-apps zenity winbind cabextract gawk sed winehq-staging="${WINEHQ_STAGING_VERSION}"~"${UBUNTU_DISTRO}" wine-staging="${WINEHQ_STAGING_VERSION}"~"${UBUNTU_DISTRO}" wine-staging-amd64="${WINEHQ_STAGING_VERSION}"~"${UBUNTU_DISTRO}" wine-staging-i386="${WINEHQ_STAGING_VERSION}"~"${UBUNTU_DISTRO}" >/dev/null || die "* main apt fail!"
}

install_full_last() {
	configure_wine_for_full_base
	sudo apt-get -q -y install procps psmisc mpg123 x264 imagemagick ffmpeg xvfb xdotool x11-apps zenity winbind cabextract gawk sed winehq-staging wine-staging wine-staging-amd64 wine-staging-i386 >/dev/null || die "* main apt fail!"
}

install_minimal_local_fixed() {
	configure_wine_for_full_base
	sudo apt-get -q -y install winbind cabextract winehq-staging="${WINEHQ_STAGING_VERSION}"~"${UBUNTU_DISTRO}" wine-staging="${WINEHQ_STAGING_VERSION}"~"${UBUNTU_DISTRO}" wine-staging-amd64="${WINEHQ_STAGING_VERSION}"~"${UBUNTU_DISTRO}" wine-staging-i386="${WINEHQ_STAGING_VERSION}"~"${UBUNTU_DISTRO}" || die "* main apt fail!"
}

install_minimal_local_last() {
	configure_wine_for_full_base
	sudo apt-get -q -y install winbind cabextract winehq-staging wine-staging wine-staging-amd64 wine-staging-i386 || die "* main apt fail!"
}

case "${1}" in
	"a")
		echo "* Fast option 1 Deps install:"
		install_full_last
		;;
	"b")
		echo "* Fast option 2 Deps install:"
		install_full_last
		;;
	"c")
		echo "* Fast option 3 Deps install:"
		install_full_last
		;;
	"d")
		echo "* Fast option 4 Deps install:"
		install_full_last
		;;
	"1")
		echo "* Option 1 Deps install:"
		install_minimal_monitor
		;;
	"2")
		echo "* Option 2 Deps install:"
		install_full_fixed
		;;
	"3")
		echo "* Option 3 Deps install:"
		install_full_fixed
		;;
	"4")
		echo "* Option 4 Deps install:"
		install_full_last
		;;
	"lf")
		echo "* Option local fixed at wine-staging ${WINEHQ_STAGING_VERSION} Deps install:"
		install_minimal_local_fixed
		;;
	"ll")
		echo "* Option local last wine-staging Deps install:"
		install_minimal_local_last
		;;
	*)
		echo "No arguments parsed."
		exit 1
esac
