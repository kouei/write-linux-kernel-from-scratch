GCC := gcc
CCFLAG := -mcpu=i386 -I../include -nostdinc -Wall -fomit-frame-pointer -c
# -nostdinc means do not search standard system directories for header files. Only search directories specified with -I.
# -c means just compile and do not link

LDFLAG := --section-start=.text=0x0 --strip-all --oformat=binary