AS := as
LD := ld -m elf_x86_64

LDFLAG := --section-start=.text=0x0 --strip-all --oformat=binary

image: linux.img

linux.img: tools/build-without-system bootsect setup
	./tools/build-without-system bootsect setup > $@

tools/build-without-system: tools/build-without-system.c
	gcc $< -o $@

bootsect: bootsect.o
	$(LD) $< $(LDFLAG) -o $@

bootsect.o: bootsect.S
	$(AS) $< -o $@

setup: setup.o
	$(LD) $< $(LDFLAG) --entry=_start_setup -o $@

.PHONY: clean
clean:
	rm -f *.o
	rm -f bootsect
	rm -f setup
	rm -f tools/build-without-system
	rm -f linux.img