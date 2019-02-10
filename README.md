# My VFIO setup

## Acknowledgements
This setup was made possible by:
- the ArchWiki, most notably these two pages: [PCI passthrough via OVMF](https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF "VFIO"),[QEMU](https://wiki.archlinux.org/index.php/QEMU "QEMU") 
- YuriAlek, who has an amazing [GitLab repository](https://gitlab.com/YuriAlek/vfio) with everything. Especially the testing-auto branch is nice
- joeknock90's[GitHub repository](https://github.com/joeknock90/Single-GPU-Passthrough), thats where I have the <rom file.../> part in my windows10.xml from

## Hardware Setup
- i7 7700K
- Palit Super Jetstream GTX 1070
- 8GB RAM, 6GB of which are reserved for the VM at any time (yes I know that sounds and maybe is stupid)
- an entire SSD is passed to the VM

## How-to
I basically followed the instructions in YuriAleks wiki.

I extracted my GPU's vbios with the extract-vbios-nvflash.sh script and nvflash (from[techpowerup](https://www.techpowerup.com/download/nvidia-nvflash/)) and edited it manually with bless. All other methods didn't work, my VM would always start, but with a black screen.

## File explanations
- arch_vm.conf -- systemd-boot entry
- config -- environment variables loaded by the windows systemd service
- extract-vbios-nvflash.sh -- script to extract the GPU vbios. Stolen from YuriAlek
- script.windows -- Kodi addon to launch windows
- windows -- VM launch script (detaches GPU and stuff, starts VM, reattaches stuff), mostly stolen from YuriAlek
- windows10.xml -- VM specs, generated with virt-manager and edited by hand to include CPU pinning, a rom file for the GPU etc.
- windows.desktop -- Nice desktop entry for GNOME
- windows.service -- Systemd unit file

## TODO
- writer better instructions
