cd $(dirname $0)

function exe () {
    local cmd=$@
    if ! pgrep -x $cmd; then
        $cmd &
    fi
}

exe $HOME/.config/awesome/screens.sh
exe picom --config=./picom/picom.conf -b

xrdb merge $HOME/.Xresources
