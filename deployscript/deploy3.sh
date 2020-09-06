#!/bin/bash
#=================================================
die() { echo >&2 "$*"; exit 1; };
#=================================================
echo "------- Running: -------"
head -3 ./install_AppImageWine_and_Logos.sh
echo "---------------------"

if [ -z "$WORKDIR" ]; then export WORKDIR="$(mktemp -d)" ; fi
if [ -z "$INSTALLDIR" ]; then export INSTALLDIR="$HOME/LogosBible_Linux_P_3" ; fi

echo "******* Option 3 *******"
export DISPLAY=:97.0

echo "======= DEBUG: Starting xvfb ======="
Xvfb $DISPLAY -screen 0 1024x768x24 &
Xvfb_PID=$!
sleep 7
echo "* Using DISPLAY: $DISPLAY"

#=================================================
PRINT_NUM=1
printscreen() {
	xwd -display $DISPLAY -root -silent | convert xwd:- png:./screenshots_3/img_${PRINT_NUM}.png
	PRINT_NUM=$((PRINT_NUM+1))
}
#=================================================

close_question_1_yes_3_windows() {
	while ! WID=$(xdotool search --name "Question: Install Logos Bible"); do
		sleep "1"
	done
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
	echo "* Sending installer keystrokes..."
	xdotool key --delay 500 Tab
	sleep "0.5"
	xdotool key --delay 500 Tab
	sleep "0.5"
	printscreen
	xdotool key --delay 500 space
	sleep "0.5"
}

close_wine_mono_init_windows() {
	while ! WID=$(xdotool search --name "Wine Mono Installer"); do
		sleep "1"
	done
	echo "Sending installer keystrokes..."
	xdotool key --window $WID --delay 500 Tab
	sleep "0.5"
	printscreen
	xdotool key --window $WID --delay 500 space
	sleep "0.5"
}

close_wine_gecko_init_windows() {
	while ! WID=$(xdotool search --name "Wine Gecko Installer"); do
		sleep "1"
	done
	echo "Sending installer keystrokes..."
	xdotool key --window $WID --delay 500 Tab
	sleep "0.5"
	printscreen
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
	sleep 7
	printscreen
	echo "* Sending installer keystrokes..."
	xdotool key --delay 500 space
	sleep 3
	printscreen
	xdotool key --delay 500 space
	sleep "0.5"
	xdotool key --delay 500 Tab
	sleep "0.5"
	xdotool key --delay 500 Tab
	sleep "0.5"
	xdotool key --delay 500 Tab
	sleep "0.5"
	printscreen
	xdotool key --delay 500 space
	sleep 3
	printscreen
	xdotool key --delay 500 space
	sleep 3
	printscreen
	xdotool key --delay 500 space
	echo "... waiting 30s for the last screen ..."
	printscreen
	sleep 2
	printscreen
	sleep 28
	echo "... end of 30s, screenshot and space key:"
	printscreen
	xdotool key --delay 500 space
}

echo "* Starting the video record:"
ffmpeg -loglevel quiet -f x11grab -video_size 1024x768 -i $DISPLAY -codec:v libx264 -r 12 video3.mp4 &
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
	tar cvzf screenshots_3.tar.gz screenshots_3

	exit 0
}

#-------------------------------------------------
# wait to all process that is using the ${1} directory to finish
wait_process_using_dir() {
	VERIFICATION_DIR="${1}"
	VERIFICATION_TIME=7
	VERIFICATION_NUM=3

	echo "* Starting test wait_process_using_dir..."
	i=0 ; while true; do
		i=$((i+1))
		echo "-------"
		echo "test wait_process_using_dir: loop with i=${i}"

		echo "test wait_process_using_dir: sleep ${VERIFICATION_TIME}"
		sleep "${VERIFICATION_TIME}"

		FIST_PID="$(lsof -t "${VERIFICATION_DIR}" | head -n 1)"
		echo "test wait_process_using_dir FIST_PID: ${FIST_PID}"
		if [ -n "${FIST_PID}" ]; then
			i=0
			echo "test wait_process_using_dir: tail --pid=${FIST_PID} -f /dev/null"
			tail --pid="${FIST_PID}" -f /dev/null
			continue
		fi

		echo "-------"
		[ "${i}" -lt "${VERIFICATION_NUM}" ] || break
	done
	echo "* End of test wait_process_using_dir."
}

wait_for_wine_process() {
	export WINEARCH=win64
	export WINEPREFIX="${INSTALLDIR}/data/wine64_bottle"
	wait_process_using_dir "${WINEPREFIX}"
	echo "* wineserver -w"
	wineserver -w
}
killall_for_wine_process() {
	export WINEARCH=win64
	export WINEPREFIX="${INSTALLDIR}/data/wine64_bottle"
	echo "* wineserver -k"
	wineserver -k
}
#-------------------------------------------------
#===========================================================================================
## 1680s => 28min
#(sleep 1680 && killall_for_wine_process) &
#CONTROL_KILL_PID=${!}

mkdir screenshots_3

chmod +x ./install_AppImageWine_and_Logos.sh

echo "* Starting install_AppImageWine_and_Logos.sh"
./install_AppImageWine_and_Logos.sh &
INSTALL_SCRIPT_PID=${!}
#--------


# Starting Steps here:
echo "* Question: using the native 64bits installation (option 3):"
close_question_1_yes_3_windows


echo "* Question: wine bottle:"
close_question_yes_windows


echo "* Waiting to initialize wine..."
# need another gecko step for 64bit
echo "* wine mono cancel:"
close_wine_mono_init_windows
echo "* wine gecko cancel:"
close_wine_gecko_init_windows
sleep 7
echo "* wine gecko cancel (part2):"
close_wine_gecko_init_windows
wait_for_wine_process

# feedback:
echo "* ls -la on INSTALLDIR/data/bin and INSTALLDIR/data"
ls -la "${INSTALLDIR}/data/bin"
ls -la "${INSTALLDIR}/data"


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


echo "* Question: download and install Logos"
close_question_yes_windows

echo "* Downloading Logos:"
sleep 1
printscreen

echo "* Logos install window:"
logos_install_window
wait_for_wine_process


echo "* Question: run Logos.sh"
close_question_yes_windows

echo "... waiting 21s to Logos start:"
sleep 21
printscreen

#echo "find sub-process Logos.sh:"
#LOGOS_SH_PID="$(pgrep -P "${INSTALL_SCRIPT_PID}" Logos.sh)"
#echo "sending signal 15 to Logos.sh with PID: ${LOGOS_SH_PID}"
#kill -SIGTERM "${LOGOS_SH_PID}"
#sleep 2
killall_for_wine_process
#---------------

#kill -SIGKILL "${CONTROL_KILL_PID}"
kill -SIGTERM "${FFMPEG_PID}"
sleep 2
# kill Xvfb whenever you feel like it
echo "* Stopping the Xvfb ..."
kill -SIGTERM "${Xvfb_PID}"
sleep 2
#---------------

tar cvzf screenshots_3.tar.gz screenshots_3
