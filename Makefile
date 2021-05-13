.PHONY: clean all build

# directories
BUILDDIR = ./build
DISTDIR = ./dist

BOOTLOADER_BIN = $(BUILDDIR)/bootloader.bin
KERNEL_BIN = $(BUILDDIR)/kernel.bin
KERNEL_ENTRY_OBJ = $(BUILDDIR)/entry.o

OS_IMG = $(DISTDIR)/os_image

build: $(OS_IMG)

$(OS_IMG): $(BOOTLOADER_BIN) $(KERNEL_BIN)
	@mkdir -p $(@D)
	@cat $^ > $@

$(BOOTLOADER_BIN): bootloader/bootloader.asm
	@mkdir -p $(@D)
	nasm $< -f bin -I "./bootloader/include/" -o $@

$(KERNEL_ENTRY_OBJ): kernel/entry.c
	@mkdir -p $(@D)
	gcc -ffreestanding -c $< -o $@

$(KERNEL_BIN): $(KERNEL_ENTRY_OBJ)
	@mkdir -p $(@D)
	ld -o $@ -Ttext 0x1000 $< --oformat binary

all: build

clean:
	rm -Rf $(BUILDDIR)
	rm -Rf $(DISTDIR)
