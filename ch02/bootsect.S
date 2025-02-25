SETUPLEN = 4

BOOTSEG  = 0x7c0

INITSEG  = 0x9000

SETUPSEG = 0x9020

SYSSEG   = 0x1000

ENDSEG   = SYSSEG + SYSSIZE

ROOT_DEV = 0x000

.code16
.text

.global _start
_start:
    
    jmpl $BOOTSEG, $start2

start2:
    movw $BOOTSEG, %ax
    movw %ax, %ds
    movw $INITSEG, %ax
    movw %ax, %es
    movw $256, %cx
    subw %si, %si
    subw %di, %di

    rep                  # rep + movsw means: "Repeat copy a word (2 bytes) from address (%ds << 4) + %si to address (%es << 4) + %di, until %cx == 0"
    movsw

    jmpl $INITSEG, $go   # Does two things, 1) set %cs = $INITSEG, 2) jump to $go label

go:
    movw %cs, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %ss
    movw $0xFF00, %sp

load_setup:
    movw $0x0000, %dx    # %dh means the id of magnetic head, %dl means drive id, 0 means floppy disk, 7 means hard disk.
    movw $0x0002, %cx    # %ch means the lower 8 bits of cylinder id, the first 0~5 bits in %cl means start sector id, 6~7 bits means the higher 2 bits of magnetic track
    movw $0x0200, %bx    # (%es << 4) + %bx is the address of the buffer. If there is any error, the CF bit will be set
    movb $SETUPLEN, %al  # %al means the number of sectors to load
    movb $0x02, %ah      # %ah == 0x02 means: load sector (512 bytes) from disk to memory
    int $0x13            # Trigger interruption: load setup from floppy disk.
    jnc ok_load_setup    # If CF == 0, then jump to ok_load_setup; Otherwise if CF == 0, don't jump.
    movw $0x0000, %dx
    movw $0x0000, %ax    # %ah == 0x0 means reset disk
    int $0x13            # Trigger interruption to reset disk
    jmp load_setup       # load setup failed, jump to load_setup to retry

ok_load_setup:

    movw $msg, %ax
    movw %ax, %bp
    movw $0x01301, %ax
    movw $0x0c, %bx
    movw $21, %cx
    movb $0, %dl
    int $0x010

    jmpl $SETUPSEG, $0

msg:
.ascii "Setup has been loaded"

.org 508
root_dev:
    .word ROOT_DEV
boot_flag:
    .word 0xaa55
    