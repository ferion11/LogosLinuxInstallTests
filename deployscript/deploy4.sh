#!/bin/bash
#=========================
die() { echo >&2 "$*"; exit 1; };
#=========================
echo "------- Running: -------"
head -3 ./install_AppImageWine_and_Logos.sh
echo "---------------------"

if [ -z "$WORKDIR" ]; then export WORKDIR="$(mktemp -d)" ; fi
if [ -z "$INSTALLDIR" ]; then export INSTALLDIR="$HOME/LogosBible_Linux_P_4" ; fi

echo "******* Option 4 *******"
export DISPLAY=:95.0

echo "======= DEBUG: Starting xvfb ======="
Xvfb $DISPLAY -screen 0 1024x768x24 &
Xvfb_PID=$!
sleep 7
echo "* Using DISPLAY: $DISPLAY"

#=========================
PRINT_NUM=1
printscreen() {
	xwd -display $DISPLAY -root -silent | convert xwd:- png:./screenshots_4/img_${PRINT_NUM}.png
	PRINT_NUM=$((PRINT_NUM+1))
}
#=========================

close_question_1_yes_1_windows() {
	while ! WID=$(xdotool search --name "Question: Install Logos Bible"); do
		sleep "1"
	done
	printscreen
	echo "* Sending installer keystrokes..."
	xdotool key --delay 500 Tab
	sleep "0.5"
	xdotool key --delay 500 Tab
	sleep "0.5"
	xdotool key --delay 500 space
	sleep "0.5"
}

close_question_1_yes_4_windows() {
	while ! WID=$(xdotool search --name "Question: Install Logos Bible"); do
		sleep "1"
	done
	printscreen
	echo "* Sending installer keystrokes..."
	xdotool key --delay 500 Tab
	sleep "0.5"
	xdotool key --delay 500 Tab
	sleep "0.5"
	xdotool key --delay 500 Tab
	sleep "0.5"
	xdotool key --delay 500 Down
	sleep "0.5"
	xdotool key --delay 500 Down
	sleep "0.5"
	xdotool key --delay 500 Down
	sleep "0.5"
	xdotool key --delay 500 space
	sleep "0.5"
	xdotool key --delay 500 Tab
	sleep "0.5"
	xdotool key --delay 500 Tab
	sleep "0.5"
	printscreen
	xdotool key --delay 500 space
	sleep "0.5"
}

close_question_yes_windows() {
	while ! WID=$(xdotool search --name "Question:*"); do
		sleep "1"
	done
	printscreen
	echo "* Sending installer keystrokes..."
	xdotool key --delay 500 space
	sleep "0.5"
}

close_question_no_windows() {
	while ! WID=$(xdotool search --name "Question:*"); do
		sleep "1"
	done
	printscreen
	echo "* Sending installer keystrokes..."
	xdotool key --delay 500 Tab
	sleep "0.5"
	xdotool key --delay 500 Tab
	sleep "0.5"
	xdotool key --delay 500 space
	sleep "0.5"
}

close_wine_mono_init_windows() {
	while ! WID=$(xdotool search --name "Wine Mono Installer"); do
		sleep "1"
	done
	printscreen
	echo "Sending installer keystrokes..."
	xdotool key --window $WID --delay 500 Tab
	sleep "0.5"
	xdotool key --window $WID --delay 500 space
	sleep "0.5"
}

close_wine_gecko_init_windows() {
	while ! WID=$(xdotool search --name "Wine Gecko Installer"); do
		sleep "1"
	done
	printscreen
	echo "Sending installer keystrokes..."
	xdotool key --window $WID --delay 500 Tab
	sleep "0.5"
	xdotool key --window $WID --delay 500 space
	sleep "0.5"
}

close_wine_error_init_windows() {
	while ! WID="$(xdotool search --name "rundll32.exe*")"; do
		sleep "1"
	done
	printscreen
	echo "Sending installer keystrokes..."
	xdotool key --window $WID --delay 500 Tab
	sleep "0.5"
	xdotool key --window $WID --delay 500 space
	sleep "0.5"
}

wait_window_and_print(){
	echo "* start waiting for $@ ..."
	while ! WID=$(xdotool search --name "$@"); do
		sleep "0.2"
	done
	echo "... found \"${*}\"! And print:"
	printscreen
}

logos_install_window(){
	while ! WID=$(xdotool search --name "Logos Bible Software Setup"); do
		sleep "1"
	done
	printscreen
	echo "* Sending installer keystrokes..."
	xdotool key --delay 500 space
	sleep 1
	printscreen
	xdotool key --delay 500 space
	sleep "0.5"
	xdotool key --delay 500 Tab
	sleep "0.5"
	xdotool key --delay 500 Tab
	sleep "0.5"
	xdotool key --delay 500 Tab
	sleep "0.5"
	xdotool key --delay 500 space
	sleep 1
	printscreen
	xdotool key --delay 500 space
	sleep 1
	printscreen
	xdotool key --delay 500 space
	echo "... waiting 4min for the last screen ..."
	printscreen
	sleep 120
	echo "... only 2min pass, screenshot, more 2min to go ..."
	sleep 60
	echo "... only 3min pass, screenshot, more 1min to go ..."
	sleep 60
	echo "... end of 4min, screenshot and space key:"
	printscreen
	xdotool key --delay 500 space
}

echo "* Starting the video record:"
ffmpeg -loglevel quiet -f x11grab -video_size 1024x768 -i $DISPLAY -codec:v libx264 -r 12 video4.mp4 &
FFMPEG_PID=${!}
finish_the_script_at_end() {
	echo "------- Ending for DEBUG -------"
	# some more info:
	ps ux | grep wine
	printscreen

	kill -SIGTERM "${FFMPEG_PID}"
	sleep 2
	kill -SIGTERM "${Xvfb_PID}"
	sleep 2
	tar cvzf screenshots_4.tar.gz screenshots_4

	exit 0
}

#-------------------------------------------------
export PATH="${INSTALLDIR}/data/bin":$PATH
wait_for_wine_process() {
	WINEARCH=win32 WINEPREFIX="${INSTALLDIR}/data/wine32_bottle" wineserver -w
}
killall_for_wine_process() {
	WINEARCH=win32 WINEPREFIX="${INSTALLDIR}/data/wine32_bottle" wineserver -k
}
#-------------------------------------------------
#===========================================================================================
mkdir screenshots_4

chmod +x ./install_AppImageWine_and_Logos.sh

echo "* Starting install_AppImageWine_and_Logos.sh"
./install_AppImageWine_and_Logos.sh &
INSTALL_SCRIPT_PID=${!}
#--------


# Starting Steps here:
echo "* Question: using the AppImage installation (option 4):"
close_question_1_yes_4_windows

echo "* Downloading AppImage:"
sleep 1
printscreen


echo "* Question: wine bottle:"
close_question_yes_windows

# feedback:
echo "* ls -la on INSTALLDIR/data/bin and INSTALLDIR/data"
ls -la "${INSTALLDIR}/data/bin"
ls -la "${INSTALLDIR}/data"

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

echo "* waiting Winetricks dotnet48 end..."
echo "find sub-process winetricks:"
WINETRICKS_PID="$(pgrep -P "${INSTALL_SCRIPT_PID}" winetricks)"
echo "wait for linux process WINETRICKS_PID: ${WINETRICKS_PID}"
tail --pid="${WINETRICKS_PID}" -f /dev/null


#-------
echo "* Downloading final AppImage:"
sleep 1
printscreen

echo "* closing erro at wine bottle update..."
close_wine_error_init_windows

echo "* Waiting to initialize last wine..."
echo "* wine gecko cancel:"
close_wine_gecko_init_windows
#-------


echo "* Question: download and install Logos"
close_question_yes_windows


echo "* Downloading Logos:"
sleep 1
printscreen

echo "* Logos install window:"
logos_install_window


echo "* Question: run Logos.sh"
close_question_yes_windows

echo "... waiting 21s to Logos start:"
sleep 21
printscreen

echo "find sub-process Logos.sh:"
LOGOS_SH_PID="$(pgrep -P "${INSTALL_SCRIPT_PID}" Logos.sh)"
echo "sending signal 15 to Logos.sh with PID: ${LOGOS_SH_PID}"
kill -SIGTERM "${LOGOS_SH_PID}"
sleep 2
#---------------

kill -SIGTERM "${FFMPEG_PID}"
sleep 2
# kill Xvfb whenever you feel like it
echo "* Stopping the Xvfb ..."
kill -SIGTERM "${Xvfb_PID}"
sleep 2
#---------------

tar cvzf screenshots_4.tar.gz screenshots_4