# My VFIO setup

## Acknowledgements
This setup was made possible by:
- the ArchWiki, most notably these two pages: [PCI passthrough via OVMF](https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF "VFIO"), [QEMU](https://wiki.archlinux.org/index.php/QEMU "QEMU") 
- YuriAlek, who has an amazing [GitLab repository](https://gitlab.com/YuriAlek/vfio) with everything. Especially the testing-auto branch is nice
- joeknock90's [GitHub repository](https://github.com/joeknock90/Single-GPU-Passthrough), thats where I have the <rom file.../> part in my windows10.xml from

## Hardware Setup
- i7 7700K
- Palit Super Jetstream GTX 1070
- 8GB RAM, 6GB of which are reserved for the VM at any time (yes I know that sounds and maybe is stupid)
- an entire SSD is passed to the VM

## How-to
I basically followed the instructions in YuriAleks wiki and the ArchWiki, but here is what I did (approximately):
- first, I set up my host according to the steps described in [Setting up IOMMU](https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF#Setting_up_IOMMU) and [Isolating GPU](https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF#Isolating_the_GPU)
- I set up my VM with virt-manager and installed windows in it (see [ArchWiki -- VFIO](https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF#Setting_up_an_OVMF-based_guest_VM))
- using virt-manager, I removed the SPICE display and other unnecessary stuff, and set it to pass through the GPU, a USB controller (which my mouse and keyboard are connected to) and my PCI sound card
- using virsh (`virsh edit win10`), I set up additional stuff unavailable in virt-manager (see README in libvirt folder)
  - important here: set the rom file for the GPU (see below)
- in the VM, installed the graphics driver and voila!
- important: in the libvirt folder, there is the .xml file and an explanation what I did. Read it, otherwise the performance will be crap

## The GPU VBIOS
You need to provide a patched GPU VBIOS if you want to use the boot GPU for your VM.
First, you need to extract the VBIOS:
- either you download one from [techpowerup](https://www.techpowerup.com/vgabios/)
  - some versions did not work for me, others did. Make sure to try a different version if it doesn't work
- you can extract the VBIOS with the extract-vbios-nvflash.sh script (see scripts folder) and nvflash (from[techpowerup](https://www.techpowerup.com/download/nvidia-nvflash/))
- if you run windows either in dualboot or in a VM with a dedicated GPU (like, the classical way), you can extract it with GPU-Z
  - I needed to set the kernel parameter `'kvm.ignore_msrs=1'` in my host, otherwise launching GPU-Z would crash my system (see this [reddit thread](https://www.reddit.com/r/VFIO/comments/ahg1ta/bsod_when_launching_gpuz/))

Then, you need to patch it. joeknock90 made a nice [how-to](https://github.com/joeknock90/Single-GPU-Passthrough#procedure) for that.
You can use the script he provides, or you can just use a hex-editor like bless and patch it manually. I patched it manually, it is very easy and probably quicker and safer.

## File and folder explanations
- `arch_vm.conf` -- systemd-boot entry
- `scripts/` -- well... launch scripts, helper scripts, environment variables
- `libvirt/` -- the windows10.xml file, which contains all the configuration and an explanation what I did
- `kodi/` -- Kodi addon to launch windows
- `windows.desktop` -- Nice desktop entry for GNOME
- `windows.service` -- Systemd unit file
