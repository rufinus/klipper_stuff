install_hooks()
{
    report_status "Installing git hooks"
        if [[ ! -e /home/pi/klipper/.git/hooks/post-merge ]]
        then
           ln -s /home/pi/klipper_stuff/scripts/post-merge.sh /home/pi/klipper/.git/hooks/post-merge
        fi
}

install_hooks()
