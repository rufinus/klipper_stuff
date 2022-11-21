#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "ERROR: Please run as root"
  exit
fi

VENDORDEVICEID=0483:df11

cp -f /home/pi/klipper_stuff/config/board/btt-octopus-11/firmware.config /home/pi/klipper/.config
pushd /home/pi/klipper
make olddefconfig
make clean
make -j4

service klipper stop
make flash FLASH_DEVICE=$VENDORDEVICEID

sleep 5
if [ -h $MCU ]; then
    echo "Flashing Successful!"
else
    echo "Flashing Octopus via vendor and device ids - 2nd pass"
    make flash FLASH_DEVICE=$VENDORDEVICEID

    sleep 5
    if [ -h $MCU ]; then
        echo "Flashing Successful!"
    else
        echo "Flashing Octopus via vendor and device ids - 3rd pass"
        make flash FLASH_DEVICE=$VENDORDEVICEID
        if [ $? -e 0 ]; then
            echo "Flashing successful!"
        else
            echo "Flashing failed :("
            service klipper start
            popd
            chown pi:pi -R /home/pi/klipper
            exit 1
        fi
    fi
fi

chown pi:pi -R /home/pi/klipper
service klipper start
popd
