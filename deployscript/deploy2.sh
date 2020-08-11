#!/bin/bash
#=========================
die() { echo >&2 "$*"; exit 1; };
#=========================

export WORKDIR="/tmp/test_workdir_2"
export INSTALLDIR="${HOME}/LogosBible_Linux_P_test_2"
echo "******* Option 2 *******"
export DISPLAY=:98.0

echo "======= DEBUG: Starting xvfb ======="
Xvfb $DISPLAY -screen 0 1024x768x24 &
Xvfb_PID=$!
sleep 7
echo "* Using DISPLAY: $DISPLAY"

#=========================
PRINT_NUM=1
printscreen() {
	xwd -display $DISPLAY -root -silent | convert xwd:- png:./screenshots_2/img_${PRINT_NUM}.png
	PRINT_NUM=$((PRINT_NUM+1))
}
#=========================

close_question_1_yes_1_windows() {
	while ! WID=$(xdotool search --name "Question: Install Logos Bible"); do
		sleep 2
	done
	printscreen
	echo "* Sending installer keystrokes..."
	xdotool key --delay 1000 Tab
	sleep 1
	xdotool key --delay 1000 Tab
	sleep 1
	xdotool key --delay 1000 space
	sleep 1
}

close_question_1_yes_2_windows() {
	while ! WID=$(xdotool search --name "Question: Install Logos Bible"); do
		sleep 2
	done
	printscreen
	echo "* Sending installer keystrokes..."
	xdotool key --delay 1000 Tab
	sleep 1
	xdotool key --delay 1000 Tab
	sleep 1
	xdotool key --delay 1000 Tab
	sleep 1
	xdotool key --delay 1000 Down
	sleep 1
	xdotool key --delay 1000 space
	sleep 1
	xdotool key --delay 1000 Tab
	sleep 1
	xdotool key --delay 1000 Tab
	sleep 1
	printscreen
	xdotool key --delay 1000 space
	sleep 1
}

close_question_1_yes_3_windows() {
	while ! WID=$(xdotool search --name "Question: Install Logos Bible"); do
		sleep 2
	done
	printscreen
	echo "* Sending installer keystrokes..."
	xdotool key --delay 1000 Tab
	sleep 1
	xdotool key --delay 1000 Tab
	sleep 1
	xdotool key --delay 1000 Tab
	sleep 1
	xdotool key --delay 1000 Down
	sleep 1
	xdotool key --delay 1000 Down
	sleep 1
	xdotool key --delay 1000 space
	sleep 1
	xdotool key --delay 1000 Tab
	sleep 1
	xdotool key --delay 1000 Tab
	sleep 1
	printscreen
	xdotool key --delay 1000 space
	sleep 1
}

close_question_yes_windows() {
	while ! WID=$(xdotool search --name "Question:*"); do
		sleep 2
	done
	printscreen
	echo "* Sending installer keystrokes..."
	xdotool key --delay 1000 space
	sleep 1
}

close_question_no_windows() {
	while ! WID=$(xdotool search --name "Question:*"); do
		sleep 2
	done
	printscreen
	echo "* Sending installer keystrokes..."
	xdotool key --delay 1000 Tab
	sleep 1
	xdotool key --delay 1000 Tab
	sleep 1
	xdotool key --delay 1000 space
	sleep 1
}

close_wine_mono_init_windows() {
	while ! WID=$(xdotool search --name "Wine Mono Installer"); do
		sleep 2
	done
	printscreen
	echo "Sending installer keystrokes..."
	xdotool key --window $WID --delay 1000 Tab
	sleep 1
	xdotool key --window $WID --delay 1000 space
	sleep 1
}

close_wine_gecko_init_windows() {
	while ! WID=$(xdotool search --name "Wine Gecko Installer"); do
		sleep 2
	done
	printscreen
	echo "Sending installer keystrokes..."
	xdotool key --window $WID --delay 1000 Tab
	sleep 1
	xdotool key --window $WID --delay 1000 space
	sleep 1
}

wait_window_and_print(){
	echo "* start waiting for $@ ..."
	while ! WID=$(xdotool search --name "$@"); do
		sleep 1
	done
	echo "... found! And print:"
	printscreen
	sleep 2
}

logos_install_window(){
	while ! WID=$(xdotool search --name "Logos Bible Software Setup"); do
		sleep 2
	done
	printscreen
	echo "* Sending installer keystrokes..."
	xdotool key --delay 1000 space
	sleep 1
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
	sleep 1
	printscreen
	xdotool key --delay 1000 space
	sleep 1
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

echo "* Starting the video record:"
ffmpeg -loglevel quiet -f x11grab -video_size 1024x768 -i $DISPLAY -codec:v libx264 -r 12 result/video2.mp4 &
FFMPEG_PID=$!
finish_the_script_at_end() {
	echo "------- Ending for DEBUG -------"
	# some more info:
	ps ux | grep wine
	printscreen

	kill -15 "${FFMPEG_PID}"
	sleep 2
	kill -15 "${Xvfb_PID}"
	tar cvzf screenshots_2.tar.gz screenshots_2
	mv screenshots_2.tar.gz result/

	exit 0
}

#-------------------------------------------------
wait_for_wine_process() {
	WINEARCH=win32 WINEPREFIX="${INSTALLDIR}/data/wine32_bottle" wineserver -w
}
killall_for_wine_process() {
	WINEARCH=win32 WINEPREFIX="${INSTALLDIR}/data/wine32_bottle" wineserver -k
}
#-------------------------------------------------
#===========================================================================================
mkdir screenshots_2

chmod +x ./install_AppImageWine_and_Logos.sh

echo "* Starting install_AppImageWine_and_Logos.sh"
./install_AppImageWine_and_Logos.sh &
INSTALL_SCRIPT_PID=${!}
#--------

# Starting Steps here:
echo "* Question: using the AppImage installation (option 2):"
close_question_1_yes_2_windows


echo "* Question: wine bottle:"
close_question_yes_windows


echo "* Waiting to initialize wine..."
echo "* wine mono cancel:"
close_wine_mono_init_windows
echo "* wine gecko cancel:"
close_wine_gecko_init_windows

echo "* ls -la on INSTALLDIR/data"
ls -la "${INSTALLDIR}/data"


echo "* Question: winetricks:"
close_question_yes_windows

echo "* waiting Winetricks corefonts"
wait_window_and_print "Winetricks corefonts"

echo "* waiting Winetricks fontsmooth"
wait_window_and_print "Winetricks fontsmooth"

echo "* waiting Winetricks dotnet48"
wait_window_and_print "Winetricks dotnet48"

echo "* waiting Winetricks dotnet48 end, at least 4min to download ..."
sleep 120
echo "... only 2min pass, more 2min to go ..."
sleep 60
echo "... only 3min pass, more 1min to go ..."
sleep 60
echo "... end of 4min, wineserver -w now:"
wait_for_wine_process


echo "* Question: download and install Logos"
close_question_yes_windows

echo "* Downloading Logos:"
sleep 1
printscreen

echo "* Logos install window:"
logos_install_window

finish_the_script_at_end
echo "* Question: clean temp files"
close_question_yes_windows

echo "* Question: run Logos.sh"
close_question_yes_windows

echo "... waiting 14s to Logos start:"
sleep 14
printscreen
#---------------

kill -15 "${FFMPEG_PID}"
# kill Xvfb whenever you feel like it
echo "* Stopping the Xvfb ..."
kill -15 "${Xvfb_PID}"
#---------------

tar cvzf screenshots_2.tar.gz screenshots_2
mv screenshots_2.tar.gz result/
