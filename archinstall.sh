#!/bin/bash

#This is a script to install Arch Linux

echo "Arch Linux install script"

#list drives
lsblk -S

#Choose drive
echo "Enter the drive that you want to use in /dev/sdx format."
read drive
clear

#partition drive
echo "Do you want to manually partition $drive? (y/n)"
read ans1
     if  [  "$ans1" = "y"  ]
          then cfdisk $drive
     
     fi
     clear
     
#select partition
echo "Below is a list of the partitions on $drive."
lsblk $drive
echo "Enter the partition where you want to install Arch."
echo "Please use /dev/sda1 format" 
read part
echo "Enter the partition for your swap" 
read spart

#format and mount partitions 
mkfs.ext4 $part
mkswap &spart
mount $part /mnt
swapon $spart
clear

#install base
echo "Press enter to begin installing Arch onto $part"
read 
pacstrap /mnt base base-devel 
clear

#generate fstab
echo "Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab
clear

#chroot into installation
arch-chroot /mnt /bin/bash

#set root password and create user
echo "Please enter the root password for your new system."
passwd
echo "Please enter a user name for a new user."
read username
useradd -m -g users -G adm,lp,wheel,power,audio,video -s /bin/bash $username
echo "Please enter a password for $username."
passwd $username
clear

#generate locale
echo "Generating locale..."
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
locale > /etc/locale.conf
clear

#setting timezone
echo "Setting timezone as American, central..."
ln -s /usr/share/zoneinfo/America/Chicago /etc/localtime
sleep 3
clear

#setting hostname
echo "Setting hostname as archpc..."
echo archpc > /etc/hostname
sleep 3
clear

#setting sudo permissions
echo "setting sudo permissions...
touch /etc/sudoers.d/01_wheel
echo "%wheel      ALL=(ALL) ALL, NOPASSWD" >> /etc/sudoers.d/O1_wheel
sleep 3
clear

#mkinit
echo "Running mkinit..."
mkinitcpio -p linux
clear

#installing grub
echo "Installing Bootloader..."
pacman -S --noconfirm grub os-prober
grub-install /dev/sdX
grub-mkconfig -o /boot/grub/grub.cfg

#installing additional packages for video, audio, drivers




