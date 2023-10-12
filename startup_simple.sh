#!/bin/sh

export PATH="/usr/bin:/usr/local/bin:/bin:/root/bin:/sbin:/usr/sbin:/usr/local/sbin"
export HOME="/root"

/bin/vsockexec -o 2056 echo Oct 12th 2023
/bin/vsockexec -o 2056 -e 2056 date


/bin/vsockexec -o 2056 echo /init -e 1 /bin/vsockexec -e 109 /bin/gcs -v4 -log-format json -loglevel debug
/init -e 1 /bin/vsockexec -o 2056 -e 109 /bin/gcs -v4 -log-format text -loglevel debug -logfile /tmp/gcs.log


/bin/vsockexec -o 2056 echo sleeping
/bin/vsockexec -o 2056 sleep 2

/bin/vsockexec -o 2056 ls -Rl /dev/
/bin/vsockexec -o 2056 dmesg

#/bin/vsockexec -o 2056 echo blockdev...
#/bin/vsockexec -o 2056 -e 2056 blockdev --getsize64 /dev/dm-0
#/bin/vsockexec -o 2056 -e 2056 blockdev --getsize64 /dev/sda
#/bin/vsockexec -o 2056 -e 2056 blockdev --getsize64 /dev/sdb
#
## Try using veritysetup with --no-superblock to open the verity device
## /bin/vsockexec -o 2056 echo veritysetup open...
## /bin/vsockexec -o 2056 -e 2056 veritysetup --no-superblock open --data-blocks 22679 --data-block-size 4096 --hash-offset 92893184 /dev/sda verityrootfs /dev/sda d7bfb99c477f0a8fdbe92fe4f548bb48727daa37d1455dbfba8309e17ab91cac
#
## /bin/vsockexec -o 2056 ls -Rl /dev/
## /bin/vsockexec -o 2056 dmesg
## /bin/vsockexec -o 2056 ls -Rl /dev/mapper
#
## /bin/vsockexec -o 2056 lsblk
#
#
#
#/bin/vsockexec -o 2056 -e 2056 date
## need init to have run before top shows much
#/bin/vsockexec -o 2056 -e 2056 top -n 1
#
#/bin/vsockexec -o 2056 echo tmp
#/bin/vsockexec -o 2056 ls -la /tmp
#
#/bin/vsockexec -o 2056 echo init.log
#/bin/vsockexec -o 2056 cat /tmp/init.log
#/bin/vsockexec -o 2056 echo opengcs.log
#/bin/vsockexec -o 2056 cat /tmp/opengcs.log
#/bin/vsockexec -o 2056 echo gcs.log
#/bin/vsockexec -o 2056 cat /tmp/gcs.log
#
##/bin/vsockexec -o 2056 -e 2056 /bin/dmesg
#
#sleep 1
#/bin/vsockexec -o 2056 echo Thats all folks...
#
## /bin/vsockexec -o 2056 -e 2056 veritysetup --no-superblock open --data-blocks 22679 --data-block-size 4096 --hash-offset 92893184 /dev/sda verityrootfs /dev/sda d7bfb99c477f0a8fdbe92fe4f548bb48727daa37d1455dbfba8309e17ab91cac
#
#
#/bin/vsockexec -o 2056 -e 2056 echo dd if=/dev/dm-0 bs=4096 skip=0 count=1 of=dm-0head0.ext4
#/bin/vsockexec -o 2056 -e 2056 dd if=/dev/dm-0 bs=4096 skip=0 count=1 of=dm-0head0.ext4
#/bin/vsockexec -o 2056 -e 2056 echo od -Ax -t x1 dm-0head0.ext4
#/bin/vsockexec -o 2056 -e 2056 od -Ax -t x1 dm-0head0.ext4
#
#/bin/vsockexec -o 2056 -e 2056 echo dd if=/dev/dm-0 bs=4096 skip=1 count=1 of=dm-0head1.ext4
#/bin/vsockexec -o 2056 -e 2056 dd if=/dev/dm-0 bs=4096 skip=1 count=1 of=dm-0head1.ext4
#/bin/vsockexec -o 2056 -e 2056 echo od -Ax -t x1 dm-0head1.ext4
#/bin/vsockexec -o 2056 -e 2056 od -Ax -t x1 dm-0head1.ext4
#
#/bin/vsockexec -o 2056 -e 2056 echo dd if=/dev/dm-0 bs=4096 skip=188 count=1 of=dm-0head188.ext4
#/bin/vsockexec -o 2056 -e 2056 dd if=/dev/dm-0 bs=4096 skip=188 count=1 of=dm-0head188.ext4
#/bin/vsockexec -o 2056 -e 2056 echo od -Ax -t x1 dm-0head188.ext4
#/bin/vsockexec -o 2056 -e 2056 od -Ax -t x1 dm-0head188.ext4
#
#/bin/vsockexec -o 2056 -e 2056 echo dd if=/dev/dm-0 bs=4096 skip=233 count=1 of=dm-0head233.ext4
#/bin/vsockexec -o 2056 -e 2056 dd if=/dev/dm-0 bs=4096 skip=233 count=1 of=dm-0head233.ext4
#/bin/vsockexec -o 2056 -e 2056 echo od -Ax -t x1 dm-0head233.ext4
#/bin/vsockexec -o 2056 -e 2056 od -Ax -t x1 dm-0head233.ext4
#
#/bin/vsockexec -o 2056 -e 2056 echo dd if=/dev/sda bs=4096 skip=0 count=1 of=sda-head0.ext4
#/bin/vsockexec -o 2056 -e 2056 dd if=/dev/sda bs=4096 skip=0 count=1 of=sda-head0.ext4
#/bin/vsockexec -o 2056 -e 2056 echo od -Ax -t x1 sda-head0.ext4
#/bin/vsockexec -o 2056 -e 2056 od -Ax -t x1 sda-head0.ext4
#
#/bin/vsockexec -o 2056 -e 2056 echo dd if=/dev/sda bs=4096 skip=1 count=1 of=sda-head1.ext4
#/bin/vsockexec -o 2056 -e 2056 dd if=/dev/sda bs=4096 skip=1 count=1 of=sda-head1.ext4
#/bin/vsockexec -o 2056 -e 2056 echo od -Ax -t x1 sda-head1.ext4
#/bin/vsockexec -o 2056 -e 2056 od -Ax -t x1 sda-head1.ext4
#
#/bin/vsockexec -o 2056 -e 2056 echo dd if=/dev/sda bs=4096 skip=188 count=1 of=sda-head188.ext4
#/bin/vsockexec -o 2056 -e 2056 dd if=/dev/sda bs=4096 skip=188 count=1 of=sda-head188.ext4
#/bin/vsockexec -o 2056 -e 2056 echo od -Ax -t x1 sda-head188.ext4
#/bin/vsockexec -o 2056 -e 2056 od -Ax -t x1 sda-head188.ext4
#
#/bin/vsockexec -o 2056 -e 2056 echo dd if=/dev/sda bs=4096 skip=233 count=1 of=sda-head233.ext4
#/bin/vsockexec -o 2056 -e 2056 dd if=/dev/sda bs=4096 skip=233 count=1 of=sda-head233.ext4
#/bin/vsockexec -o 2056 -e 2056 echo od -Ax -t x1 sda-head233.ext4
#/bin/vsockexec -o 2056 -e 2056 od -Ax -t x1 sda-head233.ext4
#
#/bin/vsockexec -o 2056 -e 2056 echo dd if=/dev/sda bs=4096 skip=35765 count=1 of=sdahead35765.ext4
#/bin/vsockexec -o 2056 -e 2056 dd if=/dev/sda bs=4096 skip=35765 count=1 of=sdahead35765.ext4
#/bin/vsockexec -o 2056 -e 2056 echo od -Ax -t x1 sdahead35765.ext4
#/bin/vsockexec -o 2056 -e 2056 od -Ax -t x1 sdahead35765.ext4
#
#/bin/vsockexec -o 2056 -e 2056 echo dd if=/dev/sda bs=4096 skip=36048 count=1 of=sdahead36048.ext4
#/bin/vsockexec -o 2056 -e 2056 dd if=/dev/sda bs=4096 skip=36048 count=1 of=sdahead36048.ext4
#/bin/vsockexec -o 2056 -e 2056 echo od -Ax -t x1 sdahead36048.ext4
#/bin/vsockexec -o 2056 -e 2056 od -Ax -t x1 sdahead36048.ext4
#
## /bin/vsockexec -o 2056 -e 2056 echo mkdir /rootfs-mount
## /bin/vsockexec -o 2056 -e 2056 mkdir /rootfs-mount
## /bin/vsockexec -o 2056 -e 2056 echo /bin/mount /dev/dm-0 /rootfs-mount
## /bin/vsockexec -o 2056 -e 2056 /bin/mount /dev/dm-0 /rootfs-mount
## /bin/vsockexec -o 2056 -e 2056 echo ls -Rl /rootfs-mount
## /bin/vsockexec -o 2056 -e 2056 ls -Rl /rootfs-mount
#/bin/vsockexec -o 2056 -e 2056 echo veritysetup format --debug --salt 0000000000000000000000000000000000000000000000000000000000000000 --no-superblock --data-blocks 35765 --data-block-size 4096 --hash-offset 146493440 /dev/sda /dev/sda
#/bin/vsockexec -o 2056 -e 2056 veritysetup format --debug --salt 0000000000000000000000000000000000000000000000000000000000000000 --no-superblock --data-blocks 35765 --data-block-size 4096 --hash-offset 146493440 /dev/sda /dev/sda
#
#/bin/vsockexec -o 2056 -e 2056 echo veritysetup status --debug /dev/dm-0
#/bin/vsockexec -o 2056 -e 2056 veritysetup status --debug /dev/dm-0
#/bin/vsockexec -o 2056 -e 2056 echo veritysetup format --debug --salt 0000000000000000000000000000000000000000000000000000000000000000 --no-superblock --data-blocks 35765 --data-block-size 4096 --hash-offset 146493440 /dev/dm-0 /dev/dm-0
#/bin/vsockexec -o 2056 -e 2056 veritysetup format --debug --salt 0000000000000000000000000000000000000000000000000000000000000000 --no-superblock --data-blocks 35765 --data-block-size 4096 --hash-offset 146493440 /dev/dm-0 /dev/dm-0
#
#/bin/vsockexec -o 2056 dmesg
#
#
#/bin/vsockexec -o 2056 -e 2056 echo blockdev...
#/bin/vsockexec -o 2056 -e 2056 blockdev --getsize64 /dev/dm-0
#/bin/vsockexec -o 2056 -e 2056 blockdev --getsize64 /dev/sda
#/bin/vsockexec -o 2056 dmesg
#
#/bin/vsockexec -o 2056 -e 2056 echo mkdir /rootfs-mount
#/bin/vsockexec -o 2056 -e 2056 mkdir /rootfs-mount
#
#/bin/vsockexec -o 2056 -e 2056 echo /bin/mount /dev/dm-0 /rootfs-mount
#/bin/vsockexec -o 2056 -e 2056 /bin/mount /dev/dm-0 /rootfs-mount
#/bin/vsockexec -o 2056 -e 2056 echo ls -Rl /rootfs-mount
#/bin/vsockexec -o 2056 -e 2056 ls -Rl /rootfs-mount
#
## switch_root /rootfs-mount /startup_2.sh
#
#
#
