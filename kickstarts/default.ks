# AUTHENTICATION AND USERS
auth --enableshadow --passalgo=sha512
rootpw --iscrypted $6$faf5E6GpQxbdKpzN$AO2t6EwrzvolXwCcjDzgLZXmYoznzhbt7HsKCCBnp0326DDZlqNVgKIGMoTffeWb7FaIv.NBsQl6BgSj5kMHC0

# FIREWALL
firewall --disabled

# LOCALIZATION AND TIME
keyboard de-latin1-nodeadkeys
lang en_US
timezone --nontp --utc Europe/Berlin

# MISC
selinux --enforcing

install
skipx
text
poweroff

services --disabled=firewalld

# PARTITIONS
zerombr

bootloader --location=mbr
clearpart --all --initlabel

part raid.01 --size=512 --ondisk=sda
part raid.02 --size=512 --ondisk=sdb

part raid.11 --ondisk=sda --grow
part raid.12 --ondisk=sdb --grow

raid /boot --level=1 --device=md0 --fstype=xfs raid.01 raid.02
raid pv.01 --level=1 --device=md1 raid.11 raid.12

volgroup vg.hyper01 pv.01

logvol /    --vgname=vg.hyper01 --name=root --size=5120 --fstype=xfs
logvol /var --vgname=vg.hyper01 --name=var  --size=4096 --fstype=xfs
logvol swap --vgname=vg.hyper01 --name=swap --size=1024 --fstype=xfs

user --name hannes
sshkey --username=hannes "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKEEo9Wz5PAsT1YNvd4U7MTIIKDor+bssx0ySk9UhsMcqi7YoRrSGHhNYf14VTts/eRaSV/RrsTVvnitKalhWSwPMdQsFTgXZnwIGHVqMoIMoIqZYhM7xm+yTJkHc0cWtRhQkfnj1Iy7k0yt2cQ6ETM2RkxIrYCW9jh2E56yv25cozcXOl+xfJCmUtCTWGA8rP9H1x7Y6I3+kCrJ66O1m/Qm2yhk3+tyBwwOsgLXGz3iQYrKtGM5LWYqFfQ49LYcusC71SfI3NubyG82lit/g3keeBjOIa9hSeamBnaUuKxodPV/N9N35vnMcz5wSVHKpEGvh+8rA3BrHBu2+YtZdL hannes"

%packages --nobase
@Core --nodefaults
%end
