#!/bin/bash
export SCRIPT_INSTALL_URL="https://github.com/ferion11/LogosLinuxInstaller/releases/download/v2.0-rc2/install_AppImageWine_and_Logos.sh"

#=========================
die() { echo >&2 "$*"; exit 1; };

PRINT_NUM=1
printscreen() {
	xwd -display :77 -root -silent | convert xwd:- png:./screenshot_${PRINT_NUM}.png
	PRINT_NUM=$((PRINT_NUM+1))
}
#=========================

#add-apt-repository ppa:pasgui/ppa -y
#add-apt-repository ppa:codeblocks-devs/release -y

#-----------------------------
dpkg --add-architecture i386
apt update
#apt install -y aptitude wget file bzip2 gcc-multilib
apt install -y aptitude wget file git tar gzip bzip2 grep sed procps libjpeg-turbo8 mpg123 wine xvfb xdotool imagemagick x11-apps zenity
#===========================================================================================

close_question_1_yes_windows() {
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
		echo "... still waiting ..."
		sleep 3
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
	echo "... waiting 5min for the last screen ..."
	sleep 60
	echo "... only 1min pass, screenshot, more 4min to go ..."
	printscreen
	sleep 120
	echo "... only 3min pass, screenshot, more 2min to go ..."
	printscreen
	sleep 120
	echo "... end of 5min, screenshot and space key:"
	printscreen
	xdotool key --delay 1000 space
}

finish_the_script_at_end() {
	echo "------- Ending for DEBUG -------"
	# some more info:
	ps ux | grep wine
	printscreen

	kill -15 "${Xvfb_PID}"
	tar cvzf screenshots.tar.gz ./screenshot*
	mv screenshots.tar.gz result/

	exit 0
}

#===========================================================================================

wget -c "${SCRIPT_INSTALL_URL}"
chmod +x ./install_AppImageWine_and_Logos.sh

echo "======= DEBUG: Starting xvfb ======="
Xvfb :77 -screen 0 1024x768x24 &
Xvfb_PID=$!
sleep 7
echo "* exporting the DISPLAY:"
export DISPLAY=:77
sleep 7
#--------

echo "* Starting install_AppImageWine_and_Logos.sh"
./install_AppImageWine_and_Logos.sh &
#--------

# Starting Steps here:

echo "* Question: using the AppImage installation (first option):"
close_question_1_yes_windows

echo "* Downloading AppImage:"
wait_window_and_print "Downloading *"
sleep 7


echo "* Question: wine bottle:"
close_question_yes_windows


echo "* Waiting to initialize wine..."
# 2 times, one for 32bit and another for 64bit (maybe 2)
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
wait_window_and_print "Downloading *"
sleep 7

echo "* Logos install window:"
logos_install_window


echo "* Question: clean temp files"
close_question_yes_windows


echo "* Question: run Logos.sh"
close_question_yes_windows

echo "... waiting 60s to Logos start:"
sleep 60
printscreen

echo "* closing all"
cd "$HOME/LogosBible_Linux_P/"
"./Logos.sh wine wineserver -k"
cd -

# Alternative to test only
#sleep 60 && printscreen
ps ux | grep wine


# kill Xvfb whenever you feel like it
kill -15 "${Xvfb_PID}"
#---------------

tar cvzf screenshots.tar.gz ./screenshot*

mv screenshots.tar.gz result/
