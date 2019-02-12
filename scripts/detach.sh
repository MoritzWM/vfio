
#!/bin/bash
# This script was initially created by YuriAlek (https://gitlab.com/YuriAlek).
# I merely stole and modified it.
# This is a part of the windows launchscript.
## Check if the script was executed as root
[[ "$EUID" -ne 0 ]] && echo "Please run as root" && exit 1

##################
# Detach devices #
##################

## Kill the Display Manager
systemctl stop lightdm

## Kill the console
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

## Detach the GPU
virsh nodedev-detach $VIRSH_GPU
virsh nodedev-detach $VIRSH_GPU_AUDIO

## Load vfio
modprobe vfio-pci
