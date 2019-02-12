#!/bin/bash
# This script was initially created by YuriAlek (https://gitlab.com/YuriAlek).
# I merely stole and modified it.
# This is a part of the windows launchscript.
## Check if the script was executed as root
[[ "$EUID" -ne 0 ]] && echo "Please run as root" && exit 1

## Unload vfio
modprobe -r vfio-pci
modprobe -r vfio_iommu_type1
modprobe -r vfio

## Reattach the GPU
virsh nodedev-reattach $VIRSH_GPU_AUDIO
virsh nodedev-reattach $VIRSH_GPU

## Reload the framebuffer and console
echo 1 > /sys/class/vtconsole/vtcon0/bind
nvidia-xconfig --query-gpu-info
echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind

## Reload the Display Manager
systemctl start lightdm
