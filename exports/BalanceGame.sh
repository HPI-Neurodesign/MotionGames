#!/bin/bash
sudo chmod 0666 /dev/hidraw*
LD_LIBRARY_PATH=. ./MotionGames.x86_64 --client --game=Balance