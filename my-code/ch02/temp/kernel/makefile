GCC := gcc
CCFLAG := -mcpu=i386 -I../include -nostdinc -Wall -fomit-frame-pointer -c
# -nostdinc means do not search standard system directories for header files. Only search directories specified with -I.
# -c means just compile and do not link

LD := ld -m elf_x86_64
LDFLAG := --section-start=.text=0x0 --strip-all --oformat=binary
OBJS := head.o

system: $(OBJS)
	$(LD) $^ $(LDFLAG) --entry=startup_32 -o $@
# --entry=xxx means specify xxx as the explicit symbol for beginning execution of your program.

head.o: head.S
	$(GCC) $^ -traditional -c -o $@
# -traditional means to imitate the behavior of pre-standard C preprocessors as opposed to ISO C preprocessors.

.PHONY: clean
clean:
	rm *.o
	rm system