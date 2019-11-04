#!/bin/sh
: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_ESC=255}

# install prereqs

(apk add -U dialog bash > /tmp/pre.log)
dialog --clear --backtitle "$APP_TITLE" --sleep 3 --tailbox /tmp/pre.log 10 25 \
    "Loading..." 8 50

export APP_TITLE="Terra OS"
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SCRIPTDIR=${BASE_DIR}/scripts

tmpfile=$(tempfile 2>/dev/null) || tmpfile=/tmp/test$$
trap "rm -f $tmpfile" 0 1 2 5 15

dialog --clear --backtitle "$APP_TITLE" --msgbox  \
    "Welcome to Terra OS!" 8 50

while true
do
    dialog --clear --backtitle "$APP_TITLE" --menu "Terra OS Installer" \
        15 50 8 \
        hostname "Configure Hostname" \
        network "Configure Network" \
        system "Install System" \
        reboot "Reboot" 2> $tmpfile
    rval=$?
    case $rval in
        $DIALOG_OK)
            $SCRIPTDIR/$(cat $tmpfile)
            ;;
        $DIALOG_CANCEL)
            sleep 2
            ;;
        $DIALOG_ESC)
            echo "Canceling install..."
            exit 0
            ;;
        *)
            sleep 5
            ;;
    esac
done
