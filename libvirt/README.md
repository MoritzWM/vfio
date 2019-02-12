# Libvirt configuration
The xml file was generated with virt-manager, but I did a lot of post-processing on it.

## kvm hidden state and vendor_id
```
      <vendor_id state='on' value='fckyounvidia'/>
      ...
    <kvm>
      <hidden state='on'/>
    </kvm>
```
- vendor_id needs to be set, otherwise the driver won't install (see [Error 43](https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF#"Error_43:_Driver_failed_to_load"_on_Nvidia_GPUs_passed_to_Windows_VMs))
- hidden state probably also needs to be set, I'm not sure
## Hugepages
```
  <memory unit='KiB'>6260736</memory>
  <currentMemory unit='KiB'>6260736</currentMemory>
  <memoryBacking>
    <hugepages/>
  </memoryBacking>
```
- 6GB are reserved for the VM at all times, no matter if it is running or not. I have enough RAM, Arch doesn't need that much
## CPU pinning
```
  <vcpu placement='static'>6</vcpu>
  <iothreads>2</iothreads>
  <iothreadids>
    <iothread id='1'/>
    <iothread id='2'/>
  </iothreadids>
  <cputune>
    <vcpupin vcpu='0' cpuset='1'/>
    <vcpupin vcpu='1' cpuset='5'/>
    <vcpupin vcpu='2' cpuset='2'/>
    <vcpupin vcpu='3' cpuset='6'/>
    <vcpupin vcpu='4' cpuset='3'/>
    <vcpupin vcpu='5' cpuset='7'/>
    <emulatorpin cpuset='0,4'/>
    <iothreadpin iothread='1' cpuset='0'/>
    <iothreadpin iothread='2' cpuset='4'/>
  </cputune>
  ...
  <cpu mode='host-passthrough' check='none'>
    <topology sockets='1' cores='3' threads='2'/>
  </cpu>
  ...
    <controller type='scsi' index='0' model='virtio-scsi'>
      <driver queues='6' iothread='1'/>
      <address type='pci' domain='0x0000' bus='0x03' slot='0x00' function='0x0'/>
    </controller>
```
- CPU pinning gives a lot of performance (see[ArchWiki](https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF#CPU_pinning))
- also added iothreads and assigned one of them to the SCSI controller
## GPU rom file and PCIe port
```
    <hostdev mode='subsystem' type='pci' managed='yes'>
      <source>
        <address domain='0x0000' bus='0x01' slot='0x00' function='0x0'/>
      </source>
      <rom file='/var/lib/libvirt/vbios/patched-vbios_fromwin.rom'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x05' function='0x0'/>
    </hostdev>
    <hostdev mode='subsystem' type='pci' managed='yes'>
      <source>
        <address domain='0x0000' bus='0x01' slot='0x00' function='0x1'/>
      </source>
      <address type='pci' domain='0x0000' bus='0x06' slot='0x00' function='0x0'/>
    </hostdev>
```
- I extracted the ROM file from a windows VM with a completely isolated GPU with GPU-Z and patched it manually
- I assigned the GPU not to a pci-root-port, but directly to pci-root
  - when host and guest did not share the GPU, everything worked fine
  - however, when I used the boot GPU for the guest, ingame performance was shit
  - reason: GPU was not connected to PCIe x16 3.0, but PCIe x16 1.1 or so (GPU-Z shows that)
  - then I found [this reddit thread](https://www.reddit.com/r/VFIO/comments/9dr5sj/q35_chipset_inhibits_your_pcie_bus_lane_to_11/) which explained it all
  - so in the <address ... /> tag of the GPU to I modified bus to `bus='0x00'` (which is the pcie-root) and the slot what was the bus before, so `slot='0x05'`
  - now in GPU-Z, it shows me that the GPU is connected via PCI and the performance is great
