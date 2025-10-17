pacman -S open-vm-tools
systemctl enable --now vmtoolsd.service
systemctl enable --now vmware-vmblock-fuse.service