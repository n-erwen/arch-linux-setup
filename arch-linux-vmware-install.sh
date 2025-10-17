loadkeys uk && \
setfont ter-132b && \
ping -c 3 ping.archlinux.org || (echo "No internet connection" && exit 1)

timedatectl set-ntp true && \

# Create 4GB boot parition and root (/) partition taking up rest of disk space
fdisk /dev/sda << EOF
g
n


+1G
n



w
EOF

mkfs.ext4 /dev/sda2 && \
mkfs.fat -F 32 /dev/sda1 && \

mount /dev/sda2 /mnt && \
mkdir /mnt/boot && \
mount /dev/sda1 /mnt/boot && \

pacstrap -K /mnt base linux linux-firmware && \

genfstab -U /mnt >> /mnt/etc/fstab && \
arch-chroot /mnt && \

ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime && \
hwclock --systohc && \

echo "LANG=en_GB.UTF-8" > /etc/locale.conf
echo "KEYMAP=uk" > /etc/vconsole.conf
echo "archlinux" > /etc/hostname

mkinitcpio -P && \
passwd && \

pacman -S grub efibootmgr && \
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB && \
grub-mkconfig -o /boot/grub/grub.cfg && \
exit
echo "You can now reboot your system."
