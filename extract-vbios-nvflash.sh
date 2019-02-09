#!/bin/bash
# This script was initially created by YuriAlek (https://gitlab.com/YuriAlek).
# I merely stole and modified it.

NVFLASH="/root/nvflash"
VBIOS_EXTRACT_PATH="/home/moritz/vbios.rom"

## Check if the script was executed as root
[[ "$EUID" -ne 0 ]] && echo "Please run as root" && exit 1

## Kill the Display Manager
systemctl stop lightdm

## Remove the framebuffer and console
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

# Unload the Kernel Modules that use the GPU
modprobe -r nvidia_drm
modprobe -r nvidia_modeset
modprobe -r nvidia
modprobe -r snd_hda_intel

## Extract the VBIOS
$NVFLASH --save $VBIOS_EXTRACT_PATH

# Reload the kernel modules
modprobe snd_hda_intel
modprobe nvidia_drm
modprobe nvidia_modeset
modprobe nvidia

## Reload the framebuffer and console
echo 1 > /sys/class/vtconsole/vtcon0/bind
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/bind

# Reload the Display Manager to access X
systemctl start lightdm
