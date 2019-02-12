# Helper scripts and environment
Here are all the helper and launch scripts.
- `check_iommu.sh` -- list IOMMU groups
- `config` -- environment variables loaded by the systemd service
- `extract-vbios-nvflash.sh` -- extract vbios from the GPU in linux
- `windows` -- launch script of the VM with shared host and guest GPU
- `windows_isolatedgpu` -- launch script for the VM when the guest GPU is isolated
- `attach.sh` -- attach the PCI devices (copied from the windows launch script)
- `detach.sh` -- detach the PCI devices (copied from the windows launch script)
