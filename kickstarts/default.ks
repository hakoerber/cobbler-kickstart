# AUTHENTICATION AND USERS
auth --enableshadow --enablemd5
rootpw --iscrypted $default_password_crypted

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
url --url=$tree

# PARTITIONS
bootloader --location=mbr --password=grub
clearpart --all --initlabel
$SNIPPET("custom/partitioning-" + $os_version)

# NETWORK
$SNIPPET('network_config')

%pre --log=/root/ks-pre.log
$SNIPPET('log_ks_pre')
$SNIPPET('kickstart_start')
$SNIPPET('pre_install_network_config')
%end

$SNIPPET("custom/packages-" + $os_version)

%post --log=/root/ks-post.log
$SNIPPET('log_ks_post')
$SNIPPET('custom/ssh_authorized_keys')
$SNIPPET('custom/install_salt')
$SNIPPET('custom/cleanup')
$SNIPPET('kickstart_done')
%end
