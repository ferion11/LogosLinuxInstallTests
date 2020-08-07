#!/bin/bash
#=========================
die() { echo >&2 "$*"; exit 1; };
#=========================
export CHROOT_DISTRO="bionic"
export CHROOT_MIRROR="http://archive.ubuntu.com/ubuntu/"

# Ubuntu Main Repos:
echo "deb ${CHROOT_MIRROR} ${CHROOT_DISTRO} main restricted universe multiverse" > /etc/apt/sources.list
echo "deb-src ${CHROOT_MIRROR} ${CHROOT_DISTRO} main restricted universe multiverse" >> /etc/apt/sources.list

###### Ubuntu Update Repos:
echo "deb ${CHROOT_MIRROR} ${CHROOT_DISTRO}-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb ${CHROOT_MIRROR} ${CHROOT_DISTRO}-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb ${CHROOT_MIRROR} ${CHROOT_DISTRO}-proposed main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb ${CHROOT_MIRROR} ${CHROOT_DISTRO}-backports main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb-src ${CHROOT_MIRROR} ${CHROOT_DISTRO}-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb-src ${CHROOT_MIRROR} ${CHROOT_DISTRO}-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb-src ${CHROOT_MIRROR} ${CHROOT_DISTRO}-proposed main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb-src ${CHROOT_MIRROR} ${CHROOT_DISTRO}-backports main restricted universe multiverse" >> /etc/apt/sources.list

apt-get -q -y update >/dev/null
echo "* Install software-properties-common..."
apt-get -q -y install software-properties-common apt-utils wget git sudo tar gzip xz-utils bzip2 gawk sed fuse >/dev/null || die "* apt software-properties-common and apt-utils erro!"
#-------------------------------------------------

apt install -y --install-recommends imagemagick mpg123 xvfb xdotool x11-apps zenity winbind cabextract || die "* main apt fail!"

#==============================================================================
#==============================================================================

export INSTALLDIR="${HOME}/LogosBible_Linux_P_1"
export DISPLAY=:99.0

echo "======= DEBUG: Starting xvfb ======="
Xvfb $DISPLAY -screen 0 1024x768x24 &
Xvfb_PID=$!
sleep 7
echo "* Using DISPLAY: $DISPLAY"

#=========================
PRINT_NUM=1
printscreen() {
	xwd -display $DISPLAY -root -silent | convert xwd:- png:./screenshots_1/img_${PRINT_NUM}.png
	PRINT_NUM=$((PRINT_NUM+1))
}
#=========================

close_question_1_yes_1_windows() {
	while ! WID=$(xdotool search --name "Question: Install Logos Bible"); do
		sleep 3
	done
	printscreen
	echo "* Sending installer keystrokes..."
	xdotool key --delay 1000 Tab
	sleep 1
	xdotool key --delay 1000 Tab
	sleep 1
	xdotool key --delay 1000 space
	sleep 2
}

close_question_yes_windows() {
	while ! WID=$(xdotool search --name "Question:*"); do
		sleep 3
	done
	printscreen
	echo "* Sending installer keystrokes..."
	xdotool key --delay 1000 space
	sleep 2
}

close_question_no_windows() {
	while ! WID=$(xdotool search --name "Question:*"); do
		sleep 3
	done
	printscreen
	echo "* Sending installer keystrokes..."
	xdotool key --delay 1000 Tab
	sleep 1
	xdotool key --delay 1000 Tab
	sleep 1
	xdotool key --delay 1000 space
	sleep 2
}

close_wine_mono_init_windows() {
	while ! WID=$(xdotool search --name "Wine Mono Installer"); do
		sleep 3
	done
	printscreen
	echo "Sending installer keystrokes..."
	xdotool key --window $WID --delay 1000 Tab
	sleep 1
	xdotool key --window $WID --delay 1000 space
	sleep 2
}

close_wine_gecko_init_windows() {
	while ! WID=$(xdotool search --name "Wine Gecko Installer"); do
		sleep 3
	done
	printscreen
	echo "Sending installer keystrokes..."
	xdotool key --window $WID --delay 1000 Tab
	sleep 1
	xdotool key --window $WID --delay 1000 space
	sleep 2
}

wait_window_and_print(){
	while ! WID=$(xdotool search --name "$@"); do
		echo "... still waiting 1s ..."
		sleep 1
	done
	echo "... found! And print:"
	printscreen
}

logos_install_window(){
	while ! WID=$(xdotool search --name "Logos Bible Software Setup"); do
		sleep 3
	done
	printscreen
	echo "* Sending installer keystrokes..."
	xdotool key --delay 1000 space
	sleep 2
	printscreen
	xdotool key --delay 1000 space
	sleep 1
	xdotool key --delay 1000 Tab
	sleep 1
	xdotool key --delay 1000 Tab
	sleep 1
	xdotool key --delay 1000 Tab
	sleep 1
	xdotool key --delay 1000 space
	sleep 2
	printscreen
	xdotool key --delay 1000 space
	sleep 2
	printscreen
	xdotool key --delay 1000 space
	echo "... waiting 4min for the last screen ..."
	printscreen
	sleep 120
	echo "... only 2min pass, screenshot, more 2min to go ..."
	sleep 60
	echo "... only 3min pass, screenshot, more 1min to go ..."
	sleep 60
	echo "... end of 4min, screenshot and space key:"
	printscreen
	xdotool key --delay 1000 space
}

finish_the_script_at_end() {
	echo "------- Ending for DEBUG -------"
	# some more info:
	ps ux | grep wine
	printscreen

	kill -15 "${Xvfb_PID}"
	tar cvzf screenshots_1.tar.gz screenshots_1
	mv screenshots_1.tar.gz result/

	exit 0
}

#===========================================================================================
mkdir screenshots_1

chmod +x ./install_AppImageWine_and_Logos.sh

echo "* Starting install_AppImageWine_and_Logos.sh"
./install_AppImageWine_and_Logos.sh &
#--------


# Starting Steps here:
echo "* Question: using the AppImage installation (option 1):"
close_question_1_yes_1_windows

echo "* Downloading AppImage:"
sleep 1
printscreen
sleep 7
#---------------------------------
# waiting, get feedback, then extract, then change the links for docker run:
# waiting:
while ! WID_EXT=$(xdotool search --name "Question:*"); do
	sleep 2
done
# feedback:
echo "* ls -la on INSTALLDIR/data/bin and INSTALLDIR/data"
ls -la "${INSTALLDIR}/data/bin"
ls -la "${INSTALLDIR}/data"
# extract (to squashfs-root folder) and change links:
"${INSTALLDIR}/data/wine-i386_x86_64-archlinux.AppImage --appimage-extract"
rm -rf "${INSTALLDIR}/data/bin/wine"
rm -rf "${INSTALLDIR}/data/bin/wineserver"
ln -s "$(pwd)/squashfs-root/AppRun" "${INSTALLDIR}/data/bin/wine"
ln -s "$(pwd)/squashfs-root/AppRun" "${INSTALLDIR}/data/bin/wineserver"
# another feedback:
echo "* ls -la on INSTALLDIR/data/bin again for the Docker run:"
ls -la "${INSTALLDIR}/data/bin"
#---------------------------------


echo "* Question: wine bottle:"
close_question_yes_windows

echo "* Waiting to initialize wine..."
echo "* wine mono cancel:"
close_wine_mono_init_windows
echo "* wine gecko cancel:"
close_wine_gecko_init_windows


echo "* Question: winetricks:"
close_question_yes_windows

echo "* waiting Winetricks corefonts"
wait_window_and_print "Winetricks corefonts"

echo "* waiting Winetricks fontsmooth"
wait_window_and_print "Winetricks fontsmooth"

echo "* waiting Winetricks dotnet48"
wait_window_and_print "Winetricks dotnet48"

echo "* waiting Winetricks dotnet48 end with at least 8min"
sleep 480
echo "* end of the 8min waiting"


echo "* Question: download and install Logos"
close_question_yes_windows

echo "* Downloading Logos:"
sleep 1
printscreen
sleep 7

echo "* Logos install window:"
logos_install_window


echo "* Question: clean temp files"
close_question_yes_windows

echo "* Question: run Logos.sh"
close_question_yes_windows

echo "... waiting 30s to Logos start:"
sleep 30
printscreen
#---------------

# kill Xvfb whenever you feel like it
echo "* Stopping the Xvfb ..."
kill -15 "${Xvfb_PID}"
#---------------

tar cvzf screenshots_1.tar.gz screenshots_1
#-------------------------------------------------

echo "Packing tar result1 file..."
tar cvf result1.tar screenshots_1.tar.gz
echo "* result1.tar size: $(du -hs result1.tar)"
