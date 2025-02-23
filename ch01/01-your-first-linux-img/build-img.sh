#!/bin/bash

set -x # Trace commands being executed
as bootsect.S -o bootsect.o
ld bootsect.o -m elf_x86_64 --section-start=.text=0x0 --strip-all --oformat=binary --output=linux.img