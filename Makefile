BASE:=base.tar.gz
DEV_BUILD:=0

GO:=go
GO_FLAGS:=-ldflags "-s -w" # strip Go binaries
CGO_ENABLED:=0
GOMODVENDOR:=

CFLAGS:=-O2 -Wall
LDFLAGS:=-static -s # strip C binaries

GO_FLAGS_EXTRA:=
ifeq "$(GOMODVENDOR)" "1"
GO_FLAGS_EXTRA += -mod=vendor
endif
GO_BUILD_TAGS:=
ifneq ($(strip $(GO_BUILD_TAGS)),)
GO_FLAGS_EXTRA += -tags="$(GO_BUILD_TAGS)"
endif
GO_BUILD:=CGO_ENABLED=$(CGO_ENABLED) $(GO) build $(GO_FLAGS) $(GO_FLAGS_EXTRA)

SRCROOT=$(dir $(abspath $(firstword $(MAKEFILE_LIST))))
# additional directories to search for rule prerequisites and targets
VPATH=$(SRCROOT)

DELTA_TARGET=out/delta.tar.gz

ifeq "$(DEV_BUILD)" "1"
DELTA_TARGET=out/delta-dev.tar.gz
endif

# The link aliases for gcstools
GCS_TOOLS=\
	generichook \
	install-drivers

SRC:=
VMGS_TOOL:=src/Parma/bin/vmgstool
IGVM_TOOL:=src/Parma/kernel-files/5.15/igvmfile.py
# this is now a 5.15 kernel
KERNEL_PATH:=linux/linux/arch/x86/boot/bzImage
##KERNEL_PATH:=src/Parma/kernel-files/5.15/bzImage
# 5.15 kernel from Parma - no dm at boot stuff KERNEL_PATH:=src/Parma/kernel-files/5.15/bzImage

.PHONY: all always rootfs test

.DEFAULT_GOAL := all

all: out/initrd.img out/rootfs.tar.gz

clean:
	find -name '*.o' -print0 | xargs -0 -r rm
	rm -rf bin deps rootfs out

test:
	cd $(SRCROOT) && $(GO) test -v ./internal/guest/...

rootfs: out/rootfs.vhd

snp: out/kernelinitrd.vmgs out/containerd-shim-runhcs-v1.exe out/hash-device.vhd out/dmverity-rootfs.vhd out/v2056.vmgs

simple: out/simple.vmgs out/oldstyle.vmgs snp

out/hash-device.vhd: out/hash_device
	cp out/hash_device $@
	./bin/cmd/dmverity-vhd -v convert --to-vhd --fst $@ -o foo

out/hash_device: out/dmverity_rootfs.vhd.ext4
	veritysetup format --no-superblock --salt 0000000000000000000000000000000000000000000000000000000000000000 out/dmverity_rootfs.vhd.ext4 $@

out/dmverity-rootfs.vhd: out/dmverity_rootfs.vhd
	cp out/dmverity_rootfs.vhd.ext4 $@
	./bin/cmd/dmverity-vhd -v convert --to-vhd --fst $@ -o foo

%.vmgs: %.bin
	rm -f $@
	# du -BM returns the size of the bin file in M, eg 7M. The sed command replaces the M with *1024*1024 and then bc does the math to convert to bytes
	$(SRC)/$(VMGS_TOOL) create --filepath $@ --filesize `du -BM $< | sed  "s/M.*/*1024*1024/" | bc`
	$(SRC)/$(VMGS_TOOL) write --filepath $@ --datapath $< -i=8


ROOTFS_DEVICE:=/dev/sda
VERITY_DEVICE:=/dev/sdb
# ^^^ is this ok?
# SALT=$(shell cat out/dmverity_rootfs.salt)
# ROOT_HASH=$(shell cat out/dmverity_rootfs.hash)
# DATA_BLOCK_COUNT=$(shell cat out/dmverity_rootfs.blockcount)
# DATA_BLOCK_SIZE=$(shell cat out/dmverity_rootfs.datablocksize)
# HASH_BLOCK_SIZE=$(DATA_BLOCK_SIZE)
# NUM_SECTORS=$(shell cat out/dmverity_rootfs.datasectors)

out/simple.bin: out/kernelinitrd.cpio.gz
	# easy case we know works to check the kernel is good without the complication of the dm-verity mounting via the kernel command line
	python3 $(SRC)/$(IGVM_TOOL) -o $@ -kernel $(SRC)/$(KERNEL_PATH) -append "8250_core.nr_uarts=0 panic=-1 debug loglevel=7 rdinit=/startup_simple.sh" -rdinit out/kernelinitrd.cpio.gz -vtl 0
	# use to test the testprint actually works as expected - ie we see 100s of prints
	# python3 $(SRC)/$(IGVM_TOOL) -o $@ -kernel $(SRC)/$(KERNEL_PATH) -append "8250_core.nr_uarts=0 panic=-1 debug loglevel=7 rdinit=/bin/testprint" -rdinit out/kernelinitrd.cpio.gz -vtl 0

out/oldstyle.bin: out/kernelinitrd.cpio.gz
	# easy case we know works to check the kernel is good without the complication of the dm-verity mounting via the kernel command line
	python3 $(SRC)/$(IGVM_TOOL) -o $@ -kernel $(SRC)/$(KERNEL_PATH) -append "8250_core.nr_uarts=0 panic=-1 debug loglevel=7 rdinit=/startup.sh" -rdinit out/kernelinitrd.cpio.gz -vtl 0

out/v2056.bin: out/kernelinitrd.cpio.gz
	rm -f $@
# python3 $(SRC)/$(IGVM_TOOL) -o out/v2056.bin -kernel $(SRC)/$(KERNEL_PATH) -append "8250_core.nr_uarts=0 panic=-1 debug loglevel=7 root=/dev/dm-0 init=/bin/bash.bash dm-mod.create=\"jp1dmverityrfs,,,ro,0 $(shell cat out/dmverity_rootfs.datasectors) verity 1 $(ROOTFS_DEVICE) $(VERITY_DEVICE) $(shell cat out/dmverity_rootfs.datablocksize) $(shell cat out/dmverity_rootfs.hashblocksize) $(shell cat out/dmverity_rootfs.datablocks) 0 sha256 $(shell cat out/dmverity_rootfs.rootdigest) $(shell cat out/dmverity_rootfs.salt)\" -- -c /startup_2.sh " -rdinit out/kernelinitrd.cpio.gz -vtl 0
#	THIS WORKS inc. rootswitch 
# python3 $(SRC)/$(IGVM_TOOL) -o out/v2056.bin -kernel $(SRC)/$(KERNEL_PATH) -append "8250_core.nr_uarts=0 panic=-1 debug loglevel=7 root=/dev/dm-0 rdinit=/startup_v2056.sh dm-mod.create=\"jp1dmverityrfs,,,ro,0 $(shell cat out/dmverity_rootfs.datasectors) verity 1 $(ROOTFS_DEVICE) $(VERITY_DEVICE) $(shell cat out/dmverity_rootfs.datablocksize) $(shell cat out/dmverity_rootfs.hashblocksize) $(shell cat out/dmverity_rootfs.datablocks) 0 sha256 $(shell cat out/dmverity_rootfs.rootdigest) $(shell cat out/dmverity_rootfs.salt) 1 ignore_corruption\"" -rdinit out/kernelinitrd.cpio.gz -vtl 0
# experimental with testprint (worked)
#	python3 $(SRC)/$(IGVM_TOOL) -o out/v2056.bin -kernel $(SRC)/$(KERNEL_PATH) -append "8250_core.nr_uarts=0 panic=-1 debug loglevel=7 root=/dev/dm-0 dm-mod.create=\"jp1dmverityrfs,,,ro,0 $(shell cat out/dmverity_rootfs.datasectors) verity 1 $(ROOTFS_DEVICE) $(VERITY_DEVICE) $(shell cat out/dmverity_rootfs.datablocksize) $(shell cat out/dmverity_rootfs.hashblocksize) $(shell cat out/dmverity_rootfs.datablocks) 0 sha256 $(shell cat out/dmverity_rootfs.rootdigest) $(shell cat out/dmverity_rootfs.salt) 1 ignore_corruption\" init=/bin/testprint"  -vtl 0
# experimental - works
	python3 $(SRC)/$(IGVM_TOOL) -o $@ -kernel $(SRC)/$(KERNEL_PATH) -append "8250_core.nr_uarts=0 panic=-1 debug loglevel=7 root=/dev/dm-0 dm-mod.create=\"jp1dmverityrfs,,,ro,0 $(shell cat out/dmverity_rootfs.datasectors) verity 1 $(ROOTFS_DEVICE) $(VERITY_DEVICE) $(shell cat out/dmverity_rootfs.datablocksize) $(shell cat out/dmverity_rootfs.hashblocksize) $(shell cat out/dmverity_rootfs.datablocks) 0 sha256 $(shell cat out/dmverity_rootfs.rootdigest) $(shell cat out/dmverity_rootfs.salt) 1 ignore_corruption\" init=/startup_simple.sh"  -vtl 0
# not working	python3 $(SRC)/$(IGVM_TOOL) -o out/v2056.bin -kernel $(SRC)/$(KERNEL_PATH) -append "8250_core.nr_uarts=0 panic=-1 debug loglevel=7 root=/dev/dm-0 init=/simpleinit dm-mod.create=\"jp1dmverityrfs,,,ro,0 $(shell cat out/dmverity_rootfs.datasectors) verity 1 $(ROOTFS_DEVICE) $(VERITY_DEVICE) $(shell cat out/dmverity_rootfs.datablocksize) $(shell cat out/dmverity_rootfs.hashblocksize) $(shell cat out/dmverity_rootfs.datablocks) 0 sha256 $(shell cat out/dmverity_rootfs.rootdigest) $(shell cat out/dmverity_rootfs.salt) 1 ignore_corruption\"" -rdinit out/kernelinitrd.cpio.gz -vtl 0
    # Remember to REFORMAT the VHD WITH --no-superblock
    # dm-verity, <name> x
    # <blank>,   <uuid> x
    # 3,         <minor> x go blank
    # ro,        <flags> x
    # <TABLE>
    # 0        <start_sector> x
    # 1638400  <num_sectors>  x
    # verity   <target_type> x
    # <TARGET_ARGS>
    # 1          <version> x
    # /dev/sdc1  <dev>   @ROOTFS_DEVICE@ ???
    # /dev/sdc2  <hash_dev>   @VERITY_DEVICE@ ???
    # 4096       <data_block_size> x
    # 4096       <hash_block_size> x
    # 204800     <num_data_blocks> x
    # 1          <hash_start_block> x go with 0
    # sha256     <algorithm>  x
    # ac87db56303c9c1da433d7209b5a6ef3e4779df141200cbd7c157dcb8dd89c42 <digest>  x
    # 5ebfe87f7df3235b80a117ebc4078e44f55045487ad4a96581d1adb564615b51 <salt> x

out/kernelinitrd.bin: out/kernelinitrd.cpio.gz
	rm -f $@
# broken - doesn't print anything IN cplat - ok with uvmtester
	python3 $(SRC)/$(IGVM_TOOL) -o $@ -kernel $(SRC)/$(KERNEL_PATH) -append "8250_core.nr_uarts=0 panic=-1 debug loglevel=7 root=/dev/dm-0 dm-mod.create=\"jp1dmverityrfs,,,ro,0 $(shell cat out/dmverity_rootfs.datasectors) verity 1 $(ROOTFS_DEVICE) $(VERITY_DEVICE) $(shell cat out/dmverity_rootfs.datablocksize) $(shell cat out/dmverity_rootfs.hashblocksize) $(shell cat out/dmverity_rootfs.datablocks) 0 sha256 $(shell cat out/dmverity_rootfs.rootdigest) $(shell cat out/dmverity_rootfs.salt) 1 ignore_corruption\" init=/startup.sh"  -vtl 0
#	python3 $(SRC)/$(IGVM_TOOL) -o $@ -kernel $(SRC)/$(KERNEL_PATH) -append "8250_core.nr_uarts=0 panic=-1 debug loglevel=7 rdinit=/startup.sh" -rdinit out/kernelinitrd.cpio.gz -vtl 0


out/kernelinitrd.cpio.gz: out/dm-startup.sh out/startup_v2056.sh startup_simple.sh
    # The filesystem built up in kernelinitrd-rootfs is only used temporarily in order to
    # mount and switch to the dmverity backed rootfs (dmverity_rootfs.vhd).
	rm -rf kernelinitrd-rootfs
	mkdir kernelinitrd-rootfs
	tar -xf $(BASE) -C kernelinitrd-rootfs
	tar -xzf out/delta.tar.gz -C kernelinitrd-rootfs
	# cp bin/internal/tools/snp-report kernelinitrd-rootfs/bin/snp-report
	cp out/dm-startup.sh kernelinitrd-rootfs/dm-startup.sh
	cp out/startup_v2056.sh kernelinitrd-rootfs/startup_v2056.sh
	cp startup_simple.sh kernelinitrd-rootfs/startup_simple.sh
	cp startup.sh kernelinitrd-rootfs/startup.sh
	cp startup_2.sh kernelinitrd-rootfs/startup_2.sh
	chmod a+x kernelinitrd-rootfs/dm-startup.sh
	chmod a+x kernelinitrd-rootfs/startup_v2056.sh
	chmod a+x kernelinitrd-rootfs/startup_2.sh
	chmod a+x kernelinitrd-rootfs/startup.sh
	cp $(SRC)/src/Parma/bin/mkfs.xfs kernelinitrd-rootfs/bin/mkfs.xfs
	chmod a+x kernelinitrd-rootfs/bin/mkfs.xfs

    # Reduce kernelinitrd size by removing unnecessary files
	# ./reduce-kernelinitrd-size.sh $(SRCROOT)
	find ./kernelinitrd-rootfs | sudo xargs touch -hmt 199912310000
    # No need to cd back as Make will execute each cmd in its own shell
	cd ./kernelinitrd-rootfs; find . -print0 | sudo cpio --null -o --format=newc --reset-access-time | sudo gzip -9 > ../$@

	#rm -rf kernelinitrd-rootfs

out/startup_v2056.sh:	out/dmverity_rootfs.vhd
    # The startup script required by the kernelinitrd to mount dmverity_rootfs when using SNP.
    # Configure the script with the root hash of the root filesystem (dmverity_rootfs).
	cp startup_v2056.sh.template $@
	sed -i "s/<ROOT_HASH>/$(shell cat out/dmverity_rootfs.rootdigest)/" out/startup_v2056.sh
	sed -i "s/<BLOCK_COUNT>/$(shell cat out/dmverity_rootfs.datablocks)/" out/startup_v2056.sh
	sed -i "s/<HASH_OFFSET>/$(shell cat out/dmverity_rootfs.hashoffset)/" out/startup_v2056.sh


out/dm-startup.sh:	out/dmverity_rootfs.vhd
    # The startup script required by the kernelinitrd to mount dmverity_rootfs when using SNP.
    # Configure the script with the root hash of the root filesystem (dmverity_rootfs).
	cp dm-startup.sh.template $@
	sed -i "s/<ROOT_HASH>/$(shell cat out/dmverity_rootfs.rootdigest)/" out/dm-startup.sh
	sed -i "s/<BLOCK_COUNT>/$(shell cat out/dmverity_rootfs.datablocks)/" out/dm-startup.sh
	sed -i "s/<HASH_OFFSET>/$(shell cat out/dmverity_rootfs.hashoffset)/" out/dm-startup.sh

out/dmverity_rootfs.vhd: out/dmverity_rootfs.tar.gz bin/cmd/dmverity-vhd
    # Format the root filesystem VHD which will be mounted by kernelinitrd via dm-verity when using SNP.
	gzip -f -d ./out/dmverity_rootfs.tar.gz
	# veritysetup format --data-blocks 35658 --data-block-size 4096 --hash-offset 146055168 out/rootfs1.vhd out/rootfs1.vhd
	## ./bin/cmd/dmverity-vhd -v convert --no-superblock --fst out/dmverity_rootfs.tar -o out | awk '/^RootHash/{ print $$2 }' > out/dmverity_rootfs.hash
	# ./bin/cmd/dmverity-vhd -v convert --no-superblock --fst out/dmverity_rootfs.tar -o out > out/dmverity_rootfs.info
	./bin/cmd/dmverity-vhd -v convert --fst out/dmverity_rootfs.tar -o out > out/dmverity_rootfs.info
    # Retrieve info required by dm-verity at boot time
    # Get the blocksize of rootfs
	cat out/dmverity_rootfs.info | awk '/^RootDigest/{ print $$2 }' > out/dmverity_rootfs.rootdigest
	cat out/dmverity_rootfs.info | awk '/^HashOffsetInBlocks/{ print $$2 }' > out/dmverity_rootfs.hashoffsetinblocks
	cat out/dmverity_rootfs.info | awk '/^Salt/{ print $$2 }' > out/dmverity_rootfs.salt
	cat out/dmverity_rootfs.info | awk '/^Algorithm/{ print $$2 }' > out/dmverity_rootfs.algorithm
	cat out/dmverity_rootfs.info | awk '/^DataBlockSize/{ print $$2 }' > out/dmverity_rootfs.datablocksize
	cat out/dmverity_rootfs.info | awk '/^HashBlockSize/{ print $$2 }' > out/dmverity_rootfs.hashblocksize
	cat out/dmverity_rootfs.info | awk '/^DataBlocks/{ print $$2 }' > out/dmverity_rootfs.datablocks
	echo $$(( $$(cat out/dmverity_rootfs.hashoffsetinblocks) * $$(cat out/dmverity_rootfs.datablocksize) / 512 )) > out/dmverity_rootfs.datasectors
	echo $$(( $$(cat out/dmverity_rootfs.hashoffsetinblocks) * $$(cat out/dmverity_rootfs.datablocksize) )) > out/dmverity_rootfs.hashoffset


	# dumpe2fs out/dmverity_rootfs.vhd | awk '/^Block size/{ print $$3 }' > out/dmverity_rootfs.datablocksize
    # Get the number of blocks in root filesystem (not including the embedded merkle tree)
	# dumpe2fs out/dmverity_rootfs.vhd | awk '/^Block count/{ print $$3 }' > out/dmverity_rootfs.blockcount
    # Calculate the hash offset, i.e the location of the divide between the real filesystem data and the embedded dmverity data
	# echo $$(( $$(cat out/dmverity_rootfs.blockcount) * $$(cat out/dmverity_rootfs.datablocksize) )) > out/dmverity_rootfs.hashoffset
	# openssl rand -hex 32 > out/dmverity_rootfs.salt



out/dmverity_rootfs.tar.gz: out/initrd.img bin/init2 startup_simple.sh startup.sh startup_2.sh bin/debuginit
    # The filesystem built in dmverity-rootfs-conv eventually becomes the Pod's root filesystem
	rm -rf dmverity-rootfs-conv
	mkdir dmverity-rootfs-conv
	gunzip -c out/initrd.img | (cd dmverity-rootfs-conv && cpio -imd)
	cp startup_2.sh dmverity-rootfs-conv/startup_2.sh
	cp startup.sh dmverity-rootfs-conv/startup.sh
	cp startup_simple.sh dmverity-rootfs-conv/startup_simple.sh
	chmod a+x dmverity-rootfs-conv/startup_2.sh
	chmod a+x dmverity-rootfs-conv/startup.sh
	chmod a+x dmverity-rootfs-conv/startup_simple.sh
	cp bin/init2 dmverity-rootfs-conv/init2
	cp bin/debuginit dmverity-rootfs-conv/debuginit
	cp $(SRC)/src/Parma/bin/mkfs.xfs dmverity-rootfs-conv/bin/mkfs.xfs
	chmod a+x dmverity-rootfs-conv/bin/mkfs.xfs
	tar -zcf $@ -C dmverity-rootfs-conv .
	# rm -rf dmverity-rootfs-conv

out/rootfs.vhd: out/rootfs.tar.gz bin/cmd/tar2ext4
	gzip -f -d ./out/rootfs.tar.gz
	bin/cmd/tar2ext4 -vhd -i ./out/rootfs.tar -o $@

out/rootfs.tar.gz: out/initrd.img
	rm -rf rootfs-conv
	mkdir rootfs-conv
	gunzip -c out/initrd.img | (cd rootfs-conv && cpio -imd)
	tar -zcf $@ -C rootfs-conv .
	rm -rf rootfs-conv

out/initrd.img: $(BASE) $(DELTA_TARGET) $(SRCROOT)/hack/catcpio.sh
	$(SRCROOT)/hack/catcpio.sh "$(BASE)" $(DELTA_TARGET) > out/initrd.img.uncompressed
	gzip -c out/initrd.img.uncompressed > $@
	rm out/initrd.img.uncompressed

# This target includes utilities which may be useful for testing purposes.
out/delta-dev.tar.gz: out/delta.tar.gz bin/internal/tools/snp-report
	rm -rf rootfs-dev
	mkdir rootfs-dev
	tar -xzf out/delta.tar.gz -C rootfs-dev
	cp bin/internal/tools/snp-report rootfs-dev/bin/
	tar -zcf $@ -C rootfs-dev .
	rm -rf rootfs-dev

out/delta.tar.gz: bin/init bin/init2 bin/debuginit  bin/vsockexec bin/testprint bin/cmd/gcs bin/cmd/gcstools bin/cmd/hooks/wait-paths Makefile
	@mkdir -p out
	rm -rf rootfs
	mkdir -p rootfs/bin/
	mkdir -p rootfs/info/
	cp bin/init rootfs/
	cp bin/init2 rootfs/
	cp bin/debuginit rootfs/
	cp bin/vsockexec rootfs/bin/
	cp bin/testprint rootfs/bin/
	cp bin/cmd/gcs rootfs/bin/
	cp bin/cmd/gcstools rootfs/bin/
	cp bin/cmd/hooks/wait-paths rootfs/bin/
	for tool in $(GCS_TOOLS); do ln -s gcstools rootfs/bin/$$tool; done
	git -C $(SRCROOT) rev-parse HEAD > rootfs/info/gcs.commit && \
	git -C $(SRCROOT) rev-parse --abbrev-ref HEAD > rootfs/info/gcs.branch && \
	date --iso-8601=minute --utc > rootfs/info/tar.date
	$(if $(and $(realpath $(subst .tar,.testdata.json,$(BASE))), $(shell which jq)), \
		jq -r '.IMAGE_NAME' $(subst .tar,.testdata.json,$(BASE)) 2>/dev/null > rootfs/info/image.name && \
		jq -r '.DATETIME' $(subst .tar,.testdata.json,$(BASE)) 2>/dev/null > rootfs/info/build.date)
	tar -zcf $@ -C rootfs .
	rm -rf rootfs

out/containerd-shim-runhcs-v1.exe:
	GOOS=windows $(GO_BUILD) -o $@ $(SRCROOT)/cmd/containerd-shim-runhcs-v1

bin/cmd/gcs bin/cmd/gcstools bin/cmd/hooks/wait-paths bin/cmd/tar2ext4 bin/internal/tools/snp-report bin/cmd/dmverity-vhd:
	@mkdir -p $(dir $@)
	GOOS=linux $(GO_BUILD) -o $@ $(SRCROOT)/$(@:bin/%=%)

bin/vsockexec: vsockexec/vsockexec.o vsockexec/vsock.o
	@mkdir -p bin
	$(CC) $(LDFLAGS) -o $@ $^

bin/testprint: testprint/testprint.o testprint/vsock.o
	@mkdir -p bin
	$(CC) $(LDFLAGS) -o $@ $^

bin/init: init/init.o vsockexec/vsock.o
	@mkdir -p bin
	$(CC) $(LDFLAGS) -o $@ $^

bin/init2: init2/init2.o vsockexec/vsock.o
	@mkdir -p bin
	$(CC) $(LDFLAGS) -o $@ $^

	
bin/debuginit: debuginit/debuginit.o vsockexec/vsock.o
	@mkdir -p bin
	$(CC) $(LDFLAGS) -o $@ $^

%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<
