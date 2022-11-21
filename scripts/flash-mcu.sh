#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "ERROR: Please run as root"
  exit
fi


cp -f /home/pi/klipper_stuff/config/board/btt-octopus-11/firmware.config /home/pi/klipper/.config
pushd /home/pi/klipper
make olddefconfig
make clean
make -j4

service klipper stop
make flash FLASH_DEVICE=/dev/btt-octopus-11

if [ -h $MCU ]; then
    echo "Flashing Successful!"
else
    echo "Flashing failed :("
    service klipper start
    popd
    chown pi:pi -R /home/pi/klipper
    exit 1
fi

chown pi:pi -R /home/pi/klipper
service klipper start
popd
