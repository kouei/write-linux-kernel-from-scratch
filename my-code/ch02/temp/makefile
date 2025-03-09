AS := as
LD := ld -m elf_x86_64

LDFLAG := --section-start=.text=0x0 --strip-all --oformat=binary

image: linux.img

linux.img: tools/build bootsect setup kernel/system
	./tools/build bootsect setup kernel/system > $@

tools/build: tools/build.c
	gcc $^ -o $@

kernel/system:
	cd kernel; make system; cd ..

bootsect: bootsect.o
	$(LD) $^ $(LDFLAG) -o $@

bootsect.o: bootsect.S
	$(AS) $^ -o $@

setup: setup.o
	$(LD) $^ $(LDFLAG) --entry=_start_setup -o $@

.PHONY: clean
clean:
	rm -f *.o
	rm -f bootsect
	rm -f setup
	rm -f tools/build
	rm -f linux.img