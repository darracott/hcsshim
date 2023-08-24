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

VMGS_TOOL:=
IGVM_TOOL:=
KERNEL_PATH:=

.PHONY: all always rootfs test

.DEFAULT_GOAL := all

all: out/initrd.img out/rootfs.tar.gz

clean:
	find -name '*.o' -print0 | xargs -0 -r rm
	rm -rf bin deps rootfs out

test:
	cd $(SRCROOT) && $(GO) test -v ./internal/guest/...

rootfs: out/rootfs.vhd

snp: out/kernelinitrd.vmgs out/containerd-shim-runhcs-v1.exe

out/kernelinitrd.vmgs: out/kernelinitrd.bin
	rm -f $@
	$(VMGS_TOOL) create --filepath $@ --filesize 67108864
	$(VMGS_TOOL) write --filepath $@ --datapath out/kernelinitrd.bin -i=8

out/v2056.vmgs: out/v2056.bin
	rm -f $@
	$(VMGS_TOOL) create --filepath $@ --filesize 67108864
	$(VMGS_TOOL) write --filepath $@ --datapath out/v2056.bin -i=8


out/v2056.bin: out/kernelinitrd.cpio.gz
	rm -f $@
	python3 $(IGVM_TOOL) -o $@ -kernel $(KERNEL_PATH) -append "8250_core.nr_uarts=0 panic=-1 debug loglevel=7 root=/dev/sda rdinit=/startup_v2056.sh systemd.verity=1 systemd.verity_root_data=/dev/sda systemd.verity_root_options=panic-on-corruption" -rdinit out/kernelinitrd.cpio.gz -vtl 0

out/kernelinitrd.bin: out/kernelinitrd.cpio.gz
	rm -f $@
	python3 $(IGVM_TOOL) -o $@ -kernel $(KERNEL_PATH) -append "8250_core.nr_uarts=0 panic=-1 debug loglevel=7 root=/dev/sda rdinit=/dm-startup.sh systemd.verity=1 systemd.verity_root_data=/dev/sda systemd.verity_root_options=panic-on-corruption" -rdinit out/kernelinitrd.cpio.gz -vtl 0


out/kernelinitrd.cpio.gz: out/dm-startup.sh
	rm -rf kernelinitrd-rootfs
	mkdir kernelinitrd-rootfs
	tar -xf $(BASE) -C kernelinitrd-rootfs
	tar -xzf out/delta.tar.gz -C kernelinitrd-rootfs
	# cp bin/internal/tools/snp-report kernelinitrd-rootfs/bin/snp-report
	cp out/dm-startup.sh kernelinitrd-rootfs/dm-startup.sh
	chmod a+x kernelinitrd-rootfs/dm-startup.sh

    # Reduce kernelinitrd size by removing unnecessary files
	./reduce-kernelinitrd-size.sh $(SRCROOT)
	find ./kernelinitrd-rootfs  | sudo xargs touch -hmt 199912310000
	find ./kernelinitrd-rootfs -print0 | sudo cpio --null -o --format=newc --reset-access-time | sudo gzip -9 > $@

	rm -rf kernelinitrd-rootfs


out/dm-startup.sh:	out/dmverity_rootfs.vhd
    # The startup script required by vmgs which mounts dmverity_rootfs when using SNP.
    # Configure the script with the root hash of the root filesystem for dm-verity.
	cp dm-startup.sh.template $@
	sed -i "s/<ROOT_HASH>/$(shell cat out/dmverity_rootfs.hash)/" out/dm-startup.sh
	sed -i "s/<BLOCK_COUNT>/$(shell cat out/dmverity_rootfs.blockcount)/" out/dm-startup.sh
	sed -i "s/<HASH_OFFSET>/$(shell cat out/dmverity_rootfs.hashoffset)/" out/dm-startup.sh

out/dmverity_rootfs.vhd: out/dmverity_rootfs.tar.gz bin/cmd/dmverity-vhd
    # Format the root filesystem VHD which will be mounted by kernelinitrd via dm-verity when using SNP.
	gzip -f -d ./out/dmverity_rootfs.tar.gz
	./bin/cmd/dmverity-vhd -v convert --fst out/dmverity_rootfs.tar -o out | awk '/^RootHash/{ print $$2 }' > out/dmverity_rootfs.hash
    # Retrieve info required by dm-verity at boot time
    # Get the blocksize of rootfs
	dumpe2fs out/dmverity_rootfs.vhd | awk '/^Block size/{ print $$3 }' > out/dmverity_rootfs.blocksize
    # Get the number of blocks in root filesystem (not including the embedded merkle tree)
	dumpe2fs out/dmverity_rootfs.vhd | awk '/^Block count/{ print $$3 }' > out/dmverity_rootfs.blockcount
    # Calculate the hash offset, i.e the location of the divide between the real filesystem data and the embedded dmverity data
	echo $$(( $$(cat out/dmverity_rootfs.blockcount) * $$(cat out/dmverity_rootfs.blocksize) )) > out/dmverity_rootfs.hashoffset


out/dmverity_rootfs.tar.gz: out/initrd.img bin/init2
	rm -rf dmverity-rootfs-conv
	mkdir dmverity-rootfs-conv
	gunzip -c out/initrd.img | (cd dmverity-rootfs-conv && cpio -imd)
	cp startup_2.sh dmverity-rootfs-conv/startup_2.sh
	cp bin/init2 dmverity-rootfs-conv/init2
	tar -zcf $@ -C dmverity-rootfs-conv .
	rm -rf dmverity-rootfs-conv

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

out/delta.tar.gz: bin/init2 bin/init bin/vsockexec bin/cmd/gcs bin/cmd/gcstools bin/cmd/hooks/wait-paths Makefile
	@mkdir -p out
	rm -rf rootfs
	mkdir -p rootfs/bin/
	mkdir -p rootfs/info/
	cp bin/init rootfs/
	cp bin/vsockexec rootfs/bin/
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

bin/init: init/init.o vsockexec/vsock.o
	@mkdir -p bin
	$(CC) $(LDFLAGS) -o $@ $^

bin/init2: init2/init2.o vsockexec/vsock.o
	@mkdir -p bin
	$(CC) $(LDFLAGS) -o $@ $^

%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<
