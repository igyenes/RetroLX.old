#!/bin/bash

ACTION=$1
shift

# the mode format is : 17.720x576.50 (the drm number + resolution + hz).
# the idea is to detect at setMode that the tv changed (ie, don't set mode 17 if on the tv i configured, 17 is 640x480 and that on the new one, this is a different resolution)
# at the same time, we keep in /var/run/drmMode the single drm number so that emulators patches remain simple

f_usage() {
    echo "${0} listModes" >&2
    echo "${0} setMode <MODE>" >&2
    echo "${0} currentMode" >&2
    echo "${0} currentResolution" >&2
    echo "${0} minTomaxResolution" >&2
    echo "${0} minTomaxResolution-secure" >&2
}

if test -z "${ACTION}"
then
    f_usage
    exit 1
fi

f_listModes() {
    if test "${1}" = "all"
    then
	echo "max-1920x1080:maximum 1920x1080"
	echo "max-640x480:maximum 640x480"
    fi
    retrolx-wlinfo "${1}" 2>/dev/null | sed -e s+"^\([0-9]*\):\([0-9]*\)x\([0-9]*\) \([0-9]*\)\(Hz .*\)$"+"\1.\2x\3.\4:\2x\3 \4\5"+
}

f_currentResolution() {
    DRMMODE=$(cat /var/run/drmMode)
    f_listModes "all" | grep -E "^${DRMMODE}\." | head -1 | sed -e s+"^[^:]*:\([0-9]*x[0-9]*\) .*$"+"\1"+
}

f_minTomaxResolution() {
	# minimize resolution because of 4K tv
	MWIDTH=$(echo "$1"x | tr -d [[:blank:]] | cut -dx -f1) # the final added x is for compatibility with v29
	MHEIGHT=$(echo "$1"x | tr -d [[:blank:]] | cut -dx -f2)

	if test -n "$MWIDTH" -a -n "$MHEIGHT" -a "$MWIDTH" != 0 -a "$MHEIGHT" != 0; then
		MAXWIDTH="$MWIDTH"
		MAXHEIGHT="$MHEIGHT"
	else
		MAXWIDTH=1920
		MAXHEIGHT=1080
	fi
	# if current resolution is ok, keep it
	read CURRENTWIDTH CURRENTHEIGHT <<< $(f_listModes "current" | sed -e s+"^\([^:]*\):\([0-9]*\)x\([0-9]*\) \([0-9]*\)\(.*\)$"+"\2 \3"+)

	if test "${CURRENTWIDTH}" -le "${MAXWIDTH}" -a "${CURRENTHEIGHT}" -le "${MAXHEIGHT}"
	then
	    exit 0
	fi

	# select a new one
	# select the first one valid
	# is it the best ? or should we loop to search the first with the same ratio ?
	# Highest resolution first, but list [p]rogressive before [i]nterlaced (p is omitted by default)
	f_listModes | sed -e "/i)$/!"s+")$"+"p)"+ -e s+"^\([^:]*\):\([0-9]*x[0-9]*\) \([0-9]*\)Hz (\(.*\))$"+"\2_\3_\4:\1:\2"+ | sort -nr | sed -e "s/_[0-9]*x[0-9]*[pi]//" |
            while IFS=':\n' read SORTSTR SUGGMODE SUGGRESOLUTION
            do
		SUGGWIDTH=$(echo "${SUGGRESOLUTION}" | cut -d x -f 1)
		SUGGHEIGHT=$(echo "${SUGGRESOLUTION}" | cut -d x -f 2)

		if test "${SUGGWIDTH}" -le "${MAXWIDTH}" -a "${SUGGHEIGHT}" -le "${MAXHEIGHT}"
		then
                    echo "${SUGGMODE}" | cut -d "." -f 1 > /var/run/drmMode
                    exit 0
		fi
            done
}

case "${ACTION}" in
    "listModes")
	f_listModes "all"
	;;
    "setMode")
	MODE=$1

	if echo "${MODE}" | grep -qE 'max-' # special max-widthxheight
	then
	    SPMODE=$(echo "${MODE}" | sed -e s+"^max-"++)
	    f_minTomaxResolution "${SPMODE}"
	else # normal mode
	    # check that the mode is valid
	    if f_listModes "all" | grep -qE "^${MODE}:"
	    then
		echo "${MODE}" | cut -d "." -f 1 > /var/run/drmMode
	    else
		echo "invalid mode ${MODE}" >&2
	    fi
	fi
	;;
    "currentMode")
	DRMMODE=$(cat /var/run/drmMode)
	f_listModes "all" | grep -E "^${DRMMODE}\." | cut -d ":" -f 1
	;;
    "currentResolution")
	f_currentResolution
	;;
    "listOutputs")
	;;
    "setOutput")
	;;
    "minTomaxResolution" | "minTomaxResolution-secure")
	# first, give the current resolution as the default in case it is not reduced.
	CURRENT=$(f_listModes "current" | head -1 | cut -d : -f 1)
	echo "${CURRENT}" | cut -d "." -f 1 > /var/run/drmMode
	# then minToMax
	f_minTomaxResolution "$1"
        ;;
    *)
        f_usage
        ;;
esac
exit 0
