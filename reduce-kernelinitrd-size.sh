# Reduce initramfs size
if [[ $# -eq 0 ]] ; then
    echo 'Must be given path to root hcsshim'
    exit 0
fi

sudo rm $1/kernelinitrd-rootfs/boot/*
sudo rm -rf $1/kernelinitrd-rootfs/usr/include/*

sudo rm $1/kernelinitrd-rootfs/bin/gcs
sudo rm $1/kernelinitrd-rootfs/bin/gcstools
# sudo rm $1/kernelinitrd-rootfs/bin/get-fake-snp-report
# sudo rm $1/kernelinitrd-rootfs/bin/get-snp-report
# sudo rm $1/kernelinitrd-rootfs/bin/hex2report
# sudo rm $1/kernelinitrd-rootfs/bin/verbose-report
# sudo rm $1/kernelinitrd-rootfs/bin/report6
sudo rm $1/kernelinitrd-rootfs/bin/wait-paths
sudo rm $1/kernelinitrd-rootfs/bin/udevadm

sudo rm $1/kernelinitrd-rootfs/usr/bin/runc

sudo rm $1/kernelinitrd-rootfs/usr/lib/x86_64-msft-linux/9.3.0/libgcc.a
sudo rm $1/kernelinitrd-rootfs/usr/lib/locale/locale-archive
sudo rm $1/kernelinitrd-rootfs/usr/lib/libfpgahwtelemetry.so
sudo rm $1/kernelinitrd-rootfs/usr/lib/libfpgamgmt.so
sudo rm $1/kernelinitrd-rootfs/usr/lib/libfpgatelem.so
sudo rm $1/kernelinitrd-rootfs/usr/lib/libxml2.so.2.9.10
sudo rm $1/kernelinitrd-rootfs/usr/lib/libfpgavfio.so
sudo rm $1/kernelinitrd-rootfs/usr/lib/libfpgacore.so