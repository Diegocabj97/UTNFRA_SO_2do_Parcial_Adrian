#!/bin/bash

sudo fdisk /dev/sde << FIN
n
p
1

+5M
y
t
8e
wq
FIN

sudo pvcreate /dev/sde1
sudo vgcreate vg_datos /dev/sde1

sudo fdisk /dev/sde <<FIN
n
p



+1.5G
t
2
8e
wq
FIN
sudo pvcreate /dev/sde2
sudo vgextend vg_datos /dev/sde2


sudo fdisk /dev/sdd <<FIN
n
p


+512M
y
t
8e
wq
FIN
sudo pvcreate /dev/sdd1
sudo vgcreate vg_temp /dev/sdd1

sudo lvcreate -L +5M vg_datos -n lv_docker
sudo lvcreate -L 1.5G vg_datos -n lv_workareas
sudo lvcreate -l +100%FREE vg_temp -n lv_swap

sudo mkfs.ext4 /dev/mapper/vg_datos-lv_workareas
sudo mkfs.ext4 /dev/mapper/vg_datos-lv_docker
sudo mkswap /dev/mapper/vg_temp-lv_swap

cd
sudo mkdir /work/
sudo mount /dev/mapper/vg_datos-lv_workareas /work/
sudo mount /dev/mapper/vg_datos-lv_docker /var/lib/docker
free -h
sudo swapon /dev/mapper/vg_temp-lv_swap


sudo pvs
sudo vgs
sudo lvs
