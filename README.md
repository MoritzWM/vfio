# My VFIO setup
This setup was made possible by:
- the ArchWiki, most notably these two pages: [PCI passthrough via OVMF](https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF "VFIO"),[QEMU](https://wiki.archlinux.org/index.php/QEMU "QEMU") 
- YuriAlek, who has an amazing [GitLab repository](https://gitlab.com/YuriAlek/vfio) with everything. Especially the testing-auto branch is nice
- joeknock90's[GitHub repository](https://github.com/joeknock90/Single-GPU-Passthrough), thats where I have the <rom file.../> part in my windows10.xml from


## How-to
I basically followed the instructions in YuriAleks wiki.

I extracted my GPU's vbios with the extract-vbios-nvflash.sh script and nvflash (from[techpowerup](https://www.techpowerup.com/download/nvidia-nvflash/)) and edited it manually with bless. All other methods didn't work, my VM would always start, but with a black screen.
