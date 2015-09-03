#platform=x86, AMD64, or Intel EM64T
# System authorization information
auth --enableshadow --enablemd5
# System bootloader configuration
bootloader --location=mbr --password=grub
# Partition clearing information
clearpart --all --initlabel
# Use text mode install
text
# Firewall configuration
firewall --disabled
# Run the Setup Agent on first boot
firstboot --disable
# System keyboard
keyboard de-latin1-nodeadkeys
# System language
lang en_US
# Use network installation
url --url=$tree
# If any cobbler repo definitions were referenced in the kickstart profile, include them here.
$yum_repo_stanza
# Network information
$SNIPPET('network_config')
# Reboot after installation
reboot

#Root password
rootpw --iscrypted $default_password_crypted
# SELinux configuration
selinux --enforcing
# Do not configure the X Window System
skipx
# System timezone
timezone --nontp --utc Europe/Berlin
# Install OS instead of upgrade
install
# Clear the Master Boot Record
zerombr

$SNIPPET('partitioning')

%pre --log=/root/ks-pre.log
$SNIPPET('log_ks_pre')
$SNIPPET('kickstart_start')
$SNIPPET('pre_install_network_config')
# Enable installation monitoring
$SNIPPET('pre_anamon')

%end
%packages --excludedocs
@Core --nodefaults
-@Base
-NetworkManager
-NetworkManager-libnm
-NetworkManager-team
-NetworkManager-tui
-firewalld
-alsa-firmware
-alsa-lib
-alsa-tools-firmware
-avahi-libs
-avahi-autoipd
-dnsmasq
-mariadb-libs
-ncurses
-ncurses-base
-ncurses-libs
-sqlite
-postfix
-kexec-tools





%end
%post --nochroot --log=/root/ks-post.log
$SNIPPET('log_ks_post_nochroot')
%end

%post --log=/root/ks-post.log
$SNIPPET('log_ks_post')
# Start yum configuration
$yum_config_stanza
# End yum configuration
$SNIPPET('post_install_kernel_options')
$SNIPPET('post_install_network_config')
$SNIPPET('koan_environment')
$SNIPPET('cobbler_register')
# Enable post-install boot notification
$SNIPPET('post_anamon')

$SNIPPET('ssh_authorized_keys')

$SNIPPET('install_salt')

# Start final steps
$SNIPPET('kickstart_done')
%end
# End final steps
